#!/usr/local/cpanel/3rdparty/bin/perl

use strict;
use warnings;

# These are the commands that a custom destination script must process
my %commands = (
    put    => \&my_put,
    get    => \&my_get,
    ls     => \&my_ls,
    mkdir  => \&my_mkdir,
    chdir  => \&my_chdir,
    rmdir  => \&my_rmdir,
    delete => \&my_delete,
);

# There must be at least the command and the local directory
usage() if ( @ARGV < 2 );

#
# The command line arguments passed to the script will be in the following order:
# command, local_directory, command arguments, and optionally, host, user password
# The local directory is passed in so we know from which directory to run the command
# we need to pass this in each time since we start the script fresh for each command
#
my ( $cmd, $local_dir, @args ) = @ARGV;

# complain if the command does not exist
usage() unless exists $commands{$cmd};

# Run our command
$commands{$cmd}->(@args);

#
# This script should only really be executed by the custom backup destination type
# If someone executes it directly out of curiosity, give them usage info
#
sub usage {
    my @cmds = sort keys %commands;
    print STDERR "This script is for implementing a custom backup destination\n";
    print STDERR "It requires the following arguments:  cmd, local_dir, cmd_args\n";
    print STDERR "These are the valid commands:  @cmds\n";
    exit 1;
}

#
# Build the remote url
#
sub my_remote {
    my ( $bucket) = @_;
    return "s3://${bucket}";
}

#
# Copy a local file to a remote destination
#
sub my_put {
    my ( $local, $remote, $host, $user, $password ) = @_;
    my $full_remote = my_remote($host);
    
    `s3cmd put $local ${full_remote}${remote}`; 

    return;
}

#
# Copy a remote file to a local destination
#
sub my_get {
    my ( $remote, $local, $host, $user, $password ) = @_;
    my $full_remote = my_remote($host);

    `s3cmd get ${full_remote}${remote} ${local} --force`;

    return;
}

#
# Print out the results of doing an ls operation
# The calling program will expect the data to be
# in the format supplied by 'ls -l' and have it
# printed to STDOUT
#
sub my_ls {
    my ( $path, $host, $user, $password ) = @_;
    my $full_remote = my_remote($host);

    `s3cmd ls $full_remote`;

    return;
}

#
# Create a directory on the remote destination
#
sub my_mkdir {
    my ( $path, $recurse, $host, $user, $password ) = @_;
    return;
}

#
# Change into a directory on the remote destination
# This does not have the same meaning as it normally would since the script
# is run anew for each command call.
# This needs to do the operation to ensure it doesn't fail
# then print the new resulting directory that the calling program
# will pass in as the local directory for subsequent calls
#
sub my_chdir {
    my ( $path, $host, $user, $password ) = @_;
    print $path;
    return;
}

#
# Recursively delete a directory on the remote destination
#
sub my_rmdir {
    my ( $path, $host, $user, $password ) = @_;
    return;
}

#
# Delete an individual file on the remote destination
#
sub my_delete {
    my ( $path, $host, $user, $password ) = @_;
    my $full_remote = my_remote($host);

    `s3cmd del ${full_remote}$path`;

    return;
}


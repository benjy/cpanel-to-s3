## cPanel to S3 Backup Script.

This script integrates with the new cPanel backup system released with cPanel 11.38.


### s3cmd Installation on CentOS 6 (Requires root)
 - Download `http://s3tools.org/repo/RHEL_6/s3tools.repo` to `/etc/yum.repos.d/`
 - Run: `yum install s3cmd`
 - Run: `s3cmd --configure` and follow the steps to connect to your S3 account.

### Installation of backup script

- Download the s3backup.pl to /scripts
- Login to WHM and go to: Backup Configuration
- Scroll down to Additional Destinations, select "Custom" from the drop down and click "Create new destination".
- Set the options as follows:
 - Name: S3
 - Script: `/usr/local/cpanel/scripts/s3backup.pl`
 - Backup Directory: /
 - Remote Host: Set this to your S3 bucket name.
 - Save and Validate Destination.


### Warning

This script comes without any warranty. We've recently deployed it to a test server and everything seems to be working fine however it is not currently been used in a live environment so use at your own risk.
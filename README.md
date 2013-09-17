## cPanel to S3 Backup Script.

This script integrates with the new cPanel backup system released with cPanel 11.38.

### Installation

- Download the s3backup.pl to /scripts
- Login to WHM and go to: Backup Configuration
- Scroll down to Additional Destinations, select "Custom" from the drop down and click "Create new destination".
- Set the options as follows:
-- Name: "S3"
-- Script: "/usr/local/cpanel/scripts/s3backup.pl"
-- Backup Directory: /
-- Remote Host: Set this to your S3 bucket name.
-- Save and Validate Destination.
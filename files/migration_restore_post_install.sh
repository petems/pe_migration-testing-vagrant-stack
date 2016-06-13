BACKUP_DIR=/vagrant/files/backup

puppet resource service puppet ensure=stopped
puppet resource service pe-puppetserver ensure=stopped
puppet resource service pe-puppetdb ensure=stopped
puppet resource service pe-console-services ensure=stopped
puppet resource service pe-nginx ensure=stopped
puppet resource service pe-activemq ensure=stopped
puppet resource service pe-orchestration-services ensure=stopped
puppet resource service pxp-agent ensure=stopped

sudo -u pe-postgres /opt/puppetlabs/server/bin/pg_restore -Cc $BACKUP_DIR/pe-puppetdb.backup.bin -d template1
sudo -u pe-postgres /opt/puppetlabs/server/bin/pg_restore -Cc $BACKUP_DIR/pe-classifier.backup.bin -d template1
sudo -u pe-postgres /opt/puppetlabs/server/bin/pg_restore -Cc $BACKUP_DIR/pe-activity.backup.bin -d template1
sudo -u pe-postgres /opt/puppetlabs/server/bin/pg_restore -Cc $BACKUP_DIR/pe-rbac.backup.bin -d template1

#Start PE services
#Install database extensions and repair database permissions
#Repair PE classification groups to reflect the 2016.2 Puppet master’s certificate name.
puppet enterprise configure

#Optional: For cleaniness revoke cert from old master if certname is different
#OLD_MASTER_CERTNAME=<old_master_certname_here>
#puppet node deactivate $OLD_MASTER_CERTNAME
#puppet cert clean $OLD_MASTER_CERTNAME


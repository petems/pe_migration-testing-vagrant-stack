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

echo 'REVOKE ALL ON DATABASE "pe-activity" FROM PUBLIC;
REVOKE ALL ON DATABASE "pe-activity" FROM "pe-postgres";
GRANT ALL ON DATABASE "pe-activity" TO "pe-postgres";
GRANT TEMPORARY ON DATABASE "pe-activity" TO PUBLIC;
GRANT ALL ON DATABASE "pe-activity" TO "pe-activity";
REVOKE ALL ON DATABASE "pe-classifier" FROM PUBLIC;
REVOKE ALL ON DATABASE "pe-classifier" FROM "pe-postgres";
GRANT ALL ON DATABASE "pe-classifier" TO "pe-postgres";
GRANT TEMPORARY ON DATABASE "pe-classifier" TO PUBLIC;
GRANT ALL ON DATABASE "pe-classifier" TO "pe-classifier";
REVOKE ALL ON DATABASE "pe-puppetdb" FROM PUBLIC;
REVOKE ALL ON DATABASE "pe-puppetdb" FROM "pe-postgres";
GRANT ALL ON DATABASE "pe-puppetdb" TO "pe-postgres";
GRANT TEMPORARY ON DATABASE "pe-puppetdb" TO PUBLIC;
GRANT ALL ON DATABASE "pe-puppetdb" TO "pe-puppetdb";
REVOKE ALL ON DATABASE "pe-rbac" FROM PUBLIC;
REVOKE ALL ON DATABASE "pe-rbac" FROM "pe-postgres";
GRANT ALL ON DATABASE "pe-rbac" TO "pe-postgres";
GRANT TEMPORARY ON DATABASE "pe-rbac" TO PUBLIC;
GRANT ALL ON DATABASE "pe-rbac" TO "pe-rbac";
REVOKE ALL ON DATABASE template1 FROM PUBLIC;
REVOKE ALL ON DATABASE template1 FROM "pe-postgres";
GRANT ALL ON DATABASE template1 TO "pe-postgres";
GRANT CONNECT ON DATABASE template1 TO PUBLIC;' > $BACKUP_DIR/grant_perms.sql

sudo -u pe-postgres /opt/puppetlabs/server/bin/psql -f $BACKUP_DIR/grant_perms.sql

echo '\c pe-puppetdb;
CREATE EXTENSION pg_trgm;
CREATE EXTENSION pgcrypto;' > $BACKUP_DIR/recreate_extensions.sql

sudo -u pe-postgres /opt/puppetlabs/server/bin/psql -f $BACKUP_DIR/recreate_extensions.sql

puppet resource service pe-puppetserver ensure=running
puppet resource service pe-puppetdb ensure=running
puppet resource service pe-console-services ensure=running
puppet resource service pe-nginx ensure=running
puppet resource service pe-activemq ensure=running
puppet resource service pe-orchestration-services ensure=running
puppet resource service pxp-agent ensure=running

#Optional: For cleaniness revoke cert from old master if certname is different
#OLD_MASTER_CERTNAME=<old_master_certname_here>
#puppet node deactivate $OLD_MASTER_CERTNAME
#puppet cert clean $OLD_MASTER_CERTNAME

#This step should repair the Node Classifier groups from old hostname to new hostname
puppet enterprise configure --modulepath /opt/puppetlabs/server/data/enterprise/modules

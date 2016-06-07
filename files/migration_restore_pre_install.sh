BACKUP_DIR=/vagrant/files/backup

mkdir -p /etc/puppetlabs/puppet

tar -zxvf $BACKUP_DIR/puppet_ssl.tar.gz -C /

#Removing PE internal certs so they can be regenerated
rm -f /etc/puppetlabs/puppet/ssl/certs/pe-internal-classifier.pem
rm -f /etc/puppetlabs/puppet/ssl/certs/pe-internal-dashboard.pem
rm -f /etc/puppetlabs/puppet/ssl/private_keys/pe-internal-classifier.pem
rm -f /etc/puppetlabs/puppet/ssl/private_keys/pe-internal-dashboard.pem
rm -f /etc/puppetlabs/puppet/ssl/public_keys/pe-internal-classifier.pem
rm -f /etc/puppetlabs/puppet/ssl/public_keys/pe-internal-dashboard.pem
rm -f /etc/puppetlabs/puppet/ssl/ca/signed/pe-internal-classifier.pem
rm -f /etc/puppetlabs/puppet/ssl/ca/signed/pe-internal-dashboard.pem

#THIS IS A TEMPORARY HACK
rm -f /etc/puppetlabs/puppet/ssl/certs/ca.pem

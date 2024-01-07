#!/bin/bash
yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils gcc
rpm -i https://nginx.org/packages/centos/7/SRPMS/nginx-1.24.0-1.el7.ngx.src.rpm
wget -P /root --no-check-certificate https://www.openssl.org/source/openssl-3.2.0.tar.gz
tar -xvf /root/openssl-3.2.0.tar.gz -C /root
yum-builddep /root/rpmbuild/SPECS/nginx.spec -y
sed -i 's/with-debug/& \\\n --with-openssl=\/root\/openssl-3.2.0/' /root/rpmbuild/SPECS/nginx.spec
yum install perl-IPC-Cmd -y
rpmbuild -bb /root/rpmbuild/SPECS/nginx.spec
yum localinstall -y /root/rpmbuild/RPMS/x86_64/nginx-1.24.0-1.el7.ngx.x86_64.rpm
systemctl enable nginx --now
systemctl start nginx
mkdir /usr/share/nginx/html/repo
cp -a /root/rpmbuild/RPMS/x86_64/nginx-* /usr/share/nginx/html/repo/
createrepo /usr/share/nginx/html/repo/
sed -i 's/index  index.html index.htm;/&\n autoindex on;/g' /etc/nginx/conf.d/default.conf
nginx -s reload
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
sudo setenforce 0
curl -a http://localhost/repo/
cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo/
gpgcheck=0
enabled=1
EOF
yum install nginx-debuginfo.x86_64 -y

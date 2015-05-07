lang en_US.UTF-8
keyboard us
timezone --utc Etc/UTC
auth --enableshadow --passalgo=sha512
selinux --permissive
#rootpw --lock
rootpw --iscrypted $6$J1xl6nKJSRxOzzlC$zoWNdnA7pGi8iGQfS0OM9NNymSkF2v1XOGkhiSGW1weUv56pNWRFHbxj/jJki7lQQfJRod9PrQoRXV0lwMUnm0
user --name=node --lock
poweroff
firstboot --reconfig

clearpart --all --initlabel
bootloader --timeout=1
autopart --type=plain

%packages --ignoremissing
#@core
initial-setup
%end


#
# CentOS repositories
#
#url --mirrorlist=http://mirrorlist.centos.org/?repo=os&release=$releasever&arch=$basearch
#repo --name=updates --mirrorlist=http://mirrorlist.centos.org/?repo=updates&release=$releasever&arch=$basearch
#repo --name=extra --mirrorlist=http://mirrorlist.centos.org/?repo=extras&release=$releasever&arch=$basearch

#url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-20&arch=x86_64
#url --url=http://mirrors.zju.edu.cn/fedora/releases/20/Everything/x86_64/os/
##url --url=http://mirrors.163.com/fedora/releases/20/Everything/x86_64/os/
###url --url=http://mirrors.163.com/centos/7.1.1503/os/x86_64/
url --url=http://172.16.1.39/centos7/
#repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f20&arch=x86_64
#repo --name=fedora --baseurl=http://mirrors.zju.edu.cn/fedora/updates/20/x86_64/
##repo --name=fedora --baseurl=http://mirrors.163.com/fedora/updates/20/x86_64/
###repo --name=centos7 --baseurl=http://mirrors.163.com/centos/7.1.1503/updates/x86_64/
repo --name=centos7 --baseurl=http://172.16.1.39/centos7/


%post
#
# Configuration YUM repo
#

#rm -rf /etc/yum.repos.d/*
#cat > /etc/yum.repos.d/fedora.repo <<__EOF__
#[fedora]
#name=fedora
#baseurl=http://mirrors.163.com/fedora/releases/20/Everything/x86_64/os/
#gpgcheck=0
#__EOF__
#yum clean all

##
## Adding upstream oVirt
##

set -x
yum-config-manager --add-repo="http://download.gluster.org/pub/gluster/glusterfs/LATEST/CentOS/glusterfs-epel.repo"
yum install -y http://plain.resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm
yum install -y ovirt-engine

#
echo "Creating a partial answer file"
#
cat > /root/ovirt-engine-answers <<__EOF__
[environment:default]
OVESETUP_CORE/engineStop=none:None
OVESETUP_DIALOG/confirmSettings=bool:True
OVESETUP_DB/database=str:engine
OVESETUP_DB/fixDbViolations=none:None
OVESETUP_DB/secured=bool:False
OVESETUP_DB/securedHostValidation=bool:False
OVESETUP_DB/host=str:localhost
OVESETUP_DB/user=str:engine
OVESETUP_DB/port=int:5432
OVESETUP_SYSTEM/nfsConfigEnabled=bool:False
OVESETUP_CONFIG/applicationMode=str:virt
OVESETUP_CONFIG/firewallManager=str:firewalld
OVESETUP_CONFIG/websocketProxyConfig=none:True
OVESETUP_CONFIG/storageType=str:nfs
OVESETUP_PROVISIONING/postgresProvisioningEnabled=bool:True
OVESETUP_APACHE/configureRootRedirection=bool:True
OVESETUP_APACHE/configureSsl=bool:True
OSETUP_RPMDISTRO/requireRollback=none:None
OSETUP_RPMDISTRO/enableUpgrade=none:None
__EOF__

%end

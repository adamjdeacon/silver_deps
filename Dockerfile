FROM centos:latest
MAINTAINER Adam Deacon <adeacon@mango-solutions.com>

RUN sed s/\#baseurl/baseurl/g -i /etc/yum.repos.d/CentOS-Linux-AppStream.repo && \
    sed s/mirrorlist/\#mirrorlist/g -i /etc/yum.repos.d/CentOS-Linux-AppStream.repo

RUN dnf install -y epel-release http://repo.okay.com.mx/centos/8/x86_64/release/okay-release-1-5.el8.noarch.rpm
RUN dnf -y update
RUN dnf install -y  --enablerepo=powertools R gcc gcc-c++ libcurl-devel openssl-devel libxml2-devel libjpeg-turbo-devel glibc-locale-source glibc-langpack-en v8-devel chromium

COPY rpms/*.rpm /local-rpms/
RUN dnf install -y /local-rpms/*.rpm && rm -Rfv /local-rpms

COPY install_packages.R /
RUN Rscript install_packages.R

VOLUME /build
WORKDIR /build

COPY build.sh /

CMD ["/build.sh"]


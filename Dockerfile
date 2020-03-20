FROM centos:latest
MAINTAINER Adam Deacon <adeacon@mango-solutions.com>


RUN dnf install -y epel-release 
RUN dnf install -y --enablerepo=PowerTools R gcc gcc-c++ libcurl-devel openssl-devel libxml2-devel libjpeg-turbo-devel glibc-locale-source glibc-langpack-en 

COPY install_packages.R /
RUN Rscript install_packages.R

VOLUME /build
WORKDIR /build

COPY build.sh /

CMD ["/build.sh"]


FROM centos:7

# Build-time variables

ARG REFRESHED_AT=2018-10-16

# Install prerequisites.

RUN yum -y install epel-release; yum clean all
RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm; yum clean all
RUN yum -y update; yum clean all

RUN yum -y install \
    gcc-c++ \
    mysql-connector-odbc \
    python36u \
    python36u-libs \
    python36u-devel \
    python36u-pip \
    unixODBC \
    unixODBC-devel \
    wget; \
    yum clean all

RUN ln --symbolic --force /usr/bin/python3.6 /usr/bin/python3 \
 && ln --symbolic --force /usr/bin/python3   /usr/bin/python \
 && ln --symbolic --force /usr/bin/pip3.6    /usr/bin/pip

RUN pip install \
    psutil \
    pyodbc

# Copy the repository's app directory.

COPY ./app /app

# Environment variables

ENV SENZING_ROOT=/opt/senzing
ENV PYTHONPATH=${SENZING_ROOT}/g2/python
ENV LD_LIBRARY_PATH=${SENZING_ROOT}/g2/lib

# Work-around https://senzing.zendesk.com/hc/en-us/articles/360009212393-MySQL-V8-0-ODBC-client-alongside-V5-x-Server

RUN wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-community-libs-8.0.12-1.el7.x86_64.rpm \
 && rpm2cpio mysql-community-libs-8.0.12-1.el7.x86_64.rpm | cpio -idmv

# Run-time command

ENTRYPOINT ["/app/senzing-configuration-changes.sh"]
CMD ["python"]

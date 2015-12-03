# LICENSE CDDL 1.0 + GPL 2.0
#
# DOCKERFILE FOR ORACLE DB 11g
# --------------------------

FROM oraclelinux:7

RUN yum -y install wget sed unzip sudo

RUN cd /etc/yum.repos.d
RUN wget http://public-yum.oracle.com/public-yum-ol6.repo

# changing the field enabled=0 to enabled=1 to reflect repositories that correspond to the machine's operating system release. 
RUN sed "s|enabled=0|enabled=1|g" public-yum-ol6.repo

RUN yum -y install oracle-rdbms-server-11gR2-preinstall

RUN yum clean all


ADD files/linux.x64_11gR2_database_1of2.zip /tmp/install/linux.x64_11gR2_database_1of2.zip
ADD files/linux.x64_11gR2_database_2of2.zip /tmp/install/linux.x64_11gR2_database_2of2.zip
ADD files/oraInst.loc /etc/oraInst.loc
ADD files/oracle.sh /usr/local/bin/oracle.sh

RUN cd /tmp/install && unzip linux.x64_11gR2_database_1of2 && unzip linux.x64_11gR2_database_2of2 && rm *.zip

#RUN groupadd -g 54321 oinstall && groupadd -g 54322 dba
RUN userdel oracle && rm -rf /home/oracle && rm /var/spool/mail/oracle
RUN useradd -m -u 54321 -g oinstall -G dba oracle
RUN echo "oracle:oracle" | chpasswd

ENV ORACLE_SID ORCL
ENV ORACLE_BASE /u01/app/oracle
ENV ORACLE_HOME $ORACLE_BASE/product/11.2/db_1
ENV PATH $ORACLE_HOME/bin:$PATH

RUN mkdir -p $ORACLE_BASE && chown -R oracle:oinstall $ORACLE_BASE && chmod -R 775 $ORACLE_BASE
RUN mkdir -p /u01/app/oraInventory && chown -R oracle:oinstall /u01/app/oraInventory && chmod -R 775 /u01/app/oraInventory

#ADD sysctl.conf /etc/sysctl.conf
RUN echo "oracle soft stack 10240" >> /etc/security/limits.conf

USER oracle
RUN cd /tmp/install/database/
RUN /tmp/install/database/runInstaller -silent -ignoreSysPrereqs -ignorePrereq -force \
    oracle.install.option=INSTALL_DB_SWONLY \
    UNIX_GROUP_NAME=oinstall \
    INVENTORY_LOCATION=$ORACLE_BASE/oraInventory \
    ORACLE_HOME=$ORACLE_HOME \
    ORACLE_HOME_NAME="OraDb11g_Home1" \
    ORACLE_BASE=$ORACLE_BASE \
    oracle.install.db.InstallEdition=SE \
    oracle.install.db.isCustomInstall=false \
    oracle.install.db.DBA_GROUP=dba \
    oracle.install.db.OPER_GROUP=dba \
    DECLINE_SECURITY_UPDATES=true \
    -waitforcompletion 

USER root
RUN rm -rf /tmp/install

EXPOSE 1521 1158

USER oracle
#CMD oracle.sh
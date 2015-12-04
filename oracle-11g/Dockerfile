# LICENSE CDDL 1.0 + GPL 2.0
#
# DOCKERFILE FOR ORACLE DB 11g
# --------------------------

FROM oraclelinux:7.1


########################################
# Install OS needed packages
########################################
RUN yum -y install wget sed unzip sudo

RUN cd /etc/yum.repos.d
RUN wget http://public-yum.oracle.com/public-yum-ol6.repo

# changing the field enabled=0 to enabled=1 to reflect repositories that correspond to the machine's operating system release. 
RUN sed "s|enabled=0|enabled=1|g" public-yum-ol6.repo

RUN yum -y install oracle-rdbms-server-11gR2-preinstall

RUN yum clean all



########################################
# Install ORACLE 11g Enterprise Edition
########################################
ADD installation_files/linux.x64_11gR2_database_1of2.zip /tmp/install/linux.x64_11gR2_database_1of2.zip
ADD installation_files/linux.x64_11gR2_database_2of2.zip /tmp/install/linux.x64_11gR2_database_2of2.zip
ADD installation_files/oraInst.loc /etc/oraInst.loc
ADD installation_files/oracle.sh /usr/local/bin/oracle.sh
RUN chmod -R 775 /usr/local/bin/oracle.sh

RUN cd /tmp/install && unzip linux.x64_11gR2_database_1of2 && unzip linux.x64_11gR2_database_2of2 && rm *.zip

#RUN groupadd -g 54321 oinstall && groupadd -g 54322 dba
RUN userdel oracle && rm -rf /home/oracle && rm /var/spool/mail/oracle
RUN useradd -m -u 54321 -g oinstall -G dba oracle
RUN echo "oracle:oracle" | chpasswd

ENV ORACLE_SID ORCL
ENV ORACLE_BASE /u01/app/oracle
ENV ORACLE_HOME $ORACLE_BASE/product/11.2/db_1
ENV ORACLE_INVENTORY $ORACLE_BASE/oraInventory
ENV PATH $ORACLE_HOME/bin:$PATH

RUN mkdir -p $ORACLE_BASE && chown -R oracle:oinstall $ORACLE_BASE && chmod -R 775 $ORACLE_BASE
RUN mkdir -p $ORACLE_INVENTORY && chown -R oracle:oinstall $ORACLE_INVENTORY && chmod -R 775 $ORACLE_INVENTORY

#ADD sysctl.conf /etc/sysctl.conf
RUN echo "oracle soft stack 10240" >> /etc/security/limits.conf

# To avoid error: sudo: sorry, you must have a tty to run sudo
RUN sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers

USER oracle

RUN cd /tmp/install/database/
RUN /tmp/install/database/runInstaller -silent -ignoreSysPrereqs -ignorePrereq -force \
    oracle.install.option=INSTALL_DB_SWONLY \
    UNIX_GROUP_NAME=oinstall \
    INVENTORY_LOCATION=$ORACLE_INVENTORY \
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

# Run the root.sh script to execute the final steps after the installation
RUN $ORACLE_HOME/root.sh

EXPOSE 1521 1158


########################################
# Create a new database
########################################
# Copy all init scripts & files and create the ORCL instance
ADD database_files/oracle-.bashrc /home/oracle/.bashrc
ADD database_files/initORCL.ora $ORACLE_HOME/dbs/initORCL.ora
ADD database_files/createdb.sql $ORACLE_HOME/config/scripts/createdb.sql
ADD database_files/create.sh /tmp/create.sh

RUN mkdir -p $ORACLE_BASE/oradata && \
  chown -R oracle:oinstall $ORACLE_BASE/oradata && \
  chmod -R 775 $ORACLE_BASE/oradata && \
  mkdir -p $ORACLE_BASE/fast_recovery_area && \
  chown -R oracle:oinstall $ORACLE_BASE/fast_recovery_area && \
  chmod -R 775 $ORACLE_BASE/fast_recovery_area

RUN  /tmp/create.sh && rm /tmp/create.sh && echo "ORCL:$ORACLE_HOME:Y" >> /etc/oratab

VOLUME [ \
  "$ORACLE_BASE/admin/docker/adump", \
  "$ORACLE_BASE/diag", \
  "$ORACLE_BASE/oradata/docker", \
  "$ORACLE_HOME/cfgtoollogs", \
  "$ORACLE_HOME/log", \
  "$ORACLE_HOME/rdbms/log" \
]


########################################
# Start Oracle command
########################################
CMD oracle.sh



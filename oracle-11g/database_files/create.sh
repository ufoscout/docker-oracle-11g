#!/bin/bash

ORACLE_BASE=/u01/app/oracle
ORACLE_HOME=$ORACLE_BASE/product/11.2/db_1

date
echo "Creating database..."
sudo -u oracle -i bash -c "sqlplus /nolog @$ORACLE_HOME/config/scripts/createdb.sql"
echo ""

date
echo "Running catalog.sql..."
cd $ORACLE_HOME/rdbms/admin
cp catalog.sql catalog-e.sql
echo "exit" >> catalog-e.sql
sudo -u oracle -i bash -c "sqlplus / as sysdba @$ORACLE_HOME/rdbms/admin/catalog-e.sql > /tmp/catalog.log"
rm catalog-e.sql
echo ""

date
echo "Running catproc.sql..."
cd $ORACLE_HOME/rdbms/admin
cp catproc.sql catproc-e.sql
echo "exit" >> catproc-e.sql
sudo -u oracle -i bash -c "sqlplus / as sysdba @$ORACLE_HOME/rdbms/admin/catproc-e.sql > /tmp/catproc.log"
rm catproc-e.sql
echo ""

date
echo "Running pupbld.sql..."
cd $ORACLE_HOME/sqlplus/admin
cp pupbld.sql pupbld-e.sql
echo "exit" >> pupbld-e.sql
sudo -u oracle -i bash -c "sqlplus system/manager @$ORACLE_HOME/sqlplus/admin/pupbld-e.sql > /tmp/pupbld.log"
rm pupbld-e.sql
echo ""

date
echo "Create is done; commit the container now"

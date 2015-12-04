# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

ORACLE_BASE=/u01/app/oracle
export ORACLE_BASE

ORACLE_SID=ORCL
export ORACLE_SID

ORACLE_HOME=$ORACLE_BASE/product/11.2/db_1
export ORACLE_HOME

PATH=$ORACLE_HOME/bin:$PATH
export PATH


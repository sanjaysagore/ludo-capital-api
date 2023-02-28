echo "**********Updating Linux Repositories and Packages.**********"
ACCEPT_EULA=Y apt update -y --yes && ACCEPT_EULA=Y apt upgrade -y --yes
echo "**********Installing Alien & libaio1 packages.**********"
ACCEPT_EULA=Y apt install -y --yes alien libaio1
echo "**********Downloading Oracle Instant Client For Linux.**********"
wget -nv "https://download.oracle.com/otn_software/linux/instantclient/215000/oracle-instantclient-basic-21.5.0.0.0-1.el8.x86_64.rpm"
echo "**********Installing Oracle Instant Client for linux.**********"
alien -i oracle-instantclient-basic-21.5.0.0.0-1.el8.x86_64.rpm
echo "**********Adding Oracle Instant Client Library in PATH.**********"
export LD_LIBRARY_PATH=/usr/lib/oracle/21/client64/lib:$LD_LIBRARY_PATH
export PATH=/usr/lib/oracle/21/client64/bin:$PATH
touch /usr/lib/oracle/21/client64/lib/network/admin/sqlnet.ora
echo "SQLNET.RECV_TIMEOUT=3600" >> /usr/lib/oracle/21/client64/lib/network/admin/sqlnet.ora
echo "SQLNET.SEND_TIMEOUT=3600" >> /usr/lib/oracle/21/client64/lib/network/admin/sqlnet.ora
echo "TCP.CONNECT_TIMEOUT=3600" >> /usr/lib/oracle/21/client64/lib/network/admin/sqlnet.ora
echo "SQLNET.OUTBOUND_CONNECT_TIMEOUT=3600" >> /usr/lib/oracle/21/client64/lib/network/admin/sqlnet.ora
echo "SQLNET.INBOUND_CONNECT_TIMEOUT=3600" >> /usr/lib/oracle/21/client64/lib/network/admin/sqlnet.ora
echo "**********Starting Gunicorn Server.**********"
gunicorn --bind=0.0.0.0 --timeout 600 --access-logfile '/home/access-log.log' --log-file '/home/app-syslog.log' --workers=3 --max-requests=50 --threads=6 run:app --preload
echo "**********DEPLOYMENT COMPLETED**********"

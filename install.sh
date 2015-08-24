if [ ! -d "nexusData" ]; then
  echo "You dont have any disk mounted, please mount a volume to /home/despegar/nexusData before proceeding"
fi
sudo /usr/local/scripts/install-csync.sh
wget https://sonatype-download.global.ssl.fastly.net/nexus/oss/nexus-2.11.3-01-bundle.tar.gz
tar -xvzf nexus-2.11.3-01-bundle.tar.gz
ln -s nexus-2.11.3-01 nexus
#mkdir nexusData #Data Folder nexus
rm -R sonatype-work/ #delete original folder
echo "Copying Config files\n"
mv nexus/conf/nexus.properties nexus/conf/nexus.properties.old
wget https://raw.githubusercontent.com/ebrainte/nexus/master/nexus.properties -O nexus/conf/nexus.properties
mkdir -p nexusData/conf/
#mv nexusData/conf/nexus.xml nexusData/conf/nexus.xml.bak
wget https://raw.githubusercontent.com/ebrainte/nexus/master/nexus.xml -O nexusData/conf/nexus.xml
#mv nexusData/conf/security.xml nexusData/conf/security.xml.bak
wget https://raw.githubusercontent.com/ebrainte/nexus/master/security.xml -O nexusData/conf/security.xml

mkdir -p /home/despegar/nexusData/storage/releases/ 
wget https://raw.githubusercontent.com/ebrainte/nexus/master/cron.sh -O cron.sh

wget https://raw.githubusercontent.com/ebrainte/nexus/master/cronjob -O cronjob

crontab cronjob


echo "Now you can start nexus by doing nexus/bin/nexus start"


csync -v /home/despegar/test/ sftp://despegar@nexustest-01/home/despegar/test


* * * * * /usr/bin/csync -v /home/despegar/nexusData/storage/releases/ sftp://despegar@nexusprod-00/home/despegar/nexusData/storage/releases/ > /home/despegar/csyncoutput.log

rsync -av --delete nexusData/storage/releases/ nexusprod-01:nexusData/storage/releases/


despegar@nexusprod-00:~$ curl --request DELETE -u admin:admin123 http://nexusprod-01:8081/nexus/content/repositories/releases/com/despegar/cgp/jenkins-diegote-plugin/0.7.3
despegar@nexusprod-00:~$ curl --request DELETE -u deployment:d3sp3g4r http://nexusprod-01:8081/nexus/content/repositories/releases/com/despegar/cgp/jenkins-diegote-plugin/0.7.3
despegar@nexusprod-00:~$ rsync -av --delete nexusData/storage/releases/ nexusprod-01:nexusData/storage/releases/

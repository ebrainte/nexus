wget https://sonatype-download.global.ssl.fastly.net/nexus/oss/nexus-2.11.3-01-bundle.tar.gz
tar -xvzf nexus-2.11.3-01-bundle.tar.gz
ln -s nexus-2.11.3-01 nexus
mkdir nexusData #Data Folder nexus
rm -R sonatype-work/ #delete original folder
echo "Copying Config files\n"
mv nexus/conf/nexus.properties nexus/conf/nexus.properties.old
wget https://raw.githubusercontent.com/ebrainte/nexus/master/nexus.properties -O nexus/conf/nexus.properties
mkdir -p nexusData/conf/
#mv nexusData/conf/nexus.xml nexusData/conf/nexus.xml.bak
wget https://raw.githubusercontent.com/ebrainte/nexus/master/nexus.xml -O nexusData/conf/nexus.xml
#mv nexusData/conf/security.xml nexusData/conf/security.xml.bak
wget https://raw.githubusercontent.com/ebrainte/nexus/master/security.xml -O nexusData/conf/security.xml
echo "Now you can start nexus by doing nexus/bin/nexus start"



rsync -av --delete nexusData/storage/releases/ nexusprod-01:nexusData/storage/releases/


despegar@nexusprod-00:~$ curl --request DELETE -u admin:admin123 http://nexusprod-01:8081/nexus/content/repositories/releases/com/despegar/cgp/jenkins-diegote-plugin/0.7.3
despegar@nexusprod-00:~$ curl --request DELETE -u deployment:d3sp3g4r http://nexusprod-01:8081/nexus/content/repositories/releases/com/despegar/cgp/jenkins-diegote-plugin/0.7.3
despegar@nexusprod-00:~$ rsync -av --delete nexusData/storage/releases/ nexusprod-01:nexusData/storage/releases/

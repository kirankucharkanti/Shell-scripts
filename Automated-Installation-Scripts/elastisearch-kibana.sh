 #!/bin/bash


function elasticsearchinstall() {
        if !  rpm -qa |grep -o 'elasticsearch........' ; then
                        echo -n "would want to install elasticsearch 5.6.2 (y/n)? "
                        old_stty_cfg=$(stty -g)
                        stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                        if echo "$answer" | grep -iq "^y" ;then
                                                                echo "yes"
                                echo -e "[elasticsearch-5.x] \nname=Elasticsearch repository for 5.x packages \nbaseurl=https://artifacts.elastic.co/packages/5.x/yum \ngpgcheck=1 \ngpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch \nenabled=1 \nautorefresh=1 \ntype=rpm-md" >>/etc/yum.repos.d/elasticsearch-5.6.2.repo
                                yum install -y nc elasticsearch-5.6.2
                                echo -n "Enter the the Cluster name for elstic search : ";read a;
                                sed -i 's/#cluster.name: my-application/cluster.name: '$a'/g' /etc/elasticsearch/elasticsearch.yml
                                echo -n "Enter the the Node name for elstic search : ";read b;
                                sed -i 's/#node.name: node-1/node.name: '$b'/g' /etc/elasticsearch/elasticsearch.yml
                                #echo -n "Enter the  Path to Data for elstic search : ";read c;
                                c=/var/lib/elasticsearch
                                sed -i '/#path.data: \/path\/to\/data/a path.data: '$c'' /etc/elasticsearch/elasticsearch.yml

                                #echo -n "Enter the  Path to Logs for elstic search : ";read d;
                                d=/var/log/elasticsearch
                                sed -i '/#path.logs: \/path\/to\/logs/a path.logs: '$d'' /etc/elasticsearch/elasticsearch.yml
                                echo -n "Enter the  Ip Address or HOSTNAME for elstic search : ";read e;
                                sed -i '/#network.host: 192.168.0.1/a network.host: '$e'' /etc/elasticsearch/elasticsearch.yml
                                sed -i 's/#http.port: 9200/http.port: 9200 /g' /etc/elasticsearch/elasticsearch.yml
                                echo JAVA_HOME=$JAVA_HOME >> /etc/sysconfig/elasticsearch
                                echo -e "Elastic Search Defined port is allowed at firewall"
                                grep -oP "http.port:\s+\K\w+" /etc/elasticsearch/elasticsearch.yml
                                echo -n "would you like to change the port (y/n)? "
                                old_stty_cfg=$(stty -g)
                                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                                        if echo "$answer" | grep -iq "^y" ;then
                                                echo "yes"

                                                function port() {
                                                  echo -n "Enter the port to assign for elasticsearch : ";
                                                  read f;
                                                  nc -v -z -w 3 localhost $f &> /dev/null && f1 || echo "Offline"
                                                }; port;
                                                echo -e "the port is available"
                                                echo -e "changing port number in /etc/elasticsearch/elasticsearch.yml"

                                                sed -i '/http.port:/c\http.port: '$f'' /etc/elasticsearch/elasticsearch.yml

                                                firewall-cmd --zone=public --permanent --add-port=$f/tcp > /dev/null
                                                firewall-cmd --reload > /dev/null

                                                systemctl daemon-reload
                                                systemctl enable elasticsearch
                                                systemctl start elasticsearch
                                                        if ps -ef |grep elasticsearch | cut -d ' ' -f 2 |grep . > /dev/null
                                                                then
                                                                echo "elasticsearch service is started successfully"
                                                                else
                                                                echo "elasticsearch service is failed to start. See \"journalctl -xe\" for details";



                                                        fi
                                               kibanainstall;
                                               exit

                                                else
                                                echo "No"
                                        fi
                                echo -e "**********************opening port****************************************"
                                firewall-cmd --zone=public --permanent --add-port=9200/tcp > /dev/null
                                firewall-cmd --reload > /dev/null

                                echo -e "******************starting elasticsearch service*****************************"
                                systemctl daemon-reload
                                systemctl enable elasticsearch
                                systemctl start elasticsearch
                                        if ps -ef |grep elasticsearch | cut -d ' ' -f 2 |grep . > /dev/null
                                                then
                                                echo "elasticsearch service is started successfully"
                                                else
                                                echo "elasticsearch service is failed to start. See \"journalctl -xe\" for details";
                                        fi




                                else
                                        echo "No"

                        fi


                        else
                        currentver="$(rpm -qa |grep -o 'elasticsearch........')"
                requiredver="elasticsearch-5.6.2-1"

                if [ "$currentver" = "$requiredver" ]; then
                        echo "version is up to date";
                        #exit
                else
                        if [ "$(printf '%s\n' "$requiredver" "$currentver" | sort -V | head -n1)" = "$requiredver" ]; then

                                                        ##############Downgrade#################
                                                        echo -n "would want to downgrade  elasticsearch 5.6.2,data may losss (y/n)? "

                                                        old_stty_cfg=$(stty -g)
                                                        stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                                                        if echo "$answer" | grep -iq "^y" ; then
                                                                                                                                echo "yes"
                                                                echo -e "**********************stoping elasticsearch service*****************************"
                                                                systemctl stop elasticsearch
                                                                systemctl disable elasticsearch
                                                                systemctl daemon-reload

                                                                echo -e "[elasticsearch-5.x] \nname=Elasticsearch repository for 5.x packages \nbaseurl=https://artifacts.elastic.co/packages/5.x/yum \ngpgcheck=1 \ngpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch \nenabled=1 \nautorefresh=1 \ntype=rpm-md" >>/etc/yum.repos.d/elasticsearch-5.6.2.repo

                                                                 yum downgrade -y nc elasticsearch-5.6.2

                                                                #echo -n "Enter the the Cluster name for elstic search : ";read g;

                                                                #sed -i '/cluster.name:/c\cluster.name: '$g'' /etc/elasticsearch/elasticsearch.yml
                                                                #echo -n "Enter the the Node name for elstic search : ";read h;
                                                                #sed -i '/node.name:/c\node.name: '$h'' /etc/elasticsearch/elasticsearch.yml
                                                                #echo -n "Enter the  Path to Data for elstic search : ";read i;
                                                                #sed -i '/path.data:/c\path.data: '$i'' /etc/elasticsearch/elasticsearch.yml
                                                                #echo -n "Enter the  Path to Logs for elstic search : ";read j;
                                                                #sed -i '/path.logs:/c\path.logs: '$j'' /etc/elasticsearch/elasticsearch.yml
                                                                #echo -n "Enter the  Ip Address for elstic search : ";read k;
                                                                #sed -i '/network.host:/c\network.host: '$k'' /etc/elasticsearch/elasticsearch.yml
                                                                echo -e "Elastic Search Defined port is allowed at firewall"
                                                                grep -oP "http.port:\s+\K\w+" /etc/elasticsearch/elasticsearch.yml
                                                                echo -n "would you like to change the port (y/n)? "
                                                                old_stty_cfg=$(stty -g)
                                                                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                                                                if echo "$answer" | grep -iq "^y" ;then
                                                                        echo "yes"

                                                                        function port1() {
                                                                          echo -n "Enter the port to assign for elasticsearch : ";
                                                                          read l;
                                                                          nc -v -z -w 3 localhost $l &> /dev/null && f1 || echo "Offline"
                                                                        }; port1;
                                                                        echo -e "the port is available"
                                                                        echo -e "changing port number in /etc/elasticsearch/elasticsearch.yml"

                                                                        sed -i '/http.port:/c\http.port: '$l'' /etc/elasticsearch/elasticsearch.yml

                                                                        firewall-cmd --zone=public --permanent --add-port=$l/tcp > /dev/null
                                                                        firewall-cmd --reload > /dev/null

                                                                        systemctl daemon-reload
                                                                        systemctl enable elasticsearch
                                                                        systemctl start elasticsearch
                                                                                if ps -ef |grep elasticsearch | cut -d ' ' -f 2 |grep . > /dev/null
                                                                                        then
                                                                                        echo "elasticsearch service is started successfully"
                                                                                        else
                                                                                        echo "elasticsearch service is failed to start. See \"journalctl -xe\" for details";



                                                                                fi
                                                                         kibanainstall;
                                                                        exit
                                                                        else
                                                                        echo "No"
                                                                fi
                                                                        echo -e "**********************opening port****************************************"
                                                                        firewall-cmd --zone=public --permanent --add-port=9200/tcp > /dev/null
                                                                        firewall-cmd --reload > /dev/null

                                                                        echo -e "******************starting elasticsearch service*****************************"
                                                                        systemctl daemon-reload
                                                                        systemctl enable elasticsearch
                                                                        systemctl start elasticsearch
                                                                                if ps -ef |grep elasticsearch | cut -d ' ' -f 2 |grep . > /dev/null
                                                                                        then
                                                                                        echo "elasticsearch service is started successfully"
                                                                                        else
                                                                                        echo "elasticsearch service is failed to start. See \"journalctl -xe\" for details";
                                                                                fi




                                                                else
                                                                        echo "No"

                                                        fi

















                                           else
                                #echo "test"
                                echo -n "would want to update to elasticsearch 5.6.2,take backup data may loss (y/n)? "

                                old_stty_cfg=$(stty -g)
                                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty
                                                        if echo "$answer" | grep -iq "^y" ;then
                                                                                                                                echo "yes"
                                                                echo -e "***********************stoping elasticsearch service*****************************"
                                                                systemctl stop elasticsearch
                                                                systemctl disable elasticsearch
                                                                systemctl daemon-reload
                                                                echo -e "[elasticsearch-5.x] \nname=Elasticsearch repository for 5.x packages \nbaseurl=https://artifacts.elastic.co/packages/5.x/yum \ngpgcheck=1 \ngpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch \nenabled=1 \nautorefresh=1 \ntype=rpm-md" >>/etc/yum.repos.d/elasticsearch-5.6.2.repo

                                                                yum update  -y nc elasticsearch-5.6.2

                                                                #echo -n "Enter the the Cluster name for elstic search : ";read m;
                                                                #sed -i '/cluster.name:/c\cluster.name: '$m'' /etc/elasticsearch/elasticsearch.yml
                                                                #echo -n "Enter the the Node name for elstic search : ";read n;
                                                                #sed -i '/node.name:/c\node.name: '$n'' /etc/elasticsearch/elasticsearch.yml
                                                                #echo -n "Enter the  Path to Data for elstic search : ";read o;
                                                                #sed -i '/path.data:/c\path.data: '$o'' /etc/elasticsearch/elasticsearch.yml
                                                                #echo -n "Enter the  Path to Logs for elstic search : ";read p;
                                                                #sed -i '/path.logs:/c\path.logs: '$p'' /etc/elasticsearch/elasticsearch.yml
                                                                #echo -n "Enter the  Ip Address for elstic search : ";read q;
                                                                #sed -i '/network.host:/c\network.host: '$q'' /etc/elasticsearch/elasticsearch.yml
                                                                echo -e "Elastic Search Defined port is allowed at firewall"
                                                                grep -oP "http.port:\s+\K\w+" /etc/elasticsearch/elasticsearch.yml
                                                                echo -n "would you like to change the port (y/n)? "
                                                                old_stty_cfg=$(stty -g)
                                                                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                                                                if echo "$answer" | grep -iq "^y" ;then
                                                                        echo "yes"

                                                                        function port2() {
                                                                          echo -n "Enter the port to assign for elasticsearch : ";
                                                                          read r;
                                                                          nc -v -z -w 3 localhost $r &> /dev/null && f1 || echo "Offline"
                                                                        }; port2;
                                                                        echo -e "the port is available"
                                                                        echo -e "changing port number in /etc/elasticsearch/elasticsearch.yml"

                                                                        sed -i '/http.port:/c\http.port: '$r'' /etc/elasticsearch/elasticsearch.yml

                                                                        firewall-cmd --zone=public --permanent --add-port=$r/tcp > /dev/null
                                                                        firewall-cmd --reload > /dev/null

                                                                        systemctl daemon-reload
                                                                        systemctl enable elasticsearch
                                                                        systemctl start elasticsearch
                                                                                if ps -ef |grep elasticsearch | cut -d ' ' -f 2 |grep . > /dev/null
                                                                                        then
                                                                                        echo "elasticsearch service is started successfully"
                                                                                        else
                                                                                        echo "elasticsearch service is failed to start. See \"journalctl -xe\" for details";



                                                                                fi
                                                                         kibanainstall;
                                                                        exit
                                                                        else
                                                                        echo "No"
                                                                fi
                                                                echo -e "**********************opening port****************************************"
                                                                firewall-cmd --zone=public --permanent --add-port=9200/tcp > /dev/null
                                                                firewall-cmd --reload > /dev/null

                                                                echo -e "******************starting elasticsearch service*****************************"
                                                                systemctl daemon-reload
                                                                systemctl enable elasticsearch
                                                                systemctl start elasticsearch
                                                                        if ps -ef |grep elasticsearch | cut -d ' ' -f 2 |grep . > /dev/null
                                                                                then
                                                                                echo "elasticsearch service is started successfully"
                                                                                else
                                                                                echo "elasticsearch service is failed to start. See \"journalctl -xe\" for details";
                                                                        fi

                                                                else
                                                                echo "No"

                                                        fi



                        fi
                fi
        fi



};











#!/bin/bash


function kibanainstall {


  if !  rpm -qa |grep -o 'kibana........' ; then

                echo -n "would want to install  kibana 5.6.2 (y/n)? "
                old_stty_cfg=$(stty -g)
                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                if echo "$answer" | grep -iq "^y" ;then
                        echo -e "[kibana-5.x] \nname=Kibana repository for 5.x packages \nbaseurl=https://artifacts.elastic.co/packages/5.x/yum \ngpgcheck=1 \ngpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch \nenabled=1 \nautorefresh=1 \ntype=rpm-md" >>/etc/yum.repos.d/kibana-5.6.10.repo
                        yum install -y nc kibana-5.6.2
                        echo -n "Enter the the Ip Address or HOSTNAME for Kibana : ";read s;
                        echo -n "Enter the elasticsearch port number  : ";read t;
                        sudo sed -i 's/#server.host: "localhost"/server.host: '$s'/g' /etc/kibana/kibana.yml
                        sed -i '/#elasticsearch.url: "http:\/\/localhost:9200"/a elasticsearch.url: "http:\/\/'$s':'$t'" ' /etc/kibana/kibana.yml
                        sed -i 's/#server.port: 5601/server.port: 5601/g' /etc/kibana/kibana.yml
                        echo -e "kibana Defined port is allowed at firewall"
                        grep -oP "server.port:\s+\K\w+" /etc/kibana/kibana.yml
                        echo -n "would you like to change the port (y/n)? "
                        old_stty_cfg=$(stty -g)
                        stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                                if echo "$answer" | grep -iq "^y" ;then
                                        echo "yes"

                                        function port3() {
                                          echo -n "Enter the port to assign for Kibana : ";
                                          read u;
                                          nc -v -z -w 3 localhost $u &> /dev/null && f1 || echo "Offline"
                                        }; port3;
                                        echo -e "the port is available"
                                        echo -e "changing port number in /etc/kibana/kibana.yml"

                                        sed -i '/server.port:/c\  server.port: '$u'' /etc/kibana/kibana.yml

                                        firewall-cmd --zone=public --permanent --add-port=$u/tcp > /dev/null
                                        firewall-cmd --reload > /dev/null

                                        systemctl daemon-reload
                                        systemctl enable kibana
                                        systemctl start kibana
                                                if ps -ef |grep kibana |grep node | awk '{print $2}' > /dev/null
                                                        then
                                                        echo "kibana service is started successfully"
                                                        else
                                                        echo "kibana service is failed to start. See \"journalctl -xe\" for details";
                                                fi
                                                                                                exit
                                                else
                                                echo "No"
                                fi
                        echo -e "**********************opening port****************************************"
                        firewall-cmd --zone=public --permanent --add-port=5601/tcp > /dev/null
                        firewall-cmd --reload > /dev/null

                        echo -e "******************starting kibana service*****************************"
                        systemctl daemon-reload
                        systemctl enable kibana
                        systemctl start kibana
                                        if ps -ef |grep kibana |grep node | awk '{print $2}' > /dev/null
                                                then
                                                echo "kibana service is started successfully"
                                                else
                                                echo "kibana service is failed to start. See \"journalctl -xe\" for details";
                                        fi




                                else
                                        echo "No"

                fi
                else

                        currentver="$(rpm -qa |grep -o 'kibana........')"
                requiredver="kibana-5.6.2-1"

                if [ "$currentver" = "$requiredver" ]; then
                        echo "version is up to date";
                        #exit
                else
                        if [ "$(printf '%s\n' "$requiredver" "$currentver" | sort -V | head -n1)" = "$requiredver" ]; then

                                                        ##############Downgrade#################
                                                        echo -n "would want to downgrade  kibana 5.6.2,data may losss (y/n)? "

                                                        old_stty_cfg=$(stty -g)
                                                        stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                                                        if echo "$answer" | grep -iq "^y" ; then
                                                                                                                                echo "yes"
                                                                echo -e "**********************stoping kibana service*****************************"
                                                                systemctl stop kibana
                                                                systemctl disable kibana
                                                                systemctl daemon-reload

                                                                echo -e "[kibana-5.x] \nname=Kibana repository for 5.x packages \nbaseurl=https://artifacts.elastic.co/packages/5.x/yum \ngpgcheck=1 \ngpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch \nenabled=1 \nautorefresh=1 \ntype=rpm-md" >>/etc/yum.repos.d/kibana-5.6.10.repo
                                                                yum downgrade -y nc kibana-5.6.2
                                                                #echo -n "Enter the the Ip Address for Kibana : ";read v;
                                                                #sudo sed -i 's/#server.host: "localhost"/server.host: '$v'/g' /etc/kibana/kibana.yml
                                                                #echo -n "Enter the elasticsearch port number  : ";read w;
                                                                #sed -i '/#elasticsearch.url: "http:\/\/localhost:9200"/a elasticsearch.url: "http:\/\/'$v':'$w'" ' /etc/kibana/kibana.yml
                                                                echo -e "Kibana port is allowed at firewall"
                                                                grep -oP "server.port:\s+\K\w+" /etc/kibana/kibana.yml
                                                                echo -n "would you like to change the port (y/n)? "
                                                                old_stty_cfg=$(stty -g)
                                                                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                                                                if echo "$answer" | grep -iq "^y" ;then
                                                                        echo "yes"

                                                                        function port5() {
                                                                          echo -n "Enter the port to assign for Kibana : ";
                                                                          read x;
                                                                          nc -v -z -w 3 localhost $x &> /dev/null && f1 || echo "Offline"
                                                                        }; port5;
                                                                        echo -e "the port is available"
                                                                        echo -e "changing port number in /etc/kibana/kibana.yml"

                                                                        sed -i '/server.port:/c\  server.port: '$x'' /etc/kibana/kibana.yml

                                                                        firewall-cmd --zone=public --permanent --add-port=$x/tcp > /dev/null
                                                                        firewall-cmd --reload > /dev/null

                                                                        systemctl daemon-reload
                                                                        systemctl enable kibana
                                                                        systemctl start kibana
                                                                        if ps -ef |grep kibana |grep node | awk '{print $2}' > /dev/null
                                                                                then
                                                                                echo "kibana service is started successfully"
                                                                                else
                                                                                echo "kibana service is failed to start. See \"journalctl -xe\" for details";
                                                                        fi
                                                                                                                                                exit
                                                                        else
                                                                        echo "No"
                                                                fi
                                                                echo -e "**********************opening port****************************************"
                                                                firewall-cmd --zone=public --permanent --add-port=5601/tcp > /dev/null
                                                                firewall-cmd --reload > /dev/null

                                                                echo -e "******************starting kibana service*****************************"
                                                                systemctl daemon-reload
                                                                systemctl enable kibana
                                                                systemctl start kibana
                                                                                if ps -ef |grep kibana |grep node | awk '{print $2}' > /dev/null
                                                                                        then
                                                                                        echo "kibana service is started successfully"
                                                                                        else
                                                                                        echo "kibana service is failed to start. See \"journalctl -xe\" for details";
                                                                                fi




                                                                        else
                                                                                echo "No"
                                                                fi

                                                                else
                                #echo "test"
                               echo -n "would want to update to kibana 5.6.2,take backup data may loss (y/n)? "

                                old_stty_cfg=$(stty -g)
                                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty
                                                        if echo "$answer" | grep -iq "^y" ;then
                                                                                                                echo "yes"
                                                        echo -e "**********************stoping kibana service*****************************"
                                                                systemctl stop kibana
                                                                systemctl disable kibana
                                                                systemctl daemon-reload

                                                                echo -e "[kibana-5.x] \nname=Kibana repository for 5.x packages \nbaseurl=https://artifacts.elastic.co/packages/5.x/yum \ngpgcheck=1 \ngpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch \nenabled=1 \nautorefresh=1 \ntype=rpm-md" >>/etc/yum.repos.d/kibana-5.6.10.repo
                                                                yum update -y nc kibana-5.6.2
                                                                #echo -n "Enter the the Ip Address for Kibana : ";read y;
                                                                #sudo sed -i 's/#server.host: "localhost"/server.host: '$y'/g' /etc/kibana/kibana.yml
                                                                #echo -n "Enter the elasticsearch port number  : ";read z;
                                                                #sed -i '/#elasticsearch.url: "http:\/\/localhost:9200"/a elasticsearch.url: "http:\/\/'$y':'$z'" ' /etc/kibana/kibana.yml
                                                                echo -e "Elastic Search Defined port is allowed at firewall"
                                                                grep -oP "#server.port:\s+\K\w+" /etc/kibana/kibana.yml
                                                                echo -n "would you like to change the port (y/n)? "
                                                                old_stty_cfg=$(stty -g)
                                                                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                                                                if echo "$answer" | grep -iq "^y" ;then
                                                                        echo "yes"

                                                                        function port6() {
                                                                          echo -n "Enter the port to assign for Kibana : ";
                                                                          read a1;
                                                                          nc -v -z -w 3 localhost $a1 &> /dev/null && f1 || echo "Offline"
                                                                        }; port6;
                                                                        echo -e "the port is available"
                                                                        echo -e "changing port number in /etc/kibana/kibana.yml"

                                                                        sed -i '/server.port:/c\  server.port: '$a1'' /etc/kibana/kibana.yml

                                                                        firewall-cmd --zone=public --permanent --add-port=$a1/tcp > /dev/null
                                                                        firewall-cmd --reload > /dev/null

                                                                        systemctl daemon-reload
                                                                        systemctl enable kibana
                                                                        systemctl start kibana
                                                                        if  ps -ef |grep kibana |grep node | awk '{print $2}'   > /dev/null
                                                                                then
                                                                                echo "kibana service is started successfully"
                                                                                else
                                                                                echo "kibana service is failed to start. See \"journalctl -xe\" for details";
                                                                        fi
                                                                                                                                                exit
                                                                        else
                                                                        echo "No"
                                                                fi
                                                                echo -e "**********************opening port****************************************"
                                                                firewall-cmd --zone=public --permanent --add-port=5601/tcp > /dev/null
                                                                firewall-cmd --reload > /dev/null

                                                                echo -e "******************starting kibana service*****************************"
                                                                systemctl daemon-reload
                                                                systemctl enable kibana
                                                                systemctl start kibana
                                                                                if ps -ef |grep kibana |grep node | awk '{print $2}' > /dev/null
                                                                                        then
                                                                                        echo "kibana service is started successfully"
                                                                                        else
                                                                                        echo "kibana service is failed to start. See \"journalctl -xe\" for details";
                                                                                fi




                                                                        else
                                                                                echo "No"
                                                                fi



                        fi
                fi
    fi



};

########java check####################
m5="$(java -version 2>&1 >/dev/null | grep 'java version' | awk '{print $3}'|sed -e 's/"//g')"
 echo "Java SE version is $m5 installed"

b5=1.8.0_161
if [ $m5 == $b5 ] ;then
echo "same version"
elif [ $m5 != $b5 ];then
  if [ $m5 \< $b5 ];then
  echo "Required Java SE version is 1.8.0_161 please upgrade"
  exit
  fi
  if [ $m5 \> $b5 ];then
  echo "Required Java SE version is 1.8.0_161 please Downgrade"
  exit
 fi
else
echo "please install Java SE version is 1.8.0_161"
exit
fi

host=$(hostname -f)
echo $host
while [ $host = localhost ]
do
echo -n "Enter the IP address of the system : ";read ipadd;
 echo -n "Enter the fully qualified domain name to assign : ";read name;
 echo $ipadd                $name  >> /etc/hosts
 sudo systemctl restart network
break
done




x=" $(dmidecode --type memory |grep Size: |grep MB |xargs | awk '{print $2,$5,$8,$11,$14,$17,$20,$23,$26,$29,$32,$35,$38,$41,$44,$47,$50,$53,$56,$59}' | awk  '{ print $1+$2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20 }')"
echo "$x"
if [ $x -ge 8192 ]
                then
                #echo "we can proceed to install"
                elasticsearchinstall;
                kibanainstall;
        else
                echo -n "memory is not sufficient to run ezflow application .If we install performance may be degraded.Do you want to install  (y/n)? "
                old_stty_cfg=$(stty -g)
                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                if echo "$answer" | grep -iq "^y" ;then
                 echo "yes"
                 elasticsearchinstall;
                 kibanainstall;
                 else
                        echo "No"
                fi

   fi
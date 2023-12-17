echo "checking diff"
for i in `hosts`; do 
    setupcompleted=`grep ^$i completed-setup.db` 
    echo "---test $setupcompleted test---"
    if [ -z "$setupcompleted" ]; then
		#print msg
		echo creating new hvost for $i
	
		## Create apache vhost conf file for each customer
        	cp template-vhost.conf_tmp $i.conf

		# Update conf file and define servername
		echo "create conf file"
		sed -i "s/SERVERNAME/$i/" $i.conf
        	#create html
		echo "create html file"
        	echo "<h1>Hello $i  "  > $i.html	

       		#deploy setup
		echo "deployment started..."
       		## copy conf files
		echo "copy files to server"
       		scp $i.* ubuntu@34.239.130.43:/tmp/                               #Ip 
       		## create document root directory
		echo "create doc root dir to server"
       		ssh -t ubuntu@34.239.130.43 sudo mkdir /var/www/html/$i          #ip
       		## move conf and web file to their localtion

		echo "move conf and html file"
       		ssh -t ubuntu@34.239.130.43 sudo mv /tmp/$i.conf /etc/apache2/sites-enabled/$i.conf
       		ssh -t ubuntu@34.239.130.43 sudo mv /tmp/$i.html /var/www/html/$i/index.html
       		##restart apache 
       		echo "reload apache"
       		ssh -t ubuntu@34.239.130.43 sudo systemctl reload apache2
       		echo "$i"  >> completed-setup.db
    fi
echo -e "\n deployment complted"    
done


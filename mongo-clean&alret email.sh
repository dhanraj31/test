VAL=`df -TH |grep /logs|awk '{print $6}'`
PER=`echo $VAL| tr -d '%'`
if [ $PER -gt 60 ]; then
        echo "Disk space usages high"
        #Generate email
        subjet="Disk space of /logs is high on UAE02"
        message="Disk space usages on /log file system is $VAL"
        recipient="pankaj@social27.com","dhanrajsingh@social27.com","gsingh@social27.com","dsingh@social27.com"
        echo "$message"|mail -s "$subject" "$recipient"
        echo /dev/null > /logs/mongodb/mongod.log
else
        subjet="Disk space of /logs is Under 60% on UAE02"
                message="Disk space usages on /log file system is $VAL"
                        recipient="pankaj@social27.com","dhanrajsingh@social27.com","gsingh@social27.com","dsingh@social27.com"
                                echo "$message"|mail -s "$subject" "$recipient"
        echo "Disk space looks good"
fi

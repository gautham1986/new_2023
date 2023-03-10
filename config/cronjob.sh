#!/bin/bash

#
# script (c) Eficode 2018
# this determines if this node is first one in autoscaling group, and if so, runs
# pre-determined script given as parameter, so acts as gatekeeper for crontab
# making sure execution is always from first node in autoscaling group only

instance_id=`curl --silent http://169.254.169.254/latest/meta-data/instance-id`
asg_first=`aws autoscaling describe-auto-scaling-instances --region eu-central-1 | jq -r '.AutoScalingInstances[0].InstanceId'`

binpath="/usr/bin/php -q"
cronpath="/var/www/keppet/core/cron"


if [ "$instance_id" == "$asg_first" ]; then
        #if here, we are first node in autoscaling group
        echo "Host id ${instance_id} matches to instance ${asg_first} which is first in autoscaling group"

        case "$1" in
            "save_keppet_rtb_impressions")
	 	echo "running ${1}"
		${binpath} $cronpath/${1}.php
		;;
	    "save_keppet_useragent_impressions")
		echo "running ${1}"
		${binpath} $cronpath/${1}.php
		;;
	    "scrape_keppet_direct")
		echo "running ${1}"
	    ${binpath} $cronpath/${1}.php
		;;
	    "scrape_prebid_report")
		echo "running ${1}"
		${binpath} $cronpath/${1}.php
		;;
            "scrape_keppet_report")
                echo "running ${1}"
                ${binpath} $cronpath/${1}.php
                ;;
	    "scrape_keppet_incoming_report")
		echo "running ${1}"
		${binpath} $cronpath/${1}.php
		;;
	    "keppet_scrape_week")
		echo "running ${1}"
	 	${binpath} $cronpath/${1}.php week
		;;
	    "keppet_scrape_month")
		echo "running ${1}"
		${binpath} $cronpath/${1}.php month
		;;
	    "prebid_currency_rates")
		echo "running ${1}"
		${binpath} $cronpath/${1}.php
		;;
	    "create_prebid_dfp_order")
		echo "running ${1}"
		${binpath} $cronpath/${1}.php
		;;
	    *) 
		echo "no argument given which cron task to run"
		;;
        esac
elif [ "$instance_id" != "$asg_first" ]; then
    echo "Host id ${instance_id} does not match to instance ${asg_first} which is first in autoscaling group"
fi

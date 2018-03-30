#!/bin/bash
curdate=`date +%Y-%m-%d`
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
warning=0
for result in `influx -database=hass -execute 'select last(value) from /.*/ group by entity_id' -format=csv -precision=rfc3339|grep -v tags|cut -d"=" -f2-`
do 
	
	date=`echo $result|cut -d"," -f2|cut -d"T" -f1`
	entity_id=`echo $result|cut -d"," -f1`
	days_diff=$(( (`date -d $date +%s` - `date -d $curdate +%s`) / (24*3600) ))
	if [ $days_diff != 0 ];
	then
		echo -e ${RED}$entity_id": "$days_diff "days."${NC}
		((warning++))
	else
		echo -e ${GREEN}$entity_id": "$days_diff "days."${NC}
	fi
done
echo "----------"
echo $warning" entity_id is having more than a day old data"

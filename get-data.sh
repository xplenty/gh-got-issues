#!/bin/sh
wget http://data.githubarchive.org/{2012,2013,2014}-{01..12}-{01..31}-{0..23}.json.gz
distinct_dates=$(ls -l | awk '{print $9}' | awk -F "-" '{count[$1"-"$2"-"$3]++}END{for(j in count) print j}')
for i in $distinct_dates
do
  echo "Grouping for $i month"
  gzip -d $i-*.json.gz
  cat $i-*.json* > to_s3/$i.json
  rm -f $i-*.json
  gzip to_s3/$i.json
  s3cmd put to_s3/$i.json S3://xplenty.public/github_archive
done 

#!/bin/sh
echo 'Content-type: text/plain'
echo

for organization in /srv/fossil/fossils/*
do

  org_name="$(basename ${organization})"
  repos=$(ls ${organization} | grep fossil)

  for repo in ${repos};
  do

    url=$(echo ${repo} | sed 's%\.fossil%%')

    echo "${org_name}/${url}"

  done

done


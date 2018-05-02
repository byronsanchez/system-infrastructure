#!/bin/sh
echo 'Content-type: text/xml'
echo
cat <<EOM
<?xml version="1.0" encoding="utf-8"?>
<opml version="1.0">
  <head>
    <title>fossil.hackbytes.io Feeds</title>
  </head>
  <body>
    <outline text="fossil.hackbytes.io RSS feeds">
EOM

for organization in /srv/fossil/fossils/*
do

  org_name="$(basename ${organization})"
  repos=$(ls ${organization} | grep fossil)

  for repo in ${repos};
  do

    url=$(echo ${repo} | sed 's%\.fossil%%')

    echo "      <outline type=\"rss\" text=\"${org_name}/${url}\" title=\"${org_name}/${url}\" xmlUrl=\"https://fossil.hackbytes.io/${org_name}/${url}/timeline.rss\" htmlUrl=\"https://fossil.hackbytes.io/${org_name}/${url}/timeline.rss\" />"

  done

done

cat <<EOM
    </outline>
  </body>
</opml>
EOM


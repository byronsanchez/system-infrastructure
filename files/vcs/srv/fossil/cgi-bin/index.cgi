#!/bin/sh
echo 'Content-type: text/html'
echo
cat <<EOM
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
  <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
      <title>fossil.nitelite.io</title>
      <style type="text/css">
      .main {
      padding-left:     1em;
      padding-top:      0.2em;
      font-family:      sans-serif;
      font-size:        1em;
      font-size:        80%;
      color:            #333;
      background-color: #fff;
      }
      td {
        padding-right: 1em;
      }

      a         { }
      a:link    { color: #777; }
      a:visited { color: #777; }
      a:hover   { color: #000; }
      a:active  { color: #777; }
      </style>
    </head>
    <body>
      <div class="main">
        <h3>fossil.nitelite.io</h3>
        <div>
          <p><a href="/opml.cgi">opml</a> | <a href="/list.cgi">list</a></p>
        </div>
	<div>
          <table>
EOM

for organization in /srv/fossil/fossils/*
do

  org_name="$(basename ${organization})"
  repos=$(ls ${organization} | grep fossil)

  for repo in ${repos};
  do

    echo '            <tr>'

    url=$(echo ${repo} | sed 's%\.fossil%%')

    echo "              <td> <a href="/${org_name}/${url}">${org_name}/${repo}</a></td>"
    echo "              <td><a href="/${org_name}/${url}/timeline.rss">rss-all</a></td>"
    echo "              <td><a href="/${org_name}/${url}/timeline.rss?y=t">rss-tickets</a></td>"
    echo "              <td><a href="/${org_name}/${url}/timeline.rss?y=ci">rss-commits</a></td>"

    echo '            </tr>'

  done

done

cat <<EOM
          </table>
        </div>
      </div>
    </body>
  </html>
EOM


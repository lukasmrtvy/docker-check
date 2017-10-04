#!/bin/sh
#curl -s --unix-socket /var/run/docker.sock http:/v1.30/containers/json | jq '.[]' > 
#curl -s https://api.github.com/repos/xbmc/xbmc/releases/latest |   jq --raw-output .tag_name

command=`curl -s --unix-socket /var/run/docker.sock http:/v1.30/containers/json | jq -r '.[].Labels.url'`
command1=`curl -s --unix-socket /var/run/docker.sock http:/v1.30/containers/json | jq -r '.[].Labels.name'`
command2=`curl -s --unix-socket /var/run/docker.sock http:/v1.30/containers/json | jq -r '.[].Labels.version'`


echo "<table>" > index.html 
echo "<tr>" >> index.html
echo "<th> Application </th>" >> index.html
echo "<th> Current version </th>" >> index.html
echo "<th> New version </th>" >> index.html
echo "</tr>" >> index.html

for p in $command
do
if [ ${p}  ];
then
test=`curl -s ${p} | jq --raw-output .tag_name`
else
test=`curl -s ${p} | jq --raw-output .tag_name`
fi
    echo "<tr>" >> index.html
    echo "<th> ${command1} </th> " >> index.html
    echo "<th> ${command2} </th> " >> index.html
    echo "<th> ${test}  </th>" >> index.html
    echo "</tr>" >> index.html
done

echo "</table>" >> index.htm

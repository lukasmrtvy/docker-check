#!/bin/sh

command=`curl -s --unix-socket /var/run/docker.sock http:/v1.30/containers/json | jq -r '.[].Id'`

echo `date` > index.html

cat << 'EOF' >> index.html
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
<div class="container">
  <h2>Docker version table</h2>
  <div class="table-responsive">
  <table class="table table-bordered .table-condensed">
    <thead>
      <tr>
        <th>Name</th>
        <th>Current version</th>
        <th>Latest version</th>
      </tr>
    </thead>
    <tbody>
EOF
for p in $command
do
  getstate=`curl -s --unix-socket /var/run/docker.sock http:/v1.30/containers/${p}/json | jq -r '.State.Status'`
  getname=`curl -s --unix-socket /var/run/docker.sock http:/v1.30/containers/${p}/json | jq -r '.Name'`
  getgiturl=`curl -s --unix-socket /var/run/docker.sock http:/v1.30/containers/${p}/json | jq -r '.Config.Labels.url'`

if [ $(echo "${getgiturl}" |  sed 's:.*/::') = "master"  ]; then
  getgitversion=`curl -s ${getgiturl} | jq -r '.sha'`
elif [ $(echo "${getgiturl}" |  sed 's:.*/::') = "tags"  ]; then
  getgitversion=`curl -s ${getgiturl} | jq -r '.[0].name'`
elif [ $(echo "${getgiturl}" |  sed 's:.*/::') = "latest"  ]; then
  getgitversion=`curl -s ${getgiturl} | jq --raw-output .tag_name`
fi
  getlocalversion=`curl -s --unix-socket /var/run/docker.sock http:/v1.30/containers/${p}/json | jq -r '.Config.Labels.version'`
if [ ${getgiturl} = "null" ] || [ ${getlocalversion} = "null" ]; then
        getgitversion=$(echo "Not available")
        getlocalversion=$(echo "Not available")
fi
    echo "<tr>" >> index.html
    echo "<td> ${getname} </td> " >> index.html
    echo "<td> ${getlocalversion}  </td>" >> index.html
    echo "<td> ${getgitversion}  </td>" >> index.html
    echo "</tr>" >> index.html
done
cat << 'EOF' >> index.html
        </tbody>
      </table>
    </div>
   </div>
  </body>
</html>
EOF


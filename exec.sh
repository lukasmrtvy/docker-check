#!/bin/sh
#curl -s --unix-socket /var/run/docker.sock http:/v1.30/containers/json | jq '.[]' >
#curl -s https://api.github.com/repos/xbmc/xbmc/releases/latest |   jq --raw-output .tag_name

command=`curl -s --unix-socket /var/run/docker.sock http:/v1.30/containers/json | jq -r '.[].Id'`


#curl -s --unix-socket /var/run/docker.sock http:/v1.30/containers/${id}/json | jq  '.Config.ExposedPorts | keys'


#command1=`curl -s --unix-socket /var/run/docker.sock http:/v1.30/containers/json | jq -r '.[].Labels.name'`
#command2=`curl -s --unix-socket /var/run/docker.sock http:/v1.30/containers/json | jq -r '.[].Labels.version'`


#curl -s --unix-socket /var/run/docker.sock http:/v1.30/containers/d91bd7ef81886b6f2c22da6698b7e1715571b0f1d4e4256738b221b7f3b8230c/json | jq  -r  -c '.NetworkSettings.Ports'

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
  <h2>Docker table</h2>
  <p> Use Label version in dockerfile to pull latest version info from github </p>
  <div class="table-responsive">
  <table class="table table-bordered .table-condensed">
    <thead>
      <tr>
        <th>1</th>
        <th>2</th>
        <th>3</th>
        <th>4</th>
        <th>5</th>
      </tr>
    </thead>
    <tbody>

EOF

for p in $command
do
  getstate=`curl -s --unix-socket /var/run/docker.sock http:/v1.30/containers/${p}/json | jq -r '.State.Status'`
  getname=`curl -s --unix-socket /var/run/docker.sock http:/v1.30/containers/${p}/json | jq -r '.Name'`
  #getports=`curl -s --unix-socket /var/run/docker.sock http:/v1.30/containers/${p}/json | jq  -r  '.Config.ExposedPorts | keys []'`
  getports=`curl -s --unix-socket /var/run/docker.sock http:/v1.30/containers/${p}/json | jq  -r  '.NetworkSettings.Ports[][].HostPort'`
  getgiturl=`curl -s --unix-socket /var/run/docker.sock http:/v1.30/containers/${p}/json | jq -r '.[].Labels.url'`
  getgitversion=`curl -s ${getgiturl} | jq --raw-output .tag_name`
  getlocalversion=`curl -s --unix-socket /var/run/docker.sock http:/v1.30/containers/${p}/json | jq -r '.[].Labels.version'`

    echo "<tr>" >> index.html
#    echo "<th> ${p} </th> " >> index.html
    echo "<th> ${getname} </th> " >> index.html
    echo "<th> ${getstate} </th> " >> index.html
    echo "<th> ${getports}  </th>" >> index.html
    echo "<th> ${getlocalversion}  </th>" >> index.html
    echo "<th> ${getgitversion}  </th>" >> index.html

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


#if [ ${p}  ];
#then
#test=`curl -s ${p} | jq --raw-output .tag_name`
#else
#test=`curl -s ${p} | jq --raw-output .tag_name`
#fi

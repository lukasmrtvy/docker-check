#!/bin/bash

api_version=v1.30

command=`curl -s --unix-socket /var/run/docker.sock http:/$api_version/containers/json | jq -r '.[].Id'`

result="result.json"
echo '{"data":[]}' > "$result"

if [ ${username+set} ] && [ ${token+set} ]; then
        auth=$(-u ${username}:${token} )
else 
        auth=""
fi

for p in $command
do
  j=$(curl -s --unix-socket /var/run/docker.sock http:/$api_version/containers/${p}/json)
  name=$(jq -r '.Name' <<< "$j")
  state=$(jq -r '.State.Status' <<< "$j")
  giturl=$(jq -r '.Config.Labels.url' <<< "$j")
  local_version=$(jq -r '.Config.Labels.version' <<< "$j")
  k=$(echo ${giturl} | awk -F'github.com/' '{print $2}' | sed -e 's#/$##')
  latest_tag=$(curl -s ${auth} https://api.github.com/repos/$k/tags | jq -r '.[0].name' |xargs  )
  latest_commit=$(curl -s ${auth} https://api.github.com/repos/$k/commits | jq -r '.[0].sha' |xargs  )
  latest_release=$(curl -s ${auth} https://api.github.com/repos/$k/releases/latest | jq -r ' .name' )

jq --arg arg_name "$name" \
  --arg arg_state "$state" \
  --arg arg_giturl "$giturl" \
  --arg arg_localversion "$local_version" \
  --arg arg_latestrelease "$latest_release" \
  --arg arg_latesttag "$latest_tag" \
  --arg arg_latestcommit "$latest_commit" \
        '.data += [[ $arg_name, $arg_state, $arg_giturl, $arg_localversion, $arg_latestrelease, $arg_latesttag, $arg_latestcommit ]]' "$result" | sponge "$result"

done

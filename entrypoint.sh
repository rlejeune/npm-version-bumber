#!/bin/bash

function incrementVersion {
  cmpt=0

  IFS='.'
  read -ra ADDR <<< "$1"
  for i in "${ADDR[@]}"; do
    if [ $cmpt == 0 ];
    then
      major="$i"
    elif [ $cmpt == 1 ];
    then
      minor="$i"
      minor=$((minor+1))
    fi

    cmpt=$((cmpt+1))
  done

  tag=$major"."$minor".0"

  IFS=''
}

cd ${GITHUB_WORKSPACE}

git fetch --tags

# get latest tag
gitTag=$(git describe --tags `git rev-list --tags --max-count=1`)

# If we have not tag, then we start at 0.0.0
if [ -z "$gitTag" ]
then
  tag=0.0.0
else
  tag=${gitTag#"v"}
fi

incrementVersion $tag

# get the npm version
npmVersion=$(cat package.json | grep version | head -1 | awk -F: '{ print $2 }' | sed 's/[",]//g' | tr -d '[[:space:]]')

# print latest
echo "Next release minor version: $tag"
echo "NPM version: $npmVersion"

if [ $tag != $npmVersion ];
then
  # echo "NPM version has been bumped"
  # bumpedVersion=$(npm version ${tag} --no-git-tag-version)
  # echo $(cat package.json | grep version | head -1 | awk -F: '{ print $2 }' | sed 's/[",]//g' | tr -d '[[:space:]]')
  echo "::set-output name=npmVersion::$tag"
else
  echo "NPM version is the same as next release"
fi

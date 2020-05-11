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
    else
      patch="$i"
    fi

    cmpt=$((cmpt+1))
  done

  bump=${DESIRED_BUMP:-minor}
  if [ $bump == 'major' ];
  then
    major=$((major+1))
    minor=0
    patch=0
  elif [ $bump == 'patch' ];
  then
    patch=$((patch+1))
  else
    minor=$((minor+1))
    patch=0
  fi
  tag=$major"."$minor"."$patch

  IFS=''
}

cd ${GITHUB_WORKSPACE}

git fetch --tags

# get latest tag
gitTag=$(git describe --tags `git rev-list --tags --max-count=1`)

if [ -z "$gitTag" ]
then
  # no tag, start with 0.0.0
  tag=0.0.0
else
  # remove the v in front of the existing tag
  tag=${gitTag#"v"}
fi

incrementVersion $tag

# get the npm version
npmversion=$(cat package.json | grep version | head -1 | awk -F: '{ print $2 }' | sed 's/[",]//g' | tr -d '[[:space:]]')

if [ $tag != $npmversion ];
then
  # update npm version
  tag=$(npm version ${tag} --no-git-tag-version)
  echo "::set-output name=new_npm_version::$tag"
else
  echo "::set-output name=new_npm_version::$npmversion"
fi

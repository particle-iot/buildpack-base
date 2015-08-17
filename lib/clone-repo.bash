clone-repo() {
  IFS='#' read -ra URL <<< "$1"
  GIT_URL=${URL[0]}
  GIT_COMMIT_ISH=${URL[1]}

  if [ ! -d "$2" ]; then
    git clone $GIT_URL $2
    cd $2
    git fetch --tags

    if [ ! -z "$GIT_COMMIT_ISH" ]; then
      git checkout $GIT_COMMIT_ISH
    fi

    git submodule update --init --recursive
  fi
}

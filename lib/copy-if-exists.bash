copy-if-exists() {
  if [ -f "$1" ]; then
    yes | cp -i $1 $2
  fi
}

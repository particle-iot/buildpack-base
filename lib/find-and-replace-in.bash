escape-sed() {
 sed \
  -e 's/\//\\\//g' \
  -e 's/\&/\\\&/g'
}

find-and-replace-in() {
  FROM=`echo $1 | escape-sed`
  TO=`echo $2 | escape-sed`
  echo $FROM
  echo $TO
  sed -i -e "s/$FROM/$TO/g" $3
}

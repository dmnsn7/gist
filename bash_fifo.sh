#!/bin/bash -e

CONCURRENCY=3

tmpfile="/tmp/$$.fifo"
mkfifo $tmpfile
exec 6<>$tmpfile
rm $tmpfile

for ((i = 0; i < CONCURRENCY; i++)); do
  echo >&6
done

while read -r line; do
  read -r <&6
  {
    sleep "$line"
    echo "$line"
    echo >&6
  } &
done <<EOF
1
3
5
6
4
2
EOF

wait
exec 6>&-

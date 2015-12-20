#!/bin/sh

while true; do
  {
    echo -e 'HTTP/1.1 200 OK\n'
    top -d 2 -b | grep --line-buffered -A 4 '^top -'
  } | nc -q0 -v -l -p 5000
  sleep 1
done

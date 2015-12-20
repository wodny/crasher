#!/bin/sh

while true; do
  {
    echo -e 'HTTP/1.1 200 OK\n'
    iostat -t 2 500
  } | nc -q0 -v -l -p 5000
  sleep 1
done

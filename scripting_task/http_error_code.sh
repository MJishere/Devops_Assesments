#!/bin/bash

URL="https://guvi.in"

status_code=$(curl -L -s --connect-timeout 5 --max-time 10 -o /dev/null -w "%{http_code}" "$URL")

echo "HTTP Status Code: $status_code"

if [ "$status_code" -ge 200 ] && [ "$status_code" -lt 400 ]; then
    echo "Success: Website is reachable"
else
    echo "Failure: Website returned error"
fi
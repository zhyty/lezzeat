#!/bin/bash
if [ "$1" == "production" ]; then
rackup --host 0.0.0.0 faye.ru -s thin -E production
else
rackup faye.ru -s thin -E production
fi


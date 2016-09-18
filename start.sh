#!/bin/bash
rackup --host 0.0.0.0 faye.ru -s thin -E production &
rvmsudo rails server -p 80 -b 0.0.0.0

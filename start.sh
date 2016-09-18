#!/bin/bash
rackup faye.ru -s thin -E production
bg %1
rvmsudo rails server -p 80 -b 0.0.0.0

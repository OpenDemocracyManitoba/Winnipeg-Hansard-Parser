#!/bin/bash
while :
do
    echo "Press [CTRL+C] to stop.."
    ruby visualize_hansard.rb ../hansard_json/2014-06-25_regular.json template.erb > /var/www/winnipegelection/production/public/hansard.html
    sleep 4
done

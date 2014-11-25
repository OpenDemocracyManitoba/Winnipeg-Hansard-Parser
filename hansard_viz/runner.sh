#!/bin/bash
while :
do
    echo "Press [CTRL+C] to stop.."
    ruby visualize_hansard.rb hansard_json/2014-06-25_regular.json hansard_viz/template.erb hansard_viz/2014-06-25_regular.html
    sleep 4
done

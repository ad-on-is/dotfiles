#!/bin/bash
sensors | grep CPU: | xargs echo -n | cut -d' ' -f 2 | sed -e 's/+//' | sed -e 's/°C//'

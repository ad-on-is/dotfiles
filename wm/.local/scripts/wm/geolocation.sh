#!/bin/bash

# Query Geoclue2 for location data using gdbus
location=$(gdbus call --system --dest org.freedesktop.GeoClue2 --object-path /org/freedesktop/GeoClue2/Manager --method org.freedesktop.GeoClue2.Manager.GetClient)

# Extract the client path from the output
client_path=$(echo $location | awk -F '"' '{print $2}')

# Set up the client
gdbus call --system --dest org.freedesktop.GeoClue2 --object-path $client_path --method org.freedesktop.DBus.Properties.Set "org.freedesktop.GeoClue2.Client" "DesktopId" "<'your_app_name'>"
gdbus call --system --dest org.freedesktop.GeoClue2 --object-path $client_path --method org.freedesktop.DBus.Properties.Set "org.freedesktop.GeoClue2.Client" "RequestedAccuracyLevel" "<2>"

# Start the client
gdbus call --system --dest org.freedesktop.GeoClue2 --object-path $client_path --method org.freedesktop.GeoClue2.Client.Start

# Wait a few seconds to get the location
sleep 5

# Get the location
location_info=$(gdbus call --system --dest org.freedesktop.GeoClue2 --object-path $client_path --method org.freedesktop.DBus.Properties.Get "org.freedesktop.GeoClue2.Client" "Location")
location_path=$(echo $location_info | awk -F '"' '{print $2}')

# Fetch latitude and longitude
latitude=$(gdbus call --system --dest org.freedesktop.GeoClue2 --object-path $location_path --method org.freedesktop.DBus.Properties.Get "org.freedesktop.GeoClue2.Location" "Latitude" | awk '{print $2}')
longitude=$(gdbus call --system --dest org.freedesktop.GeoClue2 --object-path $location_path --method org.freedesktop.DBus.Properties.Get "org.freedesktop.GeoClue2.Location" "Longitude" | awk '{print $2}')

# Output the results
echo "Latitude: $latitude, Longitude: $longitude"

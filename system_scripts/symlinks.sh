#!/bin/bash

DediRoot="/home/minecraft"
RepoRoot="/home/minecraft/network-script-data"

for Server in behrcraft survival hub1 build relay
do
    ### Server Configurations
    for File in bukkit.yml paper.yml server.properties spigot.yml
    do
        Path1="$RepoRoot/configurations/1.16_servers/$Server/$File" 
        Path2="$DediRoot/servers/$Server/$File"
        if [ -h $Path2 ]
        then
            echo "/$Server/$File Link Established"
        else
            echo "/$Server/$File Link Created"
            ln -s $Path1 $Path2
        fi 
    done

    ### Server Scripts
    Path1="$RepoRoot/denizen_scripts/$Server/"
    Path2="$DediRoot/servers/$Server/plugins/Denizen/scripts/"
    if [ -h $Path2 ]
    then
        echo "/denizen_scripts/$Server Link Established"
    else
        if [ ! -d "$Path2" ]
        then
            mkdir $Path2
        fi
        ln -s $Path1 $Path2
        echo "/denizen_scripts/$Server Link Created"
    fi 

    ### Server Script Data
    Path1="$RepoRoot/scriptdata/global/"
    Path2="$DediRoot/servers/$Server/plugins/Denizen/data/"
    if [ -h "${Path2}global" ]
    then
        echo "/$Server/data/global Link Established"
    else
        if [ ! -d "$Path2" ]
        then
            mkdir $Path2
        fi
        ln -s $Path1 $Path2
        echo "/$Server/data/global Link Created"
    fi
done

    ### Server Global Scripts
for Server in behrcraft survival hub1 build
do
    Path1="$RepoRoot/denizen_scripts/global/"
    Path2="$DediRoot/servers/$Server/plugins/Denizen/scripts/"

    if [ -h "${Path2}global" ]
    then
        echo "/$Server/global Link Established"
    else
        echo "/$Server/global Link Created"
        ln -s $Path1 $Path2
    fi 
done

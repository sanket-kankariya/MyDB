#!/bin/bash
cd db/
clear
databaseName=""
function showFunc() {
    query=("$@")
    if [[ ${query[0]} == 'dbs' ]]
    then
        list=($(ls /mnt/d/Projects/Shell/MyDB/db/))
        for i in "${list[@]}"
        do
            echo $i
        done
    elif [[ ${query[0]} == 'collections' ]]
    then
        if [[ $databaseName == '' ]]
        then
            echo "please select a database"
        else
            list=($(ls /mnt/d/Projects/Shell/MyDB/db/$databaseName))
            for i in "${list[@]}"
            do
                echo $i
            done
        fi
    fi
}

function findFunc() {
    query=("$@")
    if [ -f "${query[0]}.json" ]
    then
        if [[ ${query[2]} == '' ]]
        then
            jq '.' ${query[0]}.json
        fi
    else
        echo "${query[0]} collection doesnt exists"
    fi
}

function insertFunc() {
    query=("$@")
    json_string="${query[2]}"
    echo "$json_string"
    if [ -f "${query[0]}.json" ]
    then
        if jq -e . >/dev/null 2>&1 <<<"$json_string"; then
            echo "$json_string" | jq '.' > ${query[0]}.json
            # echo "$json_string" > ${query[0]}.json
            echo "Insert successfull"
        else
            echo "error in parsing json"
            echo "Insert unsuccessfull"
        fi
    else
        echo "${query[0]} collection doesnt exists"
    fi
    
}

function dbFunc() {
    query=("$@")
    if [[ ${query[0]} == '' ]]
    then
        if [[ $databaseName == '' ]]
        then
            echo "No database selected"
        else
            echo $databaseName
        fi
    elif [[ ${query[0]} == 'createcollection' ]]
    then
        if [[ $databaseName == '' ]]
        then
            echo "please select a database"
        else
            touch ${query[1]}.json
            echo 'collection created successfully '
        fi
    else
        if [[ ${query[1]} == 'insert' ]]
        then
            insertFunc "${query[@]}"
        elif [[ ${query[1]} == 'find' ]]
        then
            findFunc "${query[@]}"
        fi
    fi
}

while true
do
    read -r -p "> " str
    IFS=. read -ra query <<< "$str"
    # echo ${query[@]:1}
    if [[ ${query[0]} == 'show' ]]
    then
        showFunc ${query[@]:1}
    elif [[ ${query[0]} == 'cls' ]]
    then
        clear
    elif [[ ${query[0]} == 'use' ]]
    then
        cd /mnt/d/Projects/Shell/MyDB/db/
        databaseName="${query[1]}"
        if [[ -d "$databaseName" ]]
        then
            cd $databaseName/
            echo "$databaseName selected"
        else
            mkdir -p $databaseName
            cd $databaseName/
            echo "$databaseName created and selected"
        fi
    elif [[ ${query[0]} == 'exit' ]]
    then
        break
    elif [[ ${query[0]} == 'db' ]]
    then
        dbFunc "${query[@]:1}"
    fi
done

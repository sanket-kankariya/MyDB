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
    # IFS='&' read -ra subquery <<< "${query[2]}"
    # local key1="${query[2]}"
    # local value1="${query[3]}"
    # local key2="${query[5]}"
    # local value2="${query[6]}"
    # local key3="${query[8]}"
    # local value3="${query[9]}"
    # echo "$key1"
    # echo "$value1"
    # echo "$key2"
    # echo "$value2"
    # echo "$key3"
    # echo "$value3"
    if [ -f "${query[0]}.json" ]
    then
        if [[ ${query[2]} == '' ]]
        then
            jq '.' ${query[0]}.json
        else
            case "${query[2]}" in 
                *"&"*)
                    IFS='&' read -ra subquery <<< "${query[2]}"
                    if [[ ${subquery[0]} == *"="* && ${subquery[1]} == *"="* ]] 
                    then
                        IFS='=' read -ra argkv1 <<< "${subquery[0]}"
                        IFS='=' read -ra argkv2 <<< "${subquery[1]}"
                        jq --arg ka ${argkv1[0]} --arg va "${argkv1[1]}" --arg kb ${argkv2[0]} --arg vb "${argkv2[1]}" 'map(select(.[$ka] == $va and .[$kb] == $vb))' ${query[0]}.json
                    fi
                    ;;
                *"|"*)
                    IFS='|' read -ra subquery <<< "${query[2]}"
                    if [[ ${subquery[0]} == *"="* && ${subquery[1]} == *"="* ]] 
                    then
                        IFS='=' read -ra argkv1 <<< "${subquery[0]}"
                        IFS='=' read -ra argkv2 <<< "${subquery[1]}"
                        jq --arg ka ${argkv1[0]} --arg va "${argkv1[1]}" --arg kb ${argkv2[0]} --arg vb "${argkv2[1]}" 'map(select(.[$ka] == $va or .[$kb] == $vb))' ${query[0]}.json
                    fi
                    ;;
                *)
                    case "${query[2]}" in 
                    *"="*)
                        IFS='=' read -ra argkv <<< "${query[2]}"
                        jq --arg k ${argkv[0]} --arg v "${argkv[1]}" 'map(select(.[$k] == $v))' ${query[0]}.json
                        ;;
                    *"!"*)
                        echo "2"
                        IFS='!' read -ra argkv <<< "${query[2]}"
                        jq --arg k ${argkv[0]} --arg v "${argkv[1]}" 'map(select(.[$k] != $v))' ${query[0]}.json
                        ;;
                    *"<"*)
                        IFS='<' read -ra argkv <<< "${query[2]}"
                        jq --arg k ${argkv[0]} --arg v "${argkv[1]}" 'map(select(.[$k] < $v))' ${query[0]}.json
                        ;;
                    *">"*)
                        IFS='>' read -ra argkv <<< "${query[2]}"
                        jq --arg k ${argkv[0]} --arg v "${argkv[1]}" 'map(select(.[$k] > $v))' ${query[0]}.json
                        ;;
                    esac
                    ;;
            esac

        # elif [[ ${subquery[1]} == '' ]]
        # then
        #     case "${subquery[0]}" in 
        #     *"="*)
        #         IFS='=' read -ra argkv <<< "${subquery[0]}"
        #         jq --arg k ${argkv[0]} --arg v "${argkv[1]}" 'map(select(.[$k] == $v))' ${query[0]}.json
        #         ;;
        #     *"!"*)
        #         echo "2"
        #         IFS='!' read -ra argkv <<< "${subquery[0]}"
        #         jq --arg k ${argkv[0]} --arg v "${argkv[1]}" 'map(select(.[$k] != $v))' ${query[0]}.json
        #         ;;
        #     *"<"*)
        #         IFS='<' read -ra argkv <<< "${subquery[0]}"
        #         jq --arg k ${argkv[0]} --arg v "${argkv[1]}" 'map(select(.[$k] < $v))' ${query[0]}.json
        #         ;;
        #     *">"*)
        #         IFS='>' read -ra argkv <<< "${subquery[0]}"
        #         jq --arg k ${argkv[0]} --arg v "${argkv[1]}" 'map(select(.[$k] > $v))' ${query[0]}.json
        #         ;;
        #     esac
        

        # elif [[ ${query[7]} == 'and' ]]
        # then
        #     echo "3"
        #     jq --arg k1 $key1 --arg k2 $key2 --arg k3 $key3 --arg v1 "$value1" --arg v2 "$value2" --arg v3 "$value3" 'map(select(.[$k1] == $v1 and .[$k2] == $v2 and .[$k3] == $v3))' ${query[0]}.json
        # elif [[ ${query[4]} == 'and' ]]
        # then
        #     echo "2"
        #     jq --arg ka $key1 --arg va "$value1" --arg kb $key2 --arg vb "$value2" 'map(select(.[$ka] == $va and .[$kb] == $vb))' ${query[0]}.json
        # else
        #     echo "1"
        #     jq --arg k $key1 --arg v "$value1" 'map(select(.[$k] == $v))' ${query[0]}.json
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
        else
            echo "Syntax Error"
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
    else 
        echo "Syntax error"
    fi
done

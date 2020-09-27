#!/bin/bash
key="quantity<3"
case "$key" in 
                *"&"*)
                    IFS='&' read -ra subquery <<< "$key"
                    
                    ;;
                *"|"*)
                    IFS='|' read -ra subquery <<< "$key"
                    ;;
                *)
                    case "$key" in 
                    *"="*)
                        IFS='=' read -ra argkv <<< "$key"
                        jq --arg k ${argkv[0]} --arg v "${argkv[1]}" 'map(select(.[$k] == $v))' customers.json
                        ;;
                    *"!"*)
                        IFS='!' read -ra argkv <<< "${subquery[0]}"
                        jq --arg k ${argkv[0]} --arg v "${argkv[1]}" 'map(select(.[$k] != $v))' customers.json
                        ;;
                    *"<"*)
                        IFS='<' read -ra argkv <<< "${subquery[0]}"
                        jq --arg k ${argkv[0]} --arg v "${argkv[1]}" 'map(select(.[$k] < $v))' customers.json
                        ;;
                    *">"*)
                        IFS='>' read -ra argkv <<< "${subquery[0]}"
                        jq --arg k ${argkv[0]} --arg v "${argkv[1]}" 'map(select(.[$k] > $v))' customers.json
                        ;;
                    esac
                    ;;
            esac
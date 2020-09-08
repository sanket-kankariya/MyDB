# key="quantity"
# value="262"
key="supplier"
value="Wisozk Inc"
# jq ".[] | select(.$key==$value)" customers.json
jq --arg k $key --arg v "$value" 'map(select(.[$k] == $v))' customers.json
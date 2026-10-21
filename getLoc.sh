#brew install corelocationcli
CoreLocationCLI

curl -s ipinfo.io | jq -r '.loc, .city, .country'

 # Create the Git clone commands to get the Repositories
jq -r '.Repositories[] | "git clone --depth 1 --branch \(.Branch) \(.Repository) \(.Directory)" ' </build/config.json > /build/scripts/clone.sh

chmod u+rwx /build/scripts/clone.sh 

# Create the Version file from the config
jq '{ "FrameworkVersion" : .FrameworkVersion }' </build/config.json > /opt/codeontap/version.json

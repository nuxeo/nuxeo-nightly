#!/bin/sh

# Takes build.env and prepares server and web ui addons along with a final .env

# load build.env
set -a
[ -f ./build.env ] && . ./build.env
set +a

PACKAGES_REPOSITORIES="https://packages.nuxeo.com/repository/public,private::::https://packages.nuxeo.com/repository/public"
CONNECT_REPOSITORIES="nuxeo-studio::::http://connect.nuxeo.com/nuxeo/site/studio/maven"

mvn -version
cat ~/.m2/settings.xml

packages=($(echo $NUXEO_PACKAGES | tr " " "\n"))

# clean
rm -rf server/addons server/packages ui/addons

# prepare web ui addons list
addons=()

for package in "${packages[@]}"
do
  parts=($(echo $package | tr ":" "\n"))
  
  if [ ${#parts[@]} -eq '1' ];
  then
    # download the package 
    mkdir -p server/packages
    mvn dependency:get -DremoteRepositories=$PACKAGES_REPOSITORIES -Dartifact=org.nuxeo.packages:$package-package:$NUXEO_PLATFORM_VERSION:zip -Dtransitive=false -Ddest=server/packages
  else
    jar="${parts[1]}-${parts[2]}.jar"
    mkdir -p server/addons
    echo "mvn dependency:get -DremoteRepositories=$CONNECT_REPOSITORIES -Dartifact=$package -Dtransitive=false -Ddest=server/addons/$jar"
    mvn dependency:get -DremoteRepositories=$CONNECT_REPOSITORIES -Dartifact=$package -Dtransitive=false -Ddest=server/addons/$jar
    unzip server/addons/$jar 'web/nuxeo.war/ui/*' -d ui/addons
    mv ui/addons/web/nuxeo.war/ui ui/addons/${parts[1]}
    rm -r ui/addons/web
    zip -d server/addons/$jar 'web/nuxeo.war/ui/*'
    package="nuxeo-${parts[1]}-bundle.html"
  fi
  addons[${#addons[@]}]=$package
done

cat <<EOF > .env
VERSION=$VERSION
NUXEO_PLATFORM_VERSION=$NUXEO_PLATFORM_VERSION
NUXEO_WEBUI_VERSION=$NUXEO_WEBUI_VERSION
NUXEO_PACKAGES=${addons[*]}
EOF

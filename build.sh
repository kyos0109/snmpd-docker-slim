#!/bin/bash
#
# frist run docker-slim build.
#
SourceImage="kyos0109/snmpd-distroless"
SourceImageTag=":${1:-latest}"
DockerSlimBaseDir=`echo ~/Documents/Docker/docker-slim`
DockerSlimBuild="$DockerSlimBaseDir/.images"
SlimImage="$SourceImage.slim"
SlimFilesDir="files"
FinalFiles="files.tar.xz"
CopyDir=('/opt/etc/snmp' '/opt/share/snmp')

##############################################
# get source temp container id.
BaseContainer=`docker create $SourceImage$SourceImageTag`

# get docker-slim image id.
SlimImageID=`docker images --no-trunc --quiet $SourceImage$SourceImageTag | cut -d ":" -f2`

# run docker-slim build
cd $DockerSlimBaseDir
./docker-slim build -p --continue-after probe $SourceImage$SourceImageTag
cd -

# get files from build target dir.
cp -a $DockerSlimBuild/$SlimImageID/artifacts/* .

# copy build time shortage files.
for dir in ${CopyDir[*]}
do
	CopyParentsDir=$(dirname $dir)
	mkdir -p $SlimFilesDir$CopyParentsDir
	docker cp -aL $BaseContainer:$dir $SlimFilesDir$CopyParentsDir
done

# tar files.
cd $SlimFilesDir
tar Jcvf ../$FinalFiles *
cd -
rm -r $SlimFilesDir

# ADD files.tar.xz
sed -i .tmp "s/COPY\ $SlimFilesDir/ADD\ $FinalFiles/g" Dockerfile
rm Dockerfile.tmp

# rm temp source container
docker rm $BaseContainer
docker rmi $SlimImage
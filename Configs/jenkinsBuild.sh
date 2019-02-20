#1. shell脚本的变量读取
#要构建的解决方案名称
solutionName="TestWeb";
#.csproj文件全路径
csprojDir="TestWeb/TestWeb.csproj";
#容器名
containerName="testweb";
#制定run的端口
port=5000;
#项目发布的版本
newVersion=1.0.$BUILD_NUMBER;
#上一个版本
lastNum=$(($BUILD_NUMBER-1));
lastVersion=1.0.${lastNum};

echo "--kcloudy:lastVersion: "${lastVersion}"--newVersion: "${newVersion}

#2. 定义好存放发布好的项目代码的目录和备份发布内容的目录
#项目发布的目录
webDir=/usr/sftpdata/web/${solutionName}/v-${newVersion};
oldwebDir=/usr/sftpdata/web/${solutionName}/v-${lastVersion};
#归档目录
archivesDir=/usr/sftpdata/web/archives;

#3. publish发布项目到准备好的目录
echo "--kcloudy:发布dotnetcore项目--"${solutionName};
#清空文件夹
sudo rm -rf ${webDir}/*;
#发布网站到webDir
dotnet publish $JENKINS_HOME/workspace/$JOB_NAME/${csprojDir} -c Release -o ${webDir} /p:Version=${newVersion};

#4. 复制需要的配置到发布目录
#复制配置文件
#cp -rf /usr/sftpdata/web/${solutionName}/configs/* ${webDir}/;

#5. Docker容器命令详解
cd ${webDir} 

#发布后的文件进行归档
sudo mkdir -p ${archivesDir}
sudo setfacl -Rm u:jenkins:rwx ${archivesDir}
sudo tar -zcvf ${archivesDir}/${solutionName}-${newVersion}.tar.gz .

if [ -n "$(docker ps -aq -f name=${containerName})" ]; then
	#停止docker容器
	echo "--kcloudy:停止docker容器--"${containerName};
	docker stop ${containerName};
    if [ -n "$(docker ps -aq -f status=exited -f name=${containerName})" ]; then
        #删除容器
        echo "--kcloudy:删除容器--"${containerName};
		docker rm -f ${containerName};
    fi
fi

if [ -n "$(docker images -aq ${containerName}:${lastVersion})" ]; then
	#删除镜像
	echo "--kcloudy:删除镜像--"${containerName}:${lastVersion};
	docker rmi -f ${containerName}:${lastVersion};
fi

#通过Dockerfile重新构建镜像
echo "--kcloudy:通过Dockerfile重新构建镜像--"${containerName}:${newVersion};
docker build -t ${containerName}:${newVersion} .;
docker images;

echo "--kcloudy:运行容器并绑定到端口";
#docker run容器并绑定到端口
docker run -d -p ${port}:${port} --name ${containerName} ${containerName}:${newVersion};
docker logs ${containerName}

#清空发布的老版本文件夹
echo "--kcloudy:清空发布的老版本文件夹--"${oldwebDir};
sudo rm -rf ${oldwebDir};

echo "kcloudy:success!";

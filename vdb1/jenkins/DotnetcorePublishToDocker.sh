#1. shell脚本的变量读取
#要构建的解决方案名称
solutionName=$1
#.sln文件全路径
solutionDir=$2
#.csproj文件全路径
csprojDir=$3
#docker run的容器名称
containerName=$4
#制定run的端口
port=$5

#2. 定义好存放发布好的项目代码的目录和备份发布内容的目录
#项目发布的目录
webDir=/vdb1/jenkins/publish/webapp
#归档目录
archivesDir=/vdb1/jenkins/publish/archives

#3. publish发布项目到准备好的目录
echo "kcloudy:dotnet publish"
#清空文件夹
rm -rf ${webDir}/${JOB_NAME}/*
#发布网站到webDir
dotnet publish ${JENKINS_HOME}/workspace/${JOB_NAME}/${csprojDir} -c Release -o ${webDir}/${JOB_NAME} /p:Version=1.0.${BUILD_NUMBER}

#4. 复制需要的配置到发布目录
#复制配置文件
cp -rf /vdb1/jenkins/DotnetcorePublishToDockerConfigs/* ${webDir}/${JOB_NAME}/

#5. Docker容器命令详解
#停止docker容器
docker stop ${containerName}
#删除当前容器
docker rm ${containerName}
#删除镜像
docker rmi ${containerName}
#通过Dockerfile重新构建镜像
docker build -t ${containerName} ${webDir}/${JOB_NAME}/.
#docker run容器并绑定到端口
docker run -d -p ${port}:80 --name ${containerName} ${containerName}

echo "kcloudy:success!"

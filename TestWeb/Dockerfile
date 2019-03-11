# 添加基础镜像
FROM microsoft/dotnet:2.1-aspnetcore-runtime
ARG source=.
#容器中系统的工作空间
WORKDIR /app
#拷贝当前文件夹下的文件到容器中系统的工作空间
COPY $source /app
#设置Docker容器对外暴露的端口
EXPOSE 5000

ARG env=Dev
ENV ASPNETCORE_ENVIRONMENT=$env,env="--environment="$env
#容器中使用 ["dotnet","系统启动的dll"] 来运行应用程序
ENTRYPOINT ["dotnet", "TestWeb.dll"]
CMD ["$env"]
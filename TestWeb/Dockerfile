FROM microsoft/aspnetcore:latest
ARG source=.
WORKDIR /app
EXPOSE 5000
COPY $source /app
ENTRYPOINT ["dotnet", "TestWeb.dll"]

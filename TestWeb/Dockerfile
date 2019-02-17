FROM microsoft/aspnetcore:latest
ARG source
WORKDIR /publish
EXPOSE 5000
COPY /. /publish
ENTRYPOINT ["dotnet", "TestWeb.dll"]

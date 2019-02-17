FROM microsoft/aspnetcore:latest
ARG source
WORKDIR /publish
EXPOSE 80
COPY /. /publish
ENTRYPOINT ["dotnet", "TestWeb.dll"]

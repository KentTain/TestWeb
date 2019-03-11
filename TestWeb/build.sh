#!/bin/sh
echo "----$1------$env------"
echo "dotnet run --environment=$ASPNETCORE_ENVIRONMENT with TestWeb.dll"
dotnet run -p 5000:5000 --environment="$ASPNETCORE_ENVIRONMENT" TestWeb.dll

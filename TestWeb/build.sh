#!/bin/sh
echo "----------------"
echo "dotnet run --environment=$ASPNETCORE_ENVIRONMENT with TestWeb.dll"
dotnet run --environment="$ASPNETCORE_ENVIRONMENT" TestWeb.dll

FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 60294
EXPOSE 44339

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["TestWeb/TestWeb.csproj", "TestWeb/"]
RUN dotnet restore "TestWeb/TestWeb.csproj"
COPY . .
WORKDIR "/src/TestWeb"
RUN dotnet build "TestWeb.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "TestWeb.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "TestWeb.dll"]
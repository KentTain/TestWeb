FROM microsoft/dotnet:2.1-aspnetcore-runtime
ARG source=.
WORKDIR /app

COPY $source /app

EXPOSE 5000

ARG env=Dev
ENV ASPNETCORE_ENVIRONMENT=$env
ENV env="--environment="$env

COPY build.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/build.sh

ENTRYPOINT ["build.sh"]
CMD ["$env"]
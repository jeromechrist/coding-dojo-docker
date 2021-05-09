FROM microsoft/dotnet:3.0-sdk

VOLUME [ "/app" ]

WORKDIR /app

# the sonarqube runner needs java
RUN apt-get update && apt-get install -y --no-install-recommends default-jre

COPY ./aspnetapp ./aspnetapp
COPY ./aspnetapp.sln ./
COPY ./docker-entrypoint.sh /usr/local/bin/

# https://github.com/dotnet/dotnet-docker/issues/520
ENV PATH "$PATH:/root/.dotnet/tools"

ENV SonarHostUrl "http://sonarqube:9000"
ENV DotnetCoreSlnPath "/app/aspnetapp.sln"
ENV DotnetCoreSlnName "aspnetapp"

RUN dotnet tool install --global dotnet-sonarscanner

ENTRYPOINT ["docker-entrypoint.sh"]

FROM microsoft/vsts-agent:ubuntu-16.04

# Install .NET CLI dependencies

RUN apt-get update \ 
    && apt-get install -y wget \
    && wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \ 
    && apt-get update -y

RUN apt-get install -y dotnet-sdk-2.1

# # Configure Kestrel web server to bind to port 80 when present
# ENV ASPNETCORE_URLS=http://+:80 \
#     # Enable detection of running in a container
#     DOTNET_RUNNING_IN_CONTAINER=true \
#     # Enable correct mode for dotnet watch (only mode supported in a container)
#     DOTNET_USE_POLLING_FILE_WATCHER=true \
#     # Skip extraction of XML docs - generally not useful within an image/container - helps performance
#     NUGET_XMLDOC_MODE=skip

# coding-dojo-docker

Welcome to the coding dojo for Docker. Ready to have fun with whales and containers ?

![containers](https://dvdbash.files.wordpress.com/2013/06/the-wire-tv-series-s2-e05-03-dvdbash-wordpress.jpg "containers")

## open a powershell terminal with administrative rights

set the execution policy to bypass for the current session

```
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

.\00-prerequisites\setup.ps1
```

# Introduction : What is Docker
![whatis](https://d1.awsstatic.com/Developer%20Marketing/containers/monolith_2-VM-vs-Containers.78f841efba175556d82f64d1779eb8b725de398d.png "whatis")

>Containers aren't VMs. They offer isolation not virtualization.

>The host and container OSs must be the same.

Main Benefits are

- portability
- efficiency
- productivity
- version control


# Hello World

```
docker run --name hello-world hello-world
```

What happened ? This is the Dockerfile

```
FROM scratch
COPY hello /
CMD ["/hello"]
```

https://hub.docker.com/_/hello-world/

https://github.com/docker-library/hello-world

# docker run

Here we demonstrate

- how the containers are running (and exiting)
- how to check the list of running containers
- how to check the list of all containers
- how to filter the list
- how to prevent the container to exit immediately
- how to run a container in background
- how to run a rabbitmq container and port forward
- how to check the ports forwarding and logs

commands :

```
docker ps
docker ps -a
docker ps -a --filter "name=hello-world"
docker ps -a -q --filter "name=hello-world" | ForEach-Object {docker inspect $_}
docker run -it ubuntu bash
docker run -d -p 15672:15672 rabbitmq:3.7.8-management
docker port #id
docker logs
```

# Layers

Here we explain (simply)

- what are the layers of an image
- how to see them.
- What about passwords ?

commands:

```
docker history hello-world
or with an external tool such as microbadger https://microbadger.com/images/nginx
```

<!-- docker ps -a | grep "hello-world" -->
<!-- docker inspect `####` | jq -r '.[0].NetworkSettings.IPAddress' -->
<!-- docker ps -a -q --filter "name=hello-world" | ForEach-Object {docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $_} -->

# 01 - exercise 1 : let's create our own Dockerfile / container

> the image is the recipe, the container is the cake

Here we build a Dockerfile for the aspnetapp sample
We explain

- build, build context, tags
- multistage build
- layers
- FROM inheritance
- CMD vs Entrypoint

We build the image, show docker image ls, run the container locally to test it

solution
```
FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY aspnetapp/*.csproj ./aspnetapp/
RUN dotnet restore

# copy everything else and build app
COPY aspnetapp/. ./aspnetapp/
WORKDIR /app/aspnetapp
RUN dotnet publish -c Release -o out


FROM microsoft/dotnet:2.1-aspnetcore-runtime AS runtime
WORKDIR /app
COPY --from=build /app/aspnetapp/out ./
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
```

```
docker build . -t aspnetapp
```

# 02 - exercise 2 : let's create a docker registry in azure and push our image

Here we push our image to a remote registry.

We demo

- creating a Azure Container Registry
- docker login
- tagging, pushing our image

solution

```
az login

az account set --subscription 65501f8a-0af8-480e-b2fe-6b0aefc81d25

az group create --name coding-dojo-docker --location westeurope

az acr create --name codingdojodocker -g coding-dojo-docker --admin-enabled --sku Standard

{
  "adminUserEnabled": true,
  "creationDate": "2018-11-05T22:35:54.088289+00:00",
  "id": "/subscriptions/65501f8a-0af8-480e-b2fe-6b0aefc81d25/resourceGroups/coding-dojo-docker/providers/Microsoft.ContainerRegistry/registries/codingdojodocker",
  "location": "westeurope",
  "loginServer": "codingdojodocker.azurecr.io",
  "name": "codingdojodocker",
  "provisioningState": "Succeeded",
  "resourceGroup": "coding-dojo-docker",
  "sku": {
    "name": "Standard",
    "tier": "Standard"
  },
  "status": null,
  "storageAccount": null,
  "tags": {},
  "type": "Microsoft.ContainerRegistry/registries"
}

az acr credential show --name codingdojodocker
```

```
docker build . -t aspnetapp
docker tag aspnetapp codingdojodocker.azurecr.io/aspnetapp:0.1
docker push codingdojodocker.azurecr.io/aspnetapp:0.1

!! don't do it (the audience) but to demonstrate that the pulled one is working as the same as the local one
docker rm -f $(docker ps -a -q)
docker image prune
docker image rm codingdojodocker.azurecr.io/aspnetapp:0.1
docker run -p 9009:80 codingdojodocker.azurecr.io/aspnetapp
!!
```
Let's deploy this container to an Azure Web App

```
az appservice plan create --name coding-dojo-docker --resource-group coding-dojo-docker --location westeurope --is-linux --sku S1

-- kek https://github.com/Azure/azure-cli/issues/7013 -- 

az webapp create --name coding-dojo-docker --resource-group coding-dojo-docker --plan coding-dojo-docker --deployment-container-image-name hello-world

az webapp config container set --docker-registry-server-url http://codingdojodocker.azurecr.io --docker-custom-image-name codingdojodocker.azurecr.io/aspnetapp:latest --docker-registry-server-user codingdojodocker --docker-registry-server-password brrrrrrrrr --name coding-dojo-docker --resource-group coding-dojo-docker
```

# 03 - exercise - 3 this linux stuff is cool but what about windows tho ?

Here we demonstrate the images windows server core / nanoserver

The audience is following this part of

- building a dockerfile for a classic aspnet app running on IIS
- executing the container based off this image
- maybe a few words about lcow
- maybe a few words about the MTA program
- maybe a few words about running a hybrid swarm

The audience could do this but because of the size of the windows images (500mb per image per attendee....)

```
switch to windows containers
we published a classic (full framework, not dotnet core) asp.net app to ./aspnetapp-classic (from https://github.com/addianto/todo-mvc-dotnet)

docker build . -t aspnetapp-classic
docker run -P aspnetapp-classic

pray so that this is the first and last time you use windows containers
```

# Volumes

Intro with a cool tip to develop ASP.NET Core Applications in a Container

```
docker run --rm -it -p 9000:80 -v ${PWD}:/app/ -w /app/aspnetapp microsoft/dotnet:2.1-sdk dotnet watch run
```

Here we demonstrate

- mounting a volume in read/write
- mounting a volume in read-only
- share a volume with multiple containers

# Compose

Here we demonstrate

- starting a few services using a docker-compose.yml
- the usage of Traefik
- (few) words on networking
- (few) words on services and scaling, deployment, resource constraint

```
$Env:COMPOSE_CONVERT_WINDOWS_PATHS=1
docker-compose up
docker-compose scale whoami=4
```

TODO: add a few more fancy stuff like constraints, wait for it, networks

# Secrets

Here we demonstrate

- how to create a secret in docker
- how to mount this secret in a container
- how to access it from an aspnet core app

```
below : for swarm, not needed with compose. maybe a we will do a swarm init if we have time
docker swarm init
docker secret create .\050-exercise-5-secrets\dbpassword.txts
docker secret ls

```

Rotate a secret ?

...

# Swarm management tool

Here we talk about tools such as

- portainer
- rancher v1
- docker EE

docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer

## Use Cases

### cool use case 1 - our own build agent ?

First we need to create our agent pool (https://jeromechrist.visualstudio.com/_settings/agentpools?_a=agents&poolId=8)

Second we need to create a Personal Acess Token (PAT) with the following permissions :Agent Pools(read, manage), Build (Read & Execute), Code (Read & Write)
m42nwothbdeey2qjjk2vsb5wcg4r45qy2ji2efpxekw77vxzgbsq

```
docker build . -t agent
docker run --rm -e VSTS_ACCOUNT=jeromechrist -e VSTS_TOKEN=m42nwothbdeey2qjjk2vsb5wcg4r45qy2ji2efpxekw77vxzgbsq -e VSTS_POOL=coding-dojo-docker -e DOTNET_CLI_TELEMETRY_OPTOUT=true agent
```

### cool use case 2 - vulnerability scan with Zap

Go to Zap folder

```docker
docker-compose down
docker-compose build
docker-compose up -d aspnetnetapp
docker-compose up zap
```

[OWASP Site](https://github.com/zaproxy/zaproxy)

### cool use case 3 - Website analysis

Go to SiteSpeed folder

```docker
docker-compose down
docker-compose build
docker-compose up -d aspnetnetapp
docker-compose up sitespeed
```

A website will be generated in .\sitespeed-result\aspnetapp\ describing the performance of the site.

Please note that results can be aggregated to Graphite / InfluxDb and viewed through Grafana.

[Sitespeed](https://www.sitespeed.io/)

### cool use case 4 - Test using headless browser

Go to RobotFramework folder

```docker
docker-compose down
docker-compose build
docker-compose up -d aspnetnetapp
docker-compose up -d chrome
docker-compose up test-gc
```

Go to ./results/gc

You can iterate on tests just by typing again 

```docker
docker-compose up test-gc
```

You can switch to firefox:

```docker
docker-compose up -d firefox
docker-compose up test-ff
```

[Robot Framework](http://robotframework.org/)


### cool use case 3 - sidecar ... logs ?

### cool use case 4 - SchemaCrawler ?

# ze end
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

# Layers

Here we explain (simply)

- what are the layers of an image
- how to see them.
- What about passwords ?

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

# 02 - exercise 2 : let's create a docker registry in azure and push our image

Here we push our image to a remote registry.

We demo

- creating a Azure Container Registry
- docker login
- tagging, pushing our image

Let's deploy this container to an Azure Web App

# 03 - exercise - 3 this linux stuff is cool but what about windows tho ?

Here we demonstrate the images windows server core / nanoserver

# Volumes

Intro with a cool tip to develop ASP.NET Core Applications in a Container

Here we demonstrate

- mounting a volume in read/write
- mounting a volume in read-only
- share a volume with multiple containers

# Compose

Here we demonstrate

- starting a few services using a docker-compose.yml
- the usage of Traefik
- wait for it
- (few) words on networking
- (few) words on services and scaling, deployment, resource constraint
- healthcheck

# Secrets

Here we demonstrate

- how to create a secret in docker
- how to mount this secret in a container
- how to access it from an aspnet core app

...

# Swarm management tool

Here we talk about tools such as

- portainer
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

# The end. Questions ? Rants ?
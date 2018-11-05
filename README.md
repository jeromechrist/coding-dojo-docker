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

>*Containers aren't VMs. They offer isolation not vritualization. 
>
The host and container OSs must be the same.* 

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

```
docker ps
```

```
docker ps -a
```

```
docker ps -a --filter "name=hello-world"
```

```
docker ps -a -q --filter "name=hello-world" | ForEach-Object {docker inspect $_}
```

```
docker run -it ubuntu bash
```

```
docker run -d -p 15672:15672 rabbitmq:3.7.8-management
```

```
docker port #id
```

```
docker logs
```

# Layers

we can see the layers with

```
docker history hello-world
```

or with an external tool such as microbadger https://microbadger.com/images/nginx


<!-- docker ps -a | grep "hello-world" -->
<!-- docker inspect `####` | jq -r '.[0].NetworkSettings.IPAddress' -->
<!-- docker ps -a -q --filter "name=hello-world" | ForEach-Object {docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $_} -->

# let's create our own container/Dockerfile



# develop ASP.NET Core Applications in a Container

```
PS C:\work\coding-dojo-docker\099-develop-core-container> docker run --rm -it -p 9000:80 -v ${PWD}:/app/ -w /
app/aspnetapp microsoft/dotnet:2.1-sdk dotnet watch run
```

### compose

```
$Env:COMPOSE_CONVERT_WINDOWS_PATHS=1
```

```
docker-compose up
```

```
docker-compose scale whoami=4
```

## secrets

### service (pas trop sûr d'en parler, ptete viteuf)

### portainer

docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer

### 03 - our own build agent

### 04 - vulnerability scan

### 05 - sidecar ... logs ?
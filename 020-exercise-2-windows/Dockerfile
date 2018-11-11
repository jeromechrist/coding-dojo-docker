FROM microsoft/aspnet:4.7.1@sha256:d3534cac53bc3e13a707e41d8de931b91cc86d98021e2b4c643637ef666fe510

EXPOSE 80
# EXPOSE 443

# RUN Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationDevelopment,IIS-ASPNET45,IIS-BasicAuthentication,IIS-CommonHttpFeatures,IIS-DefaultDocument,IIS-DirectoryBrowsing
# RUN Add-WindowsFeature Web-server, NET-Framework-45-ASPNET, Web-Asp-Net45, Web-Http-Redirect, Web-AppInit, Web-ASP, Web-Windows-Auth, Web-Client-Auth

RUN Remove-WebSite -Name 'Default Web Site'

# RUN Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# RUN refreshenv
# RUN choco install sql2016-clrtypes -Y

ARG website_root=./aspnetapp-classic
ADD ${website_root} /inetpub/aspnetapp

RUN New-Website -Name 'aspnetapp' -Port 80 \
    -PhysicalPath 'c:\inetpub\aspnetapp'

# RUN ICACLS c:\inetpub\aspnetapp\ /grant 'IIS AppPool\DefaultAppPool:F' /T


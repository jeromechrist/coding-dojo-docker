function IsPackageInstalled($PackageName, $PackageVersion, $ShouldCheckForVersion) {
    $result = choco list -lo | Where-object { $_.ToLower().StartsWith($PackageName.ToLower()) }
    if($result -ne $null){
        if($ShouldCheckForVersion -eq $true){
            $parts = $result.Split(" ")
            return $parts[1].ToString() -eq $PackageVersion;
        }
        else{
            return $true
        }
    }
    else{
        return $false
    }
}

Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco --version
choco list -l -a

$Packages = 'docker-for-windows+18.06.1.19507', 'jq+1.5', 'vscode+1.28.2', 'azure-cli+2.0.47'
ForEach ($Package in $Packages)
{
    $packageName = $Package.Split("+")[0]
    $packageVersion = $Package.Split("+")[1].ToString()
    $installed = IsPackageInstalled $packageName $packageVersion $false
    
    if($installed -eq $false){
        Write-Output "$packageName $packageVersion is missing, installing..."
        choco install $packageName --version $packageVersion -y
    }else{
        $installedSameVersion = IsPackageInstalled $packageName $packageVersion $true
        if($installedSameVersion -eq $true){
            Write-Output "$packageName $packageVersion is already installed with the same version"
        }else{
            Write-Output "$packageName $packageVersion is already installed but with another version. You decide if you want to upgrade or not"
        }
    }
}

code --install-extension peterjausovec.vscode-docker

choco list -l -a
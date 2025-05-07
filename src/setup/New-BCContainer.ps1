# PowerShell script to set up a new Business Central container

param (
    [string]$ContainerName = "BCContainer",
    [string]$ImageName = "mcr.microsoft.com/businesscentral/sandbox",
    [string]$LicenseFilePath,
    [string]$CredentialFilePath,
    [string]$Environment = "Sandbox",
    [int]$MemoryLimit = 2GB,
    [int]$CpuLimit = 2
)

function Log-Message {
    param (
        [string]$Message,
        [string]$LogFile = "BCContainerSetup.log"
    )
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$Timestamp - $Message" | Out-File -Append -FilePath $LogFile
}

try {
    Log-Message "Starting setup for Business Central container: $ContainerName"

    # Validate parameters
    if (-not $LicenseFilePath -or -not (Test-Path $LicenseFilePath)) {
        throw "License file path is invalid or not provided."
    }

    if (-not $CredentialFilePath -or -not (Test-Path $CredentialFilePath)) {
        throw "Credential file path is invalid or not provided."
    }

    # Pull the Business Central image
    Log-Message "Pulling image: $ImageName"
    docker pull $ImageName

    # Create and start the container
    Log-Message "Creating and starting the container: $ContainerName"
    docker run -d --name $ContainerName `
        -e "licenseFile=$LicenseFilePath" `
        -e "environment=$Environment" `
        -e "memoryLimit=$MemoryLimit" `
        -e "cpuLimit=$CpuLimit" `
        $ImageName

    Log-Message "Container $ContainerName started successfully."

} catch {
    Log-Message "Error: $_"
    exit 1
}

Log-Message "Setup completed for Business Central container: $ContainerName"
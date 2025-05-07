# Publish-BCApp.ps1

param (
    [string]$AppFilePath,
    [string]$ContainerName,
    [string]$CredentialFilePath,
    [string]$TenantId,
    [string]$EnvironmentName
)

# Load credentials securely
if (Test-Path $CredentialFilePath) {
    $Credential = Get-Content $CredentialFilePath | ConvertFrom-Json
} else {
    Write-Error "Credential file not found at path: $CredentialFilePath"
    exit 1
}

# Function to publish the Business Central app
function Publish-BCApp {
    param (
        [string]$AppFilePath,
        [string]$ContainerName,
        [PSCredential]$Credential,
        [string]$TenantId,
        [string]$EnvironmentName
    )

    # Validate parameters
    if (-not (Test-Path $AppFilePath)) {
        Write-Error "App file not found at path: $AppFilePath"
        return
    }

    # Log the start of the publishing process
    Write-Host "Starting the publishing process for app: $AppFilePath to container: $ContainerName"

    try {
        # Connect to the Business Central container
        $session = New-PSSession -ComputerName $ContainerName -Credential $Credential
        Invoke-Command -Session $session -ScriptBlock {
            param ($AppFilePath, $TenantId, $EnvironmentName)
            # Publish the app
            Publish-BCApp -AppFilePath $AppFilePath -TenantId $TenantId -EnvironmentName $EnvironmentName
        } -ArgumentList $AppFilePath, $TenantId, $EnvironmentName

        # Log success
        Write-Host "Successfully published the app: $AppFilePath to container: $ContainerName"
    } catch {
        # Log any errors that occur during the process
        Write-Error "An error occurred while publishing the app: $_"
    } finally {
        # Clean up the session
        Remove-PSSession -Session $session
    }
}

# Call the function to publish the app
Publish-BCApp -AppFilePath $AppFilePath -ContainerName $ContainerName -Credential $Credential -TenantId $TenantId -EnvironmentName $EnvironmentName
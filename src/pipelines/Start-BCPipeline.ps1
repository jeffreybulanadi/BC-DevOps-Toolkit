# Start-BCPipeline.ps1

param (
    [string]$PipelineName,
    [string]$Environment,
    [string]$ConfigurationFile = "config-template.json"
)

function Log-Message {
    param (
        [string]$Message,
        [string]$LogLevel = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "$timestamp [$LogLevel] - $Message"
}

try {
    Log-Message "Starting Business Central pipeline: $PipelineName in environment: $Environment"

    # Load configuration
    if (Test-Path $ConfigurationFile) {
        $config = Get-Content $ConfigurationFile | ConvertFrom-Json
        Log-Message "Loaded configuration from $ConfigurationFile"
    } else {
        throw "Configuration file not found: $ConfigurationFile"
    }

    # Standardized parameters
    $containerName = $config.ContainerName
    $imageName = $config.ImageName

    # Start the pipeline process
    Log-Message "Invoking pipeline for container: $containerName with image: $imageName"
    
    # Placeholder for actual pipeline invocation logic
    # Invoke-Pipeline -ContainerName $containerName -ImageName $imageName

    Log-Message "Pipeline $PipelineName started successfully."
} catch {
    Log-Message "Error occurred: $_" "ERROR"
    exit 1
} finally {
    Log-Message "Pipeline execution completed."
}
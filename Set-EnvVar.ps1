<#
.SYNOPSIS
    Ensures an environment variable exists with a specific value in the given
    scope (User or Machine), creating or updating it as needed.

.PARAMETER EnvVarName
    The name of the environment variable to check/set.

.PARAMETER EnvVarValue
    The value the environment variable should have.

.PARAMETER EnvVarScope
    The scope to set the variable in: "User" or "Machine".

.EXAMPLE
    .\Set-EnvVar.ps1 -EnvVarName "PSS_ROOT" -EnvVarValue "C:\PSS" -EnvVarScope "Machine"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$EnvVarName,

    [Parameter(Mandatory = $true)]
    [string]$EnvVarValue,

    [Parameter(Mandatory = $true)]
    [ValidateSet("User", "Machine")]
    [string]$EnvVarScope
)

$scope = [System.EnvironmentVariableTarget]::$EnvVarScope

# Retrieve the current value of the environment variable in the specified scope
$currentValue = [System.Environment]::GetEnvironmentVariable($EnvVarName, $scope)

if ($null -eq $currentValue) {
    # Variable does not exist - create it
    Write-Output "Environment variable '$EnvVarName' does not exist. Creating it with value '$EnvVarValue'."
    [System.Environment]::SetEnvironmentVariable($EnvVarName, $EnvVarValue, $scope)
    Write-Output "Environment variable '$EnvVarName' has been created."
}
elseif ($currentValue -ne $EnvVarValue) {
    # Variable exists but value is incorrect - update it
    Write-Output "Environment variable '$EnvVarName' exists but has an incorrect value ('$currentValue'). Updating to '$EnvVarValue'."
    [System.Environment]::SetEnvironmentVariable($EnvVarName, $EnvVarValue, $scope)
    Write-Output "Environment variable '$EnvVarName' has been updated."
}
else {
    # Variable exists and is already correct
    Write-Output "Environment variable '$EnvVarName' already exists with the correct value ('$EnvVarValue'). No action taken."
}

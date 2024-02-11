# DockerHelper.psm1

function Build-DockerImage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Dockerfile,
 
        [Parameter(Mandatory=$true)]
        [string]$Tag,

        [Parameter(Mandatory=$true)]
        [string]$Context,

        [Parameter()]
        [string]$ComputerName
    )

    $dockerCmd = "docker build -t $Tag -f $Dockerfile $Context"
    
    if ($ComputerName){
        Invoke-Command -ComputerName $ComputerName -ScriptBlock {
            param($cmd)
            Invoke-Expression $cmd
        } -ArgumentList $dockerCmd
    } else {
        Invoke-Expression $dockerCmd
    }
}

function Copy-Prerequisites {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$ComputerName,

        [Parameter(Mandatory=$true)]
        [string[]]$Path,

        [Parameter(Mandatory=$true)]
        [string]$Destination
    )

    foreach ($sourcePath in $Path) {
        Copy-Item -Path $sourcePath -Destination "\\$ComputerName\$Destination" -Recurse
    }
}



function Run-DockerContainer {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$ImageName,

        [Parameter()]
        [string]$ComputerName,

        [Parameter()]
        [string[]]$DockerParams
    )

    $dockerCmd = "docker run $ImageName"

    if ($DockerParams) {
        $dockerCmd += " $DockerParams"
    }

    $fibonacciOutput = if ($ComputerName) {
        Invoke-Command -ComputerName $ComputerName -ScriptBlock {
            param($cmd)
            $output = & cmd /c $cmd
            $output
        } -ArgumentList $dockerCmd
    } else {
        $output = & cmd /c $dockerCmd
        $output
    }

    $fibonacciOutput
}

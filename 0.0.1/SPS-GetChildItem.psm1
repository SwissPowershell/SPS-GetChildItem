Function Get-SPSChildItem {
    [CmdLetBinding(DefaultParameterSetName='ByPath')]
    Param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True,ParameterSetName='ByPath', Position=0)]
        [Parameter(Mandatory=$False,ParameterSetName='ByCurrent', Position=0)]
        [String] 
            ${Path},
        [Parameter(Mandatory=$True, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True,ParameterSetName='ByLiteralPath', Position=0)]
        [String] 
            ${LiteralPath},
        [String]
            ${Filter} = '*',
        [String[]]
            ${Include},
        [String[]] 
            ${Exclude},
        [Switch]
            ${Recurse},
        [UInt] 
            ${Depth} = [int32]::MaxValue,
        [Switch] 
            ${Name},
        [Switch]
            ${Hidden},
        [Switch]
            ${FileInfo}
    )
    BEGIN{
        Write-Verbose 'Starting Get-SPSChildItem'
        # if the path is not specified, use the current directory
        if (-not $Path) {
            $Path = Get-Location
        }
        # Resolve the path
        if ($PSCmdlet.ParameterSetName -eq 'ByPath') {
            $LiteralPath = Resolve-Path -Path $Path
        }
        $EnumerationOptions = [System.IO.EnumerationOptions]::new()
        if ($Hidden) {
            $EnumerationOptions.AttributesToSkip = 0
        }Else{
            $EnumerationOptions.AttributesToSkip = [System.IO.FileAttributes]::Hidden
        }
        $EnumerationOptions.BufferSize = 0
        if ($ErrorActionPreference -in @('SilentlyContinue','Ignore','Continue')) {
            $EnumerationOptions.IgnoreInaccessible = $True
        }Else{
            $EnumerationOptions.IgnoreInaccessible = $False
        }
        
        $EnumerationOptions.MatchCasing = [System.IO.MatchCasing]::PlatformDefault
        $EnumerationOptions.MatchType = [System.IO.MatchType]::Simple
        $EnumerationOptions.MaxRecursionDepth = $Depth
        $EnumerationOptions.RecurseSubdirectories = $Recurse
        $EnumerationOptions.ReturnSpecialDirectories = $False
    }
    PROCESS {
        Write-Verbose "Processing path: $($LiteralPath)"
        # Get the child items using the dotnet method
        try {
            if ($FileInfo) {
                # [System.IO.Directory]::GetFiles($LiteralPath, $Filter,$EnumerationOptions) | ForEach-Object {
                #     
                # }
                ForEach ($File in $([System.IO.Directory]::GetFiles($LiteralPath, $Filter,$EnumerationOptions))) {
                    [System.IO.FileInfo]::new($File)
                }
            }Else{
                [System.IO.Directory]::GetFiles($LiteralPath, $Filter,$EnumerationOptions) 
            }
        } catch {
            $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                "Get-SPSChildItem: $($_.Exception.ErrorRecord.ToString().Replace('Exception calling "GetFiles" with "3" argument(s): "','').replace('"',''))",
                'Get-SPSChildItem',
                [System.Management.Automation.ErrorCategory]::PermissionDenied,
                # [System.Management.Automation.ErrorCategory]::NotSpecified,
                $null
            )
            throw $ErrorRecord
        }  
    }
    END {
        Write-Verbose 'Ending Get-SPSChildItem'
    }
}
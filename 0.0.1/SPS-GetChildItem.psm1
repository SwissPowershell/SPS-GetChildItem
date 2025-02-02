Function Get-SPSChildItem {
    [CmdLetBinding(DefaultParameterSetName='ByPath')]
    Param(
        [Parameter(
            Position=0,
            Mandatory=$True, 
            ValueFromPipeline=$True, 
            ValueFromPipelineByPropertyName=$True,
            ParameterSetName='ByPath',
            HelpMessage='The path to the directory to list the files from.'
        )]
        [Parameter(
            Position=0,
            Mandatory=$False,
            ParameterSetName='ByCurrent'
        )]
        [String] ${Path},

        [Parameter(
            Position=0,
            Mandatory=$True, 
            ValueFromPipeline=$True, 
            ValueFromPipelineByPropertyName=$True,
            ParameterSetName='ByLiteralPath',
            HelpMessage='The LiteralPath to the directory to list the files from.'
        )]
        [String] ${LiteralPath},

        [Parameter(
            Position=1,
            Mandatory=$False,
            HelpMessage='The filter to apply to the files.'
        )]
        [String] ${Filter} = '*',

        [Parameter(
            Mandatory=$False,
            HelpMessage='Recurse into subdirectories.'
        )]
        [Switch] ${Recurse},

        [Parameter(
            Mandatory=$False,
            HelpMessage='The maximum depth of recursion.'
        )]
        [UInt] ${Depth} = [int32]::MaxValue,

        [Parameter(
            Mandatory=$False,
            HelpMessage='Include hidden files.'
        )]
        [Switch] ${Hidden},

        [Parameter(
            Mandatory=$False,
            HelpMessage='Return [System.IO.FileInfo] instead of strings.'
        )]
        [Switch] ${AsFileInfo}
    )
    BEGIN{
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        # if the path is not specified (parameterSetName='ByCurrent'), use the current directory
        if ($PSCmdlet.ParameterSetName -eq 'ByCurrent') {
            $LiteralPath = Get-Location
        }
        # Resolve the path
        if ($PSCmdlet.ParameterSetName -eq 'ByPath') {
            $LiteralPath = Resolve-Path -Path $Path
        }
        $EnumerationOptions = [System.IO.EnumerationOptions]::new()
        if ($Hidden -eq $True) {
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
        $EnumerationOptions.RecurseSubdirectories = $Recurse -eq $True
        $EnumerationOptions.ReturnSpecialDirectories = $False
    }
    PROCESS {
        Write-Verbose "Processing path: $($LiteralPath)"
        # Get the child items using the dotnet method.
        try {
            if ($AsFileInfo -eq $True) {
                # Will return a full file info object instead of just the path string, this is slower.
                ForEach ($File in $([System.IO.Directory]::GetFiles($LiteralPath, $Filter,$EnumerationOptions))) {
                    Try {
                        [System.IO.FileInfo]::new($File)
                    }Catch{
                        Write-Warning "Unable to read fileinfo for '$($File)': $($_.Exception.Message)"
                    }
                    
                }
            }Else{
                [System.IO.Directory]::GetFiles($LiteralPath, $Filter,$EnumerationOptions) 
            }
        } catch {
            $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                "$($MyInvocation.MyCommand): $($_.Exception.ErrorRecord.ToString().Replace('Exception calling "GetFiles" with "3" argument(s): "','').replace('"',''))",
                "$($MyInvocation.MyCommand)",
                [System.Management.Automation.ErrorCategory]::PermissionDenied,
                $null
            )
            throw $ErrorRecord
        }  
        
        
    }
    END {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    }
}
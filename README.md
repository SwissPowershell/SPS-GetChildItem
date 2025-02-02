# SPS-GetChildItem Module

## Overview
This module provides a quicker way to get file child items in a given directory. It use the `[System.IO.Directory]::GetFiles()` .net method and expose `Get-ChildItem` most used parameter.

## Awaited performance gain
The performance gain is expected to be significant when the number of files in the directory is high.

When not using `-AsFileInfo` I measured an average **70%** performance gain.

When using `-AsFileInfo` the performance gain will depend on the number of files in the directory and the size of the files. The performance gain is expected to be higher when the files are small. I measured between **4%** and **60%** performance gain.

The performance gain is less significant when you use the `-AsFileInfo` parameter but the output will be `[System.IO.FileInfo]` which is what `Get-ChildItem` returns.

> [!IMPORTANT] 
> The command will not return directories.

> [!NOTE]  
> Performance of `Get-ChildItem` seems to be fluctuating for the same directory. I recommend testing the performance of this module in your environment.

### Syntax
```powershell
Get-SPSChildItem 
    [[-Path] <String>] 
    [[-Filter] <String>] 
    [-Recurse] 
    [[-Depth] <UInt>] 
    [-Hidden]
    [-AsFileInfo] 
    [<CommonParameters>]
```
```powershell
Get-SPSChildItem 
    -LiteralPath <String> 
    [[-Filter] <String>] 
    [-Recurse] 
    [[-Depth] <UInt>]  
    [-Hidden] 
    [-AsFileInfo] 
    [<CommonParameters>]

```
### Description
The Get-SPSChildItem cmdlet gets the items in one specified locations. If the item is a container, it gets the items inside the container, known as child items. You can use the Recurse parameter to get items in all child containers and use the Depth parameter to limit the number of levels to recurse.

Get-SPSChildItem doesn't display directories. It only displays files. If you want to display directories, use Get-ChildItem.
### Examples
#### Example 1: gets all the .dll files in the C:\Windows\System32 directory.
```powershell
Get-SPSChildItem -Path "C:\Windows\System32" -Filter "*.dll"
```
#### Example 2: gets all the .dll files in the C:\Windows\System32 directory and all subdirectories.
```powershell
Get-SPSChildItem -Path "C:\Windows\System32" -Filter "*.dll" -Recurse
```
#### Example 3: gets all the .dll files in the C:\Windows\System32 directory and all subdirectories, but only two levels deep.
```powershell
Get-SPSChildItem -Path "C:\Windows\System32" -Filter "*.dll" -Recurse -Depth 2
```
#### Example 4: gets all the .dll files in the C:\Windows\System32 directory and all subdirectories, but only two levels deep. The cmdlet returns FileInfo objects.
```powershell
Get-SPSChildItem -Path "C:\Windows\System32" -Filter "*.dll" -Recurse -Depth 2 -AsFileInfo
```

### Parameters
**\-Path**

Specifies the path of the items to get. Wildcards are permitted. The default is the current     directory.

    Type: String
    Mandatory: False
    Position: 0
    ValueFromPipeline: True
    ValueFromPipelineByPropertyName: True

**\-LiteralPath**

Specifies the path of the items to get. Unlike Path, the value of LiteralPath is used exactly as it is typed. No characters are interpreted as wildcards. If the path includes escape characters, enclose it in single quotation marks. Single quotation marks tell Windows PowerShell not to interpret any characters as escape sequences.

    Type: String
    Mandatory: False
    Position: 0
    ValueFromPipeline: True
    ValueFromPipelineByPropertyName: True

**\-Filter**

Specifies a filter to qualify the Path parameter. The FileSystem provider is the only installed PowerShell provider that supports filters. You can also use the Filter parameter with the FileSystem provider. The filter is applied to the items after they are retrieved. For example, you can use the Filter parameter to get only files that have a .txt file name extension. The value of this parameter qualifies the Path parameter. The syntax of the filter, including the use of wildcards, depends on the provider. Filters are more efficient than other parameters, because the provider applies them when retrieving the objects, rather than having Windows PowerShell filter the objects after they are retrieved.

    Type: String
    Mandatory: False
    Position: 1

**\-Recurse**

Gets the items in the specified locations and in all child items of the locations.

    Type: SwitchParameter
    Mandatory: False

**\-Depth**

Specifies how many levels of contained items are retrieved. Levels are relative to the content of the Path parameter. The default is 2147483647, which retrieves all subdirectories. A value of 1 retrieves all items that are directly contained in the path. A value of 2 retrieves all items that are contained in the items that are directly contained in the path, and so on. The value of this parameter counts the number of subdirectory levels that are included in the retrieval.

    Type: UInt32
    Default value: 2147483647
    Mandatory: False
    Position: 2

**\-Hidden**

Indicates that the cmdlet gets items that are not displayed by default.

    Type: SwitchParameter
    Mandatory: False

**\-AsFileInfo**

Indicates that the cmdlet returns FileInfo objects. By default, the cmdlet returns string[].

    Type: SwitchParameter
    Mandatory: False
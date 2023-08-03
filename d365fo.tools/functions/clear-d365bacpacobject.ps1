
<#
    .SYNOPSIS
        Clear out sql objects from inside the bacpac/dacpac or zip file
        
    .DESCRIPTION
        Remove a set of sql objects from inside a bacpac/dacpac or zip file, before restoring it into your SQL Server / Azure SQL DB
        
        It will open the file as a zip archive, locate the desired sql object and remove it, so when importing the bacpac the object will not be created
        
        The default behavior is that you get a copy of the file, where the desired sql objects are removed
        
    .PARAMETER Path
        Path to the bacpac/dacpac or zip file that you want to work against
        
    .PARAMETER Name
        Name of the sql object that you want to remove
        
        Supports an array of names
        
        If a schema name isn't supplied as part of the table name, the cmdlet will prefix it with "dbo."
        
        Some sql objects are 3 part named, which will require that you fill them in with brackets E.g. [dbo].[SalesTable].[CustomIndexName1]
        - Index
        - Constraints
        
    .PARAMETER ObjectType
        Instruct the cmdlet, the type of object that you want to remove
        
        As we are manipulating the bacpac file, we can only handle 1 ObjectType per run
        
        If you want to remove SqlView and SqlIndex, you will have to run the cmdlet 1 time for SqlViews and 1 time for SqlIndex
        
        Supported types are:
        "SqlView", "SqlTable", "SqlIndex", "SqlCheckConstraint"
        
    .PARAMETER OutputPath
        Path to where you want the updated bacpac/dacpac or zip file to be saved
        
    .PARAMETER ClearFromSource
        Instruct the cmdlet to delete sql objects directly from the source file
        
        It will save disk space and time, because it doesn't have to create a copy of the bacpac file, before deleting sql objects from it
        
    .EXAMPLE
        PS C:\> Clear-D365BacpacObject -Path "C:\Temp\AxDB.bacpac" -ObjectType SqlView -Name "View2" -OutputPath "C:\Temp\AXBD_Cleaned.bacpac"
        
        This will remove the SqlView "View2" from inside the bacpac file.
        
        It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
        It uses "View2" as the name of the object to delete.
        It uses "C:\Temp\AXBD_Cleaned.bacpac" as the OutputPath to where it will store the updated bacpac file.
        
    .EXAMPLE
        PS C:\> Clear-D365BacpacObject -Path "C:\Temp\AxDB.bacpac" -ObjectType SqlView -Name "dbo.View1","View2" -OutputPath "C:\Temp\AXBD_Cleaned.bacpac"
        
        This will remove the SqlView(s) "dbo.View1" and "View2" from inside the bacpac file.
        
        It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
        It uses "dbo.View1","View2" as the names of objects to delete.
        It uses "C:\Temp\AXBD_Cleaned.bacpac" as the OutputPath to where it will store the updated bacpac file.
        
    .EXAMPLE
        PS C:\> Clear-D365BacpacObject -Path "C:\Temp\AxDB.bacpac" -ObjectType SqlIndex -Name "[dbo].[SalesTable].[CustomIndexName1]" -ClearFromSource
        
        This will remove the SqlIndex "CustomIndexName1" from the dbo.SalesTable table from inside the bacpac file.
        
        It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
        It uses "[dbo].[SalesTable].[CustomIndexName1]" as the name of the object to delete.
        
        Caution:
        It will remove from the source "C:\Temp\AxDB.bacpac" directly. So if the original file is important for further processing, please consider the risks carefully.
        
    .NOTES
        It will NOT fail, if it can't find any object with the specified name
        
#>
function Clear-D365BacpacObject {
    [CmdletBinding(DefaultParameterSetName = "Copy")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '')]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('File')]
        [Alias('BacpacFile')]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [Alias("ObjectName")]
        [string[]] $Name,

        [ValidateSet("SqlView", "SqlTable", "SqlIndex", "SqlCheckConstraint")]
        [string] $ObjectType,

        [Parameter(Mandatory = $true, ParameterSetName = "Copy")]
        [string] $OutputPath,

        [Parameter(Mandatory = $true, ParameterSetName = "Keep")]
        [switch] $ClearFromSource
    )
    
    if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

    $compressPath = ""

    if ($ClearFromSource) {
        $compressPath = $Path
    }
    else {
        $compressPath = $OutputPath

        if (-not (Test-PathExists -Path $compressPath -Type Leaf -ShouldNotExist)) {
            Write-PSFMessage -Level Host -Message "The <c='em'>$compressPath</c> already exists. Consider changing the <c='em'>OutputPath</c> or <c='em'>delete</c> the <c='em'>$compressPath</c> file."
            return
        }

        if (Test-PSFFunctionInterrupt) { return }

        Write-PSFMessage -Level Verbose -Message "Copying the file from '$Path' to '$compressPath'"
        Copy-Item -Path $Path -Destination $compressPath
        Write-PSFMessage -Level Verbose -Message "Copying was completed."
    }
        
    Write-PSFMessage -Level Verbose -Message "Opening the file '$compressPath'."
    $file = [System.IO.File]::Open($compressPath, [System.IO.FileMode]::Open)
    $zipArch = [System.IO.Compression.ZipArchive]::new($file, [System.IO.Compression.ZipArchiveMode]::Update)
    Write-PSFMessage -Level Verbose -Message "File '$compressPath' was read succesfully."

    if (-not $zipArch) {
        $messageString = "Unable to open the file <c='em'>$compressPath</c>."
        Write-PSFMessage -Level Host -Message $messageString
        Stop-PSFFunction -Message "Stopping because the file couldn't be opened." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', '')))
        return
    }

    $pathWorkDirectory = "$([System.IO.Path]::GetTempPath())d365fo.tools\$([System.Guid]::NewGuid().Guid)"
        
    #Make sure the work path is created and available
    New-Item -Path $pathWorkDirectory -ItemType Directory -Force -ErrorAction Ignore > $null

    if (Test-PSFFunctionInterrupt) { return }
    
    Write-PSFMessage -Level Verbose -Message "Building the regex patterns to look for in the model.xml file."
    
    # Build the array of regex patterns that we are looking for
    # Has to be the same type
    $searchCol = @(
        foreach ($item in $Name) {
            $fullObjectName = ""

            if (-not ($item -like "*.*")) {
                $fullObjectName = "[dbo].[$item]"
            }
            elseif ($item -like "*.*" -and (-not ($item -match '\[.*?\]\.\[.*?\]') )) {
                #Throw error name format isn't as expected
                Throw
            }
            else {
                $fullObjectName = $item
            }

            $regexName = $fullObjectName.Replace("[", "\[").Replace("]", "\]").Replace(".", "\.")

            '<Element Type="{0}" Name="{1}">' -f $ObjectType, $regexName
        })

    # The model files defines all objects that will be created when importing the bacpac file
    $model = $zipArch.GetEntry("model.xml")

    Write-PSFMessage -Level Verbose -Message "Extracting local model.xml file."

    # We will have a local "model.raw.xml" file to read from
    $pathModelRaw = Join-Path -Path $pathWorkDirectory -ChildPath "model.raw.xml"
    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($model, $pathModelRaw)

    # We will have a local "model.xml" where we persist the changes to
    $pathModelWorking = Join-Path -Path $pathWorkDirectory -ChildPath "model.xml"

    # The Origin.xml file is a manifest file, with a checksum value for the model.xml file inside the bacpac
    # Removing a single character from the model.xml file, will invalidate the checksum stored inside the Origin.xml
    $origin = $zipArch.GetEntry("Origin.xml")
        
    Write-PSFMessage -Level Verbose -Message "Extracting local Origin.xml file."

    # We will have a local "Origin.raw.xml" file to read from
    $pathOriginRaw = Join-Path -Path $pathWorkDirectory -ChildPath "Origin.raw.xml"
    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($origin, $pathOriginRaw)

    # We will have a local "Origin.xml" where we persist the changes to
    $pathOriginWorking = Join-Path -Path $pathWorkDirectory -ChildPath "Origin.xml"

    # The model file is a very large XML file, reading that into a DOM object will slow down the operation
    # We will be reading the file line-by-line
    $reader = [System.IO.StreamReader]::new($pathModelRaw)
    $writer = [System.IO.StreamWriter]::new($pathModelWorking)

    # We need to know when to skip lines and at what indent to stop skipping lines
    $skipLine = $false
    $skipIdent = -1

    Write-PSFMessage -Level Verbose -Message "Starting the analysis of the model.xml file."

    :nextLine while ( -not $reader.EndOfStream) {
        $tmp = $reader.ReadLine()

        if ($skipLine) {
            # SkipLine indicates that we found the object that we want to remove
            # We need to search for the very first NEXT instance of "</Element>"

            if ($tmp -match "</Element>") {
                # We found a "</Element>", but there are several child elements

                if ($skipIdent -eq $tmp.IndexOf("<")) {
                    Write-PSFMessage -Level Verbose -Message "Skipping lines disabled. Correct close element found."

                    # The identication signals that we found the right "</Element>"

                    # Resitting the search signal/variables
                    $skipLine = $false
                    $skipIdent = -1
                    continue nextLine
                }
            }

            # We need to move forward with reading the file
            continue nextLine
        }

        foreach ($regex in $searchCol) {
            # searchCol contains ALL regex patterns that we want to remove from the model file
            # This is done to increase performance, as we only read the file onces, but validates each line multiple times

            if (($tmp -match $regex)) {
                Write-PSFMessage -Level Verbose -Message "Regex: $regex had a match. Skipping lines until close element found."

                # A match indicates that we found the next object that we want to remove

                # Setting the signal/variables - identication helps later to match to the correct "</Element>"
                $skipIdent = $tmp.IndexOf("<")
                $skipLine = $true
                continue nextLine
            }
        }

        # If skipLine and no regex was hit, we need to line in the updated model.xml file
        $writer.WriteLine($tmp)
    }
    
    # This concludes the entire update on the model.xml file
    $reader.Close()
    $writer.Flush()
    $writer.Close()

    Write-PSFMessage -Level Verbose -Message "Calculating hash value (checksum) for the updated model.xml file."

    # The model file will be checksum validated when running an import of it
    # We need to handle that
    $hashValue = Get-FileHash -Path $pathModelWorking -Algorithm SHA256 | Select-Object -ExpandProperty Hash

    # Loading the Origin.xml into memory
    [xml]$xmlDoc = Get-Content -Path $pathOriginRaw

    Write-PSFMessage -Level Verbose -Message "Updating the hash value (checksum) inside the Origin.xml file."

    # Updating the hash vaule (checksum) and saving it
    $xmlDoc.DacOrigin.Checksums.Checksum.InnerText = $hashValue
    $xmlDoc.Save($pathOriginWorking)

    Write-PSFMessage -Level Verbose -Message "Switching out the Origin.xml and model.xml files from inside the bacpac."

    # We need to remove the model.xml and origin.xml from the bacpac (archive)
    $model.Delete()
    $origin.Delete()

    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zipArch, $pathModelWorking, "model.xml") > $null
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zipArch, $pathOriginWorking, "Origin.xml") > $null

    $res = @{ }
    
    if ($zipArch) {
        $zipArch.Dispose()
    }

    if ($file) {
        $file.Close()
        $file.Dispose()
    }

    if (Test-PSFFunctionInterrupt) { return }
    
    $res.File = $compressPath
    $res.Filename = $(Split-Path -Path $compressPath -Leaf)

    [PSCustomObject]$res
}
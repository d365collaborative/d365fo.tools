function Invoke-SqlPackage ($DatabaseServer, $DatabaseName, $SqlUser, $SqlPwd, $FilePath ){

    $StartTime = Get-Date
    
    $sqlPackagePath = $Script:SqlPackage
    
    $param = "/a:export /ssn:$DatabaseServer /sdn:$DatabaseName /su:$SqlUser /sp:$SqlPwd /tf:$FilePath /p:CommandTimeout=1200 /p:VerifyFullTextDocumentTypesSupported=false /p:Storage=File"

    Remove-Item -Path $FilePath -ErrorAction SilentlyContinue -Force

    Start-Process -FilePath $sqlPackagePath -ArgumentList  $param  -NoNewWindow -Wait

    $EndTime = Get-Date

    $TimeSpan = New-TimeSpan -End $EndTime -Start $StartTime

    Write-Host "Time Taken inside: Invoke-SqlPackage" -ForegroundColor Green
    Write-Host "$TimeSpan" -ForegroundColor Green
}
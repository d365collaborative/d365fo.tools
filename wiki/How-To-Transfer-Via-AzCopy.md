# **Speed up LCS download via AzCopy**

This how-to will guide you on how to utilize the AzCopy.exe tool to increase the download speed from the LCS asset library. It can be the Shared Asset Library or it can be a Project specific Asset Library.

## **Prerequisites**
* Machine with D365FO installed
* PowerShell 5.1
* d365fo.tools module installed
* d365fo.tools module loaded into a PowerShell session
* Storage account (Full url is needed)
* Blob Container
* SAS token to Blob Container, should be a full permission while testing

Please visit the [Install as an Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Administrator) or the [Install as a Non Administrator](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Install-Non-Administrator) tutorials to learn how to install the tools.

Please visit the [Import d365fo.tools module](https://github.com/d365collaborative/d365fo.tools/wiki/Tutorial-Import-Module) tutorial to see the different ways you can load the d365fo.module into a PowerShell session.

## **Start download from LCS via the browser**
We need to get a hold of a complete source url from LCS, and thankfully it is super easy. Please see below guide:

[[images/howtos/LCS-Download-v2.gif]]

The end result is that you have a full URL/URI for the file that you want to transfer. The URL/URI will contain a valid SAS token, but will be time limited.

The source URL/URI in our example is:
"https://uswedpl1catalog.blob.core.windows.net/product-ax7productname/476c13c6-7e3d-49c4-a377-f1282fd7ad16/AX7ProductName-12-24-92935151-8f5b-45d6-9aea-392bd74bd6ec-476c13c6-7e3d-49c4-a377-f1282fd7ad16?sv=2015-12-11&sr=b&sig=ChCHvZD3eFtcHYU1n%2FqXDmKzUTbcXNefMwbVKyRKyiU%3D&se=2019-11-23T14%3A28%3A15Z&sp=r"

## **Transfer the file into your own Storage Account**
You need to concatenate the full URL/URI for you own Azure Storage Account, the container name, the desired destination filename and the SAS token that you must have in place for the container.

In out example these are the following details:

**Storage Account URL/URI**: "https://motz.blob.core.windows.net/"

**Container Name**: "azcopytest"

**SAS Token**: "?sv=2018-03-28&si=full&sr=c&sig=PH5douKkqJJrbl8CoQjizopFCtgnL50aLUJzY0k1Xqc%3D"

**Desired Filename**: "FinandOps10.0.5.part16.rar"

The combined destination URL/URI ends up being:
"https://motz.blob.core.windows.net/azcopytest/FinandOps10.0.5.part16.rar?sv=2018-03-28&si=full&sr=c&sig=PH5douKkqJJrbl8CoQjizopFCtgnL50aLUJzY0k1Xqc%3D"

With both the source and destination URL's/URI's at hand, we can start the transfer between the LCS Storage Account and our own Storage Account. Type the following command:

```
Invoke-D365AzCopyTransfer -SourceUri "https://uswedpl1catalog.blob.core.windows.net/product-ax7productname/476c13c6-7e3d-49c4-a377-f1282fd7ad16/AX7ProductName-12-24-92935151-8f5b-45d6-9aea-392bd74bd6ec-476c13c6-7e3d-49c4-a377-f1282fd7ad16?sv=2015-12-11&sr=b&sig=ChCHvZD3eFtcHYU1n%2FqXDmKzUTbcXNefMwbVKyRKyiU%3D&se=2019-11-23T14%3A28%3A15Z&sp=r" -DestinationUri "https://motz.blob.core.windows.net/azcopytest/FinandOps10.0.5.part16.rar?sv=2018-03-28&si=full&sr=c&sig=PH5douKkqJJrbl8CoQjizopFCtgnL50aLUJzY0k1Xqc%3D" -ShowOriginalProgress
```

[[images/howtos/Transfer-From-Lcs-To-Own-Storage.gif]]

Here you can see that the file is actually stored in the container under our Storage Account.

[[images/howtos/Show-File-In-Blob-Container.gif]]

## **Transfer the file from your own Storage Account to your machine**
When the transfer into your own Storage Account, you can use the same URL/URI as the new source URL/URI, and then fill in a local folder path to where you want the file to be saved. Type the following command:

```
Invoke-D365AzCopyTransfer -SourceUri "https://motz.blob.core.windows.net/azcopytest/FinandOps10.0.5.part16.rar?sv=2018-03-28&si=full&sr=c&sig=PH5douKkqJJrbl8CoQjizopFCtgnL50aLUJzY0k1Xqc%3D" -DestinationUri "c:\temp\d365fo.tools\FinandOps10.0.5.part16.rar" -ShowOriginalProgress
```

[[images/howtos/Transfer-From-Own-Storage-To-Local.gif]]

Here you can see that the file is actually stored our machine.

[[images/howtos/Show-File-Local.png]]

## **Closing comments**
In this how to we showed you how to utilize the AzCopy.exe as a tool to speed up the download process of files stored in the LCS Storage Account. It might seem a bit technical at first, but when you first learn that you are only working with a source and a destination URL/URI, it should be a doable task going foward. The `Invoke-D365AzCopyTransfer` cmdlet has a `-Filename` parameter that can help you to ease the work of concatenation, because you can then reuse the same destination URL/URI and only change the filename between multiple file transfers.
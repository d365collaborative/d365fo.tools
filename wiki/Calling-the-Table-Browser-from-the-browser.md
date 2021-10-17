**You want to be able to call the table browser in an easy way**

```
Invoke-D365TableBrowser -TableName SalesTable -Company "USMF"
```
*This will start a web browser and have it call the SysTableBrowser menu item with the SalesTable name of the table you want to see data from and only execute it against the USMF company*

**Small teaser for the combination of Get-D365Table and Invoke-D365TableBrowser**

```
Get-D365Table -Name CustTable,CustTrans | Invoke-D365TableBrowser -Company USMF
```
*You want to start the table browser for **both** CustTable & CustTrans, against the USMF company*
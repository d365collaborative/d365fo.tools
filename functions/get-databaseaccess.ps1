##############################
#.SYNOPSIS
#Gives Database Access information for the D365 Environment
#
#.DESCRIPTION
# Gvies database information used in D365FO
#
#.EXAMPLE
# Get-DatabaseAccess
#
#.NOTES
# Uses a .net dll from D365FO to retrive a DataAcessObject containing database information
##############################
function Get-DatabaseAccess
{

    $environment = Get-ApplicationEnvironment
    
    return $environment.DataAccess

}
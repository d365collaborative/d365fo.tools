function Import-AadUserIntoD365FO ($SqlCommand, $SignInName, $Name, $Id, $SID, $StartUpCompany, $IdentityProvider, $NetworkDomain, $ObjectId) {
    Write-Verbose "Testing the Email $signInName"

    $UserFound = Test-AadUserInD365FO $sqlCommand $SignInName

    if ($UserFound -eq $false) {

        Write-Verbose "Testing the userid $Id"

        $idTaken = Test-AadUserIdInD365FO $sqlCommand $id

        if ($idTaken -eq $false) {

            $userAdded = New-D365FOUser $sqlCommand $SignInName $Name $Id $Sid $StartUpCompany $IdentityProvider $NetworkDomain $ObjectId
        
            if ($userAdded -eq $true) {

                $securityAdded = Add-AadUserSecurity $sqlCommand $Id
                if ($securityAdded -eq $false) {
                    Write-Error "User $SignInName did not get securityRoles"
                }
            }
            else {
                Write-Error "User $SignInName, not added to D365FO"
            }
        }
        else {
            Write-Error "An User with ID = '$ID' allready exists"
        }

    }
    else {
        Write-Error "An User with Email $SignInName already exists in D365FO"
    }
    

}
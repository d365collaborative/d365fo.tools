function Get-TenantFromEmail($email)
{
    return $email.Substring($email.LastIndexOf('@') + 1).Trim();
}

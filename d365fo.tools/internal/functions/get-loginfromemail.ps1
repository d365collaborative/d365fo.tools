function Get-LoginFromEmail([string]$Email)
{
   return $email.Substring(0,$Email.LastIndexOf('@')).Trim();
}
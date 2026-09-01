# Load mock AWS IAM data.
# In a production implementation, this data could be retrieved through AWS IAM APIs or AWS Security Hub.

$Users = Get-Content ".\MockData\iamUsers.json" | ConvertFrom-Json

$Results = @()

# First Check: Administrator Access
# --------------------------------------------------

$AdminUsers = $Users | Where-Object {
    $_.Policies -contains "AdministratorAccess"
}

foreach ($User in $AdminUsers) {

    $Results += [PSCustomObject]@{
        User        = $User.UserName
        Detection   = "Administrator Access"
        Severity    = "Critical"
        Description = "User has AdministratorAccess assigned"
    }
}


# Second Check: MFA Not Enabled
# --------------------------------------------------

$UsersWithoutMFA = $Users | Where-Object {
    $_.MFAEnabled -eq $false
}

foreach ($User in $UsersWithoutMFA) {

    $Results += [PSCustomObject]@{
        User        = $User.UserName
        Detection   = "MFA Not Enabled"
        Severity    = "Critical"
        Description = "IAM user does not have MFA enabled"
    }
}

# Third Check: Inactive IAM Users
# --------------------------------------------------

$InactiveUsers = $Users | Where-Object {
    $_.LastActivityDays -gt 90
}

foreach ($User in $InactiveUsers) {

    $Results += [PSCustomObject]@{
        User        = $User.UserName
        Detection   = "Inactive IAM User"
        Severity    = "Medium"
        Description = "User has had no activity for more than 90 days"
    }
}

# SECURITY SUMMARY
# --------------------------------------------------

$Critical = ($Results | Where-Object {
    $_.Severity -eq "Critical"
}).Count

$High = ($Results | Where-Object {
    $_.Severity -eq "High"
}).Count

$Medium = ($Results | Where-Object {
    $_.Severity -eq "Medium"
}).Count

# RESULTS
# --------------------------------------------------

Write-Host ""
Write-Host "============================================="
Write-Host "        AWS IAM SECURITY CHECKER"
Write-Host "============================================="
Write-Host ""

if ($Results.Count -eq 0) {

    Write-Host "No security findings detected."

}
else {

    $Results | Format-Table `
        User,
        Detection,
        Severity,
        Description `
        -AutoSize
}

Write-Host ""
Write-Host "Security Findings: $($Results.Count)"
Write-Host "Critical: $Critical"
Write-Host "High:     $High"
Write-Host "Medium:   $Medium"

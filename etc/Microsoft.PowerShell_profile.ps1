Set-PSReadlineOption -EditMode Emacs -BellStyle None
Set-PSReadlineKeyHandler -Key Shift+Insert Paste

Remove-Item Alias:diff -Force
Remove-Item Alias:curl -Force
Remove-Item Alias:wget -Force

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

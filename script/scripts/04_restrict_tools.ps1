# 04_restrict_tools.ps1 - Restriction des outils système
# Auteur: Mounia

Write-Host "=== RESTRICTION DES OUTILS SYSTÈME ===" -ForegroundColor Cyan

$groupIT = "G_IT"

# Restriction PowerShell (via registre)
$registryPath = "HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell"
if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force
}
Set-ItemProperty -Path $registryPath -Name "ExecutionPolicy" -Value "Restricted" -Force
Write-Host "  PowerShell restreint" -ForegroundColor Green

# Restriction CMD (via registre)
$registryPath = "HKCU:\Software\Policies\Microsoft\Windows\System"
if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force
}
Set-ItemProperty -Path $registryPath -Name "DisableCMD" -Value 1 -Force
Write-Host "  CMD restreint" -ForegroundColor Green

# Restriction Panneau de configuration
$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force
}
Set-ItemProperty -Path $registryPath -Name "NoControlPanel" -Value 1 -Force
Write-Host "  Panneau de configuration restreint" -ForegroundColor Green

# Restriction Éditeur du registre
$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System"
if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force
}
Set-ItemProperty -Path $registryPath -Name "DisableRegistryTools" -Value 1 -Force
Write-Host "  Éditeur du registre restreint" -ForegroundColor Green

Write-Host "`nRestrictions appliquées avec succès !" -ForegroundColor Green
Write-Host "Le groupe $groupIT conserve l'accès complet" -ForegroundColor Yellow

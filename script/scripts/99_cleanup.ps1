# 99_cleanup.ps1 - Nettoyage complet
# Auteur: Mounia

$basePath = "D:\Hopital"

$groups = @(
    "G_Medecins", "G_Infirmiers", "G_Direction", "G_Comptables",
    "G_RH", "G_Communication", "G_IT"
)

$users = @(
    "medecin1", "infirmier1", "comptable1", "rh1", "com1", "directeur1", "info1"
)

Write-Host "=== DÉBUT DU NETTOYAGE COMPLET ===" -ForegroundColor Cyan

# Suppression des utilisateurs
Write-Host "`nSuppression des utilisateurs..." -ForegroundColor Yellow
foreach ($user in $users) {
    try {
        Remove-LocalUser -Name $user -ErrorAction Stop
        Write-Host "  Utilisateur supprimé : $user" -ForegroundColor Green
    } catch {
        Write-Host "  Utilisateur introuvable : $user" -ForegroundColor Yellow
    }
}

# Suppression des groupes
Write-Host "`nSuppression des groupes..." -ForegroundColor Yellow
foreach ($group in $groups) {
    try {
        Remove-LocalGroup -Name $group -ErrorAction Stop
        Write-Host "  Groupe supprimé : $group" -ForegroundColor Green
    } catch {
        Write-Host "  Groupe introuvable : $group" -ForegroundColor Yellow
    }
}

# Suppression des dossiers
Write-Host "`nSuppression des dossiers..." -ForegroundColor Yellow
if (Test-Path $basePath) {
    Remove-Item -Path $basePath -Recurse -Force
    Write-Host "  Dossier supprimé : $basePath" -ForegroundColor Green
} else {
    Write-Host "  Dossier introuvable : $basePath" -ForegroundColor Yellow
}

Write-Host "`n=== NETTOYAGE TERMINÉ ===" -ForegroundColor Cyan

# 02_create_accounts.ps1 - Création des groupes et utilisateurs
# Auteur: Sherine

Write-Host "=== CRÉATION DES GROUPES ET UTILISATEURS ===" -ForegroundColor Cyan

# Groupes de sécurité
$groups = @(
    "G_Medecins",
    "G_Infirmiers",
    "G_Direction",
    "G_Comptables",
    "G_RH",
    "G_Communication",
    "G_IT"
)

# Utilisateurs avec leur groupe
$users = @(
    @{Name="medecin1"; Group="G_Medecins"; Password="P@ssw0rd123"},
    @{Name="infirmier1"; Group="G_Infirmiers"; Password="P@ssw0rd123"},
    @{Name="comptable1"; Group="G_Comptables"; Password="P@ssw0rd123"},
    @{Name="rh1"; Group="G_RH"; Password="P@ssw0rd123"},
    @{Name="com1"; Group="G_Communication"; Password="P@ssw0rd123"},
    @{Name="directeur1"; Group="G_Direction"; Password="P@ssw0rd123"},
    @{Name="info1"; Group="G_IT"; Password="P@ssw0rd123"}
)

# Création des groupes
Write-Host "`nCréation des groupes..." -ForegroundColor Yellow
foreach ($group in $groups) {
    try {
        New-LocalGroup -Name $group -ErrorAction Stop
        Write-Host "  Groupe créé : $group" -ForegroundColor Green
    } catch {
        Write-Host "  Groupe déjà existant : $group" -ForegroundColor Yellow
    }
}

# Création des utilisateurs
Write-Host "`nCréation des utilisateurs..." -ForegroundColor Yellow
foreach ($user in $users) {
    $securePass = ConvertTo-SecureString $user.Password -AsPlainText -Force
    
    try {
        New-LocalUser -Name $user.Name -Password $securePass -FullName $user.Name -PasswordNeverExpires -ErrorAction Stop
        Write-Host "  Utilisateur créé : $($user.Name)" -ForegroundColor Green
    } catch {
        Write-Host "  Utilisateur déjà existant : $($user.Name)" -ForegroundColor Yellow
    }
    
    # Ajout au groupe
    try {
        Add-LocalGroupMember -Group $user.Group -Member $user.Name -ErrorAction Stop
        Write-Host "    -> Ajouté au groupe : $($user.Group)" -ForegroundColor Green
    } catch {
        Write-Host "    -> Déjà dans le groupe : $($user.Group)" -ForegroundColor Yellow
    }
}

Write-Host "`nGroupes et utilisateurs créés avec succès !" -ForegroundColor Green

# 03_apply_acl.ps1 - Application des permissions NTFS
# Auteur: Lina

$basePath = "D:\Hopital"

Write-Host "=== APPLICATION DES PERMISSIONS NTFS ===" -ForegroundColor Cyan

# Définition des permissions
$permissions = @(
    @{Path="Dossiers_Patients"; Access="G_Medecins"; Rights="FullControl"},
    @{Path="Soins"; Access="G_Medecins"; Rights="FullControl"},
    @{Path="Soins"; Access="G_Infirmiers"; Rights="Read,Write"},
    @{Path="RH"; Access="G_RH"; Rights="FullControl"},
    @{Path="Finance"; Access="G_Comptables"; Rights="FullControl"},
    @{Path="Comptes_Rendus"; Access="G_Medecins"; Rights="FullControl"},
    @{Path="Comptes_Rendus"; Access="G_Direction"; Rights="Read"},
    @{Path="Communication"; Access="G_Communication"; Rights="FullControl"},
    @{Path="Outils_Systeme"; Access="G_IT"; Rights="FullControl"},
    @{Path="Direction"; Access="G_Direction"; Rights="FullControl"},
    @{Path="Public"; Access="Everyone"; Rights="Read"}
)

function Set-AclPermission {
    param($Path, $Group, $Rights)
    
    $fullPath = Join-Path $basePath $Path
    
    if (!(Test-Path $fullPath)) {
        Write-Host "  Dossier inexistant : $Path" -ForegroundColor Red
        return
    }
    
    $acl = Get-Acl $fullPath
    
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        $Group, $Rights, "ContainerInherit,ObjectInherit", "None", "Allow"
    )
    
    $acl.AddAccessRule($accessRule)
    Set-Acl -Path $fullPath -AclObject $acl
}

# Suppression de l'héritage et application des permissions
foreach ($perm in $permissions) {
    try {
        Set-AclPermission -Path $perm.Path -Group $perm.Access -Rights $perm.Rights
        Write-Host "  $($perm.Path) -> $($perm.Access) ($($perm.Rights))" -ForegroundColor Green
    } catch {
        Write-Host "  Erreur sur : $($perm.Path)" -ForegroundColor Red
    }
}

Write-Host "`nPermissions NTFS appliquées avec succès !" -ForegroundColor Green

# 01_create_resources.ps1 - Création de l'arborescence
# Auteur: Syrine

$jsonPath = ".\json\ressource.json"
$config = Get-Content $jsonPath | ConvertFrom-Json

$basePath = $config.base

Write-Host "=== CRÉATION DE L'ARBORESCENCE ===" -ForegroundColor Cyan

# Création du dossier racine
if (!(Test-Path $basePath)) {
    New-Item -Path $basePath -ItemType Directory -Force
    Write-Host "Dossier racine créé : $basePath" -ForegroundColor Green
} else {
    Write-Host "Dossier racine existant : $basePath" -ForegroundColor Yellow
}

# Création des sous-dossiers
foreach ($folder in $config.structure.PSObject.Properties.Name) {
    $path = Join-Path $basePath $folder
    if (!(Test-Path $path)) {
        New-Item -Path $path -ItemType Directory -Force
        Write-Host "  Dossier créé : $folder" -ForegroundColor Green
    } else {
        Write-Host "  Dossier existant : $folder" -ForegroundColor Yellow
    }
}

Write-Host "`nArborescence créée avec succès !" -ForegroundColor Green
Write-Host "Emplacement : $basePath" -ForegroundColor White

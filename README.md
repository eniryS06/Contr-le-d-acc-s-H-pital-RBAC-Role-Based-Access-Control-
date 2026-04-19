# Contrôle d'accès Hôpital – RBAC (Role-Based Access Control)

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue)](https://docs.microsoft.com/en-us/powershell/)
[![Windows](https://img.shields.io/badge/Platform-Windows-0078D6)](https://www.microsoft.com/windows)
[![NTFS](https://img.shields.io/badge/Permissions-NTFS-green)](https://docs.microsoft.com/en-us/windows/win32/fileio/file-security-and-access-rights)
[![RBAC](https://img.shields.io/badge/Security-RBAC-purple)](https://docs.microsoft.com/en-us/windows/security/identity-protection/rbac/)

> **Projet de sécurisation des accès aux ressources informatiques d’un établissement hospitalier**  
> Mise en place d’un contrôle d’accès basé sur les rôles (**RBAC**) avec permissions **NTFS** et automatisation **PowerShell**.

---

## Table des matières

1. [Contexte & objectifs](#-contexte--objectifs)
2. [Architecture des dossiers](#-architecture-des-dossiers)
3. [Groupes & utilisateurs](#-groupes--utilisateurs)
4. [Matrice des permissions](#-matrice-des-permissions)
5. [Tests de sécurité](#-tests-de-sécurité)
6. [Scripts PowerShell](#-scripts-powershell)
7. [Captures d’écran](#-captures-décran)
8. [Structure du dépôt](#-structure-du-dépôt)
9. [Exécution](#-exécution)
10. [Équipe](#-équipe)

---

## Contexte & objectifs

| Objectif                  | Description                                                 |
|---------------------------|-------------------------------------------------------------|
| Établissement hospitalier | Chaque professionnel dispose d’un accès adapté à son métier |
| Confidentialité           | Protection stricte des données sensibles des patients       |
| Arborescence sécurisée    | Organisation logique des dossiers par métier                |
| Gestion RBAC              | Groupes de sécurité par profil (Role‑Based Access Control)  |
| Automatisation            | Déploiement reproductible via scripts PowerShell            |

---

## Architecture des dossiers

### Arborescence finale
D:\Hopital
│
├── Dossiers_Patients/ # Médecins uniquement
├── Soins/ # Médecins + Infirmiers
├── RH/ # RH uniquement
├── Finance/ # Comptables uniquement
├── Comptes_Rendus/ # Médecins + Direction
├── Communication/ # Communication uniquement
├── Outils_Systeme/ # IT uniquement
├── Direction/ # Direction uniquement
└── Public/ # Tous les profils



### Fichier de configuration JSON (`ressource.json`)

```json
{
  "base": "D:\\Hopital",
  "structure": {
    "Dossiers_Patients": {},
    "Soins": {},
    "RH": {},
    "Finance": {},
    "Comptes_Rendus": {},
    "Communication": {},
    "Outils_Systeme": {},
    "Direction": {},
    "Public": {}
  }
}
```

# Groupes & utilisateurs
Groupes de sécurité
| Groupes          | Rôle                |
|------------------|---------------------|
| G_Medecins       | Médecins            |
| G_Infirmiers     | Infirmiers          |
| G_Direction      | 	Direction          |
| G_Comptables     | Comptables          |
| G_RH             |Ressources Humaines  |
| G_Communication  | Communication       |
|G_IT              | Informatique        |


#Comptes utilisateurs

|Utilisateurs      | Groupe d’appartenance  |  Rôle               |
|------------------|------------------------|---------------------|
| medecin1	       | G_Medecins             | Médecins            |
| infirmier1		   | G_Infirmiers           | Infirmiers          |
| comptable1	     | G_Direction            | Direction           |
| rh1              | G_Comptables           | Comptables          |
| com1             | G_RH                   | Ressources Humaines |
| directeur1       | G_Communication        | Communication       |
| info1	           | G_IT                   | Informatique        |





# Matrice des permissions

| Dossier              | Accès autorisé	           |  Accès refusé             |
|----------------------|---------------------------|---------------------------|
| Dossiers_Patients		 | Médecins uniquement		   | Tous les autres           |
| Soins			           | Médecins + Infirmiers	   | Autres profil             |
| RH	                 | RH uniquement	           | Tous les autres           |
| Finance              | Comptables uniquement	   | Tous les autres           |
| Comptes_Rendus       | Médecins + Direction	     | Autres profils            |
| Communication			   | Communication uniquement	 | Tous les autres           |
| Outils_Systeme       | IT uniquement		         | Tous les autres           |
| Direction		         | Direction uniquement	     | Tous les autres           |
| Public			         | Tous les profils	         | Aucun                     |



#Tests de sécurité
Résultats des tests

| Test                          | Résultat     |
|-------------------------------|--------------|
| Médecin → Dossiers_Patients	  | AUTORISÉ     |
| Comptable → Finance	          | AUTORISÉ     |
| Infirmier → Outils_Systeme	  | BLOQUÉ       |
| IT → Outils_Systeme	          | AUTORISÉ     |
| Tous → Public	                | AUTORISÉ     |


#Restrictions outils système
Les outils suivants sont réservés au groupe G_IT (informatique) :
- PowerShell
-CMD (Invite de commandes)
-Panneau de configuration
-Éditeur du registre

#Scripts PowerShell

| Script                          | Fonction                                        |
|---------------------------------|-------------------------------------------------|
| 01_create_resources.ps1		      | Création de l’arborescence à partir du JSON     |
| 02_create_accounts.ps1		      | Création des groupes et comptes utilisateurs    |
| 03_apply_acl.ps1		            | Application des permissions NTFS                |
| 04_restrict_tools.ps1		        | Restriction des outils système (GP / Registre)  |
| 99_cleanup.ps1		              | Nettoyage complet (suppression réversible)      |


#Extrait (01_create_resources.ps1)
```
$jsonPath = ".\json\ressource.json"
$config = Get-Content $jsonPath | ConvertFrom-Json
$basePath = $config.base


foreach ($folder in $config.structure.PSObject.Properties.Name) {
    $path = Join-Path $basePath $folder
    New-Item -Path $path -ItemType Directory -Force
}
```

#Captures d’écran
Environnement de développement
https://screenshots/01-powershell-ise.png	
Édition du script dans PowerShell ISE

https://screenshots/02-uac-admin.png	
Exécution avec droits administrateur

https://screenshots/03-powershell-welcome.png	
Console PowerShell prête

https://screenshots/04-start-menu.png	
Accès rapide à PowerShell

https://screenshots/05-execution-scripts.png
Exécution des scripts


Résultats finaux:

https://screenshots/06-arborescence.png	
Dossiers créés dans D:\Hopital

https://screenshots/07-groupes-utilisateurs.png	
Groupes de sécurité et comptes

https://screenshots/08-permissions.png	
Vérification des droits NTFS

https://screenshots/09-test-acces.png	
Accès autorisé / bloqué



#Exécution
Prérequis
- Windows Server / Windows 10/11 (poste ou VM)
- PowerShell exécuté en Administrateur
- Politique d’exécution assouplie :
```
Set-ExecutionPolicy Unrestricted -Force
```

#Ordre d’exécution recommandé
```
# 1. Création de l’arborescence
.\scripts\01_create_resources.ps1

# 2. Création des groupes et utilisateurs
.\scripts\02_create_accounts.ps1

# 3. Application des permissions NTFS
.\scripts\03_apply_acl.ps1

# 4. Restriction des outils système
.\scripts\04_restrict_tools.ps1

# (Optionnel) Nettoyage complet
.\scripts\99_cleanup.ps1
```

#Équipe
|Personne      | Rôle                     |  Livrables                                 |
|--------------|--------------------------|--------------------------------------------|
| Syrine	     | Arborescence             | ressource.json + 01_create_resources.ps1   |
| Sherine		   | Groupes & utilisateurs   | Script de création des comptes             |
| Lina	       | Permissions NTFS         | 	Script d’application des ACL             |
| Mounia       | Sécurité & nettoyage     | Scripts de restriction et 99_cleanup.ps1   |

# Conclusion

| Objectif                      | Status       |
|-------------------------------|--------------|
| Arborescence sécurisée	      |      OK      |
| Groupes par rôle (RBAC)	      |      OK      |
| Permissions NTFS appliquées	  |      OK      |
| Tests de sécurité validés		  |      OK      |
| Documentation complète	      |      OK      |

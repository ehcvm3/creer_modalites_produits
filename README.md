## Objectif 🎯

Si le questionnaire EHCVM sous format Excel change, il est bon d'avoir des ingrédients pour mettre à jour les applications de collecte.

Ce projet crée des documents qui collecte les ingrédients.

Le script `creer_modalites_alimentaires.R` crée un document qui donnes les éléments à actualiser:

- Modalités. Pour les questions oui-non
- Rosters. Les éléments fixes et les conditions d'activations pour les deux rosters.
- Macros. Les conditions des macros qui sont utilisées dans les rosters.

Le script `creer_modalites_non-alimentaire.R` crée les modalités pour les produits non-alimentaires pour l'ensemble des sections 9.

## Installation 🔌

### Les pré-requis

- R
- RTools, si l'on utilise Windows comme système d'exploitation
- RStudio

<details>

<summary>
Ouvrir pour voir plus de détails 👁️
</summary>

#### R

- Suivre ce [lien](https://cran.r-project.org/)
- Cliquer sur votre système d'exploitation
- Cliquer sur `base`
- Télécharger and installer (e.g.,
  [this](https://cran.r-project.org/bin/windows/base/R-4.4.2-win.exe)
  pour le compte de Windows)

#### RTools

Nécessaire pour le système d'exploitation Windows

- Suivre ce [lien](https://cran.r-project.org/)
- Cliquer sur `Windows`
- Cliquer sur `RTools`
- Télécharger
  (e.g.,[this](https://cran.r-project.org/bin/windows/Rtools/rtools44/files/rtools44-6335-6327.exe) pour une architecture
  64bit)
- Installer dans le lieu de défaut suggéré par le programme d'installation (e.g., `C:\rtools4'`)

Ce programme permet à R de compiler des scripts écrit en C++ et utilisé par certains packages pour être plus performant (e.g., `{dplyr}`).

#### RStudio

- Suivre ce [lien](https://posit.co/download/rstudio-desktop/)
- Cliquer sur le bouton `DOWNLOAD RSTUDIO`
- Sélectionner le bon fichier d'installation selon votre système d'exploitation
- Télécharger et installer (e.g.,
  [this](https://download1.rstudio.org/electron/windows/RStudio-2024.09.1-394.exe)
  pour le compte de Windows)

RStudio est sollicité pour deux raisons :

1. Il fournit une bonne interface pour utiliser R
2. Il est accompagné par [Quarto](https://quarto.org/), un programme dont nous nous serviront pour créer certains documents.

</details>

### Le programme

- Si vous n'avez pas Git, 
  - Cliquer sur le bouton `Code`
  - Sélectionner `Download ZIP` depuis la liste déroulante
  - Décomprimer dans / vers le dossier voulu
- Si vous avez Git, suivre les instructions [ici](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository).

## Configuration ⚙️

Le programme a besoin du questionnaire EHCVM actualisé et adapté au contexte pays dans le répertoire `01_entree/`

## Emploi 👩‍💻

Après avoir installé les pré-requis et mis en places les entrées attendues, il suffit de lancer le programme en R. En particulier :

- Ouvrir le RStudio
- Ouvrir le répertoire comme un projet (ou bien double-cliquer sur le fichier `creer_tableau_excel.Rproj`)
- Ouvrir un programme pour creer des modalités et d'autres informations pour actualiser l'application (i.e, `creer_modalites_alimentaires.R`, `creer_modalites_non-alimentaires.R`)
- Cliquer sur le bouton `Source` chez RStudio pour lancer le programme
- Réagir aux messages d'erreur, au besoin (e.g., questionnaire Excel absent, onglets attendus introuvables, etc.).
- Récupérer la sortie, un fichier HTML, dans le répertoire `02_sortie/`

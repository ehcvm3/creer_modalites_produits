# ==============================================================================
# installer les packages requis
# ==============================================================================

# installer `{here}` si le package est absent
if (!base::require("here", quietly = TRUE)) {
  install.packages("here")
}
source(here::here("R", "01_install_requirements.R"))

# ==============================================================================
# confirmer les entrées
# ==============================================================================

# construire le chemin vers le questionnaire
chemin_qnr_excel <- fs::dir_ls(
  path = fs::path(here::here(), "01_entree", "01_menage"),
  type = "file",
  regexp = "(\\.xlsx|\\.xls|\\.xlsm)$"
)

# ------------------------------------------------------------------------------
# fichier existe
# ------------------------------------------------------------------------------

if (length(chemin_qnr_excel) == 0) {

  cli::cli_abort(
    message = c(
      "x" = "Aucun questionnaire EHCVM3 retrouvé.",
      "i" = "Le programme attend un questionnaire Excel avec extension `.xlsx` dans le répertoire `01_entree/01_menage/`",
      "i" = "Veuillez copier un exemplaire adapté du questionnaire dans ce dossier."
    )
  )

} else if (length(chemin_qnr_excel) > 1) {

  cli::cli_abort(
    message = c(
      "x" = "Plusieurs questionnaires EHCVM3 retrouvés.",
      "i" = "Veuillez supprimer les questionnaires exédentaires dans le répertoire `01_entree/01_menage/`",
      chemin_qnr_excel
    )
  )

}

# ------------------------------------------------------------------------------
# onglets cibles existent
# ------------------------------------------------------------------------------

onglets_cibles <- c(
  "S9a__Conso_NA",
  "S9b__Conso_NA",
  "S9c__Conso_NA",
  "S9d___Conso_NA",
  "S9e__Conso_NA",
  "S9f__Conso_NA"
)
onglets <- readxl::excel_sheets(path = chemin_qnr_excel)

if (any(!onglets_cibles %in% onglets)) {

  onglets_retrouves <- onglets_cibles[onglets_cibles %in% onglets]
  onglets_absents <- onglets_cibles[!onglets_cibles %in% onglets]

  cli::cli_abort(
    message = c(
      "x" = "Au moins un onglet attendu n'existe pas dans le questionnaire.",
      "i" = paste0(
        "Onglet(s) absent(s) : ",
        glue::glue_collapse(onglets_absents, sep = ", ", last = "et ")
      ),
      "i" = paste0(
        "Onglets retrouvés : ",
        glue::glue_collapse(onglets_retrouves, sep = ", ", last = " et ")
      )
    )
  )

}

# ==============================================================================
# générer un document qui affiche ces modalites
# ==============================================================================

# construire le chemin du document
chemin_document <- here::here("02_sortie", "produits_non-alimentaires.html")

# purger l'ancien document, s'il existe
tryCatch(
  error = function(cnd) {
    cat("Le document qui compile les codes de produit n'existe pas encore.")
  },
  fs::file_delete(chemin_document)
)

# créer le document
quarto::quarto_render(
  input = fs::path(here::here(), "inst", "produits_non-alimentaires.qmd")
)

# déplacer le document vers le dossier de sortie
fs::file_move(
  path = fs::path(
    here::here(), "inst",
    "produits_non-alimentaires.html"
  ),
  new_path = chemin_document
)

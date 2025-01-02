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
  path = fs::path(here::here(), "01_entree", "02_nsu"),
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
      "i" = "Le programme attend un questionnaire Excel avec extension `.xlsx` dans le répertoire `01_entree/02_nsu/`",
      "i" = "Veuillez copier un exemplaire adapté du questionnaire dans ce dossier."
    )
  )

} else if (length(chemin_qnr_excel) > 1) {

  cli::cli_abort(
    message = c(
      "x" = "Plusieurs questionnaires EHCVM3 retrouvés.",
      "i" = "Veuillez supprimer les questionnaires exédentaires dans le répertoire `01_entree/02_nsu/`",
      chemin_qnr_excel
    )
  )

}

# ------------------------------------------------------------------------------
# onglets cibles existent
# ------------------------------------------------------------------------------

onglets_cibles <- c("S1_Relevés")
onglets <- readxl::excel_sheets(path = chemin_qnr_excel)

if (!onglets_cibles %in% onglets) {

  cli::cli_abort(
    message = c(
      "x" = glue::glue(
        "L'onglet des relevés de prix et de poids n'a pas été retrouvé :
        {onglets_cibles}"
      ),
      "i" = paste0(
        "Onglets retrouvés : ",
        glue::glue_collapse(onglets, sep = ", ", last = " et ")
      )
    )
  )

}


# ==============================================================================
# générer un document qui affiche ces modalites
# ==============================================================================

# construire le chemin du document
chemin_document <- here::here("02_sortie", "produits_nsu.html")

# purger l'ancien document, s'il existe 
tryCatch(
  error = function(cnd) {
    cat("Le document qui compile les codes de produit n'existe pas encore.")
  },
  fs::file_delete(chemin_document)
)

# créer le document
quarto::quarto_render(
  input = fs::path(here::here(), "inst", "produits_nsu.qmd")
)

# déplacer le document vers le dossier de sortie
fs::file_move(
  path = fs::path(
    here::here(), "inst",
    "produits_nsu.html"
  ),
  new_path = chemin_document
)

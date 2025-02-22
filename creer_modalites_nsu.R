# ==============================================================================
# installer les packages requis
# ==============================================================================

# ------------------------------------------------------------------------------
# confirmer que RTools est installé
# ------------------------------------------------------------------------------

if (!base::require("pkgbuild", quietly = TRUE)) {
  install.packages("pkgbuild")
}

if (pkgbuild::has_build_tools() == FALSE) {

  url_rtools <- "https://github.com/ehcvm3/creer_tableau_produit_unite_taille?tab=readme-ov-file#rtools"

  cli::cli_abort(
    message = c(
      "x" = "RTools est introuvable. Veuillez l'installer.",
      "i" = "Sur Windows, R a besoin d'un outil pour compiler le code source.",
      "i" = paste0(
        "Veuillez suivre les instructions ici pour installer RTools : ",
        "{.url {url_rtools}}"
      )
    )
  )

}

# ------------------------------------------------------------------------------
# installer les packages nécessaires
# ------------------------------------------------------------------------------

# installer `{here}` si le package est absent
if (!base::require("here", quietly = TRUE)) {
  install.packages("here")
}
source(here::here("R", "01_install_requirements.R"))

# ------------------------------------------------------------------------------
# confirmer que Quarto est installé
# ------------------------------------------------------------------------------

if (is.null(quarto::quarto_path())) {

  url_quarto <- "https://quarto.org/docs/get-started/"

  cli::cli_abort(
    message = c(
      "x" = "Quarto est introuvable. Veuillez l'installer.",
      "i" = "Pour créer sa sortie, le programme a besoin de Quarto.",
      "i" = "Pour l'installer, suivre les instructions ici : ",
      "{.url {url_quarto}}"
    )
  )

}

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

# ------------------------------------------------------------------------------
# ligne qui démarque le les données identifiable
# ------------------------------------------------------------------------------

fichier_df <- chemin_qnr_excel |>
  readxl::read_excel(
    sheet = "S1_Relevés",
    col_names = FALSE
  ) |>
  dplyr::rename(
    produit_nom = 1,
    produit_code = 2,
  )

header_row <- which(excel_df$produit_nom ==  "Libellé")[1]

if (is.na(header_row) | is.null(header_row)) {

  cli::cli_abort(
    message = c(
      "x" = "Impossible de retrouver la dernière ligne avant les données.",
      "i" = paste0(
        "Le programme s'attend à retrouver 'Libellé' dans la 1ière colonne. ",
        "Cette ligne est censée intervenir juste avant les données."
      )
    )
  )

}

# ------------------------------------------------------------------------------
# groupes de produits présents
# ------------------------------------------------------------------------------

groupes_df <- fichier_df |>
	dplyr::filter(dplyr::row_number() >= header_row + 1) |>
	dplyr::filter(!is.na(produit_nom) & is.na(produit_code))

if (nrow(groupes_df) == 0) {

  cli::cli_abort(
    message = c(
      "x" = "Impossible de retrouver les groupes de produit.",
      "i" = paste0(
        "Le programme s'attend à ce que les groupes de produit interviennent ",
        "dans la première colonne, sans code de produit."
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

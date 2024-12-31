#' Get product codes for EHCVM3 food group
#'
#' @param product_df Data frame. Data gleaned from EHCVM3 Excel questionnaire.
#' @param food_group Character. Food group name.
#'
#' @importFrom dplyr filter pull
get_products_for_food_group <- function(
  product_df,
  food_group
) {

  prods_ehcvm3 <- product_df |>
    dplyr::filter(type_produit == food_group) |>
    dplyr::pull(produit_code)

}

#' Créer les modalités à copier dans Designer
#'
#' @param produit_df Data frame du contenu du questionnaire Excel.
#' @param produits_code Character. Vecteur des codes à inclure
#'
#' @importFrom dplyr filter mutate pull
#' @importFrom glue glue glue_collapse
creer_modalites_a_copier <- function(
  produits_df,
  produits_codes
) {

  ehcvm3_modalites <- produits_df |>
    dplyr::filter(produit_code %in% produits_codes) |>
    dplyr::mutate(modalites = glue::glue("{produit_nom}...{produit_code}")) |>
    dplyr::pull(modalites) |>
    glue::glue_collapse(sep = "\n")

  return(ehcvm3_modalites)

}
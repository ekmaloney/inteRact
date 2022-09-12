#' Reshape New Equation
#'
#' @param eq_df a data frame containing the user-supplied equation. Should follow
#' the same structure as those found in Interact.jar (10 columns, the first of which
#' should have the Z plus 9 1s or 0s indicating the elements of the corresponding
#' coefficient structure).
#'
#' @return eq_coef_info dataframe that is in the correct form for use in other functions
#' @export
#'
#' @examples
reshape_new_equation <- function(eq_df){

  # data("all_combinations", envir=environment())
  all_combos <- unique(c(inteRact::all_combinations$combos, eq_df$V1))

  decoding_coefficients <- tibble(coef_name = all_combos) %>%
                          dplyr::mutate(combos = stringr::str_remove(.data$coef_name, "Z")) %>%
    tidyr::separate(.data$combos, sep = c(3, 6), into = c("A", "B", "O")) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(AE = if_else(.data$A == "100", 1, 0),
                                 AP = if_else(.data$A == "010", 1, 0),
                                 AA = if_else(.data$A == "001", 1, 0),
                                 BE = if_else(.data$B == "100", 1, 0),
                                 BP = if_else(.data$B == "010", 1, 0),
                                 BA = if_else(.data$B == "001", 1, 0),
                                 OE = if_else(.data$O == "100", 1, 0),
                                 OP = if_else(.data$O == "010", 1, 0),
                                 OA = if_else(.data$O == "001", 1, 0))

  eq_df <- tibble::tibble(coef_name = eq_df$V1,
                 postAE = eq_df$V2,
                 postAP = eq_df$V3,
                 postAA = eq_df$V4,
                 postBE = eq_df$V5,
                 postBP = eq_df$V6,
                 postBA = eq_df$V7,
                 postOE = eq_df$V8,
                 postOP = eq_df$V9,
                 postOA = eq_df$V10)

    eq_coef_info <- dplyr::left_join(eq_df, inteRact::impression_coefficients, by = c("coef_name"))

    return(eq_coef_info)
}


reshape_emotion_equation <- function(eq) {
  eq <- tibble::tibble(coef_name = eq$V1,
               postME = eq$V2,
               postMP = eq$V3,
               postMA = eq$V4)

  eq_coef_info <- dplyr::full_join(eq, inteRact::emotions_coefficients, by = c("coef_name"))

  eq_coef_info[is.na(eq_coef_info)] <- 0

  eq_coef_info <- eq_coef_info %>%
    dplyr::mutate(terms_involved = .data$ME + .data$MP + .data$MA + .data$IE + .data$IP + .data$IA,
                         interaction_term = dplyr::if_else(.data$terms_involved > 1, 1, 0),
                         E_interaction = dplyr::if_else(.data$interaction_term == 1 & .data$IE == 1, 1, 0),
                         P_interaction = dplyr::if_else(.data$interaction_term == 1 & .data$IP == 1, 1, 0),
                         A_interaction = dplyr::if_else(.data$interaction_term == 1 & .data$IA == 1, 1, 0)) %>%
                  dplyr::select(-.data$terms_involved, .data$interaction_term)

  return(eq_coef_info)
}

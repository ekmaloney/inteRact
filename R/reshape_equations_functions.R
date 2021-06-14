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

  co_combos <- readRDS("data/coefficient_combos.RDS")
  all_combos <- unique(c(co_combos, eq_df$V1))

  decoding_coefficients <- tibble(coef_name = all_combos) %>%
                          mutate(combos = str_remove(coef_name, "Z")) %>%
                          separate(combos, sep = c(3, 6), into = c("A", "B", "O")) %>%
                          rowwise() %>%
                          mutate(AE = if_else(A == "100", 1, 0),
                                 AP = if_else(A == "010", 1, 0),
                                 AA = if_else(A == "001", 1, 0),
                                 BE = if_else(B == "100", 1, 0),
                                 BP = if_else(B == "010", 1, 0),
                                 BA = if_else(B == "001", 1, 0),
                                 OE = if_else(O == "100", 1, 0),
                                 OP = if_else(O == "010", 1, 0),
                                 OA = if_else(O == "001", 1, 0))

  eq_df <- tibble(coef_name = eq_df$V1,
                 postAE = eq_df$V2,
                 postAP = eq_df$V3,
                 postAA = eq_df$V4,
                 postBE = eq_df$V5,
                 postBP = eq_df$V6,
                 postBA = eq_df$V7,
                 postOE = eq_df$V8,
                 postOP = eq_df$V9,
                 postOA = eq_df$V10)

    eq_coef_info <- left_join(eq_df, decoding_coefficients, by = c("coef_name"))

    return(eq_coef_info)
  }

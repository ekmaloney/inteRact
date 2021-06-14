#' Batch Element Deflection
#'
#' @param df a dataframe that must have three columns named: actor, behavior, and object
#' that correspond to the elements of your event. These must match with identities and behaviors
#' in the US 2015 dictionary.
#' @param equation which equation to use - you can either set it to "us" for the
#' us 1978 equations, or "user supplied")
#' @param eq_df if you select "user supplied" for equation, this parameter should
#' be your equation dataframe, which (should have been reshaped by the
#' reshape_new_equation function prior)
#'
#' @return a dataframe in long format with a variable indicating the amount of deflection produced by each
#' element
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr rowwise
#' @importFrom dplyr %>%
#' @importFrom tidyr unnest
#'
#' @export


batch_element_deflection <- function(df, equation = c("us", "user supplied"), eq_df) {
                      df_res <- df %>%
                        rowwise() %>%
                        mutate(el_def = list(element_deflection(actor, behavior, object, equation, eq_df))) %>%
                        unnest(el_def)

                      return(df_res)
                  }

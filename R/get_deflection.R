#' Compute Deflection for an Event
#'
#' This function calculates the deflection for ABO events contained in a dataframe
#' corresponding to the inteRact event data structure.
#'
#' @param d inteRact-style events dataframe
#' @param dictionary_key a string corresponding to the dictionary from actdata you are using for cultural EPA measurements
#' @param gender either average, male, or female, depending on if you are using gendered equations
#' @param equation_key a string corresponding to the equation key from actdata
#' @param eq_df if you use your own equation, this parameter should
#' be your equation dataframe, which (should have been reshaped by the
#' reshape_new_equation function prior)
#' @return calculated deflection for the event (single number)
#'
#'
#' @export
#'
#' @examples
#' d <- tibble::tibble(actor = "ceo", behavior = "advise", object = "benefactor")
#' d <- reshape_events_df(df = d, df_format = "wide", dictionary_key = "usfullsurveyor2015", dictionary_gender = "average")
#' get_deflection(d = d, equation_key = "us2010", equation_gender= "average")

get_deflection <- function(d,
                           equation_key = NULL,
                           equation_gender = NULL,
                           eq_df = NULL,
                           ...) {

        #calculate the transient impression
        t_imp <- transient_impression(d = d,
                                      equation_key = equation_key,
                                      equation_gender = equation_gender,
                                      eq_df = eq_df)

        #get element deflection by applying the transient impression function
        total_deflection <- t_imp %>%
                      dplyr::mutate(difference = estimate - trans_imp,
                                    sqd_diff = difference^2) %>%
                      dplyr::summarise(deflection = sum(sqd_diff))


        return(total_deflection %>% ungroup() %>% dplyr::pull(deflection))

}

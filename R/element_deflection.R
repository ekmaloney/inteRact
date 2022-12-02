#' Compute Element Deflection for an Event
#'
#' This function calculates the element-wise/decomposed deflection for an Actor,
#' Behavior, Object event.
#'
#' @param d data that has been reshaped by the events_df
#' @param equation_key is a string that corresponds to an equation key from actdata
#' from actdata
#' @param equation_gender is a string that corresponds to the gender for the equation
#' @param eq_df is an optional parameter if you are using your own equation dataframe
#' @return dataframe in long format, with one row for each element-dimension of
#' the event, columns for fundamental sentiment and transient impression, the
#' difference between the fundamental sentiment and the transient impression
#' (difference) and the squared difference, the element's contribution to
#' deflection.
#'
#' @export
#'
#' @examples
#'
#' d <- tibble::tibble(actor = "ceo", behavior = "advise", object = "benefactor")
#' d <- reshape_events_df(df = d, df_format = "wide",
#' dictionary_key = "usfullsurveyor2015", dictionary_gender = "average")
#' element_deflection(d = d, equation_key = "us2010", equation_gender = "average")


#provides deflection
element_deflection <- function(d,
                               equation_key= NULL,
                               equation_gender= NULL,
                               eq_df = NULL, ...) {

          #get element deflection by applying the transient impression function
          element_deflection <- transient_impression(d = d,
                                                     equation_key = equation_key,
                                                     equation_gender = equation_gender) %>%
                                dplyr::mutate(difference = trans_imp - estimate,
                                       sqd_diff = difference^2) %>%
                                dplyr::ungroup()

            return(element_deflection)
}

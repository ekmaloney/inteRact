#' Compute Element Deflection for an Event
#'
#' This function calculates the deflection for an Actor, Behavior, Object event.
#' It assumes that the first input is an identity corresponding to the actor,
#' the second, the behavior, and last, the object. Each of these terms must be
#' in the US 2015 dictionary.
#'
#' @param df data that has been reshaped by the events_df
#' @param equation_info is a string that corresponds to "{equationkey}_{gender}"
#' from actdata
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
#' element_deflection(df = d, equation_info = "us2010_average")


#provides deflection
element_deflection <- function(df, equation_info) {

          #get element deflection by applying the transient impression function
          element_deflection <- transient_impression(df, equation_info) %>%
            dplyr::mutate(difference = trans_imp - estimate,
                   sqd_diff = difference^2) %>%
            dplyr::ungroup()

            return(element_deflection)
}

#' Compute Element Deflection for an Event
#'
#' This function calculates the deflection for an Actor, Behavior, Object event.
#' It assumes that the first input is an identity corresponding to the actor,
#' the second, the behavior, and last, the object. Each of these terms must be
#' in the US 2015 dictionary.
#'
#' @param act lowercase string corresponding to the actor identity
#' @param beh lowercase string corresponding to the behavior term
#' @param obj lowercase string corresponding to the object identity
#' @param dictionary_key a string corresponding to the dictionary from actdata you are using for cultural EPA measurements
#' @param gender either average, male, or female, depending on if you are using gendered equations
#' @param equation_key a string corresponding to the equation key from actdata
#' @param eq_df if you select "user supplied" for equation, this parameter should
#' be your equation dataframe, which (should have been reshaped by the
#' reshape_new_equation function prior)
#' @return the deflection produced by each element of the event, a 9 x 1 matrix
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr rowwise
#' @importFrom dplyr %>%
#'
#' @export
#'
#' @examples
#'
#' element_deflection(act = "ceo", beh = "advise", obj = "benefactor", dictionary_key = "usfullsurveyor2015",
#' gender = "average", equation_key = "us2010")


#provides deflection
element_deflection <- function(act,
                               beh,
                               obj,
                               dictionary_key,
                               gender,
                               equation_key,
                               eq_df = NULL) {

          #get element deflection by applying the transient impression function
          element_deflection <- transient_impression(act,
                                                     beh,
                                                     obj,
                                                     dictionary_key,
                                                     gender,
                                                     equation_key,
                                                     eq_df) %>%
            rowwise() %>%
            mutate(difference = fundamental_sentiment - trans_imp,
                   sqd_diff = difference^2) %>%
            ungroup()

            return(element_deflection)
}

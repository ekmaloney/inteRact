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
#' @param dictionary which dictionary to use, currently set to "us"
#' @param equation which equation to use - you can either set it to "us" for the
#' us 1978 equations, or "user supplied")
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
#' element_deflection("ceo", "advise", "benefactor", equation = "us")


#provides deflection
element_deflection <- function(act, beh, obj, dictionary = "us", equation = c("us", "user supplied"),
                               eq_df = NULL) {

          #get element deflection by applying the transient impression function
          element_deflection <- transient_impression(act, beh, obj, dictionary = "us",
                                                     equation = equation, eq_df = eq_df) %>%
            rowwise() %>%
            mutate(difference = fundamental_sentiment - trans_imp,
                   sqd_diff = difference^2) %>%
            ungroup()

            return(element_deflection)
}

#' Compute Deflection for an Event
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
#' @return calculated deflection for the event (single number)
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr rowwise
#' @importFrom dplyr %>%
#' @importFrom dplyr ungroup
#' @importFrom dplyr summarise
#'
#' @export
#'
#' @examples
#'
#' get_deflection("ceo", "advise", "benefactor", equation = "us")



#provides deflection
get_deflection <- function(act, beh, obj, dictionary = "us", equation = c("us", "user supplied"), eq_df = NULL) {

        #get element deflection by applying the transient impression function
        element_deflection <- transient_impression(act, beh, obj, dictionary = "us", equation, eq_df) %>%
                              rowwise() %>%
                              mutate(difference = fundamental_sentiment - trans_imp,
                              sqd_diff = difference^2)

        #add together to get total deflection
        total_deflection <- element_deflection %>%
                            ungroup() %>%
                            summarise(d = sum(sqd_diff))

        return(total_deflection)

}

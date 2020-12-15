#' Batch Deflection
#'
#' @param df a dataframe that must have three columns named: actor, behavior, and object
#' that correspond to the elements of your event. These must match with identities and behaviors
#' in the US 2015 dictionary.
#'
#' @return a dataframe with a column indicating the total deflection for the event
#' @importFrom dplyr mutate
#' @importFrom dplyr rowwise
#' @importFrom dplyr %>%

#' @export


batch_deflection <- function(df) {
  df_res <- df %>%
            rowwise() %>%
            mutate(deflection = calc_deflection(actor, behavior, object),
                   deflection = deflection$d)

  return(df_res)
}



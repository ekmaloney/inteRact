#' Batch Deflection
#'
#' @param df a dataframe that must have three columns named: actor, behavior, and object
#' that correspond to the elements of your event. These must match with identities and behaviors
#' in the US 2015 dictionary.
#'
#' @return a dataframe with a column indicating the total deflection for the event
#' @export
#'
#' @examples
#'
#' test_df <- tibble(actor = sample(us_2015_full$term[us_2015_full$type == "identity"], 10),
#' behavior = sample(us_2015_full$term[us_2015_full$type == "behavior"], 10),
#' object = sample(us_2015_full$term[us_2015_full$type == "identity"], 10))
#'
#' batch_deflection(test_df)


batch_deflection <- function(df) {
  df_res <- df %>%
            rowwise() %>%
            mutate(deflection = calc_deflection(actor, behavior, object))

  return(df_res)
}



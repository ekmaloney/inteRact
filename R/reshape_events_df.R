#' Reshape Events DF
#'
#' @param df dataframe of events
#' @param df_format whether your events dataframe is wide (a column for actor, behavior, and object)
#' or long (multiple rows for each event)
#' @param id_column if your df is in long format, you must supply the column that identifies the individual event
#' @param dictionary_key the actdata dictionary key you are using for your analysis
#' @param dictionary_gender the gender EPA ratings you are using for your analysis. Should be male, female, or average
#'
#' @return
#' @export
#'
#' @examples
#'
#' d <- tibble::tibble(actor = "ceo", behavior = "advise", object = "benefactor")
#' reshape_events_df(df = d, df_format = "wide", dictionary_key = "usfullsurveyor2015", dictionary_gender = "average")
reshape_events_df <- function(df,
                              df_format = c("wide", "long"),
                              id_column = NULL,
                              dictionary_key,
                              dictionary_gender = c("male", "female", "average")){


  #first, get the dictionary
  dictionary <- actdata::epa_subset(dataset = dictionary_key,
                           gender = dictionary_gender) %>%
                dplyr::select(term, component, E, P, A)

  #next, do different things if wide or short
  if(df_format == "wide"){

    df_long <- df %>%
              dplyr::mutate(event_id = dplyr::row_number()) %>%
              tidyr::pivot_longer(actor:object,
                           names_to = "element",
                           values_to = "term") %>%
              dplyr::mutate(component = dplyr::if_else(element == "behavior",
                                                "behavior", "identity")) %>%
              dplyr::left_join(dictionary) %>%
              tidyr::pivot_longer(E:A,
                                  names_to = "dimension",
                                  values_to = "estimate")

  }else{
    df_long <- df %>%
               dplyr::mutate(component = dplyr::if_else(element == "behavior",
                                                         "behavior", "identity"),
                             event_id = get(id_column)) %>%
               dplyr::left_join(dictionary) %>%
               dplyr::select(-all_of(id_column)) %>%
      tidyr::pivot_longer(E:A,
                          names_to = "dimension",
                          values_to = "estimate")
  }

  return(df_long)

}

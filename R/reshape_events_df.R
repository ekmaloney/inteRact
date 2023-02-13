#' Reshape Events DF
#'
#' @param df dataframe of events
#' @param df_format whether your events dataframe is wide (a column for actor, behavior, and object)
#' or long (multiple rows for each event)
#' @param id_column if your df is in long format, you must supply the column that identifies the individual event
#' @param dictionary_key the actdata dictionary key you are using for your analysis
#' @param dictionary_gender the gender EPA ratings you are using for your analysis. Should be male, female, or average
#'
#' @return a dataframe in the format necessary for applying main ACT functions to the events:
#' @export
#'
#' @examples
#'
#' d <- tibble::tibble(actor = "ceo", behavior = "advise", object = "benefactor")
#' reshape_events_df(df = d, df_format = "wide", dictionary_key = "usfullsurveyor2015", dictionary_gender = "all")
reshape_events_df <- function(df,
                              df_format = c("wide", "long"),
                              id_column = NULL,
                              dictionary_key,
                              dictionary_gender = c("male", "female", "all")){


  #first, get the dictionary
  dictionary <- actdata::epa_subset(dataset = dictionary_key)
  if("group" %in% names(dictionary)){
    dictionary <- dictionary %>%
                  dplyr::filter(group == dictionary_gender) %>%
                  dplyr::select(term, component, E, P, A)
  }else{
    dictionary <- dictionary %>%
                  dplyr::select(term, component, E, P, A)
      }


  #next, do different things if wide or short
  if(df_format == "wide"){


    all_var_names <- stats::variable.names(df)

    df_long <- df %>%
              dplyr::mutate(event_id = dplyr::row_number()) %>%
              tidyr::pivot_longer(all_var_names,
                           names_to = "element",
                           values_to = "term") %>%
              dplyr::mutate(component =
                              dplyr::case_when(element == "behavior" ~"behavior",
                              element == "actor" | element == "object" ~ "identity",
                              stringr::str_detect(element, "modifier") ~ "modifier")) %>%
      dplyr::group_by(event_id) %>%
      dplyr::mutate(event = paste(term, collapse = " ")) %>%
              dplyr::left_join(dictionary) %>%
              tidyr::pivot_longer(E:A,
                                  names_to = "dimension",
                                  values_to = "estimate")

  }else{
    df_long <- df %>%
               dplyr::mutate(component = dplyr::case_when(element == "behavior" ~"behavior",
                                                          element == "actor" | element == "object" ~ "identity",
                                                          stringr::str_detect(element, "modifier") ~ "modifier"),
                             event_id = get(id_column)) %>%
               dplyr::group_by(event_id) %>%
               dplyr::mutate(event = paste(term, collapse = " ")) %>%
               dplyr::left_join(dictionary) %>%
               dplyr::select(-dplyr::all_of(id_column)) %>%
      tidyr::pivot_longer(E:A,
                          names_to = "dimension",
                          values_to = "estimate")
  }


  df_long <- df_long %>% filter(!is.na(term))

  return(df_long)

}

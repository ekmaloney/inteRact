#' Batch Characteristic Emotion
#'
#' @param df dataframe with a variable called term that corresponds to identities you want characteristic emotions for
#' @param var the name of the variable containing your identities
#'
#' @return df with 3 new variables: characteristic emotion E, P, and A
#' @importFrom dplyr %>%
#' @export
#'
#' @examples
batch_characteristic_emotion <- function(df, var){
      d <- tibble(term = get(var, df)) %>%
            mutate(id = row_number()) %>%
            rowwise() %>%
            dplyr::mutate(char_e = list(characteristic_emotion(term))) %>%
            unnest(col = char_e) %>%
            dplyr::ungroup() %>%
            dplyr::mutate(dimension = rep(c("E", "P", "A"), length(unique(term)))) %>%
            tidyr::pivot_wider(names_from = dimension, values_from = char_e) %>%
            select(-id)

      return(d)
}

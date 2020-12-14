#' Batch Characteristic Emotion
#'
#' @param df dataframe with a variable called term that corresponds to identities you want characteristic emotions for
#'
#' @return df with 3 new variables: characteristic emotion E, P, and A
#' @importFrom dplyr %>%
#' @export
#'
#' @examples
batch_characteristic_emotion <- function(df){
      df <- df %>%
            dplyr::rowwise() %>%
            dplyr::mutate(char_e = characteristic_emotion(term),
                   char_e_E = char_e$E,
                   char_e_P = char_e$P,
                   char_e_A = char_e$A) %>%
            dplyr::select(term, E, P, A, type, country, year, char_e_E, char_e_P, char_e_A)

      return(df)
}

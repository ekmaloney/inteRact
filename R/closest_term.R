#' Closest Term
#'
#' A function to find the closest measured identity, behavior, or modifier to a specified E, P, A location.
#'
#' @param e a numeric variable equaling the Evaluation of the EPA location
#' @param p a numeric variable equaling the Potency of the EPA location
#' @param a a numeric variable equaling the Activity of the EPA location
#' @param dictionary_key a string corresponding to the dictionary from actdata you are using for cultural EPA measurements
#' @param gender either average, male, or female, depending on if you are using gendered equations
#' @param term_typ a string indicating whether you are looking for an identity, behavior, or modifier
#' @param max_dist a numeric variable equaling the maximum distance a term can be away from your EPA location
#'
#' @return a dataframe listing terms matching your search. Includes variables indicating element-wise distance and sum of squared differences.
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr rowwise
#' @importFrom dplyr %>%
#' @importFrom dplyr slice
#' @importFrom dplyr filter
#' @importFrom dplyr arrange
#' @importFrom dplyr ungroup
#' @export
#'
#' @examples
#' closest_term(1, 2.5, 3, dictionary_key = "usfullsurveyor2015", gender = "average", term_typ = "identity")

closest_term <- function(e, p, a,
                         dictionary_key,
                         gender,
                         term_typ = c("identity", "behavior", "modifier"),
                         max_dist = 1,
                         num_terms = 10) {

      #get dictionaries
      d <- actdata::epa_subset(dataset = dictionary_key, gender = gender, component = term_typ)

    terms <- d %>%
      dplyr::rowwise() %>%
      dplyr::mutate(d_e = .data$E - e,
                    d_p = .data$P - p,
                    d_a = .data$A - a,
                    d_e_s = (.data$d_e)^2,
                    d_p_s = (.data$d_p)^2,
                    d_a_s = (.data$d_a)^2,
                    ssd = sum(.data$d_e_s, .data$d_p_s, .data$d_a_s)) %>%
      dplyr::ungroup() %>%
      dplyr::filter(.data$ssd < max_dist) %>%
      dplyr::arrange(.data$ssd) %>%
      dplyr::mutate(term_name = .data$term,
                     term_E = .data$E,
                     term_P = .data$P,
                     term_A = .data$A) %>%
      dplyr::slice(1:num_terms) %>%
      dplyr::select(.data$term_name, .data$term_E, .data$term_P, .data$term_A, .data$ssd)

    if(nrow(terms) == 0){
      terms <- tibble::tibble(term_name = "No terms within max distance",
                      term_E = NA,
                      term_P = NA,
                      term_A = NA,
                      ssd = NA)
    }

    return(terms)
}


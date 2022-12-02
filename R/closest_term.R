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
#' closest_term(1, 2.5, 3, dictionary_key = "usfullsurveyor2015", dictionary_gender = "average", term_typ = "identity")

closest_term <- function(e, p, a,
                         dictionary_key,
                         dictionary_gender,
                         term_typ = c("identity", "behavior", "modifier"),
                         max_dist = 1,
                         num_terms = 10) {

  if(is.null(e) | is.null(p) | is.null(a)){
    stop("Must provide either an id_info dataframe from reshape_events_df or E, P, and A values")
  }else if(!is.numeric(e) | !is.numeric(p) | !is.numeric(a)){
    stop("E, P, and A must be numeric")
  }else{
    #get dictionaries
    d <- actdata::epa_subset(dataset = dictionary_key, gender = dictionary_gender, component = term_typ)

    terms <- d %>%
      dplyr::rowwise() %>%
      dplyr::mutate(d_e = E - e,
                    d_p = P - p,
                    d_a = A - a,
                    d_e_s = (d_e)^2,
                    d_p_s = (d_p)^2,
                    d_a_s = (d_a)^2,
                    ssd = sum(d_e_s, d_p_s, d_a_s)) %>%
      dplyr::ungroup() %>%
      dplyr::filter(ssd < max_dist) %>%
      dplyr::arrange(ssd) %>%
      dplyr::mutate(term_name = term,
                    term_E = E,
                    term_P = P,
                    term_A = A) %>%
      dplyr::slice(1:num_terms) %>%
      dplyr::select(term_name, term_E, term_P, term_A, ssd)

    if(nrow(terms) == 0){
      terms <- tibble::tibble(term_name = "No terms within max distance",
                              term_E = NA,
                              term_P = NA,
                              term_A = NA,
                              ssd = NA)
    }
  }

    return(terms)
}


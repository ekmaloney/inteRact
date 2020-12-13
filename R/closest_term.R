#' Closest Term
#'
#' A function to find the closest measured identity, behavior, or modifier to a specified E, P, A location.
#'
#' @param e a numeric variable equaling the Evaluation of the EPA location
#' @param p a numeric variable equaling the Potency of the EPA location
#' @param a a numeric variable equaling the Activity of the EPA location
#' @param dict a string indicating what dictionary you are using, currently set to 'us'
#' @param term_typ a string indicating whether you are looking for an identity, behavior, or modifier
#' @param max_dist a numeric variable equaling the maximum distance a term can be away from your EPA location
#'
#' @return a dataframe listing terms matching your search. Includes variables indicating element-wise distance and sum of squared differences.
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr rowwise
#' @importFrom dplyr %>%
#' @importFrom dplyr filter
#' @importFrom dplyr arrange
#' @importFrom dplyr ungroup
#' @export
#'
#' @examples
#' closest_term(1, 2.5, 3, term_typ = "identity")

closest_term <- function(e, p, a,
                         dict = "us",
                         term_typ,
                         max_dist = 1) {

    data("us_2015_full", envir=environment())

    terms <- us_2015_full %>%
             filter(type == term_typ) %>%
             rowwise() %>%
             mutate(d_e = E - e,
                    d_p = P - p,
                    d_a = A - a,
                    d_e_s = (d_e)^2,
                    d_p_s = (d_p)^2,
                    d_a_s = (d_a)^2,
                    ssd = sum(d_e_s, d_p_s, d_a_s)) %>%
              ungroup() %>%
              filter(ssd < max_dist) %>%
              arrange(ssd)

    return(terms)
}


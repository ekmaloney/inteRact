#' Create the I matrix from Heise (2010) that corresponds to ABO
#' elements that are not the one being solved for in optimal functions
#'
#' Convenience internal function
#'
#' @param elem string either actor, behavior, or object
#' @param eq equation
#' @param t_imp the dataframe containing the result of the transient impression from the event
#'
#' @return 29 x 29 matrix with desired terms extracted
#'
#' @export
#'
#' @examples
#' eq <- get_equation(name = "us2010", type = "impressionabo", g = "average")
#' d <- tibble::tibble(actor_modifier = "tired", actor = "ceo", behavior = "advise", object = "benefactor")
#' d <- reshape_events_df(df = d, df_format = "wide", dictionary_key = "usfullsurveyor2015", dictionary_gender = "average")
#' ti <- transient_impression(d = d, equation_key = "us2010", equation_gender = "average")
#'
#' terms_matrix <- extract_terms(elem = "actor", eq = eq, t_imp = ti)
#'
extract_terms <- function(elem,
                          eq,
                          t_imp) {

            #get fundamental terms NOT related to the element
            t_imp <- t_imp %>%
                      dplyr::mutate(f_s = if_else(element != elem,
                                                  estimate, 1))

            #get the trans_imp terms NOT related to the element
            selection_matrix <- eq %>%
                                dplyr::select(AE:OA) %>% t()

            if(elem == "actor"){
              values <- c(1, 1, 1, t_imp$estimate[4],
                          t_imp$estimate[5],
                          t_imp$estimate[6],
                          t_imp$estimate[7],
                          t_imp$estimate[8],
                          t_imp$estimate[9])

              selected_values <- as.data.frame(selection_matrix * values) %>%
                                 t() %>% tibble::as_tibble() %>%
                naniar::replace_with_na_all(condition = ~.x == 0) %>%
                dplyr::rowwise() %>%
                dplyr::mutate(product = prod(c(AE, AP, AA,
                                               BE, BP, BA,
                                               OE, OP, OA),
                                             na.rm = TRUE),
                       product = round(product, digits = 3))
            } else if(elem == "behavior") {
              values <- c(t_imp$estimate[1],
                          t_imp$estimate[2],
                          t_imp$estimate[3],
                          1, 1, 1,
                          t_imp$estimate[7],
                          t_imp$estimate[8],
                          t_imp$estimate[9])

              selected_values <- as.data.frame(selection_matrix * values) %>%
                t() %>% tibble::as_tibble() %>%
                naniar::replace_with_na_all(condition = ~.x == 0) %>%
                dplyr::rowwise() %>%
                dplyr::mutate(product = prod(c(AE, AP, AA,
                                               BE, BP, BA,
                                               OE, OP, OA),
                                             na.rm = TRUE),
                       product = round(product, digits = 3))

            } else if(elem == "object") {
              values <- c(t_imp$estimate[1],
                          t_imp$estimate[2],
                          t_imp$estimate[3],
                          t_imp$estimate[4],
                          t_imp$estimate[5],
                          t_imp$estimate[6],
                          1, 1, 1)

              selected_values <- as.data.frame(selection_matrix * values) %>%
                t() %>% tibble::as_tibble() %>%
                naniar::replace_with_na_all(condition = ~.x == 0) %>%
                dplyr::rowwise() %>%
                dplyr::mutate(product = prod(c(AE, AP, AA,
                                               BE, BP, BA,
                                               OE, OP, OA),
                                             na.rm = TRUE),
                       product = round(product, digits = 3))
            }

            #save as a vector
            i <- c(as.vector(t_imp$f_s), as.vector(selected_values$product))

            #make into a matrix with that on the diagonal
            mat_i <- matrix(0, length(i), length(i))
            diag(mat_i) <- i

            return(mat_i)
}

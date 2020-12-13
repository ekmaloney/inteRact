#' Create the I matrix from Heise (2010) that corresponds to ABO elements that are not the one being solved for in optimal functions
#'
#' @param elem string either A, B, or O
#' @param t_imp the dataframe containing the result of the transient impression from the event
#'
#' @return 29 x 29 matrix
#' @importFrom dplyr mutate
#' @importFrom dplyr case_when
#' @importFrom dplyr select
#' @importFrom dplyr %>%
#' @importFrom naniar replace_with_na_all
#'
#'
#' @export
#'
#' @examples
extract_terms <- function(elem, t_imp) {
            #load equation information
            data("us_1978", envir=environment())

            #get fundamental terms NOT related to the element
            t_imp <- t_imp %>%
                     mutate(f_s = if_else(element != elem,
                                   fundamental_sentiment, 1))

            #get the trans_imp terms NOT related to the element
            selection_matrix <- us_1978 %>% select(AE:OA)

            if(elem == "A"){
              values <- c(1, 1, 1, t_imp$fundamental_sentiment[4],
                          t_imp$fundamental_sentiment[5],
                          t_imp$fundamental_sentiment[6],
                          t_imp$trans_imp[7],
                          t_imp$trans_imp[8],
                          t_imp$trans_imp[9])

              selected_values <- as.data.frame(t(t(selection_matrix)*values)) %>%
                replace_with_na_all(., condition = ~.x == 0) %>%
                rowwise() %>%
                mutate(product = prod(c(AE, AP, AA, BE, BP, BA, OE, OP, OA), na.rm = TRUE),
                       product = round(product, digits = 3))
            } else if(elem == "B") {
              values <- c(element_def$trans_imp[1],
                          element_def$trans_imp[2],
                          element_def$trans_imp[3],
                          1, 1, 1,
                          t_imp$trans_imp[7],
                          t_imp$trans_imp[8],
                          t_imp$trans_imp[9])

              selected_values <- as.data.frame(t(t(selection_matrix)*values)) %>%
                replace_with_na_all(., condition = ~.x == 0) %>%
                rowwise() %>%
                mutate(product = prod(c(AE, AP, AA, BE, BP, BA, OE, OP, OA), na.rm = TRUE),
                       product = round(product, digits = 3))

            } else if(elem == "O") {
              values <- c(element_def$trans_imp[1],
                          element_def$trans_imp[2],
                          element_def$trans_imp[3],
                          element_def$trans_imp[4],
                          element_def$trans_imp[5],
                          element_def$trans_imp[6],
                          1, 1, 1)

              selected_values <- as.data.frame(t(t(selection_matrix)*values)) %>%
                replace_with_na_all(., condition = ~.x == 0) %>%
                rowwise() %>%
                mutate(product = prod(c(AE, AP, AA, BE, BP, BA, OE, OP, OA), na.rm = TRUE),
                       product = round(product, digits = 3))
            }

            #save as a vector
            i <- c(as.vector(t_imp$f_s), as.vector(selected_values$product))

            #make into a matrix with that on the diagonal
            mat_i <- matrix(0, 29, 29)
            diag(mat_i) <- i

            return(mat_i)
}

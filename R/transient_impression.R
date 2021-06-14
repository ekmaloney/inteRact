#' Calculate the Transient Impression after an Event
#'
#' @param actor lowercase string corresponding to the actor identity
#' @param beh lowercase string corresponding to the behavior term
#' @param object lowercase string corresponding to the object identity
#' @param dictionary which dictionary to use, currently set to "us"
#' @param equation which equation to use - you can either set it to "us" for the
#' us 1978 equations, or "user supplied")
#' @param eq_df if you select "user supplied" for equation, this parameter should
#' be your equation dataframe, which (should have been reshaped by the
#' reshape_new_equation function prior)

#' @return dataframe in long format, with one row for each element-dimension of the event, columns for fundamental sentiment and transient impression.
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr filter
#' @importFrom dplyr rowwise
#' @importFrom dplyr %>%
#' @importFrom dplyr select
#' @importFrom dplyr arrange
#' @importFrom dplyr case_when
#' @importFrom tidyr pivot_longer
#' @importFrom naniar replace_with_na_all
#' @importFrom here here
#'
#' @export
#'
#' @examples
#' transient_impression("ceo", "advise", "benefactor", equation = "us")

transient_impression <- function(act, beh, obj, dictionary = "us", equation = c("us", "user_supplied"), eq_df = NULL) {
          #make sure in the right location
          here()

          if(equation == "us"){
            data("us_1978", envir=environment())
            eq <- us_1978
          } else {
            eq <- eq_df
          }

          #read in data
          data("us_2015_full", envir=environment())

          #first get the EPA values for the elements
          abo_epa <- us_2015_full %>%
            filter((term == act & type == "identity") |
                     (term == beh & type == "behavior") |
                     (term == obj & type == "identity")) %>%
            mutate(element = case_when(term == act ~ "A",
                                       term == beh ~ "B",
                                       term == obj ~ "O")) %>%
            select(term, element, E, P, A) %>%
            pivot_longer(cols = E:A, names_to = "dimension",
                         values_to = "fundamental_sentiment") %>%
            arrange(element)

          #then construct the selection matrix
          selection_mat <- eq %>% select(AE:OA)

          #get ABO elements for coefficients
          abo_selected <- as.data.frame(t(t(selection_mat)*abo_epa$fundamental_sentiment)) %>%
            replace_with_na_all(., condition = ~.x == 0) %>%
            rowwise() %>%
            mutate(product = prod(c(AE, AP, AA, BE, BP, BA, OE, OP, OA), na.rm = TRUE))

          #multiply ABO elements by the equation coefficients
          post_epa <- t(eq[,2:10]) %*% abo_selected$product

          #put before and after together
          pre_post <- cbind(abo_epa, post_epa)

          pre_post <- pre_post %>%
                      mutate(trans_imp = post_epa) %>%
                      select(term, element, dimension, fundamental_sentiment, trans_imp)

          return(pre_post)

}


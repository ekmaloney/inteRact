#' Calculate the Transient Impression after an Event
#'
#' @param actor lowercase string corresponding to the actor identity
#' @param beh lowercase string corresponding to the behavior term
#' @param object lowercase string corresponding to the object identity
#' @param dictionary which dictionary to use, currently set to "us"

#' @return dataframe in long format, with one row for each element-dimension of the event, columns for fundamental sentiment and transient impression.
#' @export
#'
#' @examples
#' transient_impression("ceo", "advise", "benefactor")

transient_impression <- function(act, beh, obj, dictionary = "us") {

          #read in data
          load("data/us_2015_full.rda")
          load("data/us_1978.rda")

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
          selection_mat <- us_1978 %>% select(AE:OA)

          #get ABO elements for coefficients
          abo_selected <- as_tibble(t(t(selection_mat)*abo_epa$fundamental_sentiment)) %>%
            replace_with_na_all(., condition = ~.x == 0) %>%
            rowwise() %>%
            mutate(product = prod(c(AE, AP, AA, BE, BP, BA, OE, OP, OA), na.rm = TRUE))

          #multiply ABO elements by the equation coefficients
          post_epa <- t(us_1978[,2:10]) %*% abo_selected$product

          #put before and after together
          pre_post <- cbind(abo_epa, post_epa)

          pre_post <- pre_post %>%
                      mutate(trans_imp = post_epa) %>%
                      select(term, element, dimension, fundamental_sentiment, trans_imp)

          return(pre_post)

}


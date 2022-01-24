#' Calculate the Transient Impression after an Event
#'
#' @param actor lowercase string corresponding to the actor identity
#' @param beh lowercase string corresponding to the behavior term
#' @param object lowercase string corresponding to the object identity
#' @param dictionary_key a string corresponding to the dictionary from actdata you are using for cultural EPA measurements
#' @param gender either average, male, or female, depending on if you are using gendered equations
#' @param equation_key a string corresponding to the equation key from actdata
#' @param eq_df if you select "user supplied" for equation key, this parameter should
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
#' @importFrom data.table data.table
#' @importFrom data.table melt
#'
#' @export
#'
#' @examples
#' transient_impression(act = "ceo", beh = "advise", obj = "benefactor", dictionary_key = "usfullsurveyor2015",
#' gender = "average", equation_key = "us2010")
#'


transient_impression <- function(act, beh, obj,
                                 dictionary_key,
                                 gender,
                                 equation_key,
                                 eq_df = NULL) {


          #get dictionaries
          d <- actdata::epa_subset(dataset = dictionary_key, gender = gender)

          #get equation
          if(equation_key == "user_supplied"){
            eq <- eq_df
          } else {
            eq <- get_equation(name = equation_key, type = "impressionabo", gender = gender)
            eq <- reshape_new_equation(eq)
          }

          a <- d %>%
               dplyr::filter(term == act & component == "identity") %>%
               dplyr::mutate(element = "A")

          b <- d %>%
               dplyr::filter(term == beh & component == "behavior") %>%
               dplyr::mutate(element = "B")

          o <- d %>%
               dplyr::filter(term == obj & component == "identity") %>%
               dplyr::mutate(element = "O")

          abo_epa <- rbind(a, b, o)
          abo_epa <- abo_epa[,c("term", "element",  "E", "P", "A")]
          abo_epa <- data.table::data.table(abo_epa)
          abo_epa <- data.table::melt(abo_epa,
                                      id.vars = c("term", "element"),
                                      measure.vars = c("E", "P", "A"),
                                      variable.name = "dimension",
                                      value.name = "fundamental_sentiment")

          abo_epa <- abo_epa %>% arrange(element)

          #then construct the selection matrix
          selection_mat <- eq %>% dplyr::select(AE:OA)

          #get ABO elements for coefficients
          abo_selected <- as.data.frame(t(t(selection_mat)*abo_epa$fundamental_sentiment)) %>%
                          naniar::replace_with_na_all(., condition = ~.x == 0) %>%
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




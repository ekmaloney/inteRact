#' Compute Deflection for an Event
#'
#' This function calculates the deflection for an Actor, Behavior, Object event.
#' It assumes that the first input is an identity corresponding to the actor,
#' the second, the behavior, and last, the object. Each of these terms must be
#' in the US 2015 dictionary.
#'
#' @param actor lowercase string corresponding to the actor identity
#' @param beh lowercase string corresponding to the behavior term
#' @param object lowercase string corresponding to the object identity
#' @param dictionary which dictionary to use, currently set to "us"
#' @return calculated deflection for the event (single number)
#' @export
#'
#' @examples
#'
#' calc_deflection("ceo", "advises", "benefactor")



#provides deflection
calc_deflection <- function(act, beh, obj, dictionary = "us") {

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
                                values_to = "value") %>%
                   arrange(element)

        #then construct the selection matrix
        selection_mat <- us_1978 %>% select(AE:OA)

        #get ABO elements for coefficients
        abo_selected <- as_tibble(t(t(selection_mat)*abo_epa$value)) %>%
                        replace_with_na_all(., condition = ~.x == 0) %>%
                        rowwise() %>%
                        mutate(product = prod(c(AE, AP, AA, BE, BP, BA, OE, OP, OA), na.rm = TRUE))

        #multiply ABO elements by the equation coefficients
        post_epa <- t(us_1978[,2:10]) %*% abo_selected$product

        #put the before and after together
        element_deflection <- cbind(abo_epa, post_epa) %>%
                      rowwise() %>%
                      mutate(difference = value - post_epa,
                             sqd_diff = difference^2)

        #add together to get total deflection
        total_deflection <- element_deflection %>%
                            ungroup() %>%
                            summarise(d = sum(sqd_diff))

        return(total_deflection)

}


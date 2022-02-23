


modify_identity <- function(identity, modifier,
                            eq_info){

  #get the modifier and identity information
  id_info <- epa_subset(dataset = dict,
                        gender = "male") %>%
             filter((term == identity & component == "identity") |
                      term == modifier & component == "modifier") %>%
              select(term, component, E, P, A) %>%
              pivot_longer(E:A,
                           names_to = "dimension",
                           values_to = "estimate")


  equation_info <- stringr::str_split(eq_info, "_")
  #get the equation you're using
  eq <- get_equation(name = equation_info[[1]][1],
                     gender = equation_info[[1]][2],
                     type = "traitid")

  #select variables of interest
  selection_mat <- eq %>% dplyr::select(ME:IA)

  #make sure that the modifier comes first and then identity EPA info
  id_info <- id_info %>% arrange(component) %>% slice(4:6, 1:3)

  #get all of the selections
  abo_selected <- as.data.frame(t(t(selection_mat)*id_info$estimate)) %>%
    naniar::replace_with_na_all(., condition = ~.x == 0) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(product = prod(c(ME, MP, MA, IE, IP, IA), na.rm = TRUE))

  #final combination :)
  post_epa <- t(eq[,2:4]) %*% abo_selected$product

  return(post_epa)


}



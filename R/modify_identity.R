#' Modify Identity
#'
#' A function that applies the modifier equations to find the EPA location for modifier
#' + identity
#'
#' @param id_info a dataframe from reshape events that should be only
#' actor_modifier and actor elements or object_modifier and object elements
#' @param eq_info the equation information you are using, should be in the
#' form {name}_{gender}
#'
#' @return three digit EPA profile of the modified identity
#' @export
#'
#' @examples
modify_identity <- function(id_info,
                            eq_info){

  equation_info <- stringr::str_split(eq_info, "_")

  #get the equation you're using
  eq <- get_equation(name = equation_info[[1]][1],
                     g = equation_info[[1]][2],
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

  results <- tibble(dimension = c("E", "P", "A"),
                    estimate = c(post_epa[1],
                                 post_epa[2],
                                 post_epa[3]))

  return(results)


}



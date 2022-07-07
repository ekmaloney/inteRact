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
#'
modify_identity <- function(data,
                            equation_key = NULL,
                            equation_gender = NULL,
                            eq_df = NULL,
                            ...){

  #get the equation you're using
  if(equation_key %in% c("nc1978", "us2010",
                         "morocco2015", "germany2007",
                         "canada20012003", "canada1985")){
    eq <- get_equation(name = equation_key,
                       g = "average",
                       eq_df = eq_df,
                       type = "traitid")
  }else{
    eq <- get_equation(name = equation_key,
                       g = equation_gender,
                       eq_df = eq_df,
                       type = "traitid")
  }



  #select variables of interest
  selection_mat <- eq %>% dplyr::select(ME:IA)

  #make sure that the modifier comes first and then identity EPA info
  data <- data %>% dplyr::arrange(component) %>% slice(4:6, 1:3)

  #get all of the selections
  abo_selected <- as.data.frame(t(t(selection_mat)*data$estimate)) %>%
    naniar::replace_with_na_all(., condition = ~.x == 0) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(product = prod(c(ME, MP, MA, IE, IP, IA), na.rm = TRUE))

  #final combination :)
  post_epa <- t(eq[,2:4]) %*% abo_selected$product

  results <- tibble::tibble(dimension = c("E", "P", "A"),
                    estimate = c(post_epa[1],
                                 post_epa[2],
                                 post_epa[3]))

  return(results)


}



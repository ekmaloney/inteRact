#' maximally_confirm_behavior
#'
#' Identify the behavior that would maximally confirm the identities of actor
#' and object pairing
#'
#' @param actor lowercase string corresponding to the actor identity
#' @param beh lowercase string corresponding to the behavior term
#' @param object lowercase string corresponding to the object identity
#' @param which indicate whether you want the optimal behavior for "actor", "object",
#' or "both"
#' @param dictionary which dictionary to use, currently set to "us"
#' @param equation which equation to use - you can either set it to "us" for the
#' us 1978 equations, or "user supplied")
#' @param eq_df if you select "user supplied" for equation, this parameter should
#' be your equation dataframe, which (should have been reshaped by the
#' reshape_new_equation function prior)
#'
#' @return 3 digit EPA indicating the optimal behavior
#' @export
#'
#' @examples
maximally_confirm_behavior <- function(actor, object, dictionary, equation, eq_df = NULL){
  if(equation == "us"){
    data("us_1978", envir=environment())
    eq <- us_1978
  } else {
    eq <- eq_df
  }

  data("us_2015_full")

  a <- us_2015_full %>%
        filter(term == actor & type == "identity") %>%
        mutate(element = "A")

  o <- us_2015_full %>%
    filter(term == object & type == "identity") %>%
    mutate(element = "O")

  ao_epa <- rbind(a, o) %>%
    select(term, element, E, P, A) %>%
    pivot_longer(cols = E:A, names_to = "dimension",
                 values_to = "fundamental_sentiment") %>%
    arrange(element)


  i_actor <- eq %>%
    mutate(i = case_when(A == "000" & O == "000" ~ 1,
                         A == "100" & O == "000" ~ ao_epa$fundamental_sentiment[1],
                         A == "010" & O == "000" ~ ao_epa$fundamental_sentiment[2],
                         A == "001" & O == "000"~ ao_epa$fundamental_sentiment[3],
                         A == "000" & O == "100" ~ ao_epa$fundamental_sentiment[4],
                         A == "000" & O == "010" ~ ao_epa$fundamental_sentiment[5],
                         A == "000" & O == "001" ~ ao_epa$fundamental_sentiment[6],
                         A == "100" & O == "100"~ ao_epa$fundamental_sentiment[1]*ao_epa$fundamental_sentiment[4],
                         A == "100" & O == "010" ~ ao_epa$fundamental_sentiment[1]*ao_epa$fundamental_sentiment[5],
                         A == "100" & O == "001" ~ ao_epa$fundamental_sentiment[1]*ao_epa$fundamental_sentiment[6],
                         A == "010" & O == "100" ~ ao_epa$fundamental_sentiment[2]*ao_epa$fundamental_sentiment[4],
                         A == "010" & O == "010" ~ ao_epa$fundamental_sentiment[2]*ao_epa$fundamental_sentiment[5],
                         A == "010" & O == "001" ~ ao_epa$fundamental_sentiment[2]*ao_epa$fundamental_sentiment[6],
                         A == "001" & O == "100" ~ ao_epa$fundamental_sentiment[3]*ao_epa$fundamental_sentiment[4],
                         A == "001" & O == "010" ~ ao_epa$fundamental_sentiment[3]*ao_epa$fundamental_sentiment[5],
                         A == "001" & O == "001" ~ ao_epa$fundamental_sentiment[3]*ao_epa$fundamental_sentiment[6])) %>%
    select(i)

  f_s_i <- c(ao_epa$fundamental_sentiment[1],
             ao_epa$fundamental_sentiment[2],
             ao_epa$fundamental_sentiment[3],
             1, 1, 1,
             ao_epa$fundamental_sentiment[4],
             ao_epa$fundamental_sentiment[5],
             ao_epa$fundamental_sentiment[6])
  #save as a vector
  i_actor <- c(as.vector(f_s_i), as.vector(i_actor$i))

  #make into a matrix with that on the diagonal
  mat_i_actor <- matrix(0, length(i_actor), length(i_actor))
  diag(mat_i_actor) <- i_actor

  #make a behavior selection matrix
  b_s <- create_select_mat("behavior", equation, eq_df)

  #now which terms do not have behavior in them
  i_s <- matrix(data = rep(1, length(i_actor)), nrow = length(i_actor))
  i_3 <- as.matrix(c(1, 1, 1))
  g <- i_s - b_s %*% i_3
  g <- as.vector(g)

  #h contains identity matrix + coefficients of equations
  h <- construct_h_matrix(equation, eq_df)

  #term 1 of equation
  term1 <- t(b_s) %*% mat_i_actor %*% h %*% mat_i_actor %*% b_s
  term1 <- solve(term1)
  term1 <- -1*term1

  #term 2 of the equation
  term2 <- t(b_s) %*% mat_i_actor %*% h %*% mat_i_actor %*% g

  #final solution
  sol <- term1 %*% term2

  #put into nicer format
  opt_behavior_actor <- tibble(opt_E = sol[1],
                               opt_P = sol[2],
                               opt_A = sol[3],
                               term = "actor")

  return(opt_behavior_actor)
}

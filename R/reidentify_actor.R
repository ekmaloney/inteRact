#' Function to Generate the Re-identification of the Actor
#'
#' @param d a dataframe from reshape events that should be only
#' actor_modifier and actor elements or object_modifier and object elements
#' @param equation_gender either average, male, or female, depending on if you are using gendered equations
#' @param equation_key a string corresponding to the equation key from actdata
#'
#' @return dataframe with 3 columns corresponding to the EPA of optimal actor identity relabel
#' @export
#'
#' @examples
#' d <- tibble::tibble(actor = "ceo", behavior = "advise", object = "benefactor")
#' d <- reshape_events_df(df = d, df_format = "wide", dictionary_key = "usfullsurveyor2015", dictionary_gender = "average")
#' reidentify_actor(d = d, equation_key = "us2010", equation_gender = "average")
reidentify_actor <- function(d,
                             equation_key = NULL,
                             equation_gender = NULL,
                             eq_df = NULL,
                             ...) {

          #calculate the transient impression of the event
          trans_imp_df <- transient_impression(d = d,
                                               equation_key = equation_key,
                                               equation_gender = equation_gender,
                                               eq_df = eq_df)

          #get the equation
          eq <- get_equation(name = equation_key,
                             g = equation_gender,
                             eq_df = eq_df,
                             type = "impressionabo")


          #extract non-actor terms
          i_a <- extract_terms(elem = "actor",
                               eq = eq,
                               trans_imp_df)

          #create actor selection matrix
          a_s <- create_select_mat(term = "actor",
                                   eq = eq)

          #now which terms do not have actor in them
          i_s <- matrix(data = rep(1, nrow(i_a)), nrow = nrow(i_a))
          i_3 <- as.matrix(c(1, 1, 1))
          g <- i_s - a_s %*% i_3
          g <- as.vector(g)

          #construct h matrix
          h <- construct_h_matrix(eq = eq)

          #term 1 of equation
          term1 <- t(a_s) %*% i_a %*% h %*% i_a %*% a_s
          term1 <- solve(term1)
          term1 <- -1*term1

          #term 2 of the equation
          term2 <- t(a_s) %*% i_a %*% h %*% i_a %*% g

          #final solution
          sol <- term1 %*% term2

          #put into nicer format
          actor_label <- tibble::tibble(E = sol[1],
                                 P = sol[2],
                                 A = sol[3])

          return(actor_label)
}

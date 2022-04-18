#' Function to Generate the Re-identification of the Actor
#'
#' @param df data that has been reshaped by the events_df
#' @param equation_info is a string that corresponds to "{equationkey}_{gender}" from actdata
#'
#' @return dataframe with 3 columns corresponding to the EPA of optimal actor identity relabel
#' @export
#'
#' @examples
#' d <- tibble::tibble(actor = "ceo", behavior = "advise", object = "benefactor")
#' d <- reshape_events_df(df = d, df_format = "wide", dictionary_key = "usfullsurveyor2015", dictionary_gender = "average")
#' reidentify_actor(df = d, equation_info = "us2010_average")
reidentify_actor <- function(df, equation_info) {

          #calculate the transient impression of the event
          trans_imp_df <- transient_impression(df,
                                               equation_info = equation_info)

          #get the equation
          equation_info <- stringr::str_split(equation_info, "_")

          eq <- get_equation(name = equation_info[[1]][1],
                             g = equation_info[[1]][2],
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

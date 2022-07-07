#' Calculate the Optimal Behavior for the Actor following an Event
#'
#' @param df data that has been reshaped by the events_df
#' @param equation_info is a string that corresponds to "{equationkey}_{gender}"
#' from actdata
#' @return 3 digit EPA indicating the optimal behavior
#'
#' @export
#'
#' @examples
#'
#' opt_behavior_example <- tibble::tibble(actor = "teenager",
#' behavior = "beam_at",object = "friend")
#'
#'opt_behavior_df <- reshape_events_df(df = opt_behavior_example,
#'df_format = "wide", dictionary_key = "indiana2003",
#'dictionary_gender = "male")
#'
#'opt_b <- optimal_behavior(data = opt_behavior_df, equation_key = "nc1978",
#' equation_gender = "male")
#'
#'
#'
optimal_behavior <- function(data,
                             equation_key = NULL,
                             equation_gender = NULL,
                             eq_df = NULL,
                             ...) {

          #get the equation
          eq <- get_equation(name = equation_key,
                             g = equation_gender,
                             eq_df = eq_df,
                             type = "impressionabo")

          #calculate the transient impression
          element_def <- transient_impression(data,
                                              equation_key = equation_key,
                                              equation_gender = equation_gender,
                                              eq_df = eq_df)

              #select fundamental sentiment terms related to behavior
              element_def <- element_def %>%
                dplyr::mutate(f_s_b = if_else(element == "behavior",
                                         estimate, 1))

                #select transient impression terms related to behavior
                z_b <- eq %>%
                  dplyr::mutate(z_b = dplyr::case_when(B == "000" ~ 1,
                                         B == "100" ~ element_def$trans_imp[4],
                                         B == "010" ~ element_def$trans_imp[5],
                                         B == "001" ~ element_def$trans_imp[6])) %>%
                  dplyr::select(z_b)

                #save as a vector
                z_b <- c(as.vector(element_def$f_s_b), as.vector(z_b$z_b))

                #now get the non-behavior terms from each
                element_def <- element_def %>%
                  dplyr::mutate(f_s_i = if_else(element != "behavior",
                                         estimate, 1))

                ####ACTOR

                i_actor <- eq %>%
                  dplyr::mutate(i = dplyr::case_when(A == "000" & O == "000" ~ 1,
                                                A == "100" & O == "000" ~ element_def$trans_imp[1],
                                                A == "010" & O == "000" ~ element_def$trans_imp[2],
                                                A == "001" & O == "000"~ element_def$trans_imp[3],
                                                A == "000" & O == "100" ~ element_def$trans_imp[7],
                                                A == "000" & O == "010" ~ element_def$trans_imp[8],
                                                A == "000" & O == "001" ~ element_def$trans_imp[9],
                                                A == "100" & O == "100"~ element_def$trans_imp[1]*element_def$trans_imp[7],
                                                A == "100" & O == "010" ~ element_def$trans_imp[1]*element_def$trans_imp[8],
                                                A == "100" & O == "001" ~ element_def$trans_imp[1]*element_def$trans_imp[9],
                                                A == "010" & O == "100" ~ element_def$trans_imp[2]*element_def$trans_imp[7],
                                                A == "010" & O == "010" ~ element_def$trans_imp[2]*element_def$trans_imp[8],
                                                A == "010" & O == "001" ~ element_def$trans_imp[2]*element_def$trans_imp[9],
                                                A == "001" & O == "100" ~ element_def$trans_imp[3]*element_def$trans_imp[7],
                                                A == "001" & O == "010" ~ element_def$trans_imp[3]*element_def$trans_imp[8],
                                                A == "001" & O == "001" ~ element_def$trans_imp[3]*element_def$trans_imp[9])) %>%
                  dplyr::select(i)

                #save as a vector
                i_actor <- c(as.vector(element_def$f_s_i), as.vector(i_actor$i))

                #make into a matrix with that on the diagonal
                mat_i_actor <- matrix(0, length(i_actor), length(i_actor))
                diag(mat_i_actor) <- i_actor

                #make a behavior selection matrix
                b_s <- create_select_mat("behavior", eq)

                #now which terms do not have behavior in them
                i_s <- matrix(data = rep(1, length(i_actor)), nrow = length(i_actor))
                i_3 <- as.matrix(c(1, 1, 1))
                g <- i_s - b_s %*% i_3
                g <- as.vector(g)

                #h contains identity matrix + coefficients of equations
                h <- construct_h_matrix(eq)

                #term 1 of equation
                term1 <- t(b_s) %*% mat_i_actor %*% h %*% mat_i_actor %*% b_s
                term1 <- solve(term1)
                term1 <- -1*term1

                #term 2 of the equation
                term2 <- t(b_s) %*% mat_i_actor %*% h %*% mat_i_actor %*% g

                #final solution
                sol <- term1 %*% term2

                #put into nicer format
                opt_behavior_actor <- tibble::tibble(opt_E = sol[1],
                                       opt_P = sol[2],
                                       opt_A = sol[3],
                                       term = "actor")


                #####OBJECT

                ob_fsi <- c(element_def$f_s_i[7:9], 1, 1, 1, element_def$f_s_i[1:3])

                i <- eq %>%
                  dplyr::mutate(i = dplyr::case_when(A == "000" & O == "000" ~ 1,
                                       A == "100" & O == "000" ~ element_def$trans_imp[7],
                                       A == "010" & O == "000" ~ element_def$trans_imp[8],
                                       A == "001" & O == "000"~ element_def$trans_imp[9],
                                       A == "000" & O == "100" ~ element_def$trans_imp[1],
                                       A == "000" & O == "010" ~ element_def$trans_imp[2],
                                       A == "000" & O == "001" ~ element_def$trans_imp[3],
                                       A == "100" & O == "100"~ element_def$trans_imp[7]*element_def$trans_imp[1],
                                       A == "100" & O == "010" ~ element_def$trans_imp[7]*element_def$trans_imp[2],
                                       A == "100" & O == "001" ~ element_def$trans_imp[7]*element_def$trans_imp[3],
                                       A == "010" & O == "100" ~ element_def$trans_imp[8]*element_def$trans_imp[1],
                                       A == "010" & O == "010" ~ element_def$trans_imp[8]*element_def$trans_imp[2],
                                       A == "010" & O == "001" ~ element_def$trans_imp[8]*element_def$trans_imp[3],
                                       A == "001" & O == "100" ~ element_def$trans_imp[9]*element_def$trans_imp[1],
                                       A == "001" & O == "010" ~ element_def$trans_imp[9]*element_def$trans_imp[2],
                                       A == "001" & O == "001" ~ element_def$trans_imp[9]*element_def$trans_imp[3])) %>%
                  dplyr::select(i)

                #save as a vector
                i <- c(as.vector(ob_fsi), as.vector(i$i))

                #make into a matrix with that on the diagonal
                mat_i <- matrix(0, length(i), length(i))
                diag(mat_i) <- i

                #make a behavior selection matrix
                b_s <- create_select_mat("behavior", eq)

                #now which terms do not have behavior in them
                i_s <- matrix(data = rep(1, length(i)), nrow = length(i))
                i_3 <- as.matrix(c(1, 1, 1))
                g <- i_s - b_s %*% i_3
                g <- as.vector(g)

                #h contains identity matrix + coefficients of equations
                h <- construct_h_matrix(eq)

                #term 1 of equation
                term1 <- t(b_s) %*% mat_i %*% h %*% mat_i %*% b_s
                term1 <- solve(term1)
                term1 <- -1*term1

                #term 2 of the equation
                term2 <- t(b_s) %*% mat_i %*% h %*% mat_i %*% g

                #final solution
                sol <- term1 %*% term2

                #put into nicer format
                opt_behavior_object <- tibble::tibble(opt_E = sol[1],
                                       opt_P = sol[2],
                                       opt_A = sol[3],
                                       term = "object")



                  final <- rbind(opt_behavior_actor, opt_behavior_object)

    return(final)

}

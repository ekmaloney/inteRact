#' Calculate the Optimal Behavior for the Actor following an Event
#'
#' @param actor lowercase string corresponding to the actor identity
#' @param beh lowercase string corresponding to the behavior term
#' @param object lowercase string corresponding to the object identity
#' @param dictionary which dictionary to use, currently set to "us"
#'
#' @return 3 digit EPA indicating the optimal behavior
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr case_when
#' @importFrom dplyr select
#' @importFrom dplyr %>%
#' @importFrom tibble tibble
#'
#' @export
#'
#' @examples
optimal_behavior <- function(act, beh, obj, dictionary = "us") {
            #load equation information
            data("us_1978", envir=environment())

            #calculate the transient impression
            element_def <- transient_impression(act, beh, obj, dictionary = "us")

            #select fundamental sentiment terms related to behavior
            element_def <- element_def %>%
              mutate(f_s_b = if_else(element == "B",
                                     fundamental_sentiment, 1))

            #select transient impression terms related to behavior
            z_b <- us_1978 %>%
              mutate(z_b = case_when(B == "000" ~ 1,
                                     B == "100" ~ element_def$trans_imp[4],
                                     B == "010" ~ element_def$trans_imp[5],
                                     B == "001" ~ element_def$trans_imp[6])) %>%
              select(z_b)

            #save as a vector
            z_b <- c(as.vector(element_def$f_s_b), as.vector(z_b$z_b))

            #now get the non-behavior terms from each
            element_def <- element_def %>%
              mutate(f_s_i = if_else(element != "B",
                                     fundamental_sentiment, 1))

            i <- us_1978 %>%
              mutate(i = case_when(A == "000" & O == "000" ~ 1,
                                   A == "100" & O == "000"~ element_def$trans_imp[1],
                                   A == "010" & O == "000"~ element_def$trans_imp[2],
                                   A == "001" & O == "000"~ element_def$trans_imp[3],
                                   O == "100" & A == "000"~ element_def$trans_imp[7],
                                   O == "010" & A == "000"~ element_def$trans_imp[8],
                                   O == "001" & A == "000"~ element_def$trans_imp[9],
                                   A == "100" & O == "010"~ element_def$trans_imp[1]*element_def$trans_imp[8],
                                   A == "100" & O == "100"~ element_def$trans_imp[1]*element_def$trans_imp[7])) %>%
              select(i)

            #save as a vector
            i <- c(as.vector(element_def$f_s_i), as.vector(i$i))

            #make into a matrix with that on the diagonal
            mat_i <- matrix(0, 29, 29)
            diag(mat_i) <- i

            #make a behavior selection matrix
            b_s <- create_select_mat("behavior")

            #now which terms do not have behavior in them
            i_s <- matrix(data = rep(1, 29), nrow = 29)
            i_3 <- as.matrix(c(1, 1, 1))
            g <- i_s - b_s %*% i_3
            g <- as.vector(g)

            #h contains identity matrix + coefficients of equations
            h <- construct_h_matrix()

            #term 1 of equation
            term1 <- t(b_s) %*% mat_i %*% h %*% mat_i %*% b_s
            term1 <- solve(term1)
            term1 <- -1*term1

            #term 2 of the equation
            term2 <- t(b_s) %*% mat_i %*% h %*% mat_i %*% g

            #final solution
            sol <- term1 %*% term2

            #put into nicer format
            opt_behavior <- tibble(E = sol[1],
                                   P = sol[2],
                                   A = sol[3])

            return(opt_behavior)
}


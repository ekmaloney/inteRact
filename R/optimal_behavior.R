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

            #extract the terms that are not Behavior
            mat_i <- extract_terms(elem = "B", t_imp = element_def)

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


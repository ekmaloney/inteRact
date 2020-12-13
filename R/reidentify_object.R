#' Function to Generate the Re-identification of the Object
#'
#' @param act lowercase string corresponding to the actor identity
#' @param beh lowercase string corresponding to the behavior term
#' @param obj lowercase string corresponding to the object identity
#' @param dictionary which dictionary to use, currently set to "us"
#'
#' @return dataframe with 3 columns corresponding to the EPA of optimal object identity relabel
#' @importFrom tibble tibble
#' @export
#'
#' @examples
reidentify_object <- function(act, beh, obj, dictionary = "us") {
            #calculate the transient impression of the event
            trans_imp_df <- transient_impression(act, beh, obj, dictionary = "us")

            #extract terms that are not A
            i_o <- extract_terms(elem = "O", trans_imp_df)

            #create actor selection matrix
            o_s <- create_select_mat("object")

            #now which terms do not have actor in them
            i_s <- matrix(data = rep(1, 29), nrow = 29)
            i_3 <- as.matrix(c(1, 1, 1))
            g <- i_s - o_s %*% i_3
            g <- as.vector(g)

            #construct h matrix
            h <- construct_h_matrix()

            #term 1 of equation
            term1 <- t(o_s) %*% i_o %*% h %*% i_o %*% o_s
            term1 <- solve(term1)
            term1 <- -1*term1

            #term 2 of the equation
            term2 <- t(o_s) %*% i_o %*% h %*% i_o %*% g

            #final solution
            sol <- term1 %*% term2

            #put into nicer format
            obj_label <- tibble(E = sol[1],
                                  P = sol[2],
                                  A = sol[3])

            return(obj_label)
}

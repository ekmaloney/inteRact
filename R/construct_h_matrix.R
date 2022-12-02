#' Construct H Matrix
#'
#' This function is for internal use within other functions. A helper function to
#' make the H matrix needed in ACT calculations
#'
#' @param eq the equation dataframe being used in the analysis
#'
#' @return the h matrix, which "symbolize the matrices of constant parameters"
#' (see Heise, Expressive Order, p. 87)
#' @export
#'
#' @examples
#' eq <- get_equation(name = "us2010", type = "impressionabo", g = "average")
#' h_mat <- construct_h_matrix(eq = eq)
construct_h_matrix <- function(eq){

          #need to get the coefficient information
          coefs <- eq %>% dplyr::select(.data$postAE:.data$postOA) %>% as.matrix()

          #need to make an identity matrix
          identity <- matrix(0, 9, 9)
          diag(identity) <- 1

          #make h matrix
          h1 <- rbind(identity, -1*coefs)
          h2 <- cbind(identity, -1*t(coefs))
          h <- h1 %*% h2

          return(h)
}

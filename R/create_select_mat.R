#' Convenience Function for Creating Selection Matrix Depending on the Term
#'
#' @param term, string indicating whether you are selection for actor, behavior, or object
#' @param eq the equation dataframe being used for analysis
#'
#' @return selection matrix to easily grab desired estimates from entire event ABO-EPA matrix
#' see Heise, Expressive Order p. 86
#' @export
#'
#' @examples
#' eq <- get_equation(name = "us2010", type = "impressionabo", g = "average")
#' select_mat_a <- create_select_mat(term = "actor", eq = eq)

create_select_mat <- function(term,
                              eq) {

        #make identity matrix
        id_mat <- matrix(0, 9, 9)
        diag(id_mat) <- 1

        #get the coefficients from the
        coefs <- eq %>% dplyr::select(.data$AE:.data$OA) %>% as.matrix()

        z <- rbind(id_mat, coefs)

        if(term == "behavior"){
          z_select <- as.matrix(z[,4:6])
        } else if(term == "actor") {
          z_select <- as.matrix(z[,1:3])
        } else if(term == "object") {
          z_select <- as.matrix(z[,7:9])
        }

        return(z_select)
}

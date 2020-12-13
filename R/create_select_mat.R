#' Convenience Function for Creating Selection Matrix Depending on the Term
#'
#' @param term, string indicating whether you are selection for actor, behavior, or object
#'
#' @return
#' @export
#'
#' @examples

create_select_mat <- function(term) {
        #load in the data
        data("us_1978", envir=environment())

        #make identity matrix
        id_mat <- matrix(0, 9, 9)
        diag(id_mat) <- 1

        #get the coefficients from the
        coefs <- us_1978 %>% select(AE:OA) %>% as.matrix()

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

#' Construct H Matrix
#'
#' @param equation which equation to use - you can either set it to "us" for the
#' us 1978 equations, or "user supplied")
#' @param eq_df if you select "user supplied" for equation, this parameter should
#' be your equation dataframe, which (should have been reshaped by the
#' reshape_new_equation function prior)
#'
#' @return
#' @export
#'
#' @examples
construct_h_matrix <- function(equation = c("us", "user supplied"), eq_df = NULL){
          #load equation information
          if(equation == "us"){
            data("us_1978", envir=environment())
            eq <- us_1978
          } else {
            eq <- eq_df
          }

          #need to get the coefficient information
          coefs <- eq %>% select(postAE:postOA) %>% as.matrix()

          #need to make an identity matrix
          identity <- matrix(0, 9, 9)
          diag(identity) <- 1

          #make h matrix
          h1 <- rbind(identity, -1*coefs)
          h2 <- cbind(identity, -1*t(coefs))
          h <- h1 %*% h2

          return(h)
}

construct_h_matrix <- function(eq = "us"){
          #load equation information
          data("us_1978", envir=environment())

          #need to get the coefficient information
          coefs <- us_1978 %>% select(postAE:postOA) %>% as.matrix()

          #need to make an identity matrix
          identity <- matrix(0, 9, 9)
          diag(identity) <- 1

          #make h matrix
          h1 <- rbind(identity, -1*coefs)
          h2 <- cbind(identity, -1*t(coefs))
          h <- h1 %*% h2

          return(h)
}

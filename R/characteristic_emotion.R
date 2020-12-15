#' Characteristic Emotion
#'
#' @param id
#'
#' @return
#' @export
#'
#' @examples
characteristic_emotion <- function(id){
    #read in relevant data
    data("us_2015_full", envir=environment())
    data("us_emotions", envir=environment())

    #get the identity EPA scores
    r <- us_2015_full %>%
         filter(term == id & type == "identity") %>%
         select(E:A) %>% as.matrix(nrow = 1) %>% t()

    #take out the constants from the emotions equation
    d <- as.vector(us_emotions[1,2:4])

    #make identity matrix
    i <- matrix(0, nrow = 3, ncol = 3)
    diag(i) <- 1

    #get the coefficients associated with the role
    R <- us_emotions %>%
         filter(M == "000" & I != "000") %>%
         select(postME:postMA) %>% as.matrix() %>% t()

    #term2
    term2 <- ((i - R) %*% r) - d

    E <- us_emotions %>%
         filter(M != "000" & I == "000") %>%
         select(postME:postMA) %>% as.matrix() %>% t()

    QE <- us_emotions %>%
          filter(M != "000" & I != "000") %>%
          select(postME:postMA) %>% as.matrix() %>% t()

    QE <- matrix(c(QE[,1], 0,0,0, QE[,2]), nrow = 3)

    ire <- matrix(0, nrow = 3, ncol = 3)
    diag(ire) <- r[1]

    irp <- matrix(0, nrow = 3, ncol = 3)
    diag(irp) <- r[2]

    ira <- matrix(0, nrow = 3, ncol = 3)
    diag(ira) <- r[3]

    QP <- matrix(0, nrow = 3, ncol = 3)
    QA <- matrix(0, nrow = 3, ncol = 3)

    term1 <- E + ire %*% QE + irp %*% QP + ira %*% QA

    char_e <- solve(term1, term2)

    return(char_e)

}

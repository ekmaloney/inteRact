reidentify_object <- function(act, beh, obj, dictionary = "us"){
          #load equation information
          data("us_1978", envir=environment())

          #calculate the transient impression
          element_def <- transient_impression(act, beh, obj, dictionary = "us")

          #select fundamental sentiment terms related to behavior
          element_def <- element_def %>%
            mutate(f_s_o = if_else(element == "O",
                                   fundamental_sentiment, 1))

          #select transient impression terms related to behavior
          z_o <- us_1978 %>%
            mutate(z_o = case_when(O == "000" ~ 1,
                                   O == "100" ~ element_def$trans_imp[7],
                                   O == "010" ~ element_def$trans_imp[8],
                                   O == "001" ~ element_def$trans_imp[9])) %>%
            select(z_o)

          #save as a vector
          z_o <- c(as.vector(element_def$f_s_o), as.vector(z_o$z_o))

          #now get the non-behavior terms from each
          element_def <- element_def %>%
            mutate(f_s_i = if_else(element != "O",
                                   fundamental_sentiment, 1))

          i <- us_1978 %>%
            mutate(i = case_when(A == "000" & B == "000" ~ 1,
                                 A == "100" & B == "000"~ element_def$trans_imp[1],
                                 A == "010" & B == "000"~ element_def$trans_imp[2],
                                 A == "001" & B == "000"~ element_def$trans_imp[3],
                                 B == "100" & A == "000"~ element_def$fundamental_sentiment[4],
                                 B == "010" & A == "000"~ element_def$fundamental_sentiment[5],
                                 B == "001" & A == "000"~ element_def$fundamental_sentiment[6],
                                 A == "100" & B == "100"~ element_def$trans_imp[1]*element_def$trans_imp[4],
                                 A == "010" & B == "010"~ element_def$trans_imp[2]*element_def$trans_imp[5],
                                 A == "001" & B == "001"~ element_def$trans_imp[3]*element_def$trans_imp[6])) %>%
            select(i)

          #save as a vector
          i <- c(as.vector(element_def$f_s_i), as.vector(i$i))

          #make into a matrix with that on the diagonal
          i_o <- matrix(0, 29, 29)
          diag(i_o) <- i

          #make a behavior selection matrix
          o_s <- create_select_mat("object")

          #now which terms do not have behavior in them
          i_s <- matrix(data = rep(1, 29), nrow = 29)
          i_3 <- as.matrix(c(1, 1, 1))
          g <- i_s - o_s %*% i_3
          g <- as.vector(g)

          #h contains identity matrix + coefficients of equations
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

reidentify_object <- function(act, beh, obj, dictionary = "us"){
  #load equation information
  data("us_1978", envir=environment())

  a <- act
  b <- beh
  o <- obj

  #calculate the transient impression
  element_def <- transient_impression(a, b, o, dictionary = "us")

  #extract terms that are not A
  i_o <- extract_terms(elem = "O", t_imp = element_def)

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

#' Characteristic Emotion
#'
#' @param id_info a df from reshape_events_df with EPA information of the identity. Must provide either this or E, P, and A values.
#' @param equation_key is a string that corresponds to equation_key from actdata
#' @param equation_gender is a string that corresponds to what gendered data from eq
#' @param e Evaluation value
#' @param p Power value
#' @param a Activity value
#' @param eq_df Equation data frame
#' @param ...
#'
#' @return df with a 3 digit EPA profile of characteristic emotion for the identity
#' @export
#'
#' @examples
#' id <- tibble::tibble(actor = "brute")
#' id_info <- reshape_events_df(id, df_format = "wide", dictionary_key = "usfullsurveyor2015", dictionary_gender = "average")
#' characteristic_emotion(id_info, equation_key = "us2010", equation_gender = "male")
characteristic_emotion <- function(id_info = NULL,
                                   e = NULL,
                                   p = NULL,
                                   a = NULL,
                                   equation_key = NULL,
                                   equation_gender = NULL,
                                   eq_df = NULL,
                                   ...){

  # either you need the id_info df or you need to provide e, p, and a
  if(is.null(id_info)){
    if(is.null(e) | is.null(p) | is.null(a)){
      stop("Must provide either an id_info dataframe from reshape_events_df or E, P, and A values")
    }
    else {
      # they provided EPA
      if(!is.numeric(e) | !is.numeric(p) | !is.numeric(a)) {
        stop("E, P, and A must be numeric")
      } else {
        # provided epa is valid; restructure
        r <- matrix(data = c(e, p, a), nrow = 3)
      }
    }
  } else {
    # they provided a df
    #get the identity EPA scores
    r <- id_info$estimate %>% matrix(nrow = 3)
  }

    #get equation information
    eq <- get_equation(name = equation_key,
                       g = equation_gender,
                       type = "emotionid")

    #take out the constants from the emotions equation
    d <- as.vector(eq[1,2:4]) %>% as.matrix() %>% t()

    #make identity matrix
    i <- matrix(0, nrow = 3, ncol = 3)
    diag(i) <- 1

    #get the coefficients associated with the role
    R <- eq %>%
        dplyr::filter(M == "000" & I != "000") %>%
        dplyr::select(postME:postMA) %>% as.matrix() %>% t()

    #term2
    term2 <- ((i - R) %*% r) - d

    #NOW TERM 1
        E <- eq %>%
            dplyr::filter(M != "000" & I == "000") %>%
            mutate(term = dplyr::case_when(MA == 1 ~ "MA",
                                    ME == 1 ~ "ME",
                                    MP == 1 ~ "MP"),
                   term = factor(term, levels = c("ME", "MP", "MA"))) %>%
                arrange(term) %>%
            dplyr::select(postME:postMA) %>% as.matrix() %>% t()

        QE <- eq %>%
            dplyr::filter(interaction_term == 1 & IE == 1) %>%
            mutate(term = dplyr::case_when(MA == 1 ~ "MA",
                                           ME == 1 ~ "ME",
                                           MP == 1 ~ "MP"),
                   term = factor(term, levels = c("ME", "MP", "MA"))) %>%
            arrange(term) %>%
            dplyr::select(postME:postMA) %>% as.matrix() %>% t()

        ire <- matrix(0, nrow = 3, ncol = 3)
        diag(ire) <- r[1]

        irp <- matrix(0, nrow = 3, ncol = 3)
        diag(irp) <- r[2]

        ira <- matrix(0, nrow = 3, ncol = 3)
        diag(ira) <- r[3]

        QP <- eq %>%
            dplyr::filter(interaction_term == 1 & IP == 1) %>%
            mutate(term = dplyr::case_when(MA == 1 ~ "MA",
                                           ME == 1 ~ "ME",
                                           MP == 1 ~ "MP"),
                   term = factor(term, levels = c("ME", "MP", "MA"))) %>%
            arrange(term) %>%
            dplyr::select(postME:postMA) %>% as.matrix() %>% t()

        QA <- eq %>%
            dplyr::filter(interaction_term == 1 & IA == 1) %>%
            mutate(term = dplyr::case_when(MA == 1 ~ "MA",
                                           ME == 1 ~ "ME",
                                           MP == 1 ~ "MP"),
                   term = factor(term, levels = c("ME", "MP", "MA"))) %>%
            arrange(term) %>%
            dplyr::select(postME:postMA) %>% as.matrix() %>% t()

        term1 <- E + ire %*% QE + irp %*% QP + ira %*% QA

    char_e <- solve(term1, term2)

    return(char_e)
}


#' Characteristic Emotion
#'
#' @param id_info a df from reshape_events_df with EPA information of the identity
#' @param equation_info is a string that corresponds to "{equationkey}_{gender}" from actdata
#'
#' @return df with a 3 digit EPA profile of characteristic emotion for the identity
#' @export
#'
#' @examples
#' id <- tibble::tibble(actor = "brute")
#' id_info <- reshape_events_df(id, df_format = "wide", dictionary_key = "usfullsurveyor2015", dictionary_gender = "average")
#' characteristic_emotion(id_info, equation_info = "us2010_male")
characteristic_emotion <- function(id_info,
                                   equation_info){

    #get equation information
    equation_info <- stringr::str_split(equation_info, "_")

    eq <- get_equation(name = equation_info[[1]][1],
                       g = equation_info[[1]][2],
                       type = "emotionid")

    #get the identity EPA scores
    r <- id_info$estimate %>% matrix(nrow = 3)

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

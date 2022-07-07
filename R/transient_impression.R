#' Calculate the Transient Impression after an Event
#'
#' @param data data that has been reshaped by the events_data
#' @param equation_info is a string that corresponds to "{equationkey}_{gender}" from actdata
#' @return dataframe in long format, with one row for each element-dimension of the event, columns for fundamental sentiment and transient impression.
#'
#' @export
#'
#' @examples
#' d <- tibble::tibble(actor_modifier = "tired", actor = "ceo", behavior = "advise", object = "benefactor")
#' d <- reshape_events_df(df = d, df_format = "wide", dictionary_key = "usfullsurveyor2015", dictionary_gender = "average")
#' transient_impression(data = d, equation_key = "us2010", equation_gender = "average")
#'


transient_impression <- function(data,
                                 equation_key = NULL,
                                 equation_gender = NULL,
                                 eq_df = NULL, ...) {

#first, deal with modified identities
if("actor_modifier" %in% data$element){

  new_id <- data %>%
            filter(element == "actor" | element == "actor_modifier")

  new_id_epa <- modify_identity(data = new_id,
                                equation_key = equation_key,
                                equation_gender = equation_gender,
                                eq_df = eq_df)

  new_actor_info <- tibble::tibble(element = "actor",
                                   term = paste(unique(data$term[data$element == "actor_modifier"]),
                                                unique(data$term[data$element == "actor"])),
                                   component = "identity",
                                   event = unique(data$event)) %>% dplyr::bind_cols(new_id_epa)

  data <- data %>% dplyr::filter(element != "actor" & element != "actor_modifier")
  data <- dplyr::bind_rows(new_actor_info, data)

}

  if("object_modifier" %in% data$element){

    new_id <- data %>%
              filter(element == "object" | element == "object_modifier")

    new_id_epa <- modify_identity(id_info = new_id,
                                  equation_key = equation_key,
                                  equation_gender = equation_gender,
                                  eq_df = eq_df)

    new_actor_info <- tibble::tibble(element = "object",
                                     term = paste(unique(data$term[data$element == "object_modifier"]),
                                                  unique(data$term[data$element == "object"])),
                                     component = "identity",
                                     event = unique(data$event)) %>% dplyr::bind_cols(new_id_epa)

    data <- data %>% filter(element != "object" & element != "object_modifier")
    data <- bind_rows(new_actor_info, data)

  }

          #get the equation
          eq <- get_equation(name = equation_key,
                     g = equation_gender,
                     eq_df = eq_df,
                     type = "impressionabo")


          #construct the selection matrix
          selection_mat <- eq %>% dplyr::select(AE:OA)

          #get ABO elements for coefficients
          abo_selected <- as.data.frame(t(t(selection_mat)*data$estimate)) %>%
            naniar::replace_with_na_all(., condition = ~.x == 0) %>%
            dplyr::rowwise() %>%
            dplyr::mutate(product = prod(c(AE, AP, AA, BE, BP, BA, OE, OP, OA), na.rm = TRUE))

          #multiply ABO elements by the equation coefficients
          post_epa <- t(eq[,2:10]) %*% abo_selected$product
          post_epa <- tibble::tibble(post_epa = post_epa)

          #put before and after together
          pre_post <- cbind(data, post_epa)

          #get the pre and post event dimensions
          pre_post <- pre_post %>%
            dplyr::mutate(trans_imp = post_epa) %>%
            dplyr::select(element, term, component, dimension, estimate, trans_imp)

          pre_post <- pre_post %>% ungroup()

  return(pre_post)

}




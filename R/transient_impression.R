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


transient_impression <- function(d,
                                 equation_key = NULL,
                                 equation_gender = NULL,
                                 eq_df = NULL, ...) {

#first, deal with modified identities
if("actor_modifier" %in% d$element){

  new_id <- d %>%
            filter(element == "actor" | element == "actor_modifier")

  new_id_epa <- modify_identity(d = new_id,
                                equation_key = equation_key,
                                equation_gender = equation_gender,
                                eq_df = eq_df)

  new_actor_info <- tibble::tibble(element = "actor",
                                   term = paste(unique(d$term[d$element == "actor_modifier"]),
                                                unique(d$term[d$element == "actor"])),
                                   component = "identity",
                                   event = unique(d$event)) %>% dplyr::bind_cols(new_id_epa)

  d <- d %>% dplyr::filter(element != "actor" & element != "actor_modifier")
  d <- dplyr::bind_rows(new_actor_info, d)

}

  if("object_modifier" %in% d$element){

    new_id <- d %>%
      filter(element == "object" | element == "object_modifier")

    new_id_epa <- modify_identity(d = new_id,
                                  equation_key = equation_key,
                                  equation_gender = equation_gender,
                                  eq_df = eq_df)

    new_object_info <- tibble::tibble(element = "object",
                                     term = paste(unique(d$term[d$element == "object_modifier"]),
                                                  unique(d$term[d$element == "object"])),
                                     component = "identity",
                                     event = unique(d$event)) %>% dplyr::bind_cols(new_id_epa)

    d <- d %>% dplyr::filter(element != "object" & element != "object_modifier")
    d <- dplyr::bind_rows(new_object_info, d)

  }

          #get the equation
          eq <- get_equation(name = equation_key,
                     g = equation_gender,
                     eq_df = eq_df,
                     type = "impressionabo")


          #construct the selection matrix
          selection_mat <- eq %>% dplyr::select(AE:OA)

          #get ABO elements for coefficients
          abo_selected <- as.data.frame(t(t(selection_mat)*d$estimate)) %>%
            naniar::replace_with_na_all(condition = ~.x == 0) %>%
            dplyr::rowwise() %>%
            dplyr::mutate(product = prod(c(AE, AP, AA, BE, BP, BA, OE, OP, OA), na.rm = TRUE))

          #multiply ABO elements by the equation coefficients
          post_epa <- t(eq[,2:10]) %*% abo_selected$product
          post_epa <- tibble::tibble(post_epa = post_epa)

          #put before and after together
          pre_post <- cbind(d, post_epa)

          #get the pre and post event dimensions
          pre_post <- pre_post %>%
            dplyr::mutate(trans_imp = post_epa) %>%
            dplyr::select(element, term, component, dimension, estimate, trans_imp)

          pre_post <- pre_post %>% ungroup()

  return(pre_post)

}




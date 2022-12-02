#' Calculate the Transient Impression after an Event
#'
#' @param d data that has been reshaped to be in long format, with columns:
#' element, term, component, event, event_id, dimension, and estimate
#' @param equation_key the actdata equation key for the equation to use to get
#' the transient impression
#' @param equation_gender male, female, or average, corresponding to the gender
#' of equation to use when calculating the transient impression
#' @param eq_df use this only if you have used your *own* equation and not one in
#' actdata
#' @return dataframe in long format, with one row for each element-dimension of
#' the event, columns for fundamental sentiment and transient impression.
#'
#' @export
#'
#' @examples
#' d <- tibble::tibble(actor_modifier = "tired", actor = "ceo", behavior = "advise", object = "benefactor")
#' d <- reshape_events_df(df = d, df_format = "wide", dictionary_key = "usfullsurveyor2015", dictionary_gender = "average")
#' transient_impression(d = d, equation_key = "us2010", equation_gender = "average")
#'


transient_impression <- function(d,
                                 equation_key = NULL,
                                 equation_gender = NULL,
                                 eq_df = NULL, ...) {

#first, deal with modified identities
if("actor_modifier" %in% d$element){

  new_id <- d[which(d$element == "actor" | d$element == "actor_modifier"),
              , drop = FALSE]

  new_id_epa <- modify_identity(d = new_id,
                                equation_key = equation_key,
                                equation_gender = equation_gender,
                                eq_df = eq_df)

  new_actor_info <- tibble::tibble(element = "actor",
                                   term = paste(unique(d$term[d$element == "actor_modifier"]),
                                                unique(d$term[d$element == "actor"])),
                                   component = "identity",
                                   event = unique(d$event))

  new_actor_info <- cbind(new_actor_info, new_id_epa)

  d <- d[which(d$element != "actor" & d$element != "actor_modifier"),
         , drop = FALSE]

  if("event_id" %in% names(d)){
    new_actor_info$event_id <- unique(d$event_id)
  }

  d <- rbind(new_actor_info, d)
}

  if("object_modifier" %in% d$element){

    new_id <- d[which(d$element == "object" | d$element == "object_modifier"),
                , drop = FALSE]

    new_id_epa <- modify_identity(d = new_id,
                                  equation_key = equation_key,
                                  equation_gender = equation_gender,
                                  eq_df = eq_df)

    new_object_info <- tibble::tibble(element = "object",
                                     term = paste(unique(d$term[d$element == "object_modifier"]),
                                                  unique(d$term[d$element == "object"])),
                                     component = "identity",
                                     event = unique(d$event))

    new_object_info <- cbind(new_object_info, new_id_epa)

    d <- d[which(d$element == "object" | d$element == "object_modifier"),
           , drop = FALSE]

    if("event_id" %in% names(d)){
      new_object_info$event_id <- unique(d$event_id)
    }

    d <- rbind(new_object_info, d)

  }

  #d <- d %>% dplyr::arrange(match(element, c("actor", "behavior", "object")))
  d <- d[order(d$element), , drop = FALSE]

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
            dplyr::mutate(trans_imp = post_epa[,1]) %>%
            dplyr::select(element, term, component, dimension, estimate, trans_imp)

          pre_post <- pre_post %>% ungroup()

  return(pre_post)

}




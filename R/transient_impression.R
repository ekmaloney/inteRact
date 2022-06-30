#' Calculate the Transient Impression after an Event
#'
#' @param df data that has been reshaped by the events_df
#' @param equation_info is a string that corresponds to "{equationkey}_{gender}" from actdata
#' @return dataframe in long format, with one row for each element-dimension of the event, columns for fundamental sentiment and transient impression.
#'
#' @export
#'
#' @examples
#' d <- tibble::tibble(actor_modifier = "tired", actor = "ceo", behavior = "advise", object = "benefactor")
#' d <- reshape_events_df(df = d, df_format = "wide", dictionary_key = "usfullsurveyor2015", dictionary_gender = "average")
#' transient_impression(df = d, equation_info = "us2010_average")
#'


transient_impression <- function(df,
                                 equation_info,
                                 eq_df = NULL, ...) {

#first, deal with modified identities
if("actor_modifier" %in% df$element){

  new_id <- df %>%
            filter(element == "actor" | element == "actor_modifier")

  new_id_epa <- modify_identity(id_info = new_id,
                                eq_info = equation_info)

  new_actor_info <- tibble::tibble(element = "actor",
                                   term = paste(unique(df$term[df$element == "actor_modifier"]),
                                                unique(df$term[df$element == "actor"])),
                                   component = "identity",
                                   event = unique(df$event)) %>% dplyr::bind_cols(new_id_epa)

  df <- df %>% dplyr::filter(element != "actor" & element != "actor_modifier")
  df <- dplyr::bind_rows(new_actor_info, df)

}

  if("object_modifier" %in% df$element){

    new_id <- df %>%
              filter(element == "object" | element == "object_modifier")

    new_id_epa <- modify_identity(id_info = new_id,
                                  eq_info = equation_info)

    new_actor_info <- tibble::tibble(element = "object",
                                     term = paste(unique(df$term[df$element == "object_modifier"]),
                                                  unique(df$term[df$element == "object"])),
                                     component = "identity",
                                     event = unique(df$event)) %>% dplyr::bind_cols(new_id_epa)

    df <- df %>% filter(element != "object" & element != "object_modifier")
    df <- bind_rows(new_actor_info, df)

  }


  if(equation_info == "user_supplied"){
    eq <- eq_df[[1]]
  }else{
    #get the equation
    equation_info <- stringr::str_split(equation_info, "_")

    eq <- get_equation(name = equation_info[[1]][1],
                       g = equation_info[[1]][2],
                       type = "impressionabo")
  }


          #construct the selection matrix
          selection_mat <- eq %>% dplyr::select(AE:OA)

          #get ABO elements for coefficients
          abo_selected <- as.data.frame(t(t(selection_mat)*df$estimate)) %>%
            naniar::replace_with_na_all(., condition = ~.x == 0) %>%
            dplyr::rowwise() %>%
            dplyr::mutate(product = prod(c(AE, AP, AA, BE, BP, BA, OE, OP, OA), na.rm = TRUE))

          #multiply ABO elements by the equation coefficients
          post_epa <- t(eq[,2:10]) %*% abo_selected$product
          post_epa <- tibble::tibble(post_epa = post_epa)

          #put before and after together
          pre_post <- cbind(df, post_epa)

          #get the pre and post event dimensions
          pre_post <- pre_post %>%
            dplyr::mutate(trans_imp = post_epa) %>%
            dplyr::select(element, term, component, dimension, estimate, trans_imp)

  return(pre_post)

}




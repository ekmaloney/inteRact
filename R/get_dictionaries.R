#' Get Dictionary Identities
#'
#' @param dict_key of dictionary, options = china1999, china2000, egypt2014, gaysex1980,
#' germany1989, germany2007, household1994, indiana2003, internationaldomesticrelations1981,
#' internet1998, japan1984, japan19892002, morocco2015, nc1978, nireland1977, ontario1980,
#' ontario2001, politics2003, prisonersdilemma, texas1998, uga2015, uga2015bayesactsubset,
#' us2010, usfullsurveyor2015, usmturk2015, usstudent2015
#'
#' @param type behaviors, identities, mods
#'
#' @param gender av, m, f
#'
#' @return
#' @export
#'
#' @examples
get_dictionary <- function(dict_key, g){

    d <- actdata::epa_subset(dataset = dict_key)
    d <- d %>% dplyr::filter(gender == g)

  return(d)
}


#' Get Equation
#'
#' @param name name of equation. options: canada1985, canada20012003, china2000,
#' egypt2014, germany2007, japan1984, morocco2015, nc1978, us2010
#' @param type type of equation. options: emotionid, impressionabo, selfdir, traitid
#' @param gender gender of equation. options: f, m, av
#'
#' @return
#' @export
#'
#' @examples
get_equation <- function(name, type, gender){

  g <- case_when(gender == "female" ~ "f",
                 gender == "male" ~ "m",
                 gender == "average" ~ "av")

  eqn_fn <- paste0(name, "_", type, "_", g, "_eqn")

  eq <- get(eqn_fn)

  return(eq)

}

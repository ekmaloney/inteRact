#' US 2015 Gender Combined Dictionary
#'
#' Combined sentiment dictionary data collected at the University of Georgia, Duke University,
#' and in the Durham, NC community using Surveyor. A total of 1742 respondents were asked to rate
#' 929 identities, 824 behaviors, and 660 modifiers.
#'
#' Please cite as:
#' Citation: Smith-Lovin, Lynn, Dawn T. Robinson, Bryan C. Cannon, Jesse K. Clark, Robert Freeland,
#' Jonathan H. Morgan and Kimberly B. Rogers. 2016. “Mean Affective Ratings of 929 Identities,
#' 814 Behaviors, and 660 Modifiers by University of Georgia and Duke University Undergraduates
#' and by Community Members in Durham, NC, in 2012-2014.” University of Georgia: Distributed at UGA
#' Affect Control Theory Website: http://research.franklin.uga.edu/act/.
#'
#'
#' @format A data frame with 2403 rows and 10 variables:
#' \describe{
#'   \item{term}{name of identity, behavior, or modifier, string}
#'   \item{E}{point estimate of Evaluation}
#'   \item{P}{point estimate of Potency}
#'   \item{A}{point estimate of Activity}
#'   \item{E2}{point estimate of Evaluation}
#'   \item{P2}{point estimate of Potency}
#'   \item{A2}{point estimate of Activity}
#'   \item{type}{indicator whether term is identity, behavior, or modifier}
#'   \item{country}{country of dictionary}
#'   \item{year}{year dictionary was collected}
#' }
#' @source \url{http://affectcontroltheory.org///usa-combined-surveyor-dictionary-2015/}
"us_2015_full"

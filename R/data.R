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
#' US 1978 Male Equations
#'
#' A dataframe of the coefficients for the impression formation equations that was estimated in 1978.
#' A new version of the equations are currently being estimated. When this has been completed, the new
#' dataframe will be added to this package.
#'
#' Please cite as:
#' <FIGURE THIS OUT>
#'
#'
#' @format A data frame with 20 rows and 22 variables:
#' \describe{
#'   \item{coef_name}{indicator of what elements the beta is related to}
#'   \item{postAE}{coefficients to estimate the transient impression of the Actor's Evaluation}
#'   \item{postAP}{point coefficients to estimate the transient impression of the Actor's Potency}
#'   \item{postAA}{point coefficients to estimate the transient impression of the Actor's Activity}
#'   \item{postBE}{point coefficients to estimate the transient impression of the Behavior's Evaluation}
#'   \item{postBP}{point coefficients to estimate the transient impression of the Behavior's Potency}
#'   \item{postBA}{point coefficients to estimate the transient impression of the Behavior's Activity}
#'   \item{postOE}{point coefficients to estimate the transient impression of the Object's Evaluation}
#'   \item{postOP}{point coefficients to estimate the transient impression of the Object's Potency}
#'   \item{postOA}{point coefficients to estimate the transient impression of the Object's Activity}
#'   \item{A}{splitting apart Z into element A}
#'   \item{B}{splitting apart Z into element B}
#'   \item{O}{splitting apart Z into element O}
#'   \item{AE}{1 or 0 indicator whether AE is involved in estimation}
#'   \item{AP}{1 or 0 indicator whether AP is involved in estimation}
#'   \item{AA}{1 or 0 indicator whether AA is involved in estimation}
#'   \item{BE}{1 or 0 indicator whether BE is involved in estimation}
#'   \item{BP}{1 or 0 indicator whether BP is involved in estimation}
#'   \item{BA}{1 or 0 indicator whether BA is involved in estimation}
#'   \item{OE}{1 or 0 indicator whether OE is involved in estimation}
#'   \item{OP}{1 or 0 indicator whether OP is involved in estimation}
#'   \item{OA}{1 or 0 indicator whether OA is involved in estimation}
#' }
#' @source \url{http://www.tandfonline.com/doi/pdf/10.1080/0022250X.1987.9990026}
"us_1978"

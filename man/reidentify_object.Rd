% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reidentify_object.R
\name{reidentify_object}
\alias{reidentify_object}
\title{Function to Generate the Re-identification of the Object}
\usage{
reidentify_object(
  d,
  equation_key = NULL,
  equation_gender = NULL,
  eq_df = NULL,
  ...
)
}
\arguments{
\item{d}{a dataframe from reshape events that should be only
actor_modifier and actor elements or object_modifier and object elements}

\item{equation_key}{a string corresponding to the equation key from actdata}

\item{equation_gender}{either average, male, or female, depending on if you are using gendered equations}
}
\value{
dataframe with 3 columns corresponding to the EPA of optimal object identity relabel
}
\description{
Function to Generate the Re-identification of the Object
}
\examples{
d <- tibble::tibble(actor = "ceo", behavior = "advise", object = "benefactor")
d <- reshape_events_df(df = d, df_format = "wide", dictionary_key = "usfullsurveyor2015", dictionary_gender = "average")
reidentify_object(d = d, equation_key= "us2010", equation_gender = "average")
}

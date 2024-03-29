% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/characteristic_emotion.R
\name{characteristic_emotion}
\alias{characteristic_emotion}
\title{Characteristic Emotion}
\usage{
characteristic_emotion(
  id_info = NULL,
  e = NULL,
  p = NULL,
  a = NULL,
  equation_key = NULL,
  equation_gender = NULL,
  eq_df = NULL,
  ...
)
}
\arguments{
\item{id_info}{a df from reshape_events_df with EPA information of the identity. Must provide either this or E, P, and A values.}

\item{e}{Evaluation value}

\item{p}{Power value}

\item{a}{Activity value}

\item{equation_key}{is a string that corresponds to equation_key from actdata}

\item{equation_gender}{is a string that corresponds to what gendered data from eq}

\item{eq_df}{Equation data frame}

\item{...}{}
}
\value{
df with a 3 digit EPA profile of characteristic emotion for the identity
}
\description{
Characteristic Emotion
}
\examples{
id <- tibble::tibble(actor = "brute")
id_info <- reshape_events_df(id, df_format = "wide", dictionary_key = "usfullsurveyor2015", dictionary_gender = "average")
characteristic_emotion(id_info, equation_key = "us2010", equation_gender = "male")
}

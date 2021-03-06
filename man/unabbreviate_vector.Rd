% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/names_processing.R
\name{unabbreviate_vector}
\alias{unabbreviate_vector}
\title{unabbreviate vector}
\usage{
unabbreviate_vector(original_vector, acronyms)
}
\arguments{
\item{original_vector}{character vector with acronyms}

\item{acronyms}{tibble with two character columns: acronym, meaning}
}
\value{
character vector with acronyms replaced by their meaning
}
\description{
replaces acronyms in vector using dictionary of acronyms
}
\details{
replaces acronyms in character vector using dictionary of acronyms
}
\examples{
acronyms = tibble::tribble(~acronym, ~meaning,
  "FOURIER_M", "s1_12+s2_12+s3_12+s4_12+s5_12+c1_12+c2_12+c3_12+c4_12+c5_12+c6_12",
  "FOURIER_Q", "s1_4+c1_4+c2_4",
  "TRENDS", "trend_lin+trend_root")
unabbreviate_vector(c("aaa", "bbb + FOURIER_M"), acronyms)
}

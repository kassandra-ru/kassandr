% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parse_statistics.R
\name{parse_exchangerate}
\alias{parse_exchangerate}
\title{Parse exchange rates from cbr}
\usage{
parse_exchangerate(
  currency = "R01235",
  from = "1991-01-01",
  access_date = Sys.Date()
)
}
\arguments{
\item{currency}{currency code, default is R01235 (US Dollar). One may use R01239 (euro) etc}

\item{from}{starting date}

\item{access_date}{date of access is appended to every observation}
}
\value{
tsibble
}
\description{
Parse exchange rates from cbr
}
\details{
Parse exchange rates from cbr
Written by Maxim Alekseev
}
\examples{
# exch_rate <- parse_exchangerate()
}

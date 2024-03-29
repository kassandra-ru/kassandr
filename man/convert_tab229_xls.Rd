% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/converters.R
\name{convert_tab229_xls}
\alias{convert_tab229_xls}
\title{Converts tab2.29.xls file from cbr to tibble}
\usage{
convert_tab229_xls(
  path_to_source = "http://www.gks.ru/free_doc/doc_2018/bul_dr/trud/ors-2018-3kv.rar",
  access_date = Sys.Date(),
  sheet = 1
)
}
\arguments{
\item{path_to_source}{name of the original tab2.29.xls file}

\item{access_date}{date of access is appended to every observation}

\item{sheet}{number of sheet, 1 by default}
}
\value{
tibble
}
\description{
Converts tab2.29.xls file from cbr to tibble
}
\details{
Converts tab2.29.xls file from cbr to tibble.
Written by: Maxim Alekseev
}
\examples{
# no yet - needs rar extraction!
}

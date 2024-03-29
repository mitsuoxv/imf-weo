% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/output.R
\name{output_data}
\alias{output_data}
\title{Prepare download data}
\usage{
output_data(prev, df, df_prev, name_current, name_prev)
}
\arguments{
\item{prev}{A character vector of length 1, "Yes" or "No".}

\item{df}{A tibble.}

\item{df_prev}{A tibble.}

\item{name_current}{A character vector of length 1, like "2104".}

\item{name_prev}{A character vector of length 1, like "2010".}
}
\value{
A tibble.
}
\description{
Prepare download data
}
\examples{
\dontrun{
output_data(input$previous, chart_data(), chart_data_prev(),
"2110", "2104")
}
}

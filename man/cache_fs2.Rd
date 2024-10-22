% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cache-fs2.R
\name{cache_fs2}
\alias{cache_fs2}
\title{Alternative to \code{\link[memoise:cache_filesystem]{memoise::cache_filesystem()}}}
\usage{
cache_fs2(path, algo = "xxhash64", compress = FALSE)
}
\arguments{
\item{path}{Directory in which to store cached items.}

\item{algo}{The hashing algorithm used for the cache, see \code{\link[digest:digest]{digest::digest()}}
for available algorithms.}
}
\description{
\code{\link[memoise:cache_filesystem]{memoise::cache_filesystem()}} stores all caches in a single directory
which degrades filesystem performance when you have a large number
of cache files. This function adds a second level subdirectory structure
to help mitigate this issue. Future versions will enable the caller
to choose the number of levels. This works with all \code{\link[digest:digest]{digest::digest()}}
hashing algorithms.
}
\details{
Two additional functions are provided in slots in the returned list:
\itemize{
\item \code{location()} which will return the path to the cache directory
\item \code{size()} which will compute and return the size of the cache (in bytes)
}
}

#' Keybase backed cache for cross-system caching
#'
#' [Keybase](https://keybase.io/) is a secure messaging and file-sharing
#' service that provides end-to-end encryption for all services. File-sharing
#' can be public, private (either to just you or to you and selected users),
#' or with a team. Files are synchronized across all systems where you
#' have logged in to Keybase. Presently, there is a 250GB storage limit.\cr
#' \cr
#' **Keybase must be installed and the Keybase filesystem enabled to
#' use this package.**
#'
#' This uses [cache_fs2()], which means two additional functions are
#' provided in slots in the returned list:
#'
#' - `location()` which will return the path to the cache directory
#' - `size()` which will compute and return the size of the cache (in bytes)
#'
#' @param cache_path Keybase filesystem sub-path directory for
#'        storing cache files. Do not include `K:` (Windows),
#'        `/keybase` (linux), `/Volumes/keybase` (macOS) prefix.
#'        Should start with one of `public/...`, `private/...`, or
#'        `team/...`. See <https://book.keybase.io/docs/files> for more
#'        information on how the Keybase filesystem works.
#' @param algo The hashing algorithm used for the cache, see [digest::digest()]
#'        for available algorithms.
#' @export
cache_kb <- function(cache_path, algo = "sha512") {

  switch(
    platform(),
    "win" = "k:",
    "mac" = "/Volumes/Keybase",
    "linux" = "/keybase"
  ) -> kb_base

  kb_cache_dir <- file.path(kb_base, cache_path)

  if (!dir.exists(kb_cache_dir)) {
    dir.create(kb_cache_dir, recursive = TRUE, showWarnings = TRUE)
  }

  cache <- cache_fs2(kb_cache_dir, algo = algo)

  cache[["location"]] <- function() kb_cache_dir

  cache[["size"]] <- function() {
    cf <- as.list(list.files(kb_cache_dir, full.names = TRUE))
    if (length(cf) == 0) return(0)
    sum(as.numeric(do.call(file.size, cf)))
  }

  invisible(cache)

}

#' Convenience function to cache to your own public or private Keybase folder
#'
#' @details This ultimately uses [cache_fs2()], which means two additional functions are
#' provided in slots in the returned list:
#'
#' - `location()` which will return the path to the cache directory
#' - `size()` which will compute and return the size of the cache (in bytes)
#'
#' @param cache_subdir,private subdirectory _under_ either `KB_HOME/private` (if `private`
#'        is `TRUE`, the default) or `KB_HOME/public` if (`private` is `FALSE`).
#'        It will be created if it does not exist.
#' @param algo The hashing algorithm used for the cache, see [digest::digest()]
#'        for available algorithms.
#' @export
#' @examples
#' if (tinytest::at_home()) {
#' kbc <- cache_kb_self(".cache")
#'
#' kbc$location()
#'
#' mrunif <- memoise::memoise(runif, cache = kbc)
#'
#' mrunif(10) # First run, saves cache
#' mrunif(10) # Loads cache, results should be identical
#'
#' kbc$keys()
#'
#' kbc$size()
#'
#' kbc$reset()
#'
#' kbc$size()
#' }
cache_kb_self <- function(cache_subdir, private = TRUE,  algo = "sha512") {

   me <- system2(kbexec(), "whoami", stdout = TRUE)

   if (private) {
     p <- file.path("private", me, cache_subdir)
   } else {
     p <- file.path("public", me, cache_subdir)
   }

   cache_kb(p, algo)

}

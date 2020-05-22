#' Alternative to [memoise::cache_filesystem()]
#'
#' [memoise::cache_filesystem()] stores all caches in a single directory
#' which degrades filesystem performance when you have a large number
#' of cache files. This function adds a second level subdirectory structure
#' to help mitigate this issue. Future versions will enable the caller
#' to choose the number of levels. This works with all [digest::digest()]
#' hashing algorithms.
#'
#' Two additional functions are provided in slots in the returned list:
#'
#' - `location()` which will return the path to the cache directory
#' - `size()` which will compute and return the size of the cache (in bytes)
#'
#' @param path Directory in which to store cached items.
#' @param algo The hashing algorithm used for the cache, see [digest::digest()]
#'        for available algorithms.
#' @export
cache_fs2 <- function(path, algo = "xxhash64", compress = FALSE) {

  if (!dir.exists(path)) {
    dir.create(path, showWarnings = FALSE)
  }

  # convert to absolute path so it will work with user working directory changes
  path <- normalizePath(path)

  cache_reset <- function() {
    cache_files <- list.files(path, recursive = FALSE, full.names = TRUE)
    if (length(cache_files > 0)) unlink(cache_files, recursive = TRUE)
  }

  cache_set <- function(key, value) {
    hash_dir <- file.path(path, substr(key, 1, 2))
    if (!dir.exists(hash_dir)) dir.create(hash_dir, showWarnings = TRUE)
    fp <- file.path(hash_dir, key)
    saveRDS(value, file = fp, compress = compress)
  }

  cache_get <- function(key) {
    hash_dir <- file.path(path, substr(key, 1, 2))
    readRDS(file = file.path(hash_dir, key))
  }

  cache_has_key <- function(key) {
    hash_dir <- file.path(path, substr(key, 1, 2))
    file.exists(file.path(hash_dir, key))
  }

  cache_drop_key <- function(key) {
    hash_dir <- file.path(path, substr(key, 1, 2))
    file.remove(file.path(hash_dir, key))
  }

  list(
    digest = function(...) digest::digest(..., algo = algo),
    reset = cache_reset,
    set = cache_set,
    get = cache_get,
    has_key = cache_has_key,
    drop_key = cache_drop_key,
    keys = function() {
      basename(list.files(path, recursive = TRUE))
    }
  )
}

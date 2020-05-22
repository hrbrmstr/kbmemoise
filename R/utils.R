kbexec <- function() {

  where <- Sys.which("keybase")

  if (where == "") {

    paste0(
      c(
        "`keybase` executable not found.",
        "Visit 'https://keybase.io/' to download and install keybase.",
        "NOTE: this may require extra step to enable the Keybase filesystem driver."
      ),
      collapse = " "
    ) -> msg

    msg <- paste0(strwrap(msg), collapse = "\n")

    stop(msg, call. = FALSE)

  }

  where

}

is_windows <- function() .Platform$OS.type == "windows"
is_mac     <- function() Sys.info()[["sysname"]] == "Darwin"
is_linux   <- function() Sys.info()[["sysname"]] == "Linux"

#' Execution platform
#' @return one of `c("win", "mac", "linux")`
#' @export
platform <- function() {
  if (is_windows()) return("win")
  if (is_mac())     return("mac")
  if (is_linux())   return("linux")
  stop("unknown platform")
}

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Signed
by](https://img.shields.io/badge/Keybase-Verified-brightgreen.svg)](https://keybase.io/hrbrmstr)
![Signed commit
%](https://img.shields.io/badge/Signed_Commits-100%25-lightgrey.svg)
[![Linux build
Status](https://travis-ci.org/hrbrmstr/kbmemoise.svg?branch=master)](https://travis-ci.org/hrbrmstr/kbmemoise)  
![Minimal R
Version](https://img.shields.io/badge/R%3E%3D-3.5.0-blue.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

# kbmemoise

Keybase Filesystem Backing Store for ‘memoise’ Caching

## Description

Keybase <https://keybase.io> provides 250GB free, encrypted storage
making it suitable for creating a cross-system backing store for
‘memoise’ caches. Tools are provided to use Keybase with ‘memoise’.

## What’s Inside The Tin

The following functions are implemented:

  - `cache_fs2`: Alternative to memoise::cache\_filesystem()
  - `cache_kb_self`: Convenience function to cache to your own public or
    private Keybase folder
  - `cache_kb`: Keybase backed cache for cross-system caching
  - `platform`: Execution platform

## Installation

``` r
remotes::install_git("https://git.rud.is/hrbrmstr/kbmemoise.git")
# or
remotes::install_git("https://git.sr.ht/~hrbrmstr/kbmemoise")
# or
remotes::install_gitlab("hrbrmstr/kbmemoise")
# or
remotes::install_bitbucket("hrbrmstr/kbmemoise")
# or
remotes::install_github("hrbrmstr/kbmemoise")
```

NOTE: To use the ‘remotes’ install options you will need to have the
[{remotes} package](https://github.com/r-lib/remotes) installed.

## Usage

``` r
library(kbmemoise)

# current version
packageVersion("kbmemoise")
## [1] '0.1.0'
```

``` r
kbc <- cache_kb_self(".cache")

kbc$location()
## [1] "/Volumes/Keybase/private/hrbrmstr/.cache"

mrunif <- memoise::memoise(runif, cache = kbc)

mrunif(10) # First run, saves cache
##  [1] 0.5687944 0.5739892 0.4309080 0.1959454 0.7240059 0.4751237 0.4049415 0.6617540 0.7025730 0.9428181

mrunif(10) # Loads cache, results should be identical
##  [1] 0.5687944 0.5739892 0.4309080 0.1959454 0.7240059 0.4751237 0.4049415 0.6617540 0.7025730 0.9428181

kbc$keys()
## [1] "abb4b2ca91214fd892622aa50f4f5dc98d1453ae577cd916e60e02ebda8bbe7d75ff93d1fdd81967edced64de89833361e7f150cfae4898acb70b1aac932e791"

kbc$size()
## [1] 0

kbc$reset()

kbc$size()
## [1] 0
```

## kbmemoise Metrics

| Lang | \# Files |  (%) | LoC |  (%) | Blank lines |  (%) | \# Lines |  (%) |
| :--- | -------: | ---: | --: | ---: | ----------: | ---: | -------: | ---: |
| R    |        5 | 0.83 |  97 | 0.85 |          33 | 0.58 |       91 | 0.72 |
| Rmd  |        1 | 0.17 |  17 | 0.15 |          24 | 0.42 |       36 | 0.28 |

## Code of Conduct

Please note that this project is released with a Contributor Code of
Conduct. By participating in this project you agree to abide by its
terms.

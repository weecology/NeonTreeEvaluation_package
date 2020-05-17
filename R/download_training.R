#' @title Download NEONTreeEvaluation Data
#'
#' @author This function was ported from the Weecology/portalcasting repo (). Thanks to Juniper Simonis!
#' @description This suite of functions manages the downloading and (if
#'  needed) unzipping of raw files associated with the directory. \cr \cr
#'  \code{download} downloads a file from a website into the
#'  directory, unzipping and cleaning up as needed. \cr \cr
#'  \code{download_message} creates a customized download message. \cr \cr
#'  \code{download_url} prepares the URL from the inputs, depending on the
#'  download type (see \code{Details}). \cr \cr
#'  \code{download_destin} determines the download destination. \cr \cr
#'  \code{unzip_download} unzips any compressed downloads. \cr \cr
#'  \code{unzip_destins} determines the unzipping destinations for any
#'   compressed downloads.
#'
#' @param name \code{character} value of the component's name, used to create
#'  the folder within the raw subdirectory. If left as \code{NULL},
#'  \code{\link{name_from_url}} tries to obtain a name from the URL,
#'  unless \code{NULLname} is set to \code{TRUE}.
#'
#' @param type \code{character} value representing the type of input.
#'  Allowable types currently include a raw URL (\code{type = "url"}), which
#'  requires a non-\code{NULL} input for \code{url}, and from Zenodo
#'  (\code{type = "zenodo"}), which requires non-\code{NULL} input for either
#'  the concept record identifier (\code{concept_rec_id}) and
#'  version (\code{rec_version}) or record identifier (\code{rec_id})
#'  (\strong{if \code{rec_id} is used, it overrides
#'  \code{concept_rec_id}.}) \cr \cr
#'
#' @param url \code{character} value of the URL to be used if
#'  \code{type = "url"}.
#'
#' @param concept_rec_id Concept record identifier, a \code{character} value
#'  corresponding to the Zenodo concept, used when \code{type = "zenodo"}.
#'
#' @param rec_version \code{character} value of the version number or
#'  \code{"latest"} (default) for the data to be download.
#'  Used when \code{type = "zenodo"}.
#'
#' @param rec_id Optional input record identifier, a \code{character} value
#'  corresponding to the Zenodo record. Used when \code{type = "zenodo"}.
#'
#' @param cleanup \code{logical} indicator if any files put into the tmp
#'  subdirectory should be removed at the end of the process.
#'
#' @param quiet \code{logical} indicator if progress messages should be
#'  quieted.
#'
#' @param verbose \code{logical} indicator of whether or not to print out
#'   all of the information or not (and thus just the tidy messages).
#'
#' @param return_version \code{logical} indicator of whether or not to
#'  return the version name from the download URL.
#'
#' @param main \code{character} value of the name of the main component of
#'  the directory tree.
#'
#' @param NULLname \code{logical} indicator if \code{name} should be kept as
#'  \code{NULL}.
#'
#' @param zip_destin \code{character} value of the destination of the
#'  download of the zip, which is to be unzipped.
#'
#' @param source_url \code{character} value of the URL from which the download
#'  should occur
#'
#' @param sub \code{character} of the name of the subdirectory to
#'  download to.
#'
#' @param sep_char \code{character} value of the separator that delineates
#'  the extension from the file path. Generally, this will be \code{"."},
#'  but for some API URLs, the extension is actually a query component,
#'  so the separator may sometimes need to be \code{"="}.
#'
#'
#' @details If \code{type = NULL}, it is assumed to be a URL (\emph{i.e.},
#'  \code{type = "url"}).
#'
#' @return \code{download}: \code{character} of the name-version of the
#'  downloads if \code{return_version = TRUE}.
#'
#' @examples
#'  \donttest{
#'   create_dir()
#'   download("PortalData", "zenodo", concept_rec_id = "1215988")
#'   source_url <- download_url(type = "zenodo", concept_rec_id = "1215988")
#'   destin <- download_destin(name = "PortalData", source_url = source_url)
#'   download_message(type = "zenodo", source_url, rec_version = "latest")
#'   download.file(source_url, destin, mode = "wb")
#'   unzip_destins("PortalData", destin)
#'   unzip_download("PortalData", destin)
#'  }
#'
#' @export
#'
download <- function(name = NULL, type = NULL, url = NULL,
                     concept_rec_id = NULL, rec_version = "latest",
                     rec_id = NULL, sep_char = ".",return_version = TRUE,
                     main = ".", sub = "raw", quiet = FALSE,
                     verbose = FALSE, cleanup = TRUE, NULLname = FALSE,
                     arg_checks = TRUE){
  source_url <- download_url(type = type, url = url,
                             concept_rec_id = concept_rec_id,
                             rec_version = rec_version, rec_id = rec_id)
  resp <- GET(source_url)
  stop_for_status(resp)
  extension <- file_ext(path = source_url, sep_char = sep_char)
  name_alt <- name_from_url(url = source_url, NULLname = NULLname,
                            sep_char = sep_char)
  name <- (name, name_alt)
  if(extension == "zip"){
    sub <- "tmp"
  }
  destin <- download_destin(name = name, source_url = source_url,
                            main = main, sub = sub, sep_char = sep_char,
                            arg_checks = arg_checks)
  download_message(name = name, type = type, url = source_url,
                   rec_version = rec_version, quiet = quiet,
                   verbose = verbose, arg_checks = arg_checks)
  download.file(source_url, destin, quiet = !verbose, mode = "wb")
  extension <- file_ext(path = source_url, sep_char = sep_char,
                        arg_checks = arg_checks)
  if(extension == "zip"){
    unzip_download(name = name, zip_destin = destin, main = main,
                   cleanup = cleanup, arg_checks = arg_checks)
  }
  if(return_version){
    basename(source_url) %>%
      path_no_ext()
  }
}

download_message <- function(name = NULL, type = NULL, url = NULL,
                             rec_version = NULL, quiet = FALSE,
                             verbose = FALSE){
  msg1 <- paste0("  -", name)
  if(is.null(type) || type == "url"){
    msg2 <- paste0(" from ", url)
  } else if (type == "zenodo"){
    msg2 <- paste0(" (", rec_version, ") from zenodo (", url, ")")
  }
  if(verbose){
    msg <- paste0(msg1, msg2)
  } else{
    msg <- msg1
  }
  messageq(msg, quiet)
}

#' @rdname download
#'
#' @export
#'
download_url <- function(type = NULL, url = NULL, concept_rec_id = "3770410",
                         rec_version = "latest", rec_id = NULL){
  type <- ifnull(type, "url")
  type <- tolower(type)
  if(type == "url"){
    url
  } else if (type == "zenodo"){
    zenodo_url(concept_rec_id, rec_version, rec_id)
  } else {
    stop("present types allowed are only `url` and `zenodo`", call. = FALSE)
  }
}

#' @rdname download
#'
#' @export

#' @title Obtain the URL for a Zenodo record to be downloaded
#'
#' @description \code{zenodo_url} obtains the URL for a given Zenodo record,
#'  identified either by the concept record identifier (\code{concept_rec_id})
#'  and version (\code{rec_version}) or record identifier (\code{rec_id}).
#'  (\strong{Note}: if \code{rec_id} is used, it overrides
#'  \code{concept_rec_id}). \cr \cr
#'  \code{zenodo_versions}: determines the available version numbers and the
#'  corresponding record identifier for each version available for a given
#'  Zenodo concept (group of records).
#'
#' @param concept_rec_id Concept record identifier, a \code{character} value
#'  corresponding to the Zenodo concept.
#'
#' @param rec_version \code{character} value of the version number or
#'   \code{"latest"} (default) for the data to be download.
#'
#' @param rec_id Optional input record identifier, a \code{character} value
#'  corresponding to the Zenodo record.
#'
#'
#' @return \code{zenodo_url}: \code{character} value of the URL for the zip
#'  to be downloaded. \cr \cr
#'  \code{zenodo_versions}: a \code{data.frame} of version number and record
#'  identifier for each version available.
#'
#' @examples
#'  \donttest{
#'    zenodo_versions("3723356")
#'    zenodo_url("3770410", "latest")
#'    zenodo_url("3770410", "1.1.0")
#'  }
#'
#' @export
#'
zenodo_url <- function(concept_rec_id = 3723356, rec_version = "latest",
                       rec_id = NULL){
  if(is.null(rec_id)){
    avail_versions <- zenodo_versions(concept_rec_id = concept_rec_id)
    if(rec_version == "latest"){
      rec_id <- concept_rec_id
    } else{
      spot <- which(avail_versions$version == rec_version)
      if(length(spot) == 0){
        stop(paste0("version ", rec_version, " not available"), call. = FALSE)
      }
      rec_id <- avail_versions$rec_id[spot]
    }
  } else if (!is.null(concept_rec_id)){
    warning("both concept_rec_id and rec_id input. rec_id takes precedence")
  }

  url <- paste0("https://zenodo.org/api/records/", rec_id)
  res <- httr::GET(url)
  stop_for_status(res)
  content(res)$files[[1]]$links$download
}

#' @rdname zenodo_url
#'
#' @export
#'
zenodo_versions <- function(concept_rec_id, arg_checks = TRUE){
  url <- paste0("https://zenodo.org/api/records/?size=9999&",
                "q=conceptrecid:", concept_rec_id, "&all_versions=True")
  res <- GET(url)
  stop_for_status(res)
  cont <- content(res)
  nv <- length(cont)
  vers <- rep(NA, nv)
  recid <- rep(NA, nv)
  for(i in 1:nv){
    vers[i] <- cont[[i]]$metadata$version
    recid[i] <- cont[[i]]$record_id
  }
  data.frame(version = vers, rec_id = recid)
}

#' @title Attempt to extract the record name from a URL
#'
#' @description The record name is often encoded in a URL, so in the case that
#'  a name is not given for the record, this function attempts to extract it,
#'  unless told to keep the name as NULL (via \code{NULLname}).
#'
#' @param url \code{character} value of the URL.
#'
#' @param NULLname \code{logical} indicator of if the name should be kept as
#'  \code{NULL}, rather than given a name based on the URL.
#'
#' @param sep_char \code{character} value of the separator that delineates
#'  the extension from the file path. Generally, this will be \code{"."},
#'  but for some API URLs, the extension is actually a query component,
#'  so the separator may sometimes need to be \code{"="}.
#'
#' @return \code{character} value of the name or \code{NULL}.
#'
#' @examples
#'  \donttest{
#'   source_url <- zenodo_url(concept_rec_id = "1215988")
#'   name_from_url(source_url)
#'  }
#'
#' @export
#'
name_from_url <- function(url, NULLname = FALSE, sep_char = "."
                          ){
  if(NULLname){
    NULL
  } else{
    fname <- basename(url)
    fname2 <- path_no_ext(path = fname, sep_char = sep_char,
                          arg_checks = arg_checks)
    strsplit(fname2, "-")[[1]][1]
  }
}

#' @title Create a downloads list for zenodo downloads
#'
#' @description Create a downloads \code{list} for downloads from Zenodo.
#'
#' @param concept_rec_id Concept record identifier, a \code{character} value
#'  corresponding to the Zenodo concept.
#'
#' @param rec_version \code{character} value of the version number or
#'  \code{"latest"} for the data to be download.
#'
#' @param rec_id Optional input record identifier, a \code{character} value
#'  corresponding to the Zenodo record.
#'
#'
#' @return \code{list} of \code{list}s of arguments to \code{\link{download}}.
#'
#' @examples
#'  zenodo_downloads()
#'
#' @export
#'
zenodo_downloads <- function(concept_rec_id = "3770410", rec_version = "latest",
                             rec_id = NULL){
  return_if_null(c(concept_rec_id, rec_id))
  ndls <- max(c(length(concept_rec_id), length(rec_id)))
  out <- vector("list", length = ndls)
  if(!is.null(concept_rec_id)){
    if(length(rec_version) == 1){
      rec_version <- rep(rec_version, ndls)
    }
    for(i in 1:ndls){
      out[[i]] <- list(type = "zenodo", concept_rec_id = concept_rec_id[i],
                       rec_version = rec_version[i])
    }
  } else{
    for(i in 1:ndls){
      out[[i]] <- list(type = "zenodo", rec_id = rec_id[i])
    }
  }
  out
}


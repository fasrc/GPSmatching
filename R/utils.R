#' @title
#' Log system information
#'
#' @description
#' Logs system related information into the log file.
#'
#' @return
#' NULL
#'
#'@keywords internal
log_system_info <- function(){

  sys_info <- Sys.info()

  logger::log_info("System name: {sys_info[1]}, ",
                   "OS type: {.Platform$OS.type}, ",
                   "machine architecture: {sys_info[5]}, ",
                   "user: {sys_info[7]}, ",
                   "{R.version$version.string}, ",
                   "detected cores: {parallel::detectCores()[[1]]}")

}


#' @title
#' Put original data into package standard data
#'
#' @description
#' This is a temporal function to convert original data into a package standard
#' data. This function will be removed after addressing issue #67:
#' "convert accessing data from column index to column name #67"
#'
#' @param Y Output vector
#' @param w Treatment or exposure vector
#' @param c Covariate matrix
#' @param ci_appr Causal Inference approach
#'
#' @return
#' Original data with place holder columns.
#'
#' @keywords internal
#'

convert_data_into_standard_format <- function(Y, w, c, q1, q2, ci_appr){

  w_4 <- replicate(4, w)
  colnames(w_4) <- replicate(4, "w")
  if (ci_appr=="matching"){
    tmp_data <- cbind(Y,w_4,c)
  } else if (ci_appr=="weighting"){
    tmp_data <- cbind(Y,w_4,w*0+1,c)
  }

  tmp_data <- subset(tmp_data[stats::complete.cases(tmp_data) ,],  w < q2  & w > q1)
  tmp_data <- data.table(tmp_data)

  logger::log_debug("1% qauntile for trim: {q1}")
  logger::log_debug("99% qauntile for trim: {q2}")

  return(tmp_data)
}

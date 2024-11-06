box::use(reticulate)


#' @export
sample_data <- function() {
    python_src <- reticulate::import("src")
    df <- python_src$load$sample_data()
    return(df)
}

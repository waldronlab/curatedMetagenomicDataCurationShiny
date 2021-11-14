## The code in this file is based on:
## https://github.com/waldronlab/curatedMetagenomicDataCuration/blob/master/vignettes/curatedMetagenomicDataCuration.Rmd

.templateList <- function() {

    fname <- system.file(
        "extdata/template.csv",
        package = "curatedMetagenomicDataCuration"
    )

    col_types <- readr::cols(
        col.name = readr::col_character(),
        uniqueness = readr::col_character(),
        requiredness = readr::col_character(),
        multiplevalues = readr::col_logical(),
        allowedvalues = readr::col_character(),
        description = readr::col_character()
    )

    template <- readr::read_csv(file = fname, col_types = col_types)

    templatelist <- lapply(1:nrow(template), function(i){
        output <- t(template[i, ])
        output <- paste0("* *", rownames(output), "*: ", output[, 1])
        output
    })
    names(templatelist) <- template$col.name
    return(templatelist)
}


.curationReport <- function(dat) {

    suppressWarnings({
        check_output <- curatedMetagenomicDataCuration::checkCuration(dat)
    })

    no_err <- list(missingcols = NULL, invalidcols = NULL, values = NULL)
    if (identical(check_output, no_err)) {
        message("Status: OK.")
        return(invisible(NULL))
    } else {
        message("Status: Errors found.\n\n")
    }

    if (!is.null(check_output$missingcols)) {
        message(paste0(
            "## Required columns that are missing \n",
            check_output$missingcols,"\n\n"
        ))
    }

    if (!is.null(check_output$invalidcols)) {
        message("## Column erors \n")
        for (i in seq_along(check_output$invalidcols)) {
            message(paste0(
                "* \"", check_output$invalidcols[i], "\"",
                " is not defined in the template. \n"
            ))
        }
    }

    if (!is.null(check_output$values)) {
        message("## Entry errors \n\n")
        for (i in seq_along(check_output$values)) {
            if (!any(grepl("!!!", check_output$values[, i]))) next
            problemvariable <- colnames(check_output$values)[i]
            message("### ", problemvariable, "\n")
            message("**Template definition** \n\n")
            for (j in 2:6) {
                message(.templateList()[[problemvariable]][j])
            }
            message("**Errors** \n")
            output <- paste0(
                check_output$values$sampleID,
                "   :   ",
                check_output$values[, i]
            )
            for (k in seq_along(output)) {
                if (grep("!!!", output[k])) {
                    message(k, ". ", gsub("!!!", "\"", output[k]), " \n ")
                }
            }
        }
    }
}


.instructions_get_metadata <- function() {
    paste0(
        'Eneter a valid SRP identifier and click on "Get Metadata"',
        ' Then, download your file by clicking on "Download".\n\n')
}

.instructions_checkCuration <- function() {
    paste0('Upload a *_metadata.tsv file and click on "Check file".')
}



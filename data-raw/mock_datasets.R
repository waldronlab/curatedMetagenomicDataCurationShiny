## code to prepare `mock_datasets` dataset goes here
fname <- system.file(
    "curated/AsnicarF_2017/AsnicarF_2017_metadata.tsv",
    package = "curatedMetagenomicDataCuration"
)

## Dataset OK
df <- utils::read.table(fname, header = TRUE, sep = "\t")

## Dataset with a missing column (required)
missingcol <- df
missingcol$sample_id <- NULL

## Dataset with a column that is not valid
invalidcol <- df
invalidcol$new_col <- 1

## Dataset with invalid values
invalidvalue <- df
invalidvalue$number_reads <- paste0("reads", invalidvalue$number_reads)

## Dataset with several errors
multierror <- df
multierror$sample_id <- NULL
multierror$new_col <- 1
multierror$number_reads <- paste0("reads", multierror$number_reads)

## Export these tables
utils::write.table(df, "inst/extdata/data_ok_metadata.tsv", sep = "\t")
utils::write.table(missingcol, "inst/extdata/missingcol_metadata.tsv", sep = "\t")
utils::write.table(invalidcol, "inst/extdata/invalidcol_metadata.tsv", sep = "\t")
utils::write.table(invalidvalue, "inst/extdata/invalidvalue_metadata.tsv", sep = "\t")
utils::write.table(multierror, "inst/extdata/multierror_metadata.tsv", sep = "\t")


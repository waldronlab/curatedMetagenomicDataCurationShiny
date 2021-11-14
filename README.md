
# curatedMetagenomicDataCurationShiny

A shiny tool for the [get_metadata](https://github.com/waldronlab/curatedMetagenomicDataCuration/blob/master/man/get_metadata.Rd)
and
[checkCuration](https://github.com/waldronlab/curatedMetagenomicDataCuration/blob/master/man/checkCuration.Rd)
functions of the
[curatedMetagenomicDataCuration](https://github.com/waldronlab/curatedMetagenomicDataCuration)
package.


## Installation

```r
if (!"BiocManager" %in% installed.packages()[,"Package"])
    install.packages("BiocManager")
BiocManager::install("waldronlab/curatedMetagenomicDataCurationShiny") 
```

## Run the App

```r
library(curatedMetagenomicDataCurationShiny)
myApp()
```

## Example files for checkCuration

There are a few files in [inst/extdata](https://github.com/waldronlab/curatedMetagenomicDataCurationShiny/tree/main/inst/extdata)
that can be downloaded and used to test the shinyApp:

+ data_ok_metadata.tsv - no errors (this is a copy of [AsnicarF_2017_metadata.csv](https://github.com/waldronlab/curatedMetagenomicDataCuration/blob/master/inst/curated/AsnicarF_2017/AsnicarF_2017_metadata.tsv)).  
+ invalidcol_metadata.tsv - one invalid column.  
+ invalidvalue_metadata.tsv - invalid values in one column.  
+ missingcol_metadata.tsv - one of the required columns is missing  
+ multierror_metadata.tsv- all previous errors


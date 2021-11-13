
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



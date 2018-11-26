# Input is dataframe
# Delete rows if are over a certain percent NA
# 10% is my recommendation

NaDeletePercentRows <- function(dataIn, percentDeleteThreshold=10) {

    # NOTE the line below sums up the rows that have >10% NA.
    # It does not return the actual rows which have >10% NA.
    # Not all that elegant to be sure, but it works

    rowsAboveThreshold <-  sum(which(rowMeans(is.na(dataIn)) > (percentDeleteThreshold / 100)))

    if(rowsAboveThreshold == 0 ) {
        # nothing to do
        print(paste0('No rows have more than ', percentDeleteThreshold, '% missing values. No rows deleted.'))
        cat('============================================\n')
        dataOut <- dataIn

    } else {

        df2 <- dataIn[ -which(rowMeans(is.na(dataIn)) > (percentDeleteThreshold / 100)), ]

        print(paste0(nrow(dataIn) - nrow(df2), ' rows have been removed which have more than ', percentDeleteThreshold, '% missing values'))

        cat('============================================\n')
        dataOut <- df2

    }   # else

    return(dataOut)

}  # function

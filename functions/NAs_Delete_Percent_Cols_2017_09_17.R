# Input is dataframe
# Delete cols if are over a certain percent NA
# 10% is my recommendation

NaDeletePercentColumns <- function(dataIn, percentDeleteThreshold=10) {

    # NOTE the line below sums up the column numbers that have >10% NA.
    # It does not return the actual columns which have >10% NA.
    # For example, if columns 2, 3 and 4 have >10% NAs, colsAboveThreshold will be 2+3+4.
    # Not all that elegant to be sure, but it works

    colsAboveThreshold <-  sum(which(colMeans(is.na(dataIn)) > (percentDeleteThreshold / 100)))

    if(colsAboveThreshold == 0 ) {
        # nothing to do
        cat('\n')
        print(paste0('No columns have more than ', percentDeleteThreshold, '% missing values. No columns deleted.'))
        dataOut <- dataIn
        cat('\n============================================\n')

    } else {

        df2 <- dataIn[ , -which(colMeans(is.na(dataIn)) > (percentDeleteThreshold / 100))]

        cat('\n')
        print(paste0(ncol(dataIn) - ncol(df2), ' columns have been removed which have >', percentDeleteThreshold, '% missing values and they are:'))
        colsRemoved <- dataIn[ !(dataIn %in% df2)]
        print(names(colsRemoved))

        cat('\n============================================\n')
        dataOut <- df2

    }   # else

    return(dataOut)

}  # function

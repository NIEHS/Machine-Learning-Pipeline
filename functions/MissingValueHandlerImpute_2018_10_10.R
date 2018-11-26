# Impute missing values using kNN as implemented in DMwR

# Neal Cariello
# 2018_10_10

# The recommendation is to delete rows and columns if there are 10% or greater missing values.
# Of course this can be changed by the user.

# classification_or_regression must be either 'CLASSIFICATION' or 'REGRESSION'

# I think it's is more important to keep variables (cols) than observations (rows) so
# First, delete any rows with > 10% (percentDeleteThreshold)
#   then delete any cols with > 10% missing values.

MissingValueImpute <- function(dataIn, classification_or_regression, percentDeleteThreshold = 10)  {

    library(DMwR)      # knn imputation
    library(imputeTS)  # median imputation

    # Check for valid input
    if(classification_or_regression == 'CLASSIFICATION') {
        # valid input
    } else if (classification_or_regression == 'REGRESSION') {
        # valid input
    } else {
        cat('Invalid argument to function MissingValueInput() for classification_or_regression. \n
            value needs to be either CLASSIFICATION or REGRESSION \n
            value passed in is ', classification_or_regression)

        print('Stopping execution ...')
        stop()
    }

    dataTemp1 <- dataIn

    # There must NOT be any NAs in 'toPredict' - this is an uninformative row
    # Remove rows where this is the case.

    dataTemp2 <- dataTemp1[ !is.na(dataTemp1$toPredict) , ]

    rowsRemoved         <- NaDeletePercentRows(dataTemp2,      percentDeleteThreshold)
    rowsAndColsRemoved  <- NaDeletePercentColumns(rowsRemoved, percentDeleteThreshold)

    # remove toPredict and then add back
    # remvoving toPredict from rowsAndColsRemoved ensures that only numeric values exist for imputation
    toAddBack <- as.data.frame(subset(rowsAndColsRemoved, select = c(toPredict)))
    # toAddBack <- subset(rowsAndColsRemoved, select = c(toPredict))
    forImpute <-               subset(rowsAndColsRemoved, select = -c(toPredict))

    cat('There are ', sum(is.na(rowsAndColsRemoved)), ' missing values in the dataset will be imputed \n ')

    # kNN
    # Dataset with a "ton" of NAs cannot be imputed using DMwR::knn so use imputeTS::median

    impKnn = tryCatch({
        DMwR::knnImputation(forImpute)
         }, warning = function(cond) {
            message('Warning in knn imputation')
            message(cond)
        }, error = function(cond) {
            message('Too many missing values for k Nearest Neighbor imputation, using column median instead')
            impKnn <- imputeTS::na.mean(forImpute, option = 'median')
        }, finally = {
            # nothing
        } )

    dataToReturn <- cbind(toAddBack, impKnn)

    percentRowsRetained <- round( nrow(dataToReturn) / nrow(dataIn) * 100, digits = 2)
    print(paste0(percentRowsRetained, '% of the data rows are used for imputation'))

    percentColsRetained <- round( ncol(dataToReturn) / ncol(dataIn) * 100, digits = 2)
    print(paste0(percentColsRetained, '% of the data columns are used for imputation'))

    if(anyNA(dataToReturn)) {
        print('There are still missing values after imputation, program error, stopping execution')
        stop()
    }

    return(dataToReturn)

 }  # end of function(dataIn, percentDeleteThreshold = 10)  {



# Remove low variance features

# nearZeroVar is a caret function and returns the number of near zero variance cols
# See documentation for other parameters
# These variables should be considered for elimination

# Data, with the exception of what is being predicted, needs to be ALL NUMERIC for this operation

# What is being predicted, either 'classLabel' for classification or 'toPredict' for regression needs to
#     be removed before low variance features are removed.  The removed column is be added back after
#     variables are removed

deleteNearZeroVariance <- function(dataIn) {

    print('Variables with near zero variance will be removed')

    tempDataOnly       <- subset(dataIn, select = -c(toPredict))
    predictedToAddBack <- subset(dataIn, select =    toPredict)

    temp1 <- tempDataOnly

    # for testing, create a col with all 1's and see if it's removed
    # print('creating a no variance column for testing')
    # howManyRows <- nrow(temp1)
    # m <- as.data.frame(matrix(1, ncol = 1, nrow = howManyRows))
    # temp1 <- cbind(temp1, m)

    low_variance_cols <- caret::nearZeroVar(temp1)

    if(length(low_variance_cols) == 0) {
        print("There are no columns with near zero variance", quote=FALSE)
        return(dataIn)
    }


    print(paste("Number of variables with near zero variance is:", length(low_variance_cols)))
    print("Column names with near zero variance")
    names(temp1)[low_variance_cols]

    # Remove cols, add back 'classLabel' or 'toPredict', rename dataframe and return

    print(paste0("Removing ", length(low_variance_cols), " near zero variance columns"))
    temp2 <- temp1[, -low_variance_cols]

    # add back
    tempDataOnlyNzv <- cbind(predictedToAddBack, temp2)

    print('Dataframe dimensions before near zero Variance variables have been processed')
    dim(dataIn)

    print('Dataframe dimensions after near zero Variance variables have been processed')
    dim(tempDataOnlyNzv)

    return(tempDataOnlyNzv)


} # end  function

deleteHighlyCorrelated <- function(dataIn) {

    # dataframe here must be named **** tempDataOnlyNzv **** as done in previous chunk.

    # Examine highly correlated variables for possible exclusion using caret::findCorrelation
    #     and visualization using hierarchical clustering.
    # Data needs to be all numeric.

    # From the caret::findCorrelation() documentation:

    #   The absolute values of pair-wise correlations are considered. If two variables have a high correlation, the
    #     function looks at the mean absolute correlation of each variable and removes the variable with the largest
    #     mean absolute correlation.

    # Using exact = TRUE will cause the function to re-evaluate the average correlations
    #   at each step while exact = FALSE uses all the correlations regardless of whether
    #   they have been eliminated or not. The exact calculations will remove a smaller
    #   number of predictors but can be much slower when the problem dimensions are "big".


    # pull out what we are trying to predict so it does not get removed

    toAddBack   <- subset(dataIn, select =    toPredict)
    forAnalysis <- subset(dataIn, select = -c(toPredict))

    # This fails with any NA
    highlyCorrelated <- caret::findCorrelation(cor(forAnalysis), cutoff=0.95, exact=FALSE)

    if (length(highlyCorrelated) == 0) {
        print('No highly correlated variables found')
        toReturn <- cbind(toAddBack, forAnalysis)
        return(toReturn)
    }


    print(paste("Highly correlated variables being deleted:",
                names(forAnalysis)[highlyCorrelated]) )

    highlyCorrelated <- as.integer(highlyCorrelated)
    print(paste0("Removed ", length(highlyCorrelated), " highly correlated columns"))

    tempDataRemoved <- forAnalysis[, -highlyCorrelated]
    toReturn <- cbind(toAddBack, tempDataRemoved)
    return(toReturn)

} # end function
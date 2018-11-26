
###################### DATA DEFAULT For the classification model #################################################


# The segmentation data provided with caret package is from high content imaging microscopy to determine if a cell
#   is "well segmented".  If an individual cell is well segmented (coded as WS), that means that the
#   data from that cell is acceptabe.  PS indicates that data from this cell is poorly segmented and should
#   not be used for further analysis.

# More information on this dataset can be found at:
# https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-8-340
# https://topepo.github.io/caret/data-sets.html

# Note that the segmentation data has very different ranges and should be normalized.
# This normalization in done in the function ModelFit()
#########################################################################################################################


############################## DATA DEFAULT For the regression model ####################################################

# The BostonHousing data is as follows
# We are trying to predict medv (median value of home in $1000's)
# Data has very different ranges and should be normalized

#	crim     - per capita crime rate by town
#	zn       - proportion of residential land zoned for lots over 25,000 sq.ft
#	indus    - proportion of non-retail business acres per town
#	chas     - charles river dummy variable (1 if tract bounds river; else 0)
#	nox      - nitric oxides concentration (parts per 10 million)
#	rm       - average number of rooms per dwelling
#	age      - proportion of owner-occupied units built prior to 1940
#	dis      - weighted distances to five boston employment centres
#	rad      - index of accessibility to radial highways
#	tax      - full-value property-tax rate per $10,000
#	ptratio  - pupil-teacher ratio by town
#	b        - 1000(bk - 0.63)^2 where bk is the proportion of blacks by town
#	lstat    - % lower status of the population
#	medv     - median value of owner-occupied homes in $1000's


#########################################################################################################################


# addNA is for debugging for missing values, must be TRUE/FALSE

returnDefaultDataset <- function(modelType, addNA) {

    library(caret)
    library(mlbench)

    if (modelType == 'CLASSIFICATION') {

         print('Returning default dataset for classification')

         data(segmentationData)
         dataRaw <- segmentationData

        # get rid of the cell identifier as suggested by Kuhn
        dataRaw$Cell <- NULL

        # also delete "Case" which determines if an observation is in the training or test data set.
        # We will create our own training and test sets.

        ########################################################################################
        dataRaw$Case <- NULL

        ########################################################################################

        # change column name from "Class" to classLabel
        colnames(dataRaw)[colnames(dataRaw) == "Class"] <- "toPredict"

        print("segmentationData in caret package is being used")

        print('The first 5 rows and first 10 columns are')
        dataRaw[1:5, 1:10]

        print('The number of rows and columms is:')
        print(dim(dataRaw))

        # generate another factor variable and add back to test dropping of extra factor variable

        print('An extra factor column is added to test that dropping extra factor columns works OK')
        newCol <- as.data.frame(dataRaw$toPredict)
        names(newCol)[1] <- 'extra_factor_variable'
        dataRaw <- cbind(newCol, dataRaw)

        # for development of handling data with NAs
        if(addNA == 'TRUE') {

            print('Adding NAs for debugging')

            # add > 10% missing values for columns and rows to get imputation workng
            # print('Rows and cols have >10% NA')
            dataRaw[2:250, 5:10] <- NA

            # add some NA's to toPredict which is in col 1
            dataRaw[10:12, 1] <- NA

            # add random NAs
            numberNA <- 10000
            cat(numberNA, 'NAs added to segmentation data for missing values handling')

            inds     <- as.matrix(expand.grid(1:nrow(dataRaw), 1:ncol(dataRaw)))
            inds     <- matrix(inds[!is.na(dataRaw[inds])], ncol=2)
            selected <- inds[sample(nrow(inds), numberNA), ]
            dataRaw[selected] <- NA
            }  # end f(addNa == 'TRUE') {

        return(dataRaw)
    }   # end if (modelType == 'classification') {


    if (modelType == 'REGRESSION') {

        print('Returning default dataset for regression')

        # BostonHousing dataset is in mlbench
        data(BostonHousing)
        dataRaw <- BostonHousing

        # change column name from "medv" to "toPredict"
        colnames(dataRaw)[colnames(dataRaw) == "medv"] <- "toPredict"
        #change chas which is a two-factor variable to numeric
        dataRaw$chas <- as.numeric(dataRaw$chas)

        print("BostonHousing data in mlbench package is being used")

        # generate another factor variable and add back to test dropping of extra factor variable

        print('An extra factor column is added to test that dropping extra factor columns works OK')
        newCol <- as.factor(as.data.frame(dataRaw$toPredict))
        names(newCol)[1] <- 'extra_factor_variable'
        dataRaw <- cbind(newCol, dataRaw)


        # for development of handling data with NAs
        if(addNA == TRUE) {

            print('Adding NAs for debugging')

            # add > 10% missing values for columns and rows to get imputation workng

            # add random NAs
            numberNA <- 1500
            cat(numberNA, 'NAs added to BostonHousing data for missing values handling')

            inds     <- as.matrix(expand.grid(1:nrow(dataRaw), 1:ncol(dataRaw)))
            inds     <- matrix(inds[!is.na(dataRaw[inds])], ncol=2)
            selected <- inds[sample(nrow(inds), numberNA), ]
            dataRaw[selected] <- NA
        }  # end if(ADD_NA) {
        return(dataRaw)
    }

}  # end function







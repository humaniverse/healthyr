#* @apiTitle healthyr API
#* @apiDescription load datasets about UK health data

#* Return a dataset from healthyr
#* @param dataset The name of the dataset to read
#* @get /datasets
healthyr:::datasets

#* Find names of available datasets in healthyr
#* @get /datasets_available
healthyr:::datasets_available

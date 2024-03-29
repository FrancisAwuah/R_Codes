#' Create a data table (seqId, labeled, unlabeled, pr_test) to create a ROC curve
#' 
#' @param coef a named vector for the fitted coefficient vector
#' @param test_grouped_dat a data table (sequence, labeled, unlabeled, seqId) containing validation examples
#' @param order a considered order of effects
#' @param verbose a logical value
#' @param refstate a character which will be used for the common reference state; the default is to use the most frequent amino acid as the reference state for each of the position. 
#' @return a data table containing (seqId, labeled, unlabeled, pr_test)
#' @export
rocdata = function(coef,
                   test_grouped_dat,
                   Xprotein_test=NULL,
                   order = 1,
                   refstate = NULL,
                   nCores = 1,
                   verbose=T) {
  
  unique_X <- function(X,seqId){
    # return unique rows of X where each row corresponds to each seqId
    Xaug = cbind(seqId,X)
    Xaug_u = Xaug[order(seqId), ]
    Xaug_u = Xaug_u[!duplicated(Xaug_u[,"seqId"]),]
    Xaug_u[,-1]
  }
  
  if(is.null(Xprotein_test)){
    # create (X,z,wei) for a validation set
    if(verbose) cat("create Xtest for validation examples \n")
    Xprotein_test = create_model_frame(
      grouped_dat = test_grouped_dat,
      order = order,
      aggregate = T, 
      refstate = refstate,
      nCores = nCores,
      verbose=verbose)
  }
  
  
  # keep only unique sequences in Xtest
  Xtest_unique = with(Xprotein_test, unique_X(X, seqId))
  
  if(dim(coef)[2]==1){coef = coef[,1]}
  if(is.null(names(coef))){stop("coef should be a named vector")}
  if(is.null(colnames(Xtest_unique))){stop("Xtest should have column names")}
  
  # keep coefficients in coef in Xtest_unique (no contribution otherwise)
  # keep columns in Xtest_unique which exist in coef
  a0 = coef[1]
  coef_test = coef[names(coef) %in% colnames(Xtest_unique)] #intercept is never included
  Xtest = Xtest_unique[, colnames(Xtest_unique) %in% names(coef)]
  if(verbose){
    cat("length of coef(used)/coef(input):",length(coef_test),"/",length(coef[-1]),"\n")
    cat("ncol(Xtest;used)/ncol(Xtest;input):",ncol(Xtest),"/",ncol(Xtest_unique),"\n")
  }
  
  eta = Xtest %*% coef_test + a0
  pr_test = as.numeric(1 / (1 + exp(-eta)))
  
  with(test_grouped_dat, data.table(seqId = sort(unique(Xprotein_test$seqId)), labeled, unlabeled, pr_test))
}


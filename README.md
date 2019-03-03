# KNN
Determining a Win/Loss  for a political leader based on KNN.

KNN stands for K Nearest Neighbours. It is a supervised classification machine learning algorithm that determines if a data point belongs to a Class A or Class B based on some distance measure(Euclidiean distance mostly used). The K stands for the no.of data points that will be used to determine the class of the new data point. Here K is determined by Cross Validation.

US Presidential Data has factors determining if a candidate is likely to Win/Lose the US Presidential elections. The output variable here is Win.Loss that we are going to predict. We will be using all the other factors such as Optimisim, Pessimism, Openness to society that the candidates have used in their campaign speeches to determine if a candidate would Win/Loose the elections.

Before we model KNN on the data, it is of highest importance to normalize the predictor variables as KNN is highly sensitive to outliers and can determine the quality of our model in a bad way. Thus I have normalized all the predictor variables. Also, we need to split our dataset to train and test subsets to evaluate the performance of our model.

K in Knn is determined by Cross validation and the optimum K for our model is 9. So we will be using K=9, meaning a new data point will compute its Euclidiean ditance with 9 nearest points. We model the data on trainset.

Upon evaluting our model on test set, using ROC curves and AUC, we get AUC as 83.3 which corresponds to a very good model.

To depict the model, I have used Visualiztion using GGplot. The red color in the grid that corresponds to 1 depicts that the candidate is more likely to loose the election whereas 2 and aqua color depits the candidate has more chances of winning the Presidential Elections.

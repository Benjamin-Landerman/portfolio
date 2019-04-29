# Script to select the best ten features from Mushroom Classification dataset on Kaggle (https://www.kaggle.com/uciml/mushroom-classification)

import pandas as pd
import numpy as np
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import chi2

data=pd.read_csv("C:\\Users\\Ben\\Desktop\\mushrooms5.csv")
X=data.iloc[:,0:20]
y=data.iloc[:,-1]

bestfeatures=SelectKBest(score_func=chi2, k=10)
fit=bestfeatures.fit(X,y)
dfscores=pd.DataFrame(fit.scores_)
dfcolumns=pd.DataFrame(X.columns)

featureScores=pd.concat([dfcolumns,dfscores],axis=1)
featureScores.columns=['Features','Score']
print(featureScores.nlargest(10,'Score'))
# Script to build a logistic regression model with Mushroom Classification Dataset on Kaggle (https://www.kaggle.com/uciml/mushroom-classification)

import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split

dataset = pd.read_csv('C:\\Users\\Ben\\Desktop\\mushrooms2.csv')
X = dataset[[
'spore-print-color','stalk-color-above-ring','stalk-color-below-ring','stalk-root','stalk-shape',
    'cap-color','bruises','habitat','population','stalk-surface-above-ring']].values
y = dataset.x.values
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=0)

model= LogisticRegression(solver='lbfgs',max_iter=1000)
model.fit(X_train,y_train)
y_pred = model.predict(X_test)
print(y_pred)

df = pd.DataFrame({'Actual': y_test, 'Predicted': y_pred})
print(df)
print(model.score(X_test,y_test))

from sklearn.metrics import confusion_matrix
confusion_matrix(y_test, y_pred)

from sklearn.metrics import confusion_matrix
confusion_matrix(y_test, y_pred)
import pandas as pd
import numpy as np
import sklearn 
from sklearn import cross_validation, svm, ensemble

from operator import add
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
from sklearn import linear_model, neighbors, preprocessing
from sklearn.linear_model import LinearRegression


def calc_error(y_pred, y_actual):
    pred_list = add(y_pred, -1*y_actual)
    square_error = pred_list*pred_list
    final_error = np.sqrt(sum((square_error)/len(y_pred)))
    return final_error


X_train = pd.read_csv('master_factors.csv')


#This combination of predictors produced the best results

X_trainData = X_train.values[:,4:100] 
#X_trainData = X_train[['username','group','jobname']].values

y_train = X_train['walltime'].values


#Run this with different seed/take average of results (manual cross-validation) 
X_train1, X_test2, Y_train1, Y_test = cross_validation.train_test_split(X_trainData, y_train, test_size=0.10, random_state=197)




max_features_list =['log2', None, 'sqrt', 0.50]
#Change Paramters and re-run
for i in range(5, 2000):
    for j in range(0, len(max_features)):
        for h in range(1, 5):
            tree = ensemble.RandomForestRegressor(n_estimators=i, criterion='mse', max_depth=None, min_samples_split=h, min_samples_leaf=1, max_features=max_features_list[j], max_leaf_nodes=None, bootstrap=True, oob_score=True, n_jobs=4, random_state=177)
        

tree.fit(X_train1, Y_train1)
tree.score(X_train1,Y_train1)
y_predTree= tree.predict(X_test2)
print(tree.score(X_train1, Y_train1))
print(tree.oob_score_)

print(calc_error(y_predTree, Y_test))





#Logistic Regression
#logreg = linear_model.LinearRegression()
#logreg.fit(X_train1, Y_train1)
#y_predLog = logreg.predict(X_test2)
#logreg.score(X_train1,Y_train1)


#Change Paramter n_neigbors and re-run


for j in range(4,25):
    m = neighbors.KNeighborsRegressor(n_neighbors=j,  metric='minkowski', n_jobs=5)
    m.fit(X_train1, Y_train1)
    y_predKNN = m.predict(X_test2)
    print(m.score(X_train1,Y_train1))

    print(calc_error(y_predKNN, Y_test))

    y_train_pred = m.predict(X_train1)
    print(calc_error(y_train_pred, Y_train1))

    print(calc_error(y_predKNN, Y_test))

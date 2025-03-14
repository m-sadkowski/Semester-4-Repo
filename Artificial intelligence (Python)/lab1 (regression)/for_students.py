import numpy as np
import matplotlib.pyplot as plt

from data import get_data, inspect_data, split_data

data = get_data()
inspect_data(data)

train_data, test_data = split_data(data)

# Simple Linear Regression
# predict MPG (y, dependent variable) using Weight (x, independent variable) using closed-form solution
# y = theta_0 + theta_1 * x - we want to find theta_0 and theta_1 parameters that minimize the prediction error

# We can calculate the error using MSE metric:
# MSE = SUM (from i=1 to n) (actual_output - predicted_output) ** 2

# get the columns
y_train = train_data['MPG'].to_numpy()
x_train = train_data['Weight'].to_numpy()

y_test = test_data['MPG'].to_numpy()
x_test = test_data['Weight'].to_numpy()

# TODO: calculate closed-form solution
X = np.c_[np.ones(x_train.shape), x_train] # Kolumna jedynek + cecha "Weight"
# np.ones() tworzy tablicę wypełnioną jedynkami (pozwala uwzględnić wyraz wolny theta0), a np.c_ łączy dwie tablice kolumnowo w macierz
X_test = np.c_[np.ones(x_test.shape), x_test]
theta_cfs = np.linalg.inv(X.T @ X) @ X.T @ y_train # np.linalg.inv to odwrotoność macierzy, reszta ze wzoru 1.13
print("Theta (closed-form solution): ", theta_cfs)

# calculate error
MSE_train_cfs = np.mean((X @ theta_cfs - y_train) ** 2)
print("MSE for training set: ", MSE_train_cfs)
MSE_train_cfs = np.mean((X_test @ theta_cfs - y_test) ** 2)
print("MSE for test set: ", MSE_train_cfs)

# plot the regression line
x = np.linspace(min(x_test), max(x_test), 100)
y = float(theta_cfs[0]) + float(theta_cfs[1]) * x
plt.plot(x, y)
plt.scatter(x_test, y_test)
plt.xlabel('Weight')
plt.ylabel('MPG')
plt.show()

# TODO: standardization
x_train_std = (x_train - np.mean(x_train)) / np.std(x_train)
Z = np.c_[np.ones(x_train_std.shape), x_train_std]
y_train_std = (y_train - np.mean(y_train)) / np.std(y_train)
x_test_std = (x_test - np.mean(x_train)) / np.std(x_train)
X_test_std = np.c_[np.ones(x_test_std.shape), x_test_std]
y_test_std = (y_test - np.mean(y_train)) / np.std(y_train)

# TODO: calculate theta using Batch Gradient Descent
theta_gd = np.random.rand(2)

for i in range (10000):
    gradient = (2 / Z.shape[0]) * Z.T @ (Z @ theta_gd - y_train_std)
    theta_gd = theta_gd - 0.01 * gradient

print("Theta (gradient descent): ", theta_gd)

# TODO: calculate error
MSE_train_gd = np.mean((Z @ theta_gd - y_train_std) ** 2)
print("MSE for standarised train set: ", MSE_train_gd)
MSE_test_gd = np.mean((X_test_std @ theta_gd - y_test_std) ** 2)
print("MSE for standarised test set: ", MSE_test_gd)

# plot the regression line
x = np.linspace(min(x_test_std), max(x_test_std), 100)
y = float(theta_gd[0]) + float(theta_gd[1]) * x
plt.plot(x, y)
plt.scatter(x_test_std, y_test_std)
plt.xlabel('Weight')
plt.ylabel('MPG')
plt.show()
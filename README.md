# Time-series-analysis-by-using-arima
This prediction shows that exact visualization and stastical analysis for the datasets.
Time series analysis of hotel booking data. It includes data cleaning, and linear and non-linear regression models for forecasting.
#data This result belongs to the hotel booking and predicted the best value using linear and non-linear regression. in the main topic will be revealable and used to (auto.arima and HoltWinters) get the value of the analysis.
-->>#auto.arima#and #HoltWinters# is the two difference type of forecasting model for the time series analysis.

About the valuation of the data...

################################################

The script first loads the necessary packages and the hotel booking data then filters the data to only include bookings that have been checked out and groups them by month. It then creates a time series of the number of bookings per month and builds linear and non-linear regression models to predict future bookings.
-->Next, the script splits the data into training and testing sets for validation. It then predicts the number of bookings in the testing set using the non-linear regression model and computes various accuracy metrics such as R-squared, root mean squared error (RMSE), and mean absolute error (MAE).
Finally, the script creates a time series object of the number of bookings per month, tests for stationarity, and applies two different forecasting models (auto.arima and HoltWinters) to predict future bookings. The accuracy of the models is evaluated using the accuracy function from the forecast package.
Overall, this script provides a comprehensive example of how to perform time series analysis using R language on a real-world dataset.

library(tidyverse)

hotelData=read.csv("C:/Users/deves/Downloads/hotel_bookings.csv/hotel_bookings.csv") 

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(pROC))
library(lubridate)

#Time series Analysis with Seasonal Component using MLR
#Filter Bookings which are checkout and group by month

hdd =  hotelData %>% 
  filter(reservation_status=='Check-Out') %>%
  group_by(reservation_status_date,arrival_date_month )%>%
  summarise(n=n())

hdd$reservation_status_date = as.Date(hdd$reservation_status_date)

hd = hdd %>% group_by(Date=floor_date(reservation_status_date, "month")) %>%
  summarise(NumberOfBookings=sum(n)) %>%
  mutate(Month = month(Date)) %>%
  add_column(Timeperiod = 0 : 26)

hd$Month = as.factor(hd$Month)
hd = hd[-27,]
hd = hd[,c(1,4,3,2)]

#Linear Regression Model building for TS forecast

#Model1

Qmodel1 = glm(NumberOfBookings ~ Timeperiod  + Month , data=hd)
summary(Qmodel1)
layout(matrix(c(1,2,3,4),2,2)) 
plot(Qmodel1) 

#Model2  : Quadratic Non Linear Regression

hd$Timeperiod2 = hd$Timeperiod*hd$Timeperiod
Qmodel2 = glm(NumberOfBookings ~ Timeperiod  + Timeperiod2 + Month , data=hd)
summary(Qmodel2)
layout(matrix(c(1,2,3,4),2,2)) 
plot(Qmodel2)

#Validation of the model with testing and training

library(caret)
install.packages("boot")
install.packages("carData")
library(boot)
library(carData)
library(car)
set.seed(4)
n=nrow(hd)
shuffled=hd[sample(n),]
train=shuffled[1:round(0.85 * n),]
test = shuffled[(round(0.85 * n) + 1):n,]

Qmodel2 = glm(NumberOfBookings ~ Timeperiod  + Timeperiod2 + Month , data=hd)

#Prediction 
prediction=predict.lm(Qmodel2,newdata=test)
prediction
test$NumberOfBookings

#Compute metrics R2, RMSE, MAE
R2(prediction, test$NumberOfBookings)
RMSE(prediction, test$NumberOfBookings)
MAE(prediction, test$NumberOfBookings)




#TIME SERIES ANALYSIS WITH FORECASTS MODELS

#Filter Hotel Data with reservation status and date

hdd =  hotelData %>% 
  filter(reservation_status=='Check-Out') %>%
  group_by(reservation_status_date,arrival_date_month )%>%
  summarise(n=n())

hdd$reservation_status_date = as.Date(hdd$reservation_status_date)

hd = hdd %>% group_by(Date=floor_date(reservation_status_date, "month")) %>%
  summarise(NumberOfBookings=sum(n))

hd = hd[-27,]
ggplot(hd, aes(Date,NumberOfBookings)) + geom_line()

#Create TimeSeries for seasonal data
#hs = hotel data seasonal

n = length(hd$NumberOfBookings)
l = 2
hs = ts(hd$NumberOfBookings, start=c(2015, 7), end=c(2017,8), frequency= 12)
trainhs = ts(hd$NumberOfBookings[1: (n-l)], start=c(2015, 7) ,frequency= 12)
tesths  = ts(hd$NumberOfBookings[(n-l+1) : n], end=c(2017,8) ,frequency= 12)

#Test for stationary time series

library(tseries)
adf.test(hs) 
kpss.test(hs)

#See the components of time series

components = stl(hs, 'periodic')
plot(components)

library("forecast")

#Model 1 using auto.arima

Afit = auto.arima(hs, trace=TRUE)

checkresiduals(Afit)
Aforecast = forecast(Afit)
accuracy(Aforecast)
Aforecast
plot(forecast(auto.arima(hs)), sub = "Simple plot to forecast")

#Model 2 using HoltWinters

Hfit = HoltWinters(hs ,beta=TRUE, gamma=TRUE)

Hfit$fitted
checkresiduals(Hfit)
Hforecast = forecast(Hfit, h=8)
accuracy(Hforecast)
Hforecast
plot(Hforecast)

#Validation of the models

accuracy (Aforecast)
accuracy (Hforecast)

# Instalar Paqueterias
install.packages("fastDummies")

# Librerías
library(fastDummies)
library(tseries)
library(dplyr)
library(forecast)
library(urca)
library(ggplot2)

# Importar datos
data = read.csv("/cloud/project/pib2.txt", sep="")
# read.csv() es utilizado para leer archivos CSV en R.
# - file La ruta del archivo que se va a leer.
# - sep="": El delimitador de los campos (por defecto es una coma ",").
# - header=: Indica si la primera fila contiene los nombres de las columnas (por defecto es TRUE).
# - stringsAsFactors: Controla si las cadenas de texto se convierten automáticamente a factores (por defecto es TRUE, pero es recomendable usar FALSE en versiones antiguas de R).


# Definir variable "y" de serie de tiempo
y = ts(data[,2], start = 1980, frequency = 4)
# ts() se utiliza para crear objetos de series temporales en R.
# Argumentos principales:
  # - data: Los datos a ser convertidos en una serie temporal (puede ser un vector o columna de un dataframe).
  # - start: El punto de inicio de la serie temporal, así como el periodo ejmp. = c(1980,1).
  # - frequency: La cantidad de observaciones por unidad de tiempo (4 indica datos trimestrales).
  # - end: especificar el año y periodo de finalización de la serie de tiempo.

# Suavización de la seríe con transformación logaritmica
ly<- log(y)

# PLotear la variable
plot(ly,type="l", main = "GDPMEX")

# Test de Estacionaridad / Raiz Unitaria Dickey Fuller
adf = ur.df(ly, type = "trend", lags = 4)
# ur.df() Prueba de Raíz unitaria de Dickey-Fuller aumentada.
# Argumentos principales:
  # y: La serie de tiempo que se ca a probar.
    # "none": Prueba de raíz unitaria sin tendencia ni término constante.
    # "drift": Incluye un término constante en la ecuación de prueba (también conocido como con deriva).
    # "trend": Incluye tanto un término constante como una tendencia determinística (es la opción que estás utilizando).
  # lags: Número de rezagos de la variable dependiente que se deben incluir en la regresión.
  # selectlags:  Si deseas que el modelo seleccione automáticamente el número óptimo de rezagos basado en ciertos criterios, puedes usar este argumento.
    # "AIC": Criterio de información de Akaike.
    # "BIC": Criterio de información bayesiano de Schwarz.
    # "MAIC": Criterio de Akaike modificado.
    # "MBIC": Criterio de Schwarz modificado.

# Value of test-statistic is: xxx con respector al 1%, 5% y 10% de tau3 depende si tiene raiz unitaria o no
summary(adf)

# En caso de tener una caminata aleatoria, diferenciamos la serie.
d.ly = diff(ly) #Diferenciar la serie
plot(d.ly,type="l", main = "GDP LEVEL") # Plot de la serie


# Test de Estacionaridad / Raiz Unitaria Prueba que después de la diferencia ya no tiene raíz.
adf = ur.df(d.ly, type = "none", lags = 1)
summary(adf)

# Del proceso estacionario
#Funciones de autocorrelación simple
# patrones de estacionaridad 
# Autoregresivos AR
acf <-acf(d.ly, lag.max = 20)
# acf()Autocorrelación de una serie de tiempo
# Argumentos principales:
  # y: serie de tiempo
  # lag.max: =  número máximo de rezagos para los cuales se calculará la autocorrelación.
plot(acf)
acf

#Funciones de autocorrelación parcial
# Medias Moviles MA da los datos en la teoria
pacf <- pacf(d.ly, lag.max = 20)
# pacf()Autocorrelación parcial de una serie de tiempo
# Argumentos principales:
# y: serie de tiempo
# lag.max: =  número máximo de rezagos para los cuales se calculará la autocorrelación.
plot(pacf)
pacf

#Ljung-Box
# box.test(): Evalúa si hay autocorrelación en los residuos de una serie de tiempo.
Box.test(d.ly, lag = 4, type = c("Box-Pierce", "Ljung-Box"), fitdf = 0)
############################################################################
# arima(): Ajuste de un modelo a una serie temporal.
arima(d.ly, order = c(1,0,0))
arima(d.ly, order = c(2,0,2))
arima(d.ly, order = c(3,0,3))
arima(d.ly, order = c(4,0,4))
arima(d.ly, order = c(4,0,4))
############################################################################
# SARIMA  Seasonal
# Arima(): ajuste de una serie de tiempo con estacionariadad. SARIM
xx<-Arima(ly,order=c(4,0,4),seasonal = c(1,1,1))
xx

#Auto Arima
forecast(Arima(y,order=c(4,0,4),seasonal = c(1,1,1),include.drift=T),h=5)
# h = cuanto en el tiempo hay que predecir
# drif.t = con derivac"T" True
autoplot(forecast(xx,h=5))
checkresiduals(xx)

# AutoArima
xx1 <- auto.arima(y,seasonal= T, stepwise = T, approximation = T)
xx1
forecast(xx1, h=5)
autoplot(forecast(xx1,h=5))
checkresiduals(xx1)

############################################################################
# crear variables de control
exog <- fastDummies::dummy_cols(data, select_columns = "T")
exog <- exog[c(3,120,165)]
exog <- exog[-1,]
exog<- exog[c(2,3)]


exog

d.ly
exog
xx <- arima(d.ly, order = c(1,0,1), xreg = exog)
# cambio estructural
library(strucchange)
breakpoints <- breakpoints(res ~ 1)
summary(breakpoints)

auto
summary(arima(d.ly, order = c(3,0,3), fixed = c(0,0,NA,0,0,NA,NA)))


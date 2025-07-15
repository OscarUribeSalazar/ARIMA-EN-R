# 📈 Predicción del Precio de las Acciones de Amazon (AMZN) utilizando Modelos ARIMA en R

Este proyecto muestra cómo se pueden aplicar modelos ARIMA para realizar pronósticos de series temporales, utilizando como caso de estudio los precios históricos de las acciones de Amazon (AMZN). La implementación se realizó en R y el análisis fue documentado en una presentación en video.

---

## 🎯 Objetivo

Predecir el comportamiento futuro del precio de cierre ajustado de las acciones de Amazon mediante modelos ARIMA, evaluando su rendimiento y utilidad en escenarios reales de análisis financiero.

---

## 🧪 Metodología y Resultados Box-Jenkis

### 0. Recolección y preparación de los datos
- **Fuente de datos**: Yahoo Finance.
- Se extrajo el precio de cierre ajustado.
- Se realizó una visualización inicial para observar tendencia y posibles patrones estacionales.
<img width="968" height="311" alt="image" src="https://github.com/user-attachments/assets/bb84754c-15a7-4e9e-9331-9160e44b2506" /><p align="center"><em>Precio ajustado de las acciones de Amazon (AMZ)desde el 1/1/23 al 18/11/24 </em></p>

### 1. Limpieza de los datos
- Los datos fueron obtenidos desde Yahoo Finance, y se presentaron en un formato estructurado y sin valores faltantes.
- Se utilizó la columna "Adjusted Close", que representa el precio ajustado a eventos corporativos como dividendos y splits, siendo más adecuado para análisis históricos.
- Se imprimieron las primeras y últimas filas del conjunto de datos (head() y tail()), y se verificaron sus dimensiones: 472 observaciones y 1 variable.
- Se generó un resumen estadístico para visualizar métricas clave como el valor mínimo, máximo, media, mediana y cuartiles.
- Posteriormente, se definió la serie de tiempo a partir de los precios ajustados.
- Para mejorar la visualización y estabilizar la varianza, se aplicó una transformación logarítmica a la serie.
- El análisis visual reveló la presencia de tendencia y deriva, así como fluctuaciones abruptas a lo largo del tiempo.
<img width="1310" height="557" alt="image" src="https://github.com/user-attachments/assets/11eb204c-afe6-40fb-b30b-e18e68e876cb" /><p align="center"><em>Seríe de tiempo del precio por día</em></p>
- Finalmente, se analizó la distribución de los valores, observando múltiples picos y posibles indicios de componentes estructurales o choques externos que podrían estar influyendo en la trayectoria de la serie.
<img width="1311" height="567" alt="image" src="https://github.com/user-attachments/assets/86bbd689-dbc4-44e1-bc0e-7bedd517ac30" /><p align="center"><em>Distribución y densidad de los datos</em></p>


### 2. Prueba de estacionariedad
- Aplicación de la prueba **Dickey-Fuller aumentada (ADF)**.
- El resultado arrojó un valor p superior al 5%, lo que indica la presencia de una raíz unitaria. Por lo tanto, se concluyó que la serie era no estacionaria.
- Al no cumplir con la estacionariedad, se aplicó una diferenciación de primer orden (`d=1`).
<img width="1312" height="555" alt="image" src="https://github.com/user-attachments/assets/074b1f95-05cf-4929-bff9-59d228913678" /><p align="center"><em>Serie de tiempo estacionaria</em></p>
- Tras la transformación, se volvió a aplicar la prueba ADF y se obtuvo un valor p menor al 5%, confirmando que la serie ahora cumple con la condición de estacionariedad, requisito fundamental para aplicar modelos ARIMA.

### 3. ACF y PACF
- Se graficaron las funciones de autocorrelación (ACF) y autocorrelación parcial (PACF) sobre la serie previamente diferenciada para estimar los valores tentativos de los parámetros p (AR) y q (MA) del modelo ARIMA.
- En la función ACF, se observó que los rezagos posteriores al primer periodo no presentan una autocorrelación significativa, lo que sugiere un valor de q = 1.
<img width="1307" height="581" alt="image" src="https://github.com/user-attachments/assets/49c8faa7-b2ba-43cc-99ba-0ece9abe4e0c" /><p align="center"><em>Función de autocorrelación (ACF)</em></p>
- En la función PACF, los rezagos después del rezago 0 tampoco mostraron autocorrelaciones significativas, indicando la posible presencia de ruido blanco. Esto sugiere un valor de p = 0.
<img width="1300" height="574" alt="image" src="https://github.com/user-attachments/assets/abeb6d75-59fc-461a-9346-6a05761e143f" /><p align="center"><em>Función de autocorrelación Parcial (PACF)</em></p>

### 4. Especificación del modelo ARIMA (p,d,q)
- Con base en este análisis visual, se propuso inicialmente el modelo ARIMA(0,1,1).
- También se evaluaron manualmente otras configuraciones como ARIMA(1,1,1), ARIMA(2,1,2) y ARIMA(1,1,0).
- Para optimizar la selección, se utilizó la función auto.arima(), que realiza una búsqueda automática basada en criterios como AIC y BIC.
- El modelo sugerido por auto.arima() fue ARIMA(0,1,2). Este modelo presentó una mejor log-verosimilitud y una menor suma de cuadrados de los residuales, superando en desempeño a las configuraciones propuestas manualmente.


### 5. Ajuste y validación del modelo
- El modelo fue ajustado utilizando una división del conjunto de datos en formato 80/20, donde el 80% se destinó al entrenamiento y el 20% restante a la validación.
- Se generaron las predicciones utilizando los datos de prueba y el modelo previamente entrenado.
- Para evaluar el desempeño del modelo, se calculó el Error Cuadrático Medio (RMSE), obteniendo un valor que representa aproximadamente el 32% de desviación respecto a los valores reales. Esto implica que el modelo alcanzó un nivel de precisión estimado del 68%, lo cual es razonable dada la naturaleza volátil de las series financieras.

### 6. Diagnóstico de los Residuales
- Se realizó un análisis de los residuales del modelo ajustado con el fin de validar que cumplieran con los supuestos fundamentales de un modelo ARIMA bien especificado. Los resultados indicaron que:
 * La varianza de los residuales es aproximadamente constante y cercana a cero, lo que indica homocedasticidad.
 * La función de autocorrelación de los errores (ACF de los residuales) muestra que no existen correlaciones significativas a lo largo del tiempo, lo cual sugiere que se comportan como ruido blanco.
 * La distribución de los residuales se aproxima a una distribución normal, lo cual es deseable para asegurar la validez de las inferencias.
- Estos resultados respaldan que el modelo cumple con las condiciones necesarias para considerarse un Mejor Estimador Lineal Insesgado (MELI) bajo los supuestos clásicos de los modelos ARIMA.
<img width="1319" height="592" alt="image" src="https://github.com/user-attachments/assets/f8bbfaf2-b1ee-4acd-a015-c15ea3ef4110" /><p align="center"><em>Análisis de los Residuales</em></p>

### 7. Pronóstico 
- Se generó un pronóstico de los siguientes 5 valores en la serie de tiempo, con el objetivo de visualizar el comportamiento esperado en el corto plazo y validar el rendimiento del modelo.
<img width="1301" height="574" alt="image" src="https://github.com/user-attachments/assets/5f4a86ad-25ef-4aad-99ed-c9f0cf12516e" /><p align="center"><em>Pronostico de los siguiente 5 días en la serie de tiempo</em></p>
- Luego de transcurridos los 5 días posteriores a la predicción, se compararon los valores reales con los predichos. Los resultados demostraron que:
 * Las predicciones se mantuvieron dentro del intervalo de confianza del 95% en todos los casos.
 * Esto valida la confiabilidad del modelo en el corto plazo, destacando su capacidad de generar estimaciones consistentes en un horizonte reducido.

---

## 📌 Conclusiones

- l modelo ARIMA implementado permitió capturar la tendencia y estructura temporal de la serie, demostrando ser una herramienta útil para series no estacionarias sin componentes estacionales marcados.
- A pesar del buen ajuste, se recomienda considerar modelos más robustos como SARIMA (para estacionalidad) o ARIMAX (con variables exógenas) en caso de que se detecten patrones estacionales o influencias externas sobre la serie.
- Dado que las series financieras tienden a ser altamente volátiles, lograr una predicción precisa a largo plazo resulta extremadamente complejo.
- Por ello, se recomienda limitar el horizonte de predicción a uno o dos periodos como máximo, ya que más allá de ese punto la incertidumbre se incrementa considerablemente y la precisión disminuye de forma significativa.


---

## 🛠️ Tecnologías Utilizadas

| Herramienta | Uso principal |
|-------------|----------------|
| `R` | Análisis de datos y modelado ARIMA |
| `PositCloud` | Plataforma en línea para programar y ejecutar código en R, sin necesidad de instalaciones locales |
| `forecast` | Modelado ARIMA y predicciones |
| `tseries` | Prueba ADF |
| `quantmod` | Obtención de datos de mercado |
| `ggplot2` | Visualizaciones gráficas |

---

## 📁 Estructura del Repositorio

```plaintext
📦 ARIMA-AMZN
 ┣ 📜 README.md
 ┣ 📂 scripts
 ┃ ┗ arima_model_amazon.R
 ┣ 📂 videos
 ┗ 📽️ Predicción del Precio de las Acciones de Amazon (AMZN) Utilizando Modelos ARIMA en R.mpe4
 ┗ 📽️ (PARTE FINAL) Predicción del Precio de las Acciones de Amazon (AMZN) Utilizando Modelos ARIMA en R.mp4



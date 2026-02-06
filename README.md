# F1 Database Analysis

## Setup

- Descargar dataset desde [Formula 1 World Championship (1950-2020)](https://www.kaggle.com/datasets/rohanrao/formula-1-world-championship-1950-2020)  (Actualizado hasta 2024) y guardarlo en la carpeta `f1_data`.

- Ejecutar el script con `make reduce` para reducir el dataset desde 2021 en adelante y eliminar los originales que ni vamos a utlizzar

- Ejecutar todas las celdas del notebook `cleaning` para generar los detalles de los resultados de las carreras por piloto en todos los fines de semana en un DataFrame `F1_cleaned` y el detalles de los tiempos de lap y pit-stop en `lap_stop_gp`.

## Detalles de los archivos

-  En `pyEDA.ipynb` se encuentra el analisis de métricas representativas por año y las visualizacions del análisi exploratorio en base a las obervaciones del dataFrame principal y adicionales del dataFrame de los lap y pit-stops. 

<!-- - en `r_advancedEDA.ipynb` -->

<!-- - en `driverEDA.ipynb` -->

<!-- - en `predict.ipynb` -->
import numpy as np
import pandas as pd
import os

if not os.path.exists("f1_reduced"):
    os.makedirs("f1_reduced")

year_start = 2021

# nothing in status
status = pd.read_csv("f1_data/status.csv")
status.to_csv("f1_reduced/status.csv", index=False)

# races  -> reduce by "raceId"
races = pd.read_csv("f1_data/races.csv")

raceIds_to_remove = races[races["year"] < year_start]["raceId"]  # raceIds to remove
races = races[races["year"] >= year_start]
races[["raceId", "round", "year", "circuitId", "date", "quali_date", "sprint_date"]].to_csv("f1_reduced/races.csv", index=False)

# constructor_results -> reduce by "raceId"
constructor_results = pd.read_csv("f1_data/constructor_results.csv")
constructor_results = constructor_results[~constructor_results["raceId"].isin(raceIds_to_remove)].copy()
constructor_results.drop(columns=["status"], inplace=True)
constructor_results.to_csv("f1_reduced/constructor_results.csv", index=False)

# # constructor_standings -> reduce by "raceId"
# constructor_standings = pd.read_csv("f1_data/constructor_standings.csv")
# constructor_standings = constructor_standings[~constructor_standings["raceId"].isin(raceIds_to_remove)].copy()
# constructor_standings.drop(columns=["positionText"], inplace=True)
# constructor_standings.to_csv("f1_reduced/constructor_standings.csv", index=False)

# # driver_standings -> reduce by "raceId"
# driver_standings = pd.read_csv("f1_data/driver_standings.csv")
# driver_standings = driver_standings[~driver_standings["raceId"].isin(raceIds_to_remove)].copy()
# driver_standings.drop(columns=["positionText"], inplace=True)
# driver_standings.to_csv("f1_reduced/driver_standings.csv", index=False)

# qualifying -> reduce by "raceId"
qualifying = pd.read_csv("f1_data/qualifying.csv")
qualifying = qualifying[~qualifying["raceId"].isin(raceIds_to_remove)]
qualifying.to_csv("f1_reduced/qualifying.csv", index=False)

# results -> reduce by "raceId"
results = pd.read_csv("f1_data/results.csv")
results_filtered = results[~results["raceId"].isin(raceIds_to_remove)].copy()
results_filtered.drop(columns=["resultId", "position", "positionText"], inplace=True)
results_filtered.to_csv("f1_reduced/results.csv", index=False)

# sprint_results -> reduce by "raceId"
sprint_results = pd.read_csv("f1_data/sprint_results.csv")
sprint_results_filtered = sprint_results[~sprint_results["raceId"].isin(raceIds_to_remove)].copy()
sprint_results_filtered.drop(columns=["resultId", "position", "positionText"], inplace=True)
sprint_results_filtered.to_csv("f1_reduced/sprint_results.csv", index=False)

# lap_times -> reduce by "raceId"
lap_times = pd.read_csv("f1_data/lap_times.csv")
lap_times = lap_times[~lap_times["raceId"].isin(raceIds_to_remove)]
lap_times.drop(columns=["time"], inplace=True)
lap_times.to_csv("f1_reduced/lap_times.csv", index=False)

# pit_stops -> reduce by "raceId"
pit_stops = pd.read_csv("f1_data/pit_stops.csv")
pit_stops = pit_stops[~pit_stops["raceId"].isin(raceIds_to_remove)]
pit_stops.drop(columns=["stop", "time", "duration"], inplace=True)
pit_stops.to_csv("f1_reduced/pit_stops.csv", index=False)

print("Columnas y filas reducidas")

# ==========================
# por integridad de datos, los drivers y constructors que no existen desde el año inicial se eliminan
remover_by_cons_drivers = results[results["raceId"].isin(raceIds_to_remove)]

# races = races[races["year"] >= year_start]
filtered_by_cons_drivers = results[results["raceId"].isin(races["raceId"])]
filtered_sprint_by_cons_drivers = sprint_results[sprint_results["raceId"].isin(races["raceId"])]

filtered_constructors = filtered_by_cons_drivers["constructorId"].unique()
filtered_drivers = filtered_by_cons_drivers["driverId"].unique()
filtered_sprint_constructors = filtered_sprint_by_cons_drivers["constructorId"].unique()
filtered_sprint_drivers = filtered_sprint_by_cons_drivers["driverId"].unique()

all_filtered_constructors = np.union1d(filtered_constructors, filtered_sprint_constructors)
all_filtered_drivers = np.union1d(filtered_drivers, filtered_sprint_drivers)

# constructors -> reduce by "constructorId"
constructors = pd.read_csv("f1_data/constructors.csv")
constructors.drop(columns=["constructorRef", "url"], inplace=True)

# su intersect indica que los constructors aun existen desde el año inicial
constructorId_to_remove = remover_by_cons_drivers["constructorId"].unique()
unique_constructors = np.intersect1d(constructorId_to_remove, all_filtered_constructors)

for constructorId in constructorId_to_remove:
    if constructorId in unique_constructors: continue
    constructors = constructors[constructors["constructorId"] != constructorId]

constructors.to_csv("f1_reduced/constructors.csv", index=False)

# drivers -> reduce by "driverId"
drivers = pd.read_csv("f1_data/drivers.csv")
drivers["name"] = drivers["forename"] + " " + drivers["surname"]

# su intersect indica que los drivers aun existen desde el año inicial
driverId_to_remove = remover_by_cons_drivers["driverId"].unique()
unique_drivers = np.intersect1d(driverId_to_remove, all_filtered_drivers)

for driverId in driverId_to_remove:
    if driverId in unique_drivers: continue
    drivers = drivers[drivers["driverId"] != driverId]

drivers[["driverId", "name", "nationality"]].to_csv("f1_reduced/drivers.csv", index=False)

# circuits -> reduce by "circuitId"
circuits = pd.read_csv("f1_data/circuits.csv")

circuits = circuits[circuits["circuitId"].isin(races["circuitId"])]
circuits[["circuitId", "name", "location", "country"]].to_csv("f1_reduced/circuits.csv", index=False)


print("Drivers y Constructores reducidos")

CREATE TABLE IF NOT EXISTS circuits (
    circuitId INT PRIMARY KEY,              -- ID del circuito
    -- circuitRef TEXT,                        -- Referencia del circuito
    name TEXT,                              -- Nombre del circuito
    location TEXT,                          -- Ubicación del circuito
    country TEXT,                           -- País del circuito
    lat FLOAT,                              -- Latitud del circuito
    lng FLOAT,                              -- Longitud del circuito
    alt INT,                                -- Altitud del circuito
    -- url TEXT                                -- URL del circuito
);

CREATE TABLE IF NOT EXISTS constructors (
    constructorId INT PRIMARY KEY,          -- ID del constructor
    -- constructorRef TEXT,                    -- Referencia del constructor
    name TEXT,                              -- Nombre del constructor
    nationality TEXT                        -- Nacionalidad del constructor
    -- url TEXT                                -- URL del constructor
);

CREATE TABLE IF NOT EXISTS drivers (
    driverId INT PRIMARY KEY,               -- ID del piloto
    -- driverRef TEXT,                         -- Referencia del piloto
    number TEXT,                            -- Número del piloto
    code TEXT,                              -- Código del piloto
    forename TEXT,                          -- Nombre del piloto
    surname TEXT,                           -- Apellido del piloto
    dob DATE,                               -- Fecha de nacimiento del piloto
    nationality TEXT                        -- Nacionalidad del piloto
    -- url TEXT                                -- URL del piloto
);

-- NO CONSIDERADO
-- CREATE TABLE IF NOT EXISTS seasons (
--     year INT PRIMARY KEY,                   -- Año de la temporada
--     url TEXT                                -- URL de la temporada
-- );

CREATE TABLE IF NOT EXISTS races (
    raceId INT PRIMARY KEY,                 -- ID de la carrera
    year INT,                               -- Año de la carrera
    round INT,                              -- Ronda de la carrera
    circuitId INT,                          -- ID del circuito
    name TEXT,                              -- Nombre de la carrera
    date DATE,                              -- Fecha de la carrera
    time TEXT,                              -- Hora de la carrera
    -- url TEXT,                               -- URL de la carrera
    fp1_date DATE,                          -- Fecha de la primera prueba
    fp1_time TEXT,                          -- Hora de la primera prueba
    fp2_date DATE,                          -- Fecha de la segunda prueba
    fp2_time TEXT,                          -- Hora de la segunda prueba
    fp3_date DATE,                          -- Fecha de la tercera prueba
    fp3_time TEXT,                          -- Hora de la tercera prueba
    quali_date DATE,                        -- Fecha de la cuarta prueba
    quali_time TEXT,                        -- Hora de la cuarta prueba
    sprint_date DATE,                       -- Fecha de la quinta prueba
    sprint_time TEXT,                       -- Hora de la quinta prueba  
    FOREIGN KEY (circuitId) REFERENCES circuits (circuitId)
);

CREATE TABLE IF NOT EXISTS status (
    statusId INT PRIMARY KEY,               -- ID del estado
    status TEXT                             -- Estado del resultado
);

CREATE TABLE IF NOT EXISTS results (
    resultId INT PRIMARY KEY,               -- ID del resultado
    raceId INT,                             -- ID de la carrera
    driverId INT,                           -- ID del piloto
    constructorId INT,                      -- ID del constructor
    number TEXT,                            -- Número del piloto
    grid INT,                               -- Posición de la grilla inicial
    position TEXT,                          -- Posición final de la carrera
    -- positionText TEXT,                      -- Texto de la posición
    positionOrder INT,                      -- Orden de la posición
    points FLOAT,                           -- Puntos obtenidos
    laps INT,                               -- Número de vueltas
    time TEXT,                              -- Tiempo total
    milliseconds INT,                       -- Milisegundos
    fastestLap INT,                         -- Vuelta más rápida
    rank INT,                               -- Posición de la vuelta más rápida
    fastestLapTime TEXT,                    -- Tiempo de la vuelta más rápida
    fastestLapSpeed TEXT,                   -- Velocidad de la vuelta más rápida
    statusId INT,                           -- ID del estado
    FOREIGN KEY (raceId) REFERENCES races (raceId),
    FOREIGN KEY (driverId) REFERENCES drivers (driverId),
    FOREIGN KEY (constructorId) REFERENCES constructors (constructorId),
    FOREIGN KEY (statusId) REFERENCES status (statusId)
);

CREATE TABLE IF NOT EXISTS qualifying (
    qualifyId INT PRIMARY KEY,              -- ID de la calificación
    raceId INT,                             -- ID de la carrera
    driverId INT,                           -- ID del piloto
    constructorId INT,                      -- ID del constructor
    number TEXT,                            -- Número del piloto
    position INT,                           -- Posición de la calificación
    q1 TEXT,                                -- Primer tiempo de calificación
    q2 TEXT,                                -- Segundo tiempo de calificación
    q3 TEXT,                                -- Tercer tiempo de calificación
    FOREIGN KEY (raceId) REFERENCES races (raceId),
    FOREIGN KEY (driverId) REFERENCES drivers (driverId),
    FOREIGN KEY (constructorId) REFERENCES constructors (constructorId)
);

-- === Describe los tiempos de parada ===
CREATE TABLE IF NOT EXISTS pit_stops (
    raceId INT,                             -- ID de la carrera
    driverId INT,                           -- ID del piloto
    stop INT,                               -- Parada
    lap INT,                                -- Vuelta
    time TEXT,                              -- Tiempo
    duration TEXT,                          -- Duración
    milliseconds INT,                       -- Milisegundos
    PRIMARY KEY (raceId, driverId, stop),
    FOREIGN KEY (raceId) REFERENCES races (raceId),
    FOREIGN KEY (driverId) REFERENCES drivers (driverId)
);

-- === Describe los tiempos de vuelta ===
CREATE TABLE IF NOT EXISTS lap_times (
    raceId INT,                             -- ID de la carrera
    driverId INT,                           -- ID del piloto
    lap INT,                                -- Vuelta
    position INT,                           -- Posición
    time TEXT,                              -- Tiempo
    milliseconds INT,                       -- Milisegundos
    PRIMARY KEY (raceId, driverId, lap),
    FOREIGN KEY (raceId) REFERENCES races (raceId),
    FOREIGN KEY (driverId) REFERENCES drivers (driverId)
);

-- === Describe los puntos desde los pilotos ===
CREATE TABLE IF NOT EXISTS driver_standings (
    driverStandingsId INT PRIMARY KEY,      -- ID de los puntos del piloto
    raceId INT,                             -- ID de la carrera
    driverId INT,                           -- ID del piloto
    points FLOAT,                           -- Puntos
    position INT,                           -- Posición
    -- positionText TEXT,                      -- Texto de la posición
    wins INT,                               -- Victorias
    FOREIGN KEY (raceId) REFERENCES races (raceId),
    FOREIGN KEY (driverId) REFERENCES drivers (driverId)
);

-- === Describe los puntos desde los constructores ===
CREATE TABLE IF NOT EXISTS constructor_standings (
    constructorStandingsId INT PRIMARY KEY,  -- ID de los puntos del constructor
    raceId INT,                              -- ID de la carrera
    constructorId INT,                       -- ID del constructor
    points FLOAT,                            -- Puntos
    position INT,                            -- Posición
    -- positionText TEXT,                       -- Texto de la posición
    wins INT,                                -- Victorias
    FOREIGN KEY (raceId) REFERENCES races (raceId),
    FOREIGN KEY (constructorId) REFERENCES constructors (constructorId)
);

-- === Describe los puntos generales de la carrera ===
CREATE TABLE IF NOT EXISTS constructor_results (
    constructorResultsId INT PRIMARY KEY,   -- ID de los puntos del constructor
    raceId INT,                             -- ID de la carrera
    constructorId INT,                      -- ID del constructor
    points FLOAT,                           -- Puntos
    status TEXT,                            -- Estado
    FOREIGN KEY (raceId) REFERENCES races (raceId),
    FOREIGN KEY (constructorId) REFERENCES constructors (constructorId)
);

CREATE TABLE IF NOT EXISTS sprint_results (
    resultId INT PRIMARY KEY,               -- ID del resultado
    raceId INT,                             -- ID de la carrera
    driverId INT,                           -- ID del piloto
    constructorId INT,                      -- ID del constructor
    number TEXT,                            -- Número del piloto
    grid INT,                               -- Posición de la grilla
    position TEXT,                          -- Posición final
    -- positionText TEXT,                      -- Texto de la posición
    positionOrder INT,                      -- Orden de la posición
    points FLOAT,                           -- Puntos obtenidos
    laps INT,                               -- Número de vueltas
    time TEXT,                              -- Tiempo total
    milliseconds INT,                       -- Milisegundos
    fastestLap INT,                         -- Vuelta más rápida
    rank INT,                               -- Rango
    fastestLapTime TEXT,                    -- Tiempo de la vuelta más rápida
    fastestLapSpeed TEXT,                   -- Velocidad de la vuelta más rápida
    statusId INT,                           -- ID del estado
    FOREIGN KEY (raceId) REFERENCES races (raceId),
    FOREIGN KEY (driverId) REFERENCES drivers (driverId),
    FOREIGN KEY (constructorId) REFERENCES constructors (constructorId),
    FOREIGN KEY (statusId) REFERENCES status (statusId)
);
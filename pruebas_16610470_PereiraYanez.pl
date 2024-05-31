/*
Script de Pruebas N°1
Script actualizado al 11/04/2024 - 01:28 AM

station(1, "Los Heroes", t, 50, E1),
station(2, "La moneda", r, 30, E2),
station(3, "Universidad de Chile", t, 30, E3),
line(1, "L1", “UIC 60 ASCE”, [], L1),
section(E1, E2, 500, 100, S0),
section(E2, E3, 550, 100, S1),
lineAddSection(L1, S0, L1_1),
lineAddSection(L1_1, S1, L1_2),
subway(1, "Metro Santiago", Sub0),
isLine(L1_2),
% isLine(L1_1), % False porque falta estación terminal
% subwayAddLine(Sub0, [L1_1], Sub2). % False porque la línea es inconsistente
subwayAddLine(Sub0, [L1_2], Sub2).

*/

/*
Script de Prueba - Ejemplos

% creando una nueva estación
station( 0, "San Alberto Hurtado", "t", 35, ST0),
station( 1, "USACH", "c", 30, ST1),
station( 2, "Estación Central", "c", 45, ST2),
station( 3, "ULA", "r", 45, ST3),
station( 4, "República", "r", 45, ST4),
station( 5, "Los Héroes", "c", 60, ST5),
station( 6, "Toesca", "r", 40, ST6),
station( 7, "La Moneda", "r", 40, ST7),
station( 8, "Cochera", "m", 3600, ST8),
station( 9, "Parque OHiggins", "r", 30, ST9),
station( 10, "San Pablo", "t", 40, ST10),
station( 11, "Los Dominicos", "t", 60, ST11),

% creando una nueva sección
section( ST0, ST1, 2, 50, S0),
section( ST1, ST2, 2.5, 55, S1),
section( ST2, ST3, 1.5, 30, S2),
section( ST3, ST4, 3, 45, S3),
section( ST4, ST5, 3, 45, S4),
section( ST4, ST6, 1.4, 50, S5),
section( ST5, ST8, 2,  40, S6_C),
section( ST0, ST10, 3,  200, S7),
section( ST7, ST11, 7, 200, S8),

% creando lineas
line( 0, "Línea 0", "UIC 60 ASCE", [ ], L0),
line( 1, "Línea 1", "100 R.E.", [S0, S1, S2, S3, S5, S6_C, S7, S8], L1),

% calculando largo, distancia y costo
lineLength(L1, LENGTH, DISTANCE, COST),

% determinar trayecto entre estaciones, junto con su distancia y costo.
lineSectionLength(L1, "USACH", "Los Héroes", SECCIONES, DISTANCIA, COSTO),

% añadir tramo a una linea
lineAddSection(L0, S0, L0_1).


*/ 
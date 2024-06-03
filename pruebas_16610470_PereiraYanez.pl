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
% creando type's
type("Regular", R),
type("Mantencion", M),
type("Combinacion", C),
type("Terminal", T),

% creando una nueva estación
station(0, "San Alberto Hurtado", T, 35, ST0),
station(1, "USACH", C, 30, ST1),
station(2, "Estación Central", C, 45, ST2),
station(3, "ULA", R, 45, ST3),
station(4, "República", R, 45, ST4),
station(5, "Los Héroes", C, 60, ST5),
station(6, "La Moneda", R, 40, ST6),
station(7, "U. de Chile", C, 40, ST7),
station(8, "Santa Lucia", T, 45, ST8),
station(9, "Cochera", M, 3600, ST9),

% creando una nueva sección
section(ST0, ST1, 2, 50, S0),
section(ST1, ST2, 2.5, 55, S1),
section(ST2, ST3, 1.5, 30, S2),
section(ST3, ST4, 3, 45, S3),
section(ST4, ST5, 3, 45, S4),
section(ST5, ST6, 1.4, 50, S5),
section(ST6, ST7, 2,  40, S6),
section(ST7, ST8, 3,  200, S7),
section(ST8, ST9, 3,  200, S8), %Seccion que Incluye cochera
section(ST6, ST8, 3,  200, S9), 

% creando lineas
line(0, "Línea 0", "UIC 60 ASCE", [ ], L0),
line(1, "Línea 1", "100 R.E.", [S0, S1, S2, S3, S4, S5, S6, S7], L1),
%line(1, "Línea 1", "100 R.E.", [S0, S1, S2, S3, S0, S5, S6, S7], L1), %False estaciones repetidas
%line(1, "Línea 1", "100 R.E.", [S0, S1, S2, S3, S4, S5, S6, S8], L1), %False no termina en terminal
%line(1, "Línea 1", "100 R.E.", [S0, S1, S2, S3, S4, S5, S6, S9], L1), %False estaciones no comunican


% calculando largo, distancia y costo
lineLength(L1, LENGTH, DISTANCE, COST),

% determinar trayecto entre estaciones, junto con su distancia y costo.
lineSectionLength(L1, "USACH", "Los Héroes", SECCIONES, DISTANCIA, COSTO),

% añadir tramo a una linea
lineAddSection(L0, S0, L0_1),

% evaluando linea
%isLine(L0_1). %false por que no tiene estacion terminal
%isLine(L0). %false
isLine(L1), %true

% creando carType's
car_type("Central", CT),
car_type("Terminal", TR),

% creando carros de pasajeros.
pcar(0, 90, "NS-74", CT, PC0),
pcar(1, 100, "NS-74", TR, PC1),
pcar(2, 150, "NS-74", TR, PC2),
pcar(3, 90, "NS-74", CT, PC3),
pcar(4, 100, "AS-2014", CT, PC4),
pcar(5, 100, "AS-2014", CT, PC5),
pcar(6, 100, "AS-2016", CT, PC6),
pcar(7, 120, "NS-74", TR, PC7),

% creando train
train(0, "CAF", "UIC 60 ASCE", 60, [ ], T0),
train(1, "CAF", "UIC 60 ASCE", 70, [PC1, PC0, PC3, PC2], T1),
train(2, "CAF", "UIC 60 ASCE", 80, [PC1, PC2], T1_2),

% agregando pcar a train (indice empieza en 0)
trainAddCar(T0, PC1, 0, T2),
trainAddCar(T2, PC0, 1, T3),
trainAddCar(T3, PC3, 2, T4),
trainAddCar(T4, PC2, 3, T5), %T5 es identico a T1
%trainAddCar(T1, PC1, 2, T1_2), %False xq PC1 ya existe en T1
trainAddCar(T1, PC7, 2, T1_3), %T1_3 tiene carro terminal en medio

% eliminando pcar a train (indice empieza en 0)
trainRemoveCar(T4, 2, T4_2), %T4_2 es indentico a T3
trainRemoveCar(T4, 1, T4_3),

% evaluando si es tren
%isTrain(T4). %False pq no termina en terminal.
%isTrain(T1_3), %False pq tiene tren terminal en medio
isTrain(T1_2), %True pq es tren en su estructura minima t-t
isTrain(T1), %True

% calculando capacidad del tren
trainCapacity(T0, C_T0), %C_T0 = 0
trainCapacity(T1, C_T1). %C_T1 = 430


*/ 
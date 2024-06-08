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

%--------------------------------------------------------------------------------

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
station(10, "La Cisterna", T, 35, ST10),
station(11, "El Parron", R, 30, ST11),
station(12, "Lo Ovalle", C, 40, ST12),
station(13, "Ciudad del Niño", T, 25, ST13),
station(20, "Cerrillos", T, 30, ST20),
station(21, "Lo Valledor", C, 40, ST21),
station(22, "Pedro Aguirre Cerda", R, 20, ST22),
station(23, "Franklin", T, 40, ST23),

% creando una nueva sección
section(ST0, ST1, 2, 50, S0),
section(ST1, ST2, 2.5, 55, S1),
section(ST2, ST3, 1.5, 30, S2),
section(ST3, ST4, 3, 45, S3),
section(ST4, ST5, 3, 45, S4),
section(ST5, ST6, 1.4, 50, S5),
section(ST6, ST7, 2, 40, S6),
section(ST7, ST8, 3, 20, S7),
section(ST8, ST9, 3, 50, S8), %Seccion que Incluye cochera
section(ST6, ST8, 3, 30, S9), 
section(ST10, ST11, 4, 50, S10), 
section(ST11, ST12, 3, 40, S11), 
section(ST12, ST13, 2.5, 45, S12), 
section(ST20, ST21, 3,  50, S20), 
section(ST21, ST22, 4, 40, S21), 
section(ST22, ST23, 1.5, 50, S22), 

% creando lineas
line(0, "Línea 0", "UIC 60 ASCE", [ ], L0),
line(1, "Línea 1", "100 R.E.", [S0, S1, S2, S3, S4, S5, S6, S7], L1),
line(2, "Línea 2", "100 R.E.", [S10, S11, S12], L2),
line(6, "Línea 6", "100 R.E.", [S20, S21, S22], L6),
%line(1, "Línea 1", "100 R.E.", [S0, S1, S2, S3, S0, S5, S6, S7], L1), %False estaciones repetidas
%line(1, "Línea 1", "100 R.E.", [S0, S1, S2, S3, S4, S5, S6, S8], L1), %False no termina en terminal
%line(1, "Línea 1", "100 R.E.", [S0, S1, S2, S3, S4, S5, S6, S9], L1), %False estaciones no comunican

% calculando largo, distancia y costo
lineLength(L1, LengthL1, DistanceL1, CostL1), %LengthL1=9, DistanceL1=18.4, CostL1=335
lineLength(L2, LengthL2, DistanceL2, CostL2), %LengthL2=4, DistanceL2=9.5, CostL2=135
lineLength(L6, LengthL6, DistanceL6, CostL6), %LengthL6=4, DistanceL6=8.5, CostL6=140

% determinar trayecto entre estaciones, junto con su distancia y costo.
lineSectionLength(L1, "USACH", "Los Héroes", SectionL1, DisSectionL1, CostSectionL1), %SectionL1, DisSectionL1=10 , CostSectionL1=175 
lineSectionLength(L2, "La Cisterna", "Lo Ovalle", SectionL2, DisSectionL2, CostSectionL2), %SectionL2, DisSectionL2=7 , CostSectionL2=90 
lineSectionLength(L6, "Cerrillos", "Franklin", SectionL6, DisSectionL6, CostSectionL6), %SectionL6, DisSectionL6=8.5 , CostSectionL6=140  

% añadir tramo a una linea
lineAddSection(L0, S0, L0_1),
lineAddSection(L0_1, S4, L0_2),
lineAddSection(L0_2, S7, L0_3),

% evaluando linea
%isLine(L0_1). %false por que no tiene estacion terminal
%isLine(L0). %false pq esta vacia
%isLine(L0_3). %false pq no esta conectada
isLine(L1), %true
isLine(L2), %true
isLine(L6), %true

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
pcar(8, 150, "NS-74", TR, PC8),

% creando train
train(0, "CAF", "UIC 60 ASCE", 60, [ ], T0),
train(1, "CAF", "UIC 60 ASCE", 70, [PC1, PC0, PC3, PC2], T1),
train(2, "ALSTOM", "UIC 60 ASCE", 80, [PC7, PC8], T2),

% agregando pcar a train (indice empieza en 0)
trainAddCar(T0, PC1, 0, T0_1),
trainAddCar(T0_1, PC0, 1, T0_2),
trainAddCar(T0_2, PC3, 2, T0_3),
trainAddCar(T0_3, PC2, 3, T0_4), %T0_4 es identico a en pcar T1
%trainAddCar(T1, PC1, 2, T1_2), %False xq PC1 ya existe en T1
trainAddCar(T1, PC7, 2, T1_3), %T1_3 tiene carro terminal en medio

% eliminando pcar a train (indice empieza en 0)
trainRemoveCar(T0_4, 2, T0_4_2), 
trainRemoveCar(T0_4_2, 1, T0_4_3), %Tren con estructura T-T

% evaluando si es tren
%isTrain(T0). %False pq no termina en terminal.
%isTrain(T1_3), %False pq tiene tren terminal en medio
isTrain(T0_4_2), %True pq es tren en su estructura T-C-T
isTrain(T2), %True pq es tren en su estructura minima T-T
isTrain(T1), %True

% calculando capacidad del tren
trainCapacity(T0, C_T0), %C_T0 = 0
trainCapacity(T1, C_T1), %C_T1 = 430
trainCapacity(T2, C_T2), %C_T2 = 250

% crando drivers
driver(0, "Eren Yeager", "CAF", D0),
driver(1, "Oliver Atom", "ALSTOM", D1),
driver(2, "Kakaroto", "CAF", D2),
driver(3, "Levy Ackerman", "ALSTOM", D3),
driver(4, "Hanamichi Sakuragi", "CAF", D4),
driver(5, "Monkey D. Luffy", "ALSTOM", D5),

% crando subway
subway(0, "Metro Santiago", SW0),

% agregando train a subway
subwayAddTrain(SW0, [T1], SW1), % True
subwayAddTrain(SW1, [T2], SW1_2), % True
subwayAddTrain(SW0, [T1, T2], SW3), % True, otra forma de asignar trenes a subway SW1_2 = SW3
%subwayAddTrain(SW3, [T1_3], SW3_1), % False pq T1_3 no cumple con condicion isTrain
%subwayAddTrain(SW3, [T1], SW3_2), %False pq T1 ya esta agregada

% agregando lines a subway
subwayAddLine(SW1_2, [L1], SW2), % True
subwayAddLine(SW2, [L2, L6], SW2_2), %True
subwayAddLine(SW3, [L2, L6], SW5), %True
%subwayAddLine(Sw2_2, [L1], Sw2_3), %False pq L1 ya existe
%subwayAddLine(SW0, [L0], SW4). %False pq L0 no cumple con condicion de ser linea valida

% agregando drivers a subway
subwayAddDriver(SW2_2, [D0], SW6), %True
subwayAddDriver(SW6, [D1, D2, D3], SW6_1), %True
subwayAddDriver(SW5, [D4, D5], SW7), %True
%subwayAddDriver(SW6_1, [D0], SW6_2). %False, pq D0 ya esta agregado a SW6_1

% pasando subway a string
subwayToString(SW6_1, StringSW6_1),
subwayToString(SW7, StringSW7),

% cambiando tiempo de parada de una estacion
subwaySetStationStoptime(SW6_1, "Los Héroes", 90, SW8),
subwaySetStationStoptime(SW8, "El Parron", 25, SW8_1),
subwaySetStationStoptime(SW8_1, "Franklin", 50, SW8_2),
subwaySetStationStoptime(SW0, "Franklin", 50, SW0_1), %Subway vacio, retorna subway original

% asignar tren a linea
subwayAssignTrainToLine(SW8_2, 1, 1, SW9),
subwayAssignTrainToLine(SW9, 2, 2, SW9_1).


*/ 


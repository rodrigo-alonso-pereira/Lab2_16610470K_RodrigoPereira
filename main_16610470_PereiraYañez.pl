% Constructor Type
% TODO: Cambiar nombre por stationType
type(Name, [Name]).

% Obtiene nombre de Type 
type_get_name(Type, Name) :-
    type(Name,Type).


%-----------------------------------------------------------------------------------------------
/*
Req 2: TDA station - constructor

- Descripcion = Predicado constructor de una estación de metro.
- MP: station/5.
*/
station(Id, Name, Type, StopTime, [Id, Name, Type, StopTime]).

% Obtiene Id de Station
station_get_id(Station, Id) :-
    station(Id, _, _, _, Station).

% Obtiene Name de Station
station_get_name(Station, Name) :-
    station(_, Name, _, _, Station).

% Obtiene Type de Station
station_get_type(Station, Type) :-
    station(_, _, Type, _, Station).

% Obtiene StopTime de Station
station_get_stop_time(Station, StopTime) :-
    station(_, _, _, StopTime, Station).


%-----------------------------------------------------------------------------------------------
/*
Req 3: TDA section - constructor.
 
- Descripcion = Predicado que permite establecer enlaces entre dos estaciones.
- MP: section/5.
*/
section(Point1, Point2, Distance, Cost, [Point1, Point2, Distance, Cost]).

% Obtiene Point1 de Section
section_get_point1(Section, Point1) :-
    section(Point1, _, _, _, Section).

% Obtiene Point2 de Section
section_get_point2(Section, Point2) :-
    section(_, Point2, _, _, Section).

% Obtiene Distance de Section
section_get_distance(Section, Distance) :-
    section(_, _, Distance, _, Section).

% Obtiene Cost de Section
section_get_cost(Section, Cost) :-
    section(_, _, _, Cost, Section).


%-----------------------------------------------------------------------------------------------
/*
Req 4: TDA line - constructor.
 
- Descripcion = Predicado que permite crear una línea.
- MP: line/5.
*/
line(Id, Name, RailType, Sections, [Id, Name, RailType, Sections]).

% Obtiene el id de una linea
line_get_id(Line, Id) :-
    line(Id, _, _, _, Line).

% Obtiene el name de una linea
line_get_name(Line, Name) :-
    line(_, Name, _, _, Line).

% Obtiene el name de una linea
line_get_railType(Line, RailType) :-
    line(_, _, RailType, _, Line).

% Obtiene lista de secciones de una linea
line_get_sections(Line, Sections) :-
    line(_, _, _, Sections, Line).


%-----------------------------------------------------------------------------------------------
/*
Req 5: TDA line - Otros predicados.
 
- Descripcion = Predicado que permite determinar el largo total de una línea 
                (cantidad de estaciones), la distancia (en la unidad de medida expresada 
                en cada tramo) y su costo.
- MP: lineLength/4.
- MS: line_get_sections/2,
	  (ListSections = [] ->  
    	Length = 0,
        Distance = 0,
        Cost = 0
      ;
      sum_element_list/3,
	  sum_element_list/3,
      new_name_station_list/2,
      delete_duplicates/2,
      length_list/2.
*/

% Imprimir elementos por consola
print_element(Element) :-
    write(Element), 
    nl,
    nl.

% Evalua si existe elemento en lista
belongs(Element, [Element|_]) :- !.

belongs(Element, [_|Tail]) :- 
    belongs(Element, Tail).

% Suma los elementos de una lista de TDAs
sum_element_list([], 0, _).

sum_element_list([Head|Tail], TotalSum, Predicate) :-
    call(Predicate, Head, Element),
    sum_element_list(Tail, Acc, Predicate),
    TotalSum is Acc + Element.

% Contar elemento de una lista
length_list([], 0).

length_list([_|Tail], Length) :-
    length_list(Tail, Acc),
    Length is Acc + 1.

% Crear sublista de nombre estaciones
new_name_station_list([], []).

new_name_station_list([Head|Tail], NewList) :-
    section_get_point1(Head, Station1),
    section_get_point2(Head, Station2),
    station_get_name(Station1, Name1),
    station_get_name(Station2 , Name2),
    new_name_station_list(Tail, Acc),
    append([Name1, Name2], Acc, NewList).

% Remover duplicados de una lista
delete_duplicates([], []).

delete_duplicates([Head|Tail], NewList) :-
    belongs(Head, Tail),
    delete_duplicates(Tail, NewList).

delete_duplicates([Head|Tail], [Head|NewList]) :-
    not(belongs(Head, Tail)),
    delete_duplicates(Tail, NewList).

lineLength(Line, Length, Distance, Cost) :-
    line_get_sections(Line, ListSections),
    (ListSections = [] ->  
    	Length = 0,
        Distance = 0,
        Cost = 0
    ;
    	sum_element_list(ListSections, Distance, section_get_distance),
    	sum_element_list(ListSections, Cost, section_get_cost),
    	new_name_station_list(ListSections, ListStation),
    	delete_duplicates(ListStation, ListStationClean),
    	length_list(ListStationClean, Length)).
    

%-----------------------------------------------------------------------------------------------
/*
Req 6: TDA line - otras funciones.
 
- Descripcion = Predicado que permite determinar el trayecto entre una estación origen y 
                una final, la distancia de ese trayecto y el costo.
- MP: lineLength/6.
- MS: section_get_point1/2,
    section_get_point2/2,
    station_get_name/2,
    station_get_name/2,
    ((Name1 == StationStart ; Flag == 'True') ->  
    	NewFlag = 'True',
        append([Section], Acc, FilterSectionList),
        ((Name1 == StationEnd ; Name2 == StationEnd) ->  
        	filter_section_list/5
        ;
        	filter_section_list/5)
    ;
    	filter_section_list/5).
*/

% Filtrar lista de secciones segun estacion de inicio y fin
filter_section_list([], _, _, _, []).

filter_section_list([Section|Tail], StationStart, StationEnd, Flag, FilterSectionList) :-
    section_get_point1(Section, Station1),
    section_get_point2(Section, Station2),
    station_get_name(Station1, Name1),
    station_get_name(Station2, Name2),
    ((Name1 == StationStart ; Flag == 'True') ->  
    	NewFlag = 'True',
        append([Section], Acc, FilterSectionList),
        ((Name1 == StationEnd ; Name2 == StationEnd) ->  
        	filter_section_list(Tail, StationStart, StationEnd, 'False', Acc)
        ;
        	filter_section_list(Tail, StationStart, StationEnd, NewFlag, Acc))
    ;
    	filter_section_list(Tail, StationStart, StationEnd, Flag, FilterSectionList)).
    
lineSectionLength(Line, StationStart, StationEnd, Sections, Distance, Cost) :-
    line_get_sections(Line, SectionList),
    filter_section_list(SectionList, StationStart, StationEnd, 'False', Sections),
    sum_element_list(Sections, Distance, section_get_distance),
    sum_element_list(Sections, Cost, section_get_cost).


%-----------------------------------------------------------------------------------------------
/*
Req 7: TDA line - modificador.
 
- Descripcion = Predicado que permite añadir tramos a una línea.
- MP: lineAddSection/3.
- MS: line_get_sections/2,
      not(belongs/2),
      line_get_id/2,
      line_get_name/2,
      line_get_railType/2,
      append(SectionList, [Section], NewSectionList),
      line/5.
*/

lineAddSection(Line, Section, NewLine) :-
    line_get_sections(Line, SectionList),
    not(belongs(Section, SectionList)), %Verifica que seccion no este duplicada
    line_get_id(Line, Id),
    line_get_name(Line, Name),
    line_get_railType(Line, RailType),
    append(SectionList, [Section], NewSectionList),
    line(Id, Name, RailType, NewSectionList, NewLine).


%-----------------------------------------------------------------------------------------------
/*
Req 8: TDA line - modificador.
 
- Descripcion = Predicado que permite determinar si un elemento cumple con las restricciones 
                señaladas en apartados anteriores en relación a las estaciones y tramos para 
                poder conformar una línea.
- MP: isLine/1.
- MS: line_get_sections/2,
      is_empty_line/1,
      partial_station_list/2,
      last/2,
      section_get_point2/2,
      append(ParcialStationList, [LastStation], StationList),
      is_station/1,
      is_terminal/1,
      is_section_communicates/1.
*/    

% Crear sublista con estaciones iniciales de cada seccion de una linea
partial_station_list([], []).

partial_station_list([Section|Tail], NewStationList) :-
    section_get_point1(Section, Station1),
    partial_station_list(Tail, AccList),
    append([Station1], AccList, NewStationList).

% Recorre lista de TDA's y obtiene lista de un elemento en particular
get_element_from_list_tda([], _, []).

get_element_from_list_tda([First|Tail], Predicate, ListElement) :-
    call(Predicate, First, Element),
    get_element_from_list_tda(Tail, Predicate, AccList),
    append([Element], AccList, ListElement).

% Recorre lista verificando si todos los elemento son iguales
all_element_equal([]). % Si esta vacia es true

all_element_equal([_]). % Si tiene un elemento es true

all_element_equal([Element, Element|Tail]) :-
    all_element_equal([Element|Tail]).

% Recorre lista verificando si todos los elemento son diferentes
all_element_different([]).

all_element_different([_]).

all_element_different([First|Tail]) :-
   not(belongs(First, Tail)),
    all_element_different(Tail).

% Evalua si station cumple con sus condiciones
is_station(StationList) :-
    get_element_from_list_tda(StationList, station_get_id, IdList),
    get_element_from_list_tda(StationList, station_get_name, NameList),
    all_element_different(IdList),
    all_element_different(NameList).

% Entrega primer elemento de lista
first([First|_], First).

% Evalua si primera y ultima estacion son terminal
is_terminal(StationList) :-
    first(StationList, Station1),
    station_get_type(Station1, Type1),
    type_get_name(Type1, NameType1),
    last(StationList, Station2),
    station_get_type(Station2, Type2),
    type_get_name(Type2, NameType2),
    NameType1 == "Terminal",
    NameType2 == "Terminal".

% Evalua si lista esta vacia
is_empty([]).

% Crear sublista con estaciones iniciales y finales de cada seccion de una linea
full_station_list([], []).

full_station_list([Section|Tail], NewStationList) :-
    section_get_point1(Section, Station1),
    section_get_point2(Section, Station2),
    full_station_list(Tail, AccList),
    append([Station1, Station2], AccList, NewStationList).

% Evalua si las secciones estan conectadas
check_pair_station([_, _]).

check_pair_station([_, X, X | Tail]) :-
    check_pair_station([X|Tail]).

% Evalua si las secciones se comunican
is_section_communicates(SectionList) :-
    full_station_list(SectionList, StationList),
    check_pair_station(StationList).

isLine(Line) :-
    line_get_sections(Line, SectionList),
    not(is_empty(SectionList)), !, %Verifica que line no este vacia
    partial_station_list(SectionList, ParcialStationList),
    last(SectionList, LastSection),
    section_get_point2(LastSection, LastStation),
    append(ParcialStationList, [LastStation], StationList),
    is_station(StationList), !,
    is_terminal(StationList), !,
    is_section_communicates(SectionList).

%-----------------------------------------------------------------------------------------------

% IMPLEMENTACIONES PARA FUNCIONAMIENTO PREDICADO pcar.

% Constructor de carType
car_type(Name, [Name]).

car_type_get_name(CarType, Name) :-
    type(Name,CarType).

/*
Req 9: TDA pcar - Constructor.
 
- Descripcion = Permite crear los carros de pasajeros que conforman un convoy. Los carros 
                pueden ser de tipo terminal (tr) o central (ct).

- MP: pcar/5.
*/      

pcar(Id, Capacity, Model, Type, [Id, Capacity, Model, Type]).

% Obtiene Id de pcar
pcar_get_id(Pcar, Id) :-
    pcar(Id, _, _, _, Pcar).

% Obtiene Capacity de pcar
pcar_get_capacity(Pcar, Capacity) :-
    pcar(_, Capacity, _, _, Pcar).

% Obtiene Model de pcar
pcar_get_model(Pcar, Model) :-
    pcar(_, _, Model, _, Pcar).

% Obtiene Type de pcar
pcar_get_type(Pcar, Type) :-
    pcar(_, _, _, Type, Pcar).


%-----------------------------------------------------------------------------------------------
/*
Req 10: TDA train - Constructor.
 
- Descripcion = Predicado que permite crear un tren o convoy.

- MP: train/6.
*/   

train(Id, Maker, RailType, Speed, Pcars, [Id, Maker, RailType, Speed, Pcars]).

% GET DE TDA train

% Obtiene Id de train
train_get_id(Train, Id) :-
    train(Id, _, _, _, _, Train).

% Obtiene Maker de train
train_get_maker(Train, Maker) :-
    train(_, Maker, _, _, _, Train).

% Obtiene RailType de train
train_get_rail_type(Train, RailType) :-
    train(_, _, RailType, _, _, Train).

% Obtiene Speed de train
train_get_speed(Train, Speed) :-
    train(_, _, _, Speed, _, Train).

% Obtiene Pcars de train
train_get_pcars(Train, Pcars) :-
    train(_, _, _, _, Pcars, Train).

%-----------------------------------------------------------------------------------------------

% IMPLEMENTACIONES PARA FUNCIONAMIENTO PREDICADO trainAddCar.

% Permite agregar un elemento en una lista con posicion dada
add_element_list([], Element, 0, [Element]) :- !.

add_element_list(List, Element, 0, [Element|List]) :- !.

add_element_list([First|Tail], Element, Position, [First|NewTail]) :-
    Position > 0,
    NewPosition is Position - 1,
    add_element_list(Tail, Element, NewPosition, NewTail).


/*
Req 11: TDA train - Modificador.
 
- Descripcion = Predicado que permite añadir carros a un tren en una posición dada.

- MP: trainAddCar/4.
- MS: train_get_id/2,
      train_get_maker/2,
      train_get_rail_type/2,
      train_get_speed/2,
      train_get_pcars/2,
      not(belongs/2),
      add_element_list/4,
      train/6.
*/   

trainAddCar(Train, Pcar, Position, NewTrain) :-
    train_get_id(Train, Id),
    train_get_maker(Train, Maker),
    train_get_rail_type(Train, RailType),
    train_get_speed(Train, Speed),
    train_get_pcars(Train, PcarList),
    not(belongs(Pcar, PcarList)),
    add_element_list(PcarList, Pcar, Position, NewPcarList),
    train(Id, Maker, RailType, Speed, NewPcarList, NewTrain), !.

%-----------------------------------------------------------------------------------------------

% IMPLEMENTACIONES PARA FUNCIONAMIENTO PREDICADO trainRemoveCar.

% Permite eliminar un elemento de una lista en una posicion dada
remove_element_list([], 0, []).

remove_element_list([_|Tail], 0, Tail).

remove_element_list([First|Tail], Position, [First|NewTail]) :-
    Position > 0,
    NewPosition is Position - 1,
    remove_element_list(Tail, NewPosition, NewTail).

/*
Req 12: TDA train - Modificador.
 
- Descripcion = Predicado que permite eliminar un carro desde el convoy.

- MP: trainRemoveCar/3.
- MS: train_get_id/2,
      train_get_maker/2,
      train_get_rail_type/2,
      train_get_speed/2,
      train_get_pcars/2,
      remove_element_list/3,
      train/6.
*/   

trainRemoveCar(Train, Position, NewTrain) :-
    train_get_id(Train, Id),
    train_get_maker(Train, Maker),
    train_get_rail_type(Train, RailType),
    train_get_speed(Train, Speed),
    train_get_pcars(Train, PcarList),
    remove_element_list(PcarList, Position, NewPcarList),
    train(Id, Maker, RailType, Speed, NewPcarList, NewTrain).

 %-----------------------------------------------------------------------------------------------

% IMPLEMENTACIONES PARA FUNCIONAMIENTO PREDICADO isTrain. 

% Evalua si lista con TDA's tiene igual elemento en particular entre ellas
same_element_in_tda(List, Predicate) :-
    get_element_from_list_tda(List, Predicate, 	NewList),
    all_element_equal(NewList).

% Evalua si lista de pcars cumple con requerimientos
is_pcar(PcarList) :-
    same_element_in_tda(PcarList, pcar_get_model),
    get_element_from_list_tda(PcarList, pcar_get_type, TypeList),
    get_element_from_list_tda(TypeList, car_type_get_name, NameTypeList),
    length_list(NameTypeList, Length),
    first(NameTypeList, FirstNameType),
    last(NameTypeList, LastNameType),
    FirstNameType == "Terminal",
    LastNameType == "Terminal",
    remove_element_list(NameTypeList, 0, NameTypeList2),
    LastPosition is Length - 2,
    remove_element_list(NameTypeList2, LastPosition, MiddleNameTypeList),
    all_element_equal(MiddleNameTypeList).

/*
Req 13: TDA train - Pertenencia.
 
- Descripcion = Predicado que permite determinar si un elemento es un tren válido.

- MP: isTrain/1.
- MS: train_get_pcars/2,
      is_pcar/1.
*/  

isTrain(Train) :-
    train_get_pcars(Train, PcarList),
    is_pcar(PcarList).

%----------------------------------------------------------------------------------------------- 
  
/*
Req 14: TDA train - Otros predicados.
 
- Descripcion = Predicado que permite determinar la capacidad máxima de pasajeros del tren.

- MP: trainCapacity/2.
- MS: train_get_pcars/2,
      sum_element_list/3.
*/  

trainCapacity(Train, Capacity) :-
    train_get_pcars(Train, PcarList),
    sum_element_list(PcarList, Capacity, pcar_get_capacity).

%-----------------------------------------------------------------------------------------------
  
/*
Req 15: TDA driver - Constructor.
 
- Descripcion = Predicado que permite crear un conductor cuya habilitación de conducción 
                 depende del fabricante de tren (train-maker).

- MP: driver/4.
*/    
    
driver(Id, Name, TrainMaker, [Id, Name, TrainMaker]).

% Obtiene Id de driver
driver_get_id(Driver, Id) :-
    driver(Id, _, _, Driver).

% Obtiene TrainMaker de driver
driver_get_train_maker(Driver, TrainMaker) :-
    driver(_, _, TrainMaker, Driver).

%-----------------------------------------------------------------------------------------------

% IMPLEMENTACIONES PARA FUNCIONAMIENTO PREDICADO subway.

% Constructor de DriverData
driver_data(IdDriver, DepartureTime, DepartureStation, ArrivalStation, [IdDriver, DepartureTime, DepartureStation, ArrivalStation]).

% Obtiene IdDriver de driver_data
driver_data_get_id_driver(DriverData, IdDriver) :-
    driver_data(IdDriver, _, _, _, _, DriverData). 

% Obtiene DepartureTime de driver_data
driver_data_get_departure_time(DriverData, DepartureTime) :-
    driver_data(_, _, DepartureTime, _, _, DriverData).

% Obtiene DepartureStation de driver_data
driver_data_get_departure_station(DriverData, DepartureStation) :-
    driver_data(_, _, _, DepartureStation, _, DriverData).

% Obtiene ArrivalStation de driver_data
driver_data_get_arrival_station(DriverData, ArrivalStation) :-
    driver_data(_, _, _, _, ArrivalStation, DriverData).


% Constructor de Assign
assign(IdLine, IdTrain, DriverData, [IdLine, IdTrain, DriverData]).

% Obtiene IdLine de assign
assign_get_id_line(Assign, IdLine) :-
    assign(IdLine, _, _, Assign).

% Obtiene IdTrain de assign
assign_get_id_train(Assign, IdTrain) :-
    assign(_, IdTrain, _, Assign).

% Obtiene DriverData de assign
assign_get_driver_data(Assign, DriverData) :-
    assign(_, _, DriverData, Assign).


% Constructor de subway
subway(Id, Name, Lines, Trains, Drivers, Assign, [Id, Name, Lines, Trains, Drivers, Assign]).

% Obtiene Lines de subway
subway_get_lines(Subway, Lines) :-
    subway(_, _, Lines, _, _, _, Subway).

% Obtiene Trains de subway
subway_get_trains(Subway, Trains) :-
    subway(_, _, _, Trains, _, _, Subway).

% Obtiene Drivers de subway
subway_get_drivers(Subway, Drivers) :-
    subway(_, _, _, _, Drivers, _, Subway).

% Obtiene Assign de subway
subway_get_assign(Subway, Assign) :-
    subway(_, _, _, _, _, Assign, Subway).

/*
Req 16: TDA subway - Constructor.
 
- Descripcion = Predicado que permite crear una red de metro.

- MP: subway/3.
- MS: subway/7
*/   
    
subway(Id, Name, Subway) :-
    subway(Id, Name, [], [], [], [], Subway).

% GET DE TDA subway

% Obtiene Id de subway
subway_get_id(Subway, Id) :-
    subway(Id, _, _, _, _,  _, Subway).

% Obtiene Name de subway
subway_get_name(Subway, Name) :-
    subway(_, Name, _, _, _,  _, Subway).

%-----------------------------------------------------------------------------------------------

% IMPLEMENTACIONES PARA FUNCIONAMIENTO PREDICADO subwayAddTrain.

% Une dos sublistas en una lista
join_list([], []).

join_list([First|Tail], NewList) :-
    join_list(Tail, Acc),
    append(First, Acc, NewList).

% Recorre lista y verifica algun predicado en particular
foreach([], _).

foreach([First|Tail], Predicate) :-
    call(Predicate, First),
    foreach(Tail, Predicate).

% Verifica si nuevo tren agregado cumple con condiciones de id's train no repetidos y id's pcar 
% no repetidos, ademas verifica si train o lista de trains es o son trenes validos
verification_trains(TrainList) :-
	get_element_from_list_tda(TrainList, train_get_id, IdTrainList),
    get_element_from_list_tda(TrainList, train_get_pcars, PcarList),
    join_list(PcarList, NewPcarList),
    get_element_from_list_tda(NewPcarList, pcar_get_id, IdPcarList),
    all_element_different(IdTrainList),
    all_element_different(IdPcarList).
	
/*
Req 17: TDA subway - Modificador.
 
- Descripcion = Predicado que permite añadir trenes a una red de metro.

- MP: subwayAddTrain/3.
- MS: foreach/2,
      subway_get_id/2,
      subway_get_name/2,
      subway_get_lines/2,
      subway_get_trains/2,
      subway_get_drivers/2,
      subway_get_assign/2,
      append(OldTrains, TrainsIn, NewTrains),
      verification_trains/1,
      subway/7, !.
*/      

subwayAddTrain(Subway, TrainsIn, NewSubway) :-
    foreach(TrainsIn, isTrain),
    subway_get_id(Subway, Id),
    subway_get_name(Subway, Name),
    subway_get_lines(Subway, Lines),
    subway_get_trains(Subway, OldTrains),
    subway_get_drivers(Subway, Drivers),
    subway_get_assign(Subway, Assign),
    append(OldTrains, TrainsIn, NewTrains),
    verification_trains(NewTrains),
    subway(Id, Name, Lines, NewTrains, Drivers, Assign, NewSubway), !.

%-----------------------------------------------------------------------------------------------

% IMPLEMENTACIONES PARA FUNCIONAMIENTO PREDICADO subwayAddLine.    

% Verifica si las lineas a agregar cumplen con tener ids diferentes
verification_lines(LineList) :-
    get_element_from_list_tda(LineList, line_get_id, IdLineList),
    all_element_different(IdLineList).

/*
Req 18: TDA subway - Modificador.
 
- Descripcion = Predicado que permite añadir líneas a una red de metro.

- MP: subwayAddLine/3.
- MS: foreach/2,
      subway_get_id/2,
      subway_get_name/2,
      subway_get_lines/2,
      subway_get_trains/2,
      subway_get_drivers/2,
      subway_get_assign/2,
      append(OldLines, LinesIn, NewLines),
      verification_lines/1,
      subway/7, !.
*/       

subwayAddLine(Subway, LinesIn, NewSubway) :-
    foreach(LinesIn, isLine),
    subway_get_id(Subway, Id),
    subway_get_name(Subway, Name),
    subway_get_lines(Subway, OldLines),
    subway_get_trains(Subway, Trains),
    subway_get_drivers(Subway, Drivers),
    subway_get_assign(Subway, Assign),
    append(OldLines, LinesIn, NewLines),
    verification_lines(NewLines),
    subway(Id, Name, NewLines, Trains, Drivers, Assign, NewSubway), !.

%-----------------------------------------------------------------------------------------------

% IMPLEMENTACIONES PARA FUNCIONAMIENTO PREDICADO subwayAddDriver.    

% Verifica que drivers no esten repetidos
verification_driver(DriverList) :-
  get_element_from_list_tda(DriverList, driver_get_id, IdDriverList),
    all_element_different(IdDriverList).

/*
Req 19: TDA subway - Modificador.
 
- Descripcion = Predicado que permite añadir conductores a una red de metro.

- MP: subwayAddDriver/3.
- MS: subway_get_id/2,
      subway_get_name/2,
      subway_get_lines/2,
      subway_get_trains/2,
      subway_get_drivers/2,
      subway_get_assign/2,
      append(OldDrivers, DriversIn, NewDrivers),
      verification_driver/1,
      subway/7, !.
*/       
  
subwayAddDriver(Subway, DriversIn, NewSubway) :-
    subway_get_id(Subway, Id),
    subway_get_name(Subway, Name),
    subway_get_lines(Subway, Lines),
    subway_get_trains(Subway, Trains),
    subway_get_drivers(Subway, OldDrivers),
    subway_get_assign(Subway, Assign),
    append(OldDrivers, DriversIn, NewDrivers),
    verification_driver(NewDrivers),
    subway(Id, Name, Lines, Trains, NewDrivers, Assign, NewSubway), !.
  
%-----------------------------------------------------------------------------------------------

% IMPLEMENTACIONES PARA FUNCIONAMIENTO PREDICADO subwayToString.    

% Aplana una lista 
flatten_list([], []).

flatten_list([First|Tail], FlatList) :-
    flatten_list(First, FlatHead),
    flatten_list(Tail, FlatTail),
    append(FlatHead, FlatTail, FlatList).

flatten_list(Element, [Element]) :-
    not(is_list(Element)).

/*
Req 20: TDA subway - Otros predicados.
 
- Descripcion = Predicado que permite expresar una red de metro en un formato String.

- MP: subwayToString/2.
- MS: flatten_list/2,
      maplist/3,
      atomic_list_concat/3.
*/     

subwayToString(List, Result) :-
    flatten_list(List, FlatList),
    maplist(atom_string, FlatList, StringList),
    atomic_list_concat(StringList, ' ', Result).
  
%-----------------------------------------------------------------------------------------------

% IMPLEMENTACIONES PARA FUNCIONAMIENTO PREDICADO subwaySetStationStoptime.   

% Modifica StopTime de station
station_set_stop_time(Station, StationName, Time, NewStation) :-
	station_get_id(Station, Id),
	station_get_name(Station, Name),
	station_get_type(Station, Type),
	station_get_stop_time(Station, StopTime),
    (Name == StationName ->  
    	station(Id, Name, Type, Time, NewStation)
    ;   
    	station(Id, Name, Type, StopTime, NewStation)).


% Recorre lista de secction para modificar c/station 
section_set_stop_time([], _, _, []).

section_set_stop_time([First|Tail], StationName, Time, NewSections) :-
    section_get_distance(First, Distance),
	section_get_cost(First, Cost),
    section_get_point1(First, Station1),
    section_get_point2(First, Station2),
    station_set_stop_time(Station1, StationName, Time, NewStation1),
    station_set_stop_time(Station2, StationName, Time, NewStation2),
    section(NewStation1, NewStation2, Distance, Cost, NewSection),
	section_set_stop_time(Tail, StationName, Time, Acc),
	append([NewSection], Acc, NewSections).
    
% Recorre lista de lines para modificar c/section
lines_set_stop_time([], _, _, []).

lines_set_stop_time([First|Tail], StationName, Time, NewLines) :-
	line_get_id(First, Id),
	line_get_name(First, Name),
	line_get_railType(First, RailType),
    line_get_sections(First, Sections),
    section_set_stop_time(Sections, StationName, Time, NewSections),
    line(Id, Name, RailType, NewSections, NewLine),
    lines_set_stop_time(Tail, StationName, Time, Acc),
    append([NewLine], Acc, NewLines).

/*
Req 21: TDA subway - Modificador.
 
- Descripcion = Predicado que permite modificar el tiempo de parada de una estación.

- MP: subwaySetStationStoptime/4.
- MS: subway_get_id/2,
      subway_get_name/2,
      subway_get_lines/2,
      subway_get_trains/2,
      subway_get_drivers/2,
      subway_get_assign/2,
      lines_set_stop_time/4,
      subway/7, !.
*/  

subwaySetStationStoptime(Subway, StationName, Time, NewSubway) :-
    subway_get_id(Subway, Id),
    subway_get_name(Subway, Name),
    subway_get_lines(Subway, Lines),
    subway_get_trains(Subway, Trains),
    subway_get_drivers(Subway, Drivers),
    subway_get_assign(Subway, Assign),
    lines_set_stop_time(Lines, StationName, Time, NewLines),
    subway(Id, Name, NewLines, Trains, Drivers, Assign, NewSubway), !.
  
%-----------------------------------------------------------------------------------------------

% IMPLEMENTACIONES PARA FUNCIONAMIENTO PREDICADO subwayAssignTrainToLine.   

% Evalua si lista con TDA's tiene un elemento en particular
exist_element(List, Element, Predicate) :-
    get_element_from_list_tda(List, Predicate, ListElement),
    belongs(Element, ListElement).
   
/*
Req 22: TDA subway - Modificador.
 
- Descripcion = Predicado que permite modificar el tiempo de parada de una estación.

- MP: subwayAssignTrainToLine/4.
- MS: subway_get_id/2,
      subway_get_name/2,
      subway_get_lines/2,
      subway_get_trains/2,
      subway_get_drivers/2,
      subway_get_assign/2,
      assign/4,
      append(Assigns, [NewAssign], NewAssigns),
      exist_element/3,
      exist_element/3,
      subway/7, !.
*/    
    
subwayAssignTrainToLine(Subway, TrainId, LineId, NewSubway) :-
    subway_get_id(Subway, Id),
    subway_get_name(Subway, Name),
    subway_get_lines(Subway, Lines),
    subway_get_trains(Subway, Trains),
    subway_get_drivers(Subway, Drivers),
    subway_get_assign(Subway, Assigns),
    assign(LineId, TrainId, [], NewAssign),
    append(Assigns, [NewAssign], NewAssigns),
    exist_element(Trains, TrainId, train_get_id),
    exist_element(Lines, LineId, line_get_id),
    subway(Id, Name, Lines, Trains, Drivers, NewAssigns, NewSubway), !.
  
%-----------------------------------------------------------------------------------------------

% IMPLEMENTACIONES PARA FUNCIONAMIENTO PREDICADO subwayAssignDriverToTrain.       

%TODO SI HAY TIEMPO, PROBAR
% Corroborar que driver pueda conducir el tren
can_drive(Train, Driver) :-
    driver_get_train_maker(Driver, TrainMaker),
    train_get_maker(Train, Maker),
    TrainMaker == Maker.  

% Recorre lista de TDAs y devuelve un Element
find_item([], _, _, _) :- fail.

find_item([First|Tail], SearchedItem, Predicate, Item) :-
    call(Predicate, First, Element),
    (Element == SearchedItem ->  
    	Item = First, !
    ;   
    	find_item(Tail, SearchedItem, Predicate, Item)).

% Asigna DriverData al Assign que contenga el TrainId
assign_add_driverData(Assign, DriverData, TrainId, NewAssign) :-
    assign_get_id_line(Assign, IdLine),
	assign_get_id_train(Assign, ActualIdTrain),
	assign_get_driver_data(Assign, OldDriverData),
    (ActualIdTrain == TrainId ->  
    	assign(IdLine, ActualIdTrain, DriverData, NewAssign)
    ;   
    	assign(IdLine, ActualIdTrain, OldDriverData, NewAssign)).

% Recorre lista de assigns y crea nueva lista con assigns
assign_find_train([], _, _, []). 

assign_find_train([First|Tail], TrainId, DriverData, NewAssigns) :-
    assign_add_driverData(First, DriverData, TrainId, NewAssign),
    assign_find_train(Tail, TrainId, DriverData, Acc),
    append([NewAssign], Acc, NewAssigns). 
    	   
/*
Req 23: TDA subway - Modificador.
 
- Descripcion = Predicado que permite asignar un conductor a un tren en un horario de 
                salida determinado considerando estación de partida y de llegada.

- MP: subwayAssignDriverToTrain/7.
- MS: subway_get_id/2,
   	  subway_get_name/2,
      subway_get_lines/2,
      subway_get_trains/2,
      subway_get_drivers/2,
      subway_get_assign/2,
      driver_data/5,
      exist_element/3,
      exist_element/3,
      assign_find_train/4,
	  subway/7, !.
*/  

subwayAssignDriverToTrain(Subway, DriverId, TrainId, DepartureTime, DepartureStation, ArrivalStation, NewSubway) :-
    subway_get_id(Subway, Id),
    subway_get_name(Subway, Name),
    subway_get_lines(Subway, Lines),
    subway_get_trains(Subway, Trains),
    subway_get_drivers(Subway, Drivers),
    subway_get_assign(Subway, OldAssigns),
    driver_data(DriverId, DepartureTime, DepartureStation, ArrivalStation, DriverData),
    exist_element(Trains, TrainId, train_get_id),
    exist_element(Drivers, DriverId, driver_get_id),
    find_item(Trains, TrainId, train_get_id, Train),
    find_item(Drivers, DriverId, driver_get_id, Driver),
    can_drive(Train, Driver),
    assign_find_train(OldAssigns, TrainId, DriverData, NewAssigns),
	subway(Id, Name, Lines, Trains, Drivers, NewAssigns, NewSubway), !.
  
%-----------------------------------------------------------------------------------------------

% IMPLEMENTACIONES PARA FUNCIONAMIENTO PREDICADO subwayAssignDriverToTrain.       

/*
Req 24: TDA subway - Otros predicados.
 
- Descripcion = Predicado que permite determinar dónde está un tren a partir de una hora indicada del día.

- MP: subwayAssignDriverToTrain/7.
- MS: 
*/  

%whereIsTrain(Subway, TrainId, TimeStart, Station) :-
    






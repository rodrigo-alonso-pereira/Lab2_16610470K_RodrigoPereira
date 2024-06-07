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

% Obtiene id de Station
station_get_id(Station, Id) :-
    station(Id, _, _, _, Station).

% Obtiene name de Station
station_get_name(Station, Name) :-
    station(_, Name, _, _, Station).

% Obtiene type de Station
station_get_type(Station, Type) :-
    station(_, _, Type, _, Station).


%-----------------------------------------------------------------------------------------------
/*
Req 3: TDA section - constructor.
 
- Descripcion = Predicado que permite establecer enlaces entre dos estaciones.
- MP: section/5.
*/
section(Point1, Point2, Distance, Cost, [Point1, Point2, Distance, Cost]).

% Obtiene Point1 de una seccion
section_get_point1(Section, Point1) :-
    section(Point1, _, _, _, Section).

% Obtiene Point2 de una seccion
section_get_point2(Section, Point2) :-
    section(_, Point2, _, _, Section).

% Obtiene Distance de una seccion
section_get_distance(Section, Distance) :-
    section(_, _, Distance, _, Section).

% Obtiene Cost de una seccion
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
    nl.

% Evalua si existe elemento en lista
belongs(Element, [Element|_]).

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
is_empty(List) :-
    not(List == []). %cambiar logica

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
    is_empty(SectionList),
    partial_station_list(SectionList, ParcialStationList),
    last(SectionList, LastSection),
    section_get_point2(LastSection, LastStation),
    append(ParcialStationList, [LastStation], StationList),
    is_station(StationList),
    is_terminal(StationList),
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
add_element_list([], Element, 0, [Element]).

add_element_list(List, Element, 0, [Element|List]).

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
    train(Id, Maker, RailType, Speed, NewPcarList, NewTrain).

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
 
- Descripcion =  Predicado que permite eliminar un carro desde el convoy.

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
 
- Descripcion =  Predicado que permite determinar si un elemento es un tren válido.

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
 
- Descripcion =  Predicado que permite determinar la capacidad máxima de pasajeros del tren.

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
 
- Descripcion =  Predicado que permite crear un conductor cuya habilitación de conducción 
                 depende del fabricante de tren (train-maker).

- MP: driver/4.
*/    
    
driver(Id, Name, TrainMaker, [Id, Name, TrainMaker]).

%-----------------------------------------------------------------------------------------------

% IMPLEMENTACIONES PARA FUNCIONAMIENTO PREDICADO subway.

% Constructor de subway
subway(Id, Name, Lines, Trains, Drivers, [Id, Name, Lines, Trains, Drivers]).


/*
Req 16: TDA subway - Constructor.
 
- Descripcion =  Predicado que permite crear una red de metro.

- MP: subway/3.
- MS: subway/6
*/   
    
subway(Id, Name, Subway) :-
    subway(Id, Name, [], [], [], Subway).

% GET DE TDA subway

% Obtiene Id de subway
subway_get_id(Subway, Id) :-
    subway(Id, _, _, _, _, Subway).

% Obtiene Name de subway
subway_get_name(Subway, Name) :-
    subway(_, Name, _, _, _, Subway).

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

% Verifica si nuevo tren agregado cumple con condiciones de id's train no repetidos y id's pcar no repetidos
% ademas verifica si train o lista de trains es o son trenes validos
verification_trains(TrainList) :-
	get_element_from_list_tda(TrainList, train_get_id, IdTrainList),
    get_element_from_list_tda(TrainList, train_get_pcars, PcarList),
    join_list(PcarList, NewPcarList),
    get_element_from_list_tda(NewPcarList, pcar_get_id, IdPcarList),
    all_element_different(IdTrainList),
    all_element_different(IdPcarList).
	
/*
Req 17: TDA subway - Modificador.
 
- Descripcion =  Predicado que permite crear una red de metro.

- MP: subwayAddTrain/3.
- MS: foreach/2,
      subway_get_id/2,
      subway_get_name/2,
      subway/6,
      append/3,
      verification_trains/1,
      subway/6.
*/      

subwayAddTrain(Subway, TrainsIn, NewSubway) :-
    foreach(TrainsIn, isTrain),
    subway_get_id(Subway, Id),
    subway_get_name(Subway, Name),
    subway(_, _, Lines, OldTrains, Drivers, Subway),
    append(OldTrains, TrainsIn, NewTrains),
    verification_trains(NewTrains),
    subway(Id, Name, Lines, NewTrains, Drivers, NewSubway).

%-----------------------------------------------------------------------------------------------

% IMPLEMENTACIONES PARA FUNCIONAMIENTO PREDICADO subwayAddLine.    

verification_lines(NewLines) :-
    get_element_from_list_tda(NewLines, line_get_id, IdLineList),
    all_element_different(IdLineList).

/*
Req 18: TDA subway - Modificador.
 
- Descripcion =  Predicado que permite añadir conductores a una red de metro.

- MP: subwayAddLine/3.
- MS: 
*/       

subwayAddLine(Subway, LinesIn, NewSubway) :-
    foreach(LinesIn, isLine),
    subway_get_id(Subway, Id),
    subway_get_name(Subway, Name),
    subway(_, _, OldLines, Trains, Drivers, Subway),
    append(OldLines, LinesIn, NewLines),
    verification_lines(NewLines),
    subway(Id, Name, NewLines, Trains, Drivers, NewSubway).
    
    
    
    
    
    
    
    
    
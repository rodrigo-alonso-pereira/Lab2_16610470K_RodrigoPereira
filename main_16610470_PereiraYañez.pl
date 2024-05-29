/*
Req 2: TDA station - constructor

- Descripcion = Predicado constructor de una estación de metro.
- MP: station/5.
*/
station(Id, Name, Type, StopTime, [Id, Name, Type, StopTime]).

station_get_name(Station, Name) :-
    station(_, Name, _, _, Station).


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


/*
Req 4: TDA line - constructor.
 
- Descripcion = Predicado que permite crear una línea.
- MP: line/5.
*/
line(Id, Name, RailType, Sections, [Id, Name, RailType, Sections]).

% Obtiene lista de secciones de una linea
line_get_sections(Line, Sections) :-
    line(_, _, _, Sections, Line).


/*
Req 5: TDA line - Otros predicados.
 
- Descripcion = Predicado que permite determinar el largo total de una línea (cantidad de estaciones), 
                la distancia (en la unidad de medida expresada en cada tramo) y su costo.
- MP: lineLength/4.
- MS: line_get_sections/2,
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

% Recorre lista y obtiene elemento
get_element_list([], _).

get_element_list([First|Tail], Predicate) :-
    call(Predicate, First),
    get_element_list(Tail, Predicate).

% Agregar elemento al final.
add_end(List, Element [List|Element]).

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

% Remover duplicados
delete_duplicates([], []).

delete_duplicates([Head|Tail], NewList) :-
    belongs(Head, Tail),
    delete_duplicates(Tail, NewList).

delete_duplicates([Head|Tail], [Head|NewList]) :-
    not(belongs(Head, Tail)),
    delete_duplicates(Tail, NewList).

%lineLength(L1, LENGTH, DISTANCE, COST) :-
lineLength(L1, LENGTH, DISTANCE, COST) :-
    line_get_sections(L1, ListSections),
    sum_element_list(ListSections, DISTANCE, section_get_distance),
	sum_element_list(ListSections, COST, section_get_cost),
    new_name_station_list(ListSections, ListStation),
    delete_duplicates(ListStation, ListStationClean),
    length_list(ListStationClean, LENGTH).
    


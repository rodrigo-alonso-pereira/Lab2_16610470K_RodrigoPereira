% Constructor Type
type(Name, [Name]).

type_get_name(Type, Name) :-
    type(Name,Type).

/*
Req 2: TDA station - constructor

- Descripcion = Predicado constructor de una estación de metro.
- MP: station/5.
*/
station(Id, Name, Type, StopTime, [Id, Name, Type, StopTime]).

station_get_id(Station, Id) :-
    station(Id, _, _, _, Station).

station_get_name(Station, Name) :-
    station(_, Name, _, _, Station).

station_get_type(Station, Type) :-
    station(_, _, Type, _, Station).


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


/*
Req 5: TDA line - Otros predicados.
 
- Descripcion = Predicado que permite determinar el largo total de una línea (cantidad de estaciones), 
                la distancia (en la unidad de medida expresada en cada tramo) y su costo.
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
    

/*
Req 6: TDA line - otras funciones.
 
- Descripcion = Predicado que permite determinar el trayecto entre una estación origen y una final, 
                la distancia de ese trayecto y el costo.
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
   

/*
Req 8: TDA line - modificador..
 
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

% Recorre lista de TDA's y obtiene elemento en particular
get_element_from_list_tda([], _, []).

get_element_from_list_tda([First|Tail], Predicate, ListElement) :-
    call(Predicate, First, Id),
    get_element_from_list_tda(Tail, Predicate, AccList),
    append([Id], AccList, ListElement).

% Recorre lista verificando si elemento esta repetido en lista
evaluate_repeated_element([First|Tail]) :-
    belongs(First, Tail).
evaluate_repeated_element([_|Tail]) :-
    evaluate_repeated_element(Tail).

% Evalua si station cumple con sus condiciones
is_station(StationList) :-
    get_element_from_list_tda(StationList, station_get_id, IdList),
    get_element_from_list_tda(StationList, station_get_name, NameList),
    not(evaluate_repeated_element(IdList)),
    not(evaluate_repeated_element(NameList)).

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

% Evalua si linea esta vacia
is_empty_line(SectionList) :-
    not(SectionList == []).

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
    is_empty_line(SectionList),
    partial_station_list(SectionList, ParcialStationList),
    last(SectionList, LastSection),
    section_get_point2(LastSection, LastStation),
    append(ParcialStationList, [LastStation], StationList),
    is_station(StationList),
    is_terminal(StationList),
    is_section_communicates(SectionList).
    
    
    
    







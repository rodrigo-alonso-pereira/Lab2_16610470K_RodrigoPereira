/*
Req 2: TDA station - constructor

- Descripcion = Predicado constructor de una estación de metro.
- MP: station/5.
*/
station(Id, Name, Type, StopTime, [Id, Name, Type, StopTime]).


/*
Req 3: TDA section - constructor.
 
- Descripcion = Predicado que permite establecer enlaces entre dos estaciones.
- MP: section/5.
*/
section(Point1, Point2, Distance, Cost, [Point1, Point2, Distance, Cost]).

% Obtiene distancia de una seccion
section_get_distance(Section, Distance) :-
    section(_, _, Distance, _, Section).

% Obtiene costo de una seccion
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
- MS:
*/

% Imprimir elementos lista
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

% Suma los elementos de una lista de TDAs
sum_element_list([], 0, _).

sum_element_list([Head|Tail], TotalSum, Predicate) :-
    call(Predicate, Head, Element),
    sum_element_list(Tail, Acc, Predicate),
    TotalSum is Acc + Element.


% 1 obtener lista de secciones. OK
% 2 obtener cada seccion.
% 3 obtener distancia y sumar en una acumulador.
% 4 obtener costo y sumar en un acumulador.
% 5 obtener estaciones y agregar en nueva lista, sin repetidos.
% 6 obtener largo de nueva lista

%lineLength(L1, LENGTH, DISTANCE, COST) :-
lineLength(L1, DISTANCE, COST) :-
    line_get_sections(L1, ListSections),
    sum_element_list(ListSections, DISTANCE, section_get_distance),
	sum_element_list(ListSections, COST, section_get_cost).
    


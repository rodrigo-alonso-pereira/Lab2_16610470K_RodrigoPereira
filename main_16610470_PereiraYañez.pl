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


/*
Req 4: TDA line - constructor.
 
- Descripcion = Predicado que permite crear una línea.
- MP: line/5.
*/
line(Id, Name, RailType, Sections, [Id, Name, RailType, Sections]).


/*
Req 5: TDA line - Otros predicados.
 
- Descripcion = Predicado que permite determinar el largo total de una línea (cantidad de estaciones), 
                la distancia (en la unidad de medida expresada en cada tramo) y su costo.
- MP: line/5.
- MS:
*/

pertenece(Elemento, [Elemento|_]].

pertenece(Elemento, [_|Resto]) :-
    pertenece(Elemento, Resto).

distancia([], 0).

distancia([_|Resto], Distancia) :-
    distancia(Resto, Acc),
    Distancia is Acc + 

lineLength(L1, LENGTH) :-
    line(_, _, _, Sections, L1),
    section 
    
    
    
    




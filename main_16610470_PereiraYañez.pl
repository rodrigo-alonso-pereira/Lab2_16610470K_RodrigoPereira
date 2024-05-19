/*
Req 2: TDA station - constructor

- Descripcion = Predicado constructor de una estación de metro.
- MP: station(Id, Name, Type, StopTime, [Id, Name, Type, StopTime]).
*/
station(Id, Name, Type, StopTime, [Id, Name, Type, StopTime]).


/*
Req 3: TDA section - constructor.
 
- Descripcion = Predicado que permite establecer enlaces entre dos estaciones.
- MP: station(Point1, Point2, Distance, Cost, Section, [Point1, Point2, Distance, Cost, Section]).
*/
section(Point1, Point2, Distance, Cost, [Point1, Point2, Distance, Cost]).


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
 
- Descripcion = Predicado que permite crear una línea .
- MP: line/5.
*/
line(Id, Name, RailType, Sections, [Id, Name, RailType, Sections]).


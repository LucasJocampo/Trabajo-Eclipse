/*
En Bella Vista, Chepes y Ezeiza hay telescopio.
En Chacabuco, Arrecifes, Chepes y Venado Tuerto hay reposeras públicas.
Observatorio astronómico hay en Quines.
Lentes para sol se consiguen en Quines, Rodeo, Rio Cuarto, Merlo.
*/
%Sum toda la duracion 
%Ciudades 2116/13 -> 162,7692307692308
%ciudad(Ciudad, Provincia,(Horario,Altura,Duracion ) )
ciudad(arrecifes, buenos_aires, datos(1744, 2.5, 040)).
ciudad(bella_vista, san_juan, datos(1741, 11.5, 227)).
ciudad(carmen_de_areco, buenos_aires, datos(1744, 2.1, 130)).
ciudad(chacabuco, buenos_aires, datos(1743, 2.6, 207)).
ciudad(chepes, la_rioja, datos(1742, 8.9, 203)).
ciudad(ezeiza, buenos_aires, datos(1744, 0.9, 101)).
ciudad(jachal, san_juan, datos(1741, 11.1, 139)).
ciudad(pergamino, buenos_aires, datos(1744, 2.9, 056)).
ciudad(quines, san_luis, datos(1742, 7.8, 213)).
ciudad(rodeo, san_juan, datos(1741, 11.5, 216)).
ciudad(rio_cuarto, cordoba, datos(1742, 6.3, 154)).
ciudad(venado_tuerto, santa_fe, datos(1743, 4.1, 211)).
ciudad(merlo, san_luis, datos(1742, 7.1, 219)).
%functores

%Servicios
%bella_vista, chepes, ezeiza, chacabuco, arrecifes, venado_tuerto, quines
esProvincia(buenos_aires).
esProvincia(san_juan).
esProvincia(san_luis).
esProvincia(la_rioja).
esProvincia(cordoba).
esProvincia(santa_fe).
%Telescopio 177 PROM
servicio(bella_vista, telescopio).
servicio(chepes, telescopio).
servicio(ezeiza, telescopio).    
%Reposera
servicio(chacabuco, reposeras_publicas).
servicio(arrecifes, reposeras_publicas).
servicio(chepes, reposeras_publicas).
servicio(venado_tuerto, reposeras_publicas).
%Obeservatorio
servicio(quines, observatorio_astronomico).
%Lentes
servicio(quines, lentes_sol).
servicio(rodeo, lentes_sol).
servicio(rio_cuarto, lentes_sol).
servicio(merlo, lentes_sol).

%1.Los lugares donde la altura del sol es más de 10º o empieza después de las 17:42.

% ciudad(Ciudad,Provincia, Horario, Altura, Duracion)
alturaMayor10(Ciudad):-
    ciudad(Ciudad, _, datos(_, Altura, _)),
    Altura > 10.

empiezaDespues(Ciudad):-
    ciudad(Ciudad, _, datos(Horario, _, _)),
    Horario >1742.

%2.Los lugares que no tienen ningún servicio.
sinServicio(Ciudad):-
    ciudad(Ciudad, _, datos(_, _, _)),
    not(servicio(Ciudad,_)).

%3. Las provincias que tienen un sola ciudad donde verlo.
provinciaConUna(Provincia) :-
    ciudad(Ciudad, Provincia, datos(_, _, _)),
    forall(ciudad(OtraCiudad, Provincia, datos(_, _, _)), OtraCiudad = Ciudad).
    %not((ciudad(OtraCiudad, Provincia, datos(_, _, _)), OtraCiudad \= Ciudad)).
    
%4. El lugar donde dura más.
dondeDuraMas(Ciudad, OtraCiudad) :-
    ciudad(Ciudad, _, datos(_, _, Duracion)),
    forall((ciudad(OtraCiudad, _, datos(_, _, OtraDuracion)), OtraCiudad \= Ciudad), Duracion > OtraDuracion).
    %not((ciudad(OtraCiudad, _, datos(_, _, OtraDuracion)), OtraDuracion > Duracion)).

%5. La duración promedio del eclipse: en todo el país, en cada provincia, en las ciudades con telescopio.
% Duración promedio del eclipse en todo el país
cantidadCiudadesPais(Cantidad) :-
    findall(_, ciudad(_, _, datos(_, _, _)), Ciudades),
    length(Ciudades, Cantidad).

duracionTotalPais(Total) :-
    findall(Duracion, ciudad(_, _, datos(_, _, Duracion)), Duraciones),
    sumlist(Duraciones, Total). %Sumo la lista de duraciones y la devuelvo como total

duracionPromedioPais(Promedio) :-
    duracionTotalPais(Total),
    cantidadCiudadesPais(Cantidad),
    Promedio is Total / Cantidad.

%Duracion Promedio en cada provincia
duracionPromedioProvincia(Provincia, Promedio) :-
   %ciudad(_,Provincia, datos(_,_,Duracion)),
    esProvincia(Provincia),
    findall(Duracion, ciudad(_, Provincia, datos(_, _, Duracion)), Duraciones),
    sacarPromedio(Duraciones, Promedio).
    
%Duracion promedio en las ciudades con telescopio
duracionPromedioTelescopio(Provincia, Promedio) :-
    esProvincia(Provincia),
    findall(Duracion, (ciudad(Ciudad, Provincia, datos(_, _, Duracion)), servicio(Ciudad, telescopio)), Duraciones),
    sacarPromedio(Duraciones, Promedio).

sacarPromedio(Lista, Promedio) :-
    sumlist(Lista, Total),
    length(Lista, Cantidad),
    Cantidad > 0,
    Promedio is Total / Cantidad.

%6. Analizar la inversibilidad de los predicados del item 2 y 5. Justificar.
% La inversibilidad del predicado del ejercicio 2 es total, ya que si ponemos el predicado tal cual en la terminal sinServicio(Ciudad).
% nos devuelve todas las ciudades que no poseen servicios.
% La inversibilidad del predicado del ejercico es total, ya que si ponemos el predicado duracionPromedioProvincia(X,C). en la terminal
% nos devuelve todos los promedios de cada provincia
% A su vez, si ponemos duracionPromedioProvincia(X,211)., nos devuelve la provincia cuyo promedio es 211, la cual es Santa Fe
% y también si ponemos duracionPromedioProvincia(santa_fe,C). nos devuelve el promedio de Santa Fe


fn interpolacion_lineal t CP1 CP2 Inicio Fin= 
(

V1 = (CP2-CP1)

return CP1 + ((normalize V1)*(((length V1)/(Fin-Inicio))*(t-Inicio)))

)

fn interpolacion_cuadratica t CP1 CP2 CP3 Inicio Fin=
(
	I1 = interpolacion_lineal t CP1 CP2 Inicio Fin
	I2 = interpolacion_lineal t CP2 CP3 Inicio Fin
	
	return interpolacion_lineal t I1 I2 Inicio Fin
	
)

fn interpolacion Traveler CP1 Altura CP2 Inicio Fin=
(
	animate on
	(
		for t in Inicio to Fin by 1 do
		(
			at time t
			(
				--if t == Inicio do Traveler.stretch.stretch = -0.25
				Traveler.pos = interpolacion_cuadratica t CP1 Altura CP2  Inicio Fin
			)
		)
	)
)
--Vector de plataformas de salto
global posicion = #()
global nombres= #()

rollout Salto "Salto"
(
	group "Objeto" (
		pickbutton UI_SelectorObj "Selecciona Objeto"
	)
	group "Puntos de salto" (
		listbox  UI_ListaP selection:0
		pickbutton UI_SelectorP "Añadir nuevo Punto de Salto"
	)
	on UI_SelectorObj picked obj do
	(
		global Traveler = obj
		UI_SelectorObj.text = obj.name
	)
	
	on UI_SelectorP picked obj do
	(
		append nombres obj.name
		append posicion obj
		UI_ListaP.items = nombres
		
	)
	
	group "Crear Trayectoria" (
		spinner UI_Intervalo "T_Salto" range:[10,1000,100] type:#Integer
		button UI_Trayectoria "Crear Trayectoria"
	)
	
	on UI_Trayectoria pressed do
	(	
		if Traveler!= undefined do
		( 
			Inicio = 0
			Fin = UI_Intervalo.Value
			deletekeys Traveler
			Traveler.dir = [0,0,1]
			for i = 1 to posicion.count - 1 do
			(
				obj1 = posicion[i]
				obj2 = posicion[i + 1]				
				--Movimiento y calculo de parametros
				distancia = distance obj1 obj2
				 
				Altura =  (obj1.pos + obj2.pos) / 2
				Altura.z = Altura.z - distancia
				
				interpolacion Traveler obj1.pos Altura obj2.pos Inicio Fin
				Traveler.showtrajectory = on
					
				Inicio = Fin
				Fin = Fin + UI_Intervalo.Value
			)
		)
	)
)

createDialog Salto
fn interpolacion_lineal t CP1 CP2 total= 
(

V1 = (CP2-CP1)

return CP1 + ((normalize V1)*(((length V1)/total)*t))

)

fn interpolacion_cuadratica t CP1 CP2 CP3 total=
(
	I1 = interpolacion_lineal t CP1 CP2 total
	I2 = interpolacion_lineal t CP2 CP3 total
	
	return interpolacion_lineal t I1 I2 total
	
)

fn interpolacion_cubica t CP1 CP2 CP3 CP4 total= 
(
		I1 = interpolacion_lineal t CP1 CP2 total
		I2 = interpolacion_lineal t CP2 CP3 total
		I3 = interpolacion_lineal t CP3 CP4 total
		
		return interpolacion_cuadratica t I1 I2 I3 total
)


fn saltar Traveler CP1 CP2 CP3 Altura  Inicio Fin Str Incl Direcc =
(
	animate on
	(
		-- Mitad del total de frames del salto
		Mitad = (Fin - Inicio) / 2
		
		-- Valores intermedios para la interpolación del Squash y Stretch
		if Str do (
			Tercio = (Mitad - Inicio) / 3
			Aux_1_1 = [Tercio, 0.6, 0]
			Aux_1_2 = [2*Tercio, -0.1, 0]
			Aux_2_1 = [Mitad + Tercio, -0.1, 0]
			Aux_2_2 = [Mitad + 2*Tercio, 0.6, 0]	
			Primero = [0, 0.5, 0]
			Medio = [Mitad, 0, 0]
			Ultimo = [(Fin - Inicio), 0.5, 0]
		)
		
		--Cáculo del ángulo y la dirección del giro
		if Direcc do (
			
			-- Dir = 0 -> dentro , Dir > 0 -> derecha y Dir < 0 -> izquierda
			Dir = (CP2.x - CP1.x)*(CP3.y - CP1.y) - (CP2.y - CP1.y)*(CP3.x - CP1.x)
			
			Contiguo1 = distance CP1 CP2
			Contiguo2 = distance CP2 CP3
			Opuesto = distance CP1 CP3
			
			Angulo_Giro = acos ( (Opuesto*Opuesto - Contiguo1*Contiguo1 - Contiguo2*Contiguo2 ) / ( -2*Contiguo1*Contiguo2) )		
		)
		
		--Cálculo del intervalo de inclinación por cada frame
		if Incl then (	
			Angulo = 25
			Intervalo_rot = Angulo / Mitad
			
		) else Angulo = 0
		
		
		
		for t in Inicio to Fin by 1 do
		(
			--Cambiamos la inclinación
			if Incl then Angulo = Angulo - Intervalo_rot
				
			
			at time t 
			(
		
				if ((t == Inicio or t == Fin) and Str) then Traveler.stretch.stretch = -0.25 -- Al inicio del salto de encuantra aplastado
				else
				(
					if Str do (
						--Calculamos el valor del stretch mediante interpolación cúbica
						if ( t <= Mitad + Inicio) then St = interpolacion_cubica  (t - Inicio) Primero Aux_1_1 Aux_1_2 Medio (Mitad)
						else 	St = interpolacion_cubica  (t - Inicio - Mitad) Medio Aux_2_1 Aux_2_2 Ultimo (Mitad)
											
						Traveler.stretch.stretch = St.y
					)
					
					--Cambiamos la inclinación
					Traveler.rotation.y_rotation =  Angulo
					
					
					if ( t == Fin - 1 and Direcc) then (
						--Cambiamos la dirección del objeto en función del ángulo y la dirección de giro 
						if(Dir > 0) then (
							Traveler.rotation.z_rotation =  Traveler.rotation.z_rotation + 180 - Angulo_Giro						
						)
						else if (Dir < 0) then Traveler.rotation.z_rotation = Traveler.rotation.z_rotation - (180 - Angulo_Giro)
					)
				)
				
				--Cambiamos la posición del objeto mediante interpolación cuadrática
				Traveler.pos = interpolacion_cuadratica (t - Inicio) CP1 Altura CP2 (Fin - Inicio)
		
			)
			
		)
	)
 )

-- Vectores para los puntos de salto
global puntos = #()
global obj_puntos = #()
 
rollout Salto "Salto"
(
	group "Actor" (
		pickbutton UI_SelectorActor "Selecciona Actor"
	)
	
	group "Puntos de salto" (
		
		listbox  UI_ListaP "" selection:0
		pickbutton UI_SelectorP "Añadir nuevo punto"
		button UI_EliminarP "Eliminar punto" enabled:false
        button UI_MoverUpP "Mover arriba" enabled:false 	
		button UI_MoverDownP "Mover abajo" enabled:false 
	)
	
	group "Efectos" (
		checkbox UI_CheckStretch "Squash y Stretch"
		checkbox UI_CheckInclinacion  "Inclinación de salto"
		checkbox UI_CheckDireccion "Seguir la dirección de salto"
	)
	
	group "Tiempos" (
		spinner UI_IF "Comienzo" range:[0,1000,0] type:#Integer
		spinner UI_FF "Duracion salto" range:[5,100,20] type:#Integer
		button UI_CrearSalto "Crear"
	)
	
	on UI_SelectorActor picked obj do
	(
		global Traveler = obj
		UI_SelectorActor.text = obj.name
	)
	
	
	on UI_SelectorP picked obj do
	(
		append puntos obj.name
		append obj_puntos obj
		UI_ListaP.items = puntos
		
	)
	
	on  UI_ListaP selected obj do 
	(
		if UI_ListaP.selection != 0 then
		(
			UI_EliminarP.enabled = true
			UI_MoverUpP.enabled = true
			UI_MoverDownP.enabled = true
		)
		else
		(
			UI_EliminarP.enabled = false
			UI_MoverUpP.enabled = false
			UI_MoverDownP.enabled = false
		)
	
	)	

	on UI_EliminarP pressed do
	(
		pos = UI_ListaP.selection
		if pos != 0 do
		(
		deleteItem puntos pos
		deleteItem obj_puntos pos
		UI_ListaP.items = puntos
		UI_EliminarP.enabled = false
		UI_MoverUpP.enabled = false
		UI_MoverDownP.enabled = false		
		UI_ListaP.selection = 0
		)
	)
	
	on UI_MoverUpP pressed do
	(
		pos = UI_ListaP.selection
		obj = UI_ListaP.selected
		
		if pos != 0 and pos != 1 do 
		(
			puntos[pos] = puntos[pos-1]
			puntos[pos-1] = obj
			
			objeto = obj_puntos[pos]
			obj_puntos[pos] = obj_puntos[pos-1]
			obj_puntos[pos-1] = objeto
			
			UI_ListaP.items = puntos
			UI_ListaP.selection = pos - 1
		)
		
		
	)
	
	on UI_MoverDownP pressed do
	(
		pos = UI_ListaP.selection
		obj = UI_ListaP.selected
		
		if pos != 0 and pos != puntos.count do 
		(
			puntos[pos] = puntos[pos+1]
			puntos[pos+1] = obj
			
			objeto = obj_puntos[pos]
			obj_puntos[pos] = obj_puntos[pos+1]
			obj_puntos[pos+1] = objeto
			
			UI_ListaP.items = puntos
			UI_ListaP.selection = pos + 1
		)
		
		
	)
	
	on UI_CrearSalto pressed do
	(
		
		--Eliminamos los modificadores y las keys
		if Traveler.modifiers.count != 0 do 	Traveler.stretch.stretch = 0.0
		collapseStack  Traveler 
		deletekeys Traveler.controller #allKeys
		addModifier Traveler (stretch stretch:0.0)
		
		--Sin efectos por defecto
		Str = false
		Incl = false
		Direcc = false
		
		--Verificamos si se ha seleccionado algún efecto
		if UI_CheckStretch.checked do Str = true
		if UI_CheckInclinacion.checked do Incl = true
		if 	UI_CheckDireccion.checked	do Direcc = true	
		
		if Traveler != undefined and obj_puntos.count > 1 do
		(
				
			
			
			--Modificamos el rango de la animación en caso de necesitarlo
			Inicio = UI_IF.value
			Fin = (UI_IF.value+UI_FF.value)			
			Fin_animacion = (Inicio + UI_FF.value*(obj_puntos.count - 1))
			if animationRange.end < Fin_animacion do
			animationRange = interval Inicio (Inicio + UI_FF.value*(obj_puntos.count - 1))
			
			--Alineamos el objeto a partir de su eje x con la dirección del primer salto		
			if Direcc do 
			(
				Traveler.dir = [0,0,1]
				
				p1 = obj_puntos[1].pos
				p1.z = 0
				p2 = obj_puntos[2].pos
				p2.z = 0
				 dir = normalize (p2 - p1)
			
				vec = Traveler.transform[1]  --Eje x
				tm = Traveler.transform
				vec = normalize vec
				dir = normalize dir
				rtm = angleaxis (acos (dot vec dir)) (normalize (cross dir vec))
				Traveler.transform = translate (rotate (scalematrix tm.scale) (tm.rotation*rtm)) tm.pos
					
			)	
				
			--Animamos cada salto por separado
			for i = 1 to obj_puntos.count - 1  do
			(
				obj1 = obj_puntos[i]
				obj2 = obj_puntos[i + 1]				
				obj3 = obj_puntos[i + 2]  
				
				--En caso de estar en el último punto de salto
				if i == obj_puntos.count - 1 do obj3 = obj2 = obj_puntos[i + 1]
								
					distancia = distance obj1 obj2
				 
				--Calculamos la altura del salto
				Altura =  (obj1.pos + obj2.pos) / 2
				Altura.z = Altura.z + distancia
				
				--Animamos el salto
				saltar Traveler obj1.pos  obj2.pos obj3.pos Altura Inicio Fin Str Incl Direcc  
				Traveler.showtrajectory = on
					
				Inicio = Fin
				Fin = Fin + UI_FF.value
			)
			
		)
	)
)

createDialog Salto
    
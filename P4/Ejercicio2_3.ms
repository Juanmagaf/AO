fn interpolacion_lineal t CP1 CP2= 
(

V1 = (CP2-CP1)

return CP1 + ((normalize V1)*(((length V1)/100)*t))

)

fn interpolacion_cuadratica t CP1 CP2 CP3=
(
	I1 = interpolacion_lineal t CP1 CP2
	I2 = interpolacion_lineal t CP2 CP3
	
	return interpolacion_lineal t I1 I2
	
)


fn interpolacion Traveler CP1 CP2 CP3 =
(
animate on
(
	for t in 0 to 100 by 1 do
	(
		at time t
		(
			Traveler.pos = interpolacion_cuadratica t CP1 CP2 CP3
			
		)
		
	)
)
 )


interpolacion $Sphere001  $Dummy001.pos $Dummy002.pos $Dummy003.pos

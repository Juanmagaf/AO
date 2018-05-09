animate on
(
	at time 0 $Sphere001.pos = [0,0,0]
	
	for t in 0 to 100 by 1 do
	(
		at time t
		(
			
			at time t $Sphere002.pos = $Sphere001.pos + [25,0,0]
			at time t $Sphere002.pos = $Sphere001.pos + [25,25,0]
					
			at time t $Sphere003.pos = $Sphere002.pos - [50,0,0]
			at time t $Sphere003.pos = $Sphere002.pos - [50,0,-20]
		)
		
	)
		
	
)

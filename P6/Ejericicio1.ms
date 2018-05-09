animate on
	(
		
		for t in 0 to 200 by 1 do
		(
			at time t 
			(
			$Sphere002.pos = $Sphere001.pos 
			
			--Vector rayo para generar la colisión con el plano
			Rayo = ray $Sphere001.pos [0,0,-1]
			Colision = IntersectRay $Plane001 Rayo
				--$Sphere002.pos = Colision.pos + [0,0,$Sphere002.radius] Esto es sin ser la normal
			$Sphere002.pos = Colision.pos + [0,0,$Sphere002.radius]+Colision.dir 
			
			-- Direccion que toma la pelota 
			vdir = $Sphere002.pos - (at time (t - 1) $Sphere002.pos)
			
			
			vrot = cross vdir Colision.dir
				
				
			RotAngle = ((length vdir)/($Sphere002.radius*pi))*180
			Quaternion = quat RotAngle (normalize vrot)
				
			RotEuler = QuatToEuler Quaternion
			rotate $Sphere002 RotEuler
			)
		)
		
	)
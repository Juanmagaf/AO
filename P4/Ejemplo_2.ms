fn interpolacion Traveler Traveler2 CP1 CP2 CP3= 
(



V1 = (CP2-CP1)
V2 = (CP3-CP2)

animate on
(
	for t in 0 to 100 by 1 do
	(
		at time t
		(
			Traveler.pos = CP1 + ((normalize V1)*(((length V1)/100)*t))
			Traveler2.pos = CP2 + ((normalize V2)*(((length V2)/100)*t))
		)
		
	)
)
)


interpolacion $Ball $Ball2 $Box001.pos $Box002.pos $Box003.pos

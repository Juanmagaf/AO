ball = sphere radius:10 wireColor:blue
ball1 = sphere radius:10 wireColor:green
animate on
( 
	at time 0   ball.pos = [-100,-20,0]
	at time 0   ball1.pos = [-100,20,0]
	at time 100 ball.pos = [100,-20,0]
	at time 50 ball1.pos = [100,20,0]
)

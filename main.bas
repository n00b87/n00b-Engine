Include "engine.bas"


Game_WindowOpen("My Game", 640, 480, 0) 'Open the game window

LoadStage("MyFirstLevel.stage") 'Loads the stage
Stage_Layer_Physics[2] = True 'Turns physics on for layer 2

hero = GetActorID("hero") 'Gets a reference to our hero Actor in our stage
Actor_Physics[hero] = True 'Turns physics on for our hero actor
Actor_Weight[hero] = 3.5 'Sets the speed the hero actor falls at

hero_move_speed = 3 'Setting a variable for our movement speed

While Not Key(K_ESCAPE)

	'Move Left/Right
	If Key(K_LEFT) Then
		Actor_Move(hero, -hero_move_speed, 0) 'Move the actor left
		Actor_SetAnimationByName(hero, "MOVE_LEFT") 'Set the Move Left Animation on the sprite
	ElseIf Key(K_RIGHT) Then
		Actor_Move(hero, hero_move_speed, 0) 'Move the actor right
		Actor_SetAnimationByName(hero, "MOVE_RIGHT") 'Set the Move Right Animation on the sprite
	End If
	
	'Jump
	If Actor_Physics_State[hero] = PHYSICS_STATE_GROUND And Key(K_Z) Then 'Check if Actor is on the ground and Z key is pressed
		Actor_Physics_State[hero] = PHYSICS_STATE_RISE 'Lets the physics engine know the actor is going to be off the ground
		Actor_Jump[hero] = 80 'Sets a value that determines height of jump
		Actor_Force_Y[hero] = -4 'Sets the upward speed of the jump
		Select Case Actor_GetAnimationName$(hero, Actor_CurrentAnimation[hero]) 'Get the Current Animation Name
		Case "MOVE_LEFT"
			Actor_SetAnimationByName(hero, "JUMP_LEFT") 'Sets the left jump animation
			Actor_SetAnimationFrame(hero, 0) 'Sets the animation frame to 0
		Case "MOVE_RIGHT"
			Actor_SetAnimationByName(hero, "JUMP_RIGHT") 'Sets the Right jump animation
			Actor_SetAnimationFrame(hero, 0) 'Sets the animation frame to 0
		End Select
	End If
	
	cam_x = 0
	
	If Actor_X[hero] > 320 Then
		cam_x = Actor_X[hero] - 320 'Move the Camera so that the actor is in the middle of the screen
	End If
	
	Stage_SetOffset(cam_x, 0) 'Offset the stage by how much we want to move the camera by

	Game_Render() 'Draws the Game Screen
Wend
Include "engine.bas"


Game_WindowOpen("Platform Demo", 640, 480, 0) 'Open the game window

LoadStage("demo.stage") 'Loads the stage
Stage_Layer_Physics[4] = True 'Turns physics on for layer 4
Stage_Layer_ColDet[4] = True 'ColDet must be enabled on the physics layer for physics calculations to be performed

hero = GetActorID("knight") 'Gets a reference to our hero Actor in our stage
Actor_Physics[hero] = True 'Turns physics on for our hero actor
Actor_Weight[hero] = 3.5 'Sets the speed the hero actor falls at

'Storing the starting position of the actor so we can move the actor here if they fall of the edge of a platform
start_x = Actor_X[hero]
start_y = Actor_Y[hero]

hero_move_speed = 3 'Setting a variable for our movement speed

prev_state = 0 ' A variable to track the physics state of the actor

Dim right_anim_list$[5] ' A list of all the right facing animations that we will use to check if the actor is facing right
right_anim_list$[0] = "RUN_RIGHT"
right_anim_list$[1] = "JUMP_RIGHT"
right_anim_list$[2] = "JUMP_FALL_RIGHT"
right_anim_list$[3] = "FALL_RIGHT"
right_anim_list$[4] = "STAND_RIGHT"

Dim jump_fall_list$[2] ' A list of the jump to fall transition animations that will be checked to determine when to change to the fall animation
jump_fall_list$[0] = "JUMP_FALL_RIGHT"
jump_fall_list$[1] = "JUMP_FALL_LEFT"

SetColor(RGB(255,255,255))
PrintS("Arrow Keys to Move")
PrintS("Z to Jump")


While Not Key(K_ESCAPE)

	move_flag = false
	
	'Move Left/Right
	If Key(K_LEFT) Then
		Actor_Move(hero, -hero_move_speed, 0) 'Move the actor left
		If Actor_Physics_State[hero] = PHYSICS_STATE_GROUND Then
			Actor_SetAnimationByName(hero, "RUN_LEFT") 'Set the Move Left Animation on the sprite
		End If
		move_flag = True
	ElseIf Key(K_RIGHT) Then
		Actor_Move(hero, hero_move_speed, 0) 'Move the actor right
		If Actor_Physics_State[hero] = PHYSICS_STATE_GROUND Then
			Actor_SetAnimationByName(hero, "RUN_RIGHT") 'Set the Move Right Animation on the sprite
		End If
		move_flag = True
	Else
		Select Case Actor_GetAnimationName$(hero, Actor_CurrentAnimation[hero])
		Case "RUN_RIGHT"
			Actor_SetAnimationByName(hero, "STAND_RIGHT")
		Case "RUN_LEFT"
			Actor_SetAnimationByName(hero, "STAND_LEFT")
		End Select
	End If
	
	'Jump
	If Actor_Physics_State[hero] = PHYSICS_STATE_GROUND And Key(K_Z) Then 'Check if Actor is on the ground and Z key is pressed
		Actor_Physics_State[hero] = PHYSICS_STATE_RISE 'Lets the physics engine know the actor is going to be off the ground
		Actor_Jump[hero] = 80 'Sets a value that determines height of jump
		Actor_Force_Y[hero] = -4 'Sets the upward speed of the jump
		Select Case Actor_GetAnimationName$(hero, Actor_CurrentAnimation[hero]) 'Get the Current Animation Name
		Case "RUN_LEFT", "STAND_LEFT"
			Actor_SetAnimationByName(hero, "JUMP_LEFT") 'Sets the left jump animation
			Actor_SetAnimationFrame(hero, 0) 'Sets the animation frame to 0
		Case "RUN_RIGHT", "STAND_RIGHT"
			Actor_SetAnimationByName(hero, "JUMP_RIGHT") 'Sets the Right jump animation
			Actor_SetAnimationFrame(hero, 0) 'Sets the animation frame to 0
		End Select
	ElseIf Actor_Physics_State[hero] = PHYSICS_STATE_GROUND and prev_state <> PHYSICS_STATE_GROUND Then 'Check if actor lands on the ground
		If InList(right_anim_list$, 5, Actor_GetAnimationName$(hero, Actor_CurrentAnimation[hero])) Then 'Check if the actor is facing right
			If move_flag Then
				Actor_SetAnimationByName(hero, "RUN_RIGHT") 'If the actor lands on the ground and the arrow key is held down then set the running animation 
			Else
				Actor_SetAnimationByName(hero, "STAND_RIGHT") 'If the actor lands on the ground and is not moving then set the stand still animation
			End If
			Actor_SetAnimationFrame(hero, 0) 'Sets the frame of the animation to zero
		Else
			If move_flag Then
				Actor_SetAnimationByName(hero, "RUN_LEFT") 'If the actor lands on the ground and the arrow key is held down then set the running animation
			Else
				Actor_SetAnimationByName(hero, "STAND_LEFT") 'If the actor lands on the ground and is not moving then set the stand still animation
			End If
			Actor_SetAnimationFrame(hero, 0) 'Sets the frame of the animation to zero
		End If
	ElseIf Actor_Physics_State[hero] = PHYSICS_STATE_FALL Then 'If actor is falling
		If prev_state <> PHYSICS_STATE_FALL Then 'Check if the actor just started falling
			If InList(right_anim_list$, 5, Actor_GetAnimationName(hero, Actor_CurrentAnimation[hero])) Then 'Check if the actor is facing right
				Actor_SetAnimationByName(hero, "JUMP_FALL_RIGHT") 'Play the transition animation between jumping and falling
				Actor_SetAnimationFrame(hero, 0) 'Sets the frame of the transition animation to 0
			Else
				Actor_SetAnimationByName(hero, "JUMP_FALL_LEFT") 'Play the transition animation between jumping and falling
				Actor_SetAnimationFrame(hero, 0) 'Sets the frame of the transition animation to 0
			End If
		ElseIf InList(jump_fall_list$, 2, Actor_GetAnimationName(hero, Actor_CurrentAnimation[hero])) And Actor_AnimationEnded[hero] Then 'Check if the transition animation has ended
			If Actor_GetAnimationName$(hero, Actor_CurrentAnimation[hero]) = "JUMP_FALL_RIGHT" Then ' Check if the actor is falling right
				Actor_SetAnimationByName(hero, "FALL_RIGHT") ' Play the falling animation
				Actor_SetAnimationFrame(hero, 0)
			ElseIf Actor_GetAnimationName$(hero, Actor_CurrentAnimation[hero]) = "JUMP_FALL_LEFT" Then ' Check if the actor is falling left
				Actor_SetAnimationByName(hero, "FALL_LEFT") ' Play the falling animation
				Actor_SetAnimationFrame(hero, 0)
			End If
		End If
	End If
	
	prev_state = Actor_Physics_State[hero] ' Get the current state of the actor
	
	cam_x = 0
	
	If Actor_X[hero] > 320 Then
		cam_x = Actor_X[hero] - 320 'Move the Camera so that the actor is in the middle of the screen
	End If
	
	If Actor_Y[hero] > 400 Then
		Actor_SetPosition(hero, start_x, start_y) 'Move Actor back to the start if it falls off the stage
	End If
	
	Stage_SetOffset(cam_x, 0) 'Offset the stage by how much we want to move the camera by

	Game_Render() 'Draws the Game Screen
Wend
ifndef Player_h_
Player_h_	EQU	<>

include stats.inc

; before enter into the world, we need to read those values from the database.
Player struct
	m_Id		QWORD ?
	m_Name 		BYTE 64 DUP(0)
	m_Stats 	Stats <>
	
	; Here, we should note that the player can have more than 10 spells 
	; available. Take into account!
	m_Spells	QWORD 10 DUP(0) ; 10 Pointers to every spell.
	
	; Here, we should add a vector or a list of sprites with the different 
	; animations for the player based on the state of the player
	m_Sprite	Sprite<> 		; Animation
	
	m_Speed 	DWORD ?			; Walks to 1 meter per second
	m_Position 	Vector2D<>
Player ends

; Constructor
Player_ctor proto :ptr Player

; Destructor
Player_dtor proto :ptr Player

; Handle input
Player_handleInput proto :ptr Player, :ptr SDL_Event

; Update player
Player_update proto :ptr Player

; Render texture
Player_render proto :ptr Player

endif
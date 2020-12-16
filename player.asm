include player.inc

.code

; Constructor
Player_ctor proc pPlayer:ptr Player
	
	ret
Player_ctor endp

; Destructor
Player_dtor proc pPlayer:ptr Player
	
	ret
Player_dtor endp

; Handle input
Player_handleInput proc pPlayer:ptr Player, evt:ptr SDL_Event
	
	mov rsi, evt
	.if (SDL_Event PTR[rsi]).type_ == SDL_KEYDOWN && (SDL_Event PTR[rsi]).key.repeat_ == 0 
		nop
	.elseif (SDL_Event PTR[rsi]).type_ == SDL_KEYUP && (SDL_Event PTR[rsi]).key.repeat_ == 0
		nop
	.endif
	ret
Player_handleInput endp

; Update player
Player_update proc pPlayer:ptr Player
	
	ret
Player_update endp

; Render texture
Player_render proc pPlayer:ptr Player
	
	ret
Player_render endp
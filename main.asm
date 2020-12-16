;
;
; Heroes Of Magick Worlds
; -----------------------
;
; Classic old RPG 2D game (with isometric view).
;
;------------------------------------------------------------------------------ 
OPTION WIN64:8
OPTION LITERALS:ON

; Include libraries
includelib SDL2.lib
includelib SDL2main.lib
includelib SDL2_image.lib
includelib SDL2_ttf.lib

include main.inc
include SDL.inc
include SDL_image.inc
include SDL_ttf.inc

GameCTX struct
	m_pWindow 		QWORD ?
	m_pRenderer 	QWORD ?
	m_eventHandler 	SDL_Event <>
	m_quit			BYTE ?
GameCTX ends

Window struct
	m_Width 	DWORD ?
	m_Height 	DWORD ?
Window ends

include texture.asm

InitGame proto
HaltGame proto
InitSDL2 proto
HaltSDL2 proto

.const

.data?

.data

gGameCtx	GameCTX<>
gWindow 	Window<>

gTexture 	Texture<>

.code
main proc 
	LOCAL clip:SDL_Rect
	LOCAL x:DWORD
	LOCAL y:DWORD
	
	mov x, 0
	mov y, 0
	invoke InitGame
	
	mov gGameCtx.m_quit, 0
	.while gGameCtx.m_quit != 1
		; Process Input
		invoke SDL_PollEvent, addr gGameCtx.m_eventHandler
		.while rax != 0
			.if gGameCtx.m_eventHandler.type_ == SDL_EVENTQUIT
				mov gGameCtx.m_quit, 1
			.endif
			
			invoke SDL_PollEvent, addr gGameCtx.m_eventHandler
		.endw
		
		invoke SDL_GetKeyboardState, 0
		.if BYTE PTR [rax + SDL_SCANCODE_UP]
			sub y, 10
		.endif
		.if  BYTE PTR [rax + SDL_SCANCODE_DOWN]
			add y, 10
		.endif
		.if  BYTE PTR [rax + SDL_SCANCODE_LEFT]
			sub x, 10
		.endif
		.if  BYTE PTR [rax + SDL_SCANCODE_RIGHT]
			add x, 10
		.endif
		; Update game based on dt
		
		; Render the game
		invoke SDL_SetRenderDrawColor, gGameCtx.m_pRenderer, 0, 0, 0, 0FFh
		invoke SDL_RenderClear, gGameCtx.m_pRenderer
		
		; Draw texture
		mov clip.w, 160
		mov clip.h, 160
		invoke Texture_render, addr gTexture, x, y, addr clip, 0, 0, 0  
		
		; Finally, render the GUI
		
		invoke SDL_RenderPresent, gGameCtx.m_pRenderer
	.endw
	
	invoke HaltGame
	
	invoke ExitProcess, EXIT_SUCCESS
	ret
main endp

InitGame proc
	
	invoke InitSDL2
	
	; Load resources 
	invoke Texture_ctor, addr gTexture
	invoke Texture_loadTextureFile, addr gTexture, "Resources\\Textures\\Characters\\Necromancer_Male\\Necromancer_Base\\Sprite_1.png"
	
	ret
InitGame endp

HaltGame proc
	
	; Destroy resources
	invoke Texture_dtor, addr gTexture
	
	invoke HaltSDL2
	
	ret
HaltGame endp

InitSDL2 proc
	
	; Init SDL2
	invoke SDL_Init, SDL_INIT_VIDEO
	.if rax<0
		xor rax, rax
		jmp EXIT
	.endif
	
	invoke SDL_CreateWindow, 
		"Heroes of Magick Worlds", 
		SDL_WINDOWPOS_UNDEFINED, 
		SDL_WINDOWPOS_UNDEFINED, 
		1280, 
		960, 
		SDL_WINDOW_SHOWN
		
	.if rax==0
		jmp EXIT
	.endif
	mov gGameCtx.m_pWindow, rax

	; Create the renderer
	invoke SDL_CreateRenderer, rax, -1, SDL_RENDERER_ACCELERATED OR SDL_RENDERER_PRESENTVSYNC ; By default, we render a frame every 16ms.
	.if rax==0
		jmp EXIT
	.endif
	mov gGameCtx.m_pRenderer, rax
	
	; Initialize renderer color
	invoke SDL_SetRenderDrawColor, gGameCtx.m_pRenderer, 0FFh, 0FFh, 0FFh, 0FFh
	
	invoke IMG_Init, IMG_INIT_PNG
	and rax, IMG_INIT_PNG
	.if rax!=IMG_INIT_PNG
		xor rax, rax
		jmp EXIT
	.endif
	
    invoke TTF_Init
    .if rax==-1
    	xor rax, rax
    	jmp EXIT
    .endif
    
	mov rax, 1
EXIT:
	ret
InitSDL2 endp

HaltSDL2 proc
	
	invoke SDL_DestroyRenderer, gGameCtx.m_pRenderer 
	invoke SDL_DestroyWindow, gGameCtx.m_pWindow
	
	invoke TTF_Quit
	invoke IMG_Quit
	invoke SDL_Quit
	ret
HaltSDL2 endp

END

; vim options: ts=2 sw=2

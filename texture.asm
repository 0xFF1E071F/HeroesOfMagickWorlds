include texture.inc

externdef gGameCtx:GameCTX

.code
Texture_ctor proc uses rdi, pTexture:ptr Texture
	mov rdi, pTexture
	mov (Texture PTR[rdi]).m_pTexture, 0
	mov (Texture PTR[rdi]).m_Width, 0
	mov (Texture PTR[rdi]).m_Height, 0
	ret
Texture_ctor endp

; Destructor
Texture_dtor proc uses rdi, pTexture:ptr Texture
	mov rdi, pTexture
	.if (Texture PTR[rdi]).m_pTexture!=0
		invoke SDL_DestroyTexture, (Texture PTR[rdi]).m_pTexture
		mov (Texture PTR[rdi]).m_pTexture, 0
		mov (Texture PTR[rdi]).m_Width, 0
		mov (Texture PTR[rdi]).m_Height, 0
	.endif
	ret
Texture_dtor endp

; load from file
Texture_loadTextureFile proc uses rbx rsi pTexture:ptr Texture, strPathToTextureFile: ptr BYTE
	LOCAL bSuccess:BYTE
	LOCAL loadedSurface:QWORD
	LOCAL newTexture:QWORD
	
	mov bSuccess, 1
	mov newTexture, 0
	
	mov rsi, pTexture
	
	; First we should clean existing texture from pTexture data structure
	invoke Texture_dtor, pTexture
	
	invoke IMG_Load, strPathToTextureFile
	.if rax==0
		mov bSuccess, 0
		jmp ERROR
	.endif
	
	mov loadedSurface, rax
	invoke SDL_MapRGB, (SDL_Surface PTR [rax]).format,0,0FFh, 0FFh
	invoke SDL_SetColorKey, loadedSurface, 1, eax
	
	; Create texture from surface pixels
	invoke SDL_CreateTextureFromSurface, gGameCtx.m_pRenderer, loadedSurface
	.if rax==0
		mov bSuccess, 0
		jmp ERROR
	.endif
	mov newTexture, rax
	
	; Get image dimensions
	mov rsi, loadedSurface
	mov eax, (SDL_Surface PTR [rsi]).w
	mov ebx, (SDL_Surface PTR [rsi]).h
	
	mov rsi, pTexture
	mov (Texture PTR[rsi]).m_Width, eax
	mov (Texture PTR[rsi]).m_Height, ebx
	
	; Set texture
	mov rax, newTexture
	mov (Texture PTR[rsi]).m_pTexture,rax
	 
	; Delete old loaded surface
	invoke SDL_FreeSurface, loadedSurface
	
ERROR:
	mov al, bSuccess
	ret
Texture_loadTextureFile endp

; Render texture
Texture_render proc uses rbx rsi rdi r12 r13 r14 r15, pTexture:ptr Texture, x:DWORD, y:DWORD, pClip:ptr SDL_Rect, angle:real8, pCenter:ptr SDL_Point, flip:SDL_RendererFlip
	LOCAL renderQuad:SDL_Rect
	
	mov rsi, pTexture
	mov rbx, (Texture PTR[rsi]).m_pTexture

	mov r12d, x
	mov r13d, y
	mov r14d, (Texture PTR[rsi]).m_Width
	mov r15d, (Texture PTR[rsi]).m_Height
	
	mov renderQuad.x, r12d
	mov renderQuad.y, r13d
	mov renderQuad.w, r14d
	mov renderQuad.h, r15d
	
	.if pClip != 0
		mov rsi, pClip
		mov r14d, (SDL_Rect PTR[rsi]).w
		mov r15d, (SDL_Rect PTR[rsi]).h
		mov renderQuad.w, r14d
		mov renderQuad.h, r15d
	.endif
	
    invoke SDL_RenderCopyEx, gGameCtx.m_pRenderer, rbx, pClip, addr renderQuad, angle, pCenter, flip
	ret
Texture_render endp
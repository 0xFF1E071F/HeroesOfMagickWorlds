ifndef Sprite_h_
Sprite_h_	EQU	<>

Sprite struct
	m_pTexture 	QWORD ?  
	m_Width 	DWORD ?
	m_Height 	DWORD ?
Sprite ends

; Constructor
Sprite_ctor proto :ptr Texture

; Destructor
Sprite_dtor proto :ptr Texture

; load from file
Sprite_loadTextureFile proto :ptr Texture, :ptr BYTE

; Render texture
Sprite_render proto :ptr Texture, :DWORD, :DWORD, :ptr SDL_Rect, :real8, :ptr SDL_Point, :SDL_RendererFlip

endif
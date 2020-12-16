ifndef Texture_h_
Texture_h_	EQU	<>

Texture struct
	m_pTexture 	QWORD ?  
	m_Width 	DWORD ?
	m_Height 	DWORD ?
Texture ends

; Constructor
Texture_ctor proto :ptr Texture

; Destructor
Texture_dtor proto :ptr Texture

; load from file
Texture_loadTextureFile proto :ptr Texture, :ptr BYTE

; Render texture
Texture_render proto :ptr Texture, :DWORD, :DWORD, :ptr SDL_Rect, :real8, :ptr SDL_Point, :SDL_RendererFlip

endif
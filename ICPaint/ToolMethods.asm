;
; ToolMethods.asm
;
; Created: 26/11/2016 18:20:46
; Authors: AL4413, MV914
; 

SelectColours:									;Selection Method - Checks if mouse is selecting a colour square (r19,r22) and sets the foreground colour to it 
		push r19
		push r20
		push r21
		push r22
		push r25
		push r26
		
	SelectColour1:								;Checks if RED square selected 
		ldi r19, 5
		ldi r20, 0
		ldi r21, 5
		ldi r22, 0
		call MouseOnColourSquare				;Compare mouse position to 20x20 square at position r19-r22 
		cpi r16, $ff
		BRNE SelectColour2						;if red square not selected -> go to green square
		
		ldi r19,1								;Colour 1 selected
		rcall SetSelectedColour					;Sets the SelectedColour value in memory to the value in r19
		call DrawSelectedColour					;Draws a selection box around the ColourSquareSelected square from memory
		
		ldi r25, COLOUR_REDL
		ldi r26, COLOUR_REDH
		call SetForegroundColour				;Sets Foreground colour to RED

		rjmp SelectColoursEnd

	SelectColour2:								;Checks if GREEN square selected 
		ldi r19, 30
		ldi r20, 0
		ldi r21, 5
		ldi r22, 0
		call MouseOnColourSquare				;Compare mouse position to 20x20 square at position r19-r22
		cpi r16, $ff	
		BRNE SelectColour3						;if green square not selected -> go to blue square
		
		ldi r19,2								;Colour 2 selected 
		rcall SetSelectedColour					;Sets the SelectedColour value in memory to the value in r19
		call DrawSelectedColour					;Draws a selection box around the ColourSquareSelected square from memory
		
		ldi r25, COLOUR_GREENL
		ldi r26, COLOUR_GREENH
		call SetForegroundColour

		rjmp SelectColoursEnd

	SelectColour3:								;Checks if BLUE square selected 
		ldi r19, 55
		ldi r20, 0
		ldi r21, 5
		ldi r22, 0
		call MouseOnColourSquare				;Compare mouse position to 20x20 square at position r19-r22
		cpi r16, $ff
		BRNE SelectColour4						;if blue square not selected -> go to cyan square
		
		ldi r19,3								;Colour 3 selected
		rcall SetSelectedColour					;Sets the SelectedColour value in memory to the value in r19
		call DrawSelectedColour					;Draws a selection box around the ColourSquareSelected square from memory
		
		ldi r25, COLOUR_BLUEL
		ldi r26, COLOUR_BLUEH
		call SetForegroundColour

		rjmp SelectColoursEnd
	
	SelectColour4:								;Checks if CYAN square selected 
		ldi r19, 5
		ldi r20, 0
		ldi r21, 30
		ldi r22, 0
		call MouseOnColourSquare				;Compare mouse position to 20x20 square at position r19-r22
		cpi r16, $ff
		BRNE SelectColour5						;if cyan square not selected -> go to magenta square
		
		ldi r19,4								;colour 4 selected 
		rcall SetSelectedColour					;Sets the SelectedColour value in memory to the value in r19
		call DrawSelectedColour					;Draws a selection box around the ColourSquareSelected square from memory
		
		ldi r25, COLOUR_CYANL
		ldi r26, COLOUR_CYANH
		call SetForegroundColour

		rjmp SelectColoursEnd
	
	SelectColour5:								;Checks if MAGENTA square selected 
		ldi r19, 30
		ldi r20, 0
		ldi r21, 30
		ldi r22, 0
		call MouseOnColourSquare				;Compare mouse position to 20x20 square at position r19-r22
		cpi r16, $ff
		BRNE SelectColour6						;if magenta square not selected -> go to yellow square
		
		ldi r19,5								;Colour 5 selected 
		rcall SetSelectedColour					;Sets the SelectedColour value in memory to the value in r19
		call DrawSelectedColour					;Draws a selection box around the ColourSquareSelected square from memory
		
		ldi r25, COLOUR_MAGENTAL
		ldi r26, COLOUR_MAGENTAH
		call SetForegroundColour
		
		rjmp SelectColoursEnd

	SelectColour6:								;Checks if YELLOW square selected 
		ldi r19, 55
		ldi r20, 0
		ldi r21, 30
		ldi r22, 0
		call MouseOnColourSquare				;Compare mouse position to 20x20 square at position r19-r22
		cpi r16, $ff
		BRNE SelectColour7						;if yellow square not selected -> go to white square
		
		ldi r19,6								;Colour 6 selected 
		rcall SetSelectedColour					;Sets the SelectedColour value in memory to the value in r19.
		call DrawSelectedColour					;Draws a selection box around the ColourSquareSelected square from memory
		
		ldi r25, COLOUR_YELLOWL
		ldi r26, COLOUR_YELLOWH
		call SetForegroundColour
		
		rjmp SelectColoursEnd

	SelectColour7:								;Checks if WHITE square selected 
		ldi r19, 5
		ldi r20, 0
		ldi r21, 55
		ldi r22, 0
		call MouseOnColourSquare				;Compare mouse position to 20x20 square at position r19-r22
		cpi r16, $ff
		BRNE SelectColour8						;if white square not selected -> go to grey square
		
		ldi r19,7								;Colour 7 selected
		rcall SetSelectedColour					;Sets the SelectedColour value in memory to the value in r19.
		call DrawSelectedColour					;Draws a selection box around the ColourSquareSelected square from memory
		
		ldi r25, COLOUR_WHITEL
		ldi r26, COLOUR_WHITEH
		call SetForegroundColour

		rjmp SelectColoursEnd

	SelectColour8:								;Checks if GREY square selected 
		ldi r19, 30
		ldi r20, 0
		ldi r21, 55
		ldi r22, 0
		call MouseOnColourSquare				;Compare mouse position to 20x20 square at position r19-r22
		cpi r16, $ff
		BRNE SelectColour9						;if grey square not selected -> go to black square
		
		ldi r19,8								;Colour 8 selected
		rcall SetSelectedColour					;Sets the SelectedColour value in memory to the value in r19.
		call DrawSelectedColour					;Draws a selection box around the ColourSquareSelected square from memory
		
		ldi r25, COLOUR_GREYL
		ldi r26, COLOUR_GREYH
		call SetForegroundColour
		
		rjmp SelectColoursEnd
		
	SelectColour9:								;Checks if BLACK square selected 
		ldi r19, 55
		ldi r20, 0
		ldi r21, 55
		ldi r22, 0
		call MouseOnColourSquare				;Compare mouse position to 20x20 square at position r19-r22
		cpi r16, $ff
		BRNE SelectColour10						;if black square not selected -> go to first custom square
		
		ldi r19,9								;Colour 9 selected
		rcall SetSelectedColour					;Sets the SelectedColour value in memory to the value in r19.
		call DrawSelectedColour					;Draws a selection box around the ColourSquareSelected square from memory
			
		ldi r25, COLOUR_BLACKL
		ldi r26, COLOUR_BLACKH
		call SetForegroundColour

		rjmp SelectColoursEnd
	
	SelectColour10:								;Checks if FIRST CUSTOM square selected 
		ldi r19, 5
		ldi r20, 0
		ldi r21, 80
		ldi r22, 0
		call MouseOnColourSquare				;Compare mouse position to 20x20 square at position r19-r22
		cpi r16, $ff
		BRNE SelectColour11						;if first custom square not selected -> go to second custom square
		
		ldi r19,10								;First Custom colour selected 
		rcall SetSelectedColour					;Sets the SelectedColour value in memory to the value in r19.
		call DrawSelectedColour					;Draws a selection box around the ColourSquareSelected square from memory
	
		push ZL
		push ZH
		
		;Sets the foreground colour on the driver memory $0160 and $0161 to first custom colour stored in r25/26
		ldi ZL,$60
		ldi ZH,$01								
		ld r25, Z+								
		ld r26, Z+								
		call SetForegroundColour				
		
		pop ZH
		pop ZL

		call SetSlidersToForegroundColour		;Puts slider pointers in the corresponding position for the first custom colour 

		rjmp SelectColoursEnd

	SelectColour11:								;Checks if SECOND CUSTOM square selected
		ldi r19, 30	
		ldi r20, 0
		ldi r21, 80
		ldi r22, 0
		call MouseOnColourSquare
		cpi r16, $ff
		BRNE SelectColour12
		
		ldi r19,11								;Second Custom colour selected 
		rcall SetSelectedColour					;Sets the SelectedColour value in memory to the value in r19.
		call DrawSelectedColour					;Draws a selection box around the ColourSquareSelected square from memory

		push ZL
		push ZH
		
		;Sets the foreground colour on the driver memory $0162 and $0163 to second custom colour stored in r25/26
		ldi ZL,$62						
		ldi ZH,$01
		ld r25, Z+
		ld r26, Z+
		call SetForegroundColour				
		
		pop ZH
		pop ZL

		call SetSlidersToForegroundColour		;Puts slider pointers in the corresponding position for the second custom colour 

		rjmp SelectColoursEnd
		
	SelectColour12:								;Checks if THIRD CUSTOM square selected
		ldi r19, 55
		ldi r20, 0
		ldi r21, 80			
		ldi r22, 0
		call MouseOnColourSquare
		cpi r16, $ff
		BRNE SelectColoursEnd
		
		ldi r19,12								;Third Custom colour selected 
		rcall SetSelectedColour					;Sets the SelectedColour value in memory to the value in r19.
		call DrawSelectedColour					;Draws a selection box around the ColourSquareSelected square from memory

		push ZL
		push ZH
		
		;Sets the foreground colour on the driver memory $0164 and $0165 to third custom colour stored in r25/26
		ldi ZL,$64								
		ldi ZH,$01
		ld r25, Z+
		ld r26, Z+
		call SetForegroundColour				
		
		pop ZH
		pop ZL

		call SetSlidersToForegroundColour		;Puts slider pointers in the corresponding position for the third custom colour 

	SelectColoursEnd:
		pop r26
		pop r25
		pop r22
		pop r21
		pop r20
		pop r19
		ret
		
		
SetSelectedColour:								;Sets the SelectedColour value in memory to the value in r19.
		push ZL
		push ZH
		
		ldi ZL,$56
		ldi ZH,$01
		ST Z,r19
		
		pop ZH
		pop ZL
		ret



SelectTool1:									;Selection method - Tool box 1, RECTANGLE 
		push r16
		push r19
		push r20
		push r21
		push r22
		push r25
		push r26
		push YL
		push YH

		ldi r19,5 								;= x1low
		ldi r20,0 								;= x1high
		ldi r21,185 							;= y1low
		ldi r22,0 								;= y1highSquare
		call MouseOnToolSquare					;Compare mouse position to 20x20 square at position r19-r22

		cpi r16, $ff
		BRNE SelectTool1End						;if tool not selected, END 
												;else tool selected
		ldi YL,$25								;CurrentDrawingMode memory $0125
		ldi YH,$01
		ldi r19,$01
		ST Y,r19								
		rcall ResetTools						;Sets CurrentDrawingMode to RectangleTool
		call DrawSelectedTool					;Draws black square around selected tool box

	SelectTool1End:
		pop YH
		pop YL
		pop r26
		pop r25
		pop r22
		pop r21
		pop r20
		pop r19
		pop r16
		ret

SelectTool2:									;Selection method - Tool box 2, ELLIPSE
		push r16
		push r19
		push r20
		push r21
		push r22
		push r25
		push r26
		push YL
		push YH

		ldi r19,43 								;= x1low
		ldi r20,0 								;= x1high
		ldi r21,185 							;= y1low
		ldi r22,0 								;= y1highSquare
		call MouseOnToolSquare					;Compare mouse position to 20x20 square at position r19-r22

		cpi r16, $ff
		BRNE SelectTool2End						;if tool not selected, END
												;else tool selected
		ldi YL,$25								;CurrentDrawingMode memory $0125	
		ldi YH,$01
		ldi r19,$02
		ST Y,r19
		rcall ResetTools						;Sets CurrentDrawingMode to EllipseTool
		call DrawSelectedTool					;Draws black square around selected tool box

	SelectTool2End:
		pop YH
		pop YL
		pop r26
		pop r25
		pop r22
		pop r21
		pop r20
		pop r19
		pop r16
		ret

SelectTool3:									;Selection method - Tool box 3, TRIANGLE
		push r16
		push r19
		push r20
		push r21
		push r22
		push r25
		push r26
		push YL
		push YH

		ldi r19,5 								;= x1low
		ldi r20,0 								;= x1high
		ldi r21,222 							;= y1low
		ldi r22,0								;= y1highSquare
		call MouseOnToolSquare					;Compare mouse position to 20x20 square at position r19-r22

		cpi r16, $ff				
		BRNE SelectTool3End						;if tool not selected, END
												;else tool selected
		ldi YL,$25								;CurrentDrawingMode memory $0125
		ldi YH,$01
		ldi r19,$03								;Sets CurrentDrawingMode to TriangleTool
		ST Y,r19
		
		rcall ResetTools
		call DrawSelectedTool					;Draws black square around selected tool box

	SelectTool3End:
		pop YH
		pop YL
		pop r26
		pop r25
		pop r22
		pop r21
		pop r20
		pop r19
		pop r16
		ret

SelectTool4:									;Selection method - Tool box 4, BRUSH
		push r16
		push r19
		push r20
		push r21
		push r22
		push r25
		push r26
		push YL
		push YH

		ldi r19,43 								;= x1low
		ldi r20,0 								;= x1high
		ldi r21,222 							;= y1low
		ldi r22,0 								;= y1highSquare
		call MouseOnToolSquare					;Compare mouse position to 20x20 square at position r19-r22

		cpi r16, $ff
		BRNE SelectTool4End						;if tool not selected, END
												;else tool selected
		ldi YL,$25								;CurrentDrawingMode memory $0125
		ldi YH,$01
		ldi r19,$00								
		ST Y,r19								;Sets CurrentDrawingMode to PaintBrush
		
		rcall ResetTools
		call DrawSelectedTool					;Draws black square around selected tool box

	SelectTool4End:
		pop YH
		pop YL
		pop r26
		pop r25
		pop r22
		pop r21
		pop r20
		pop r19
		pop r16
		ret

SelectTool5:									;Selection method - Tool box 5, LINE
		push r16
		push r19
		push r20
		push r21
		push r22
		push r25
		push r26
		push YL
		push YH

		ldi r19,5 								;= x1low
		ldi r20,0 								;= x1high
		ldi r21,3 								;= y1low
		ldi r22,1 								;= y1highSquare
		call MouseOnToolSquare					;Compare mouse position to 20x20 square at position r19-r22

		cpi r16, $ff
		BRNE SelectTool5End						;if tool not selected, END
												;else tool selected
		ldi YL,$25								;CurrentDrawingMode memory $0125
		ldi YH,$01
		ldi r19,$04								
		ST Y,r19								;Sets CurrentDrawingMode to LineTool
		
		rcall ResetTools
		call DrawSelectedTool					;Draws black square around selected tool box

	SelectTool5End:
		pop YH
		pop YL
		pop r26
		pop r25
		pop r22
		pop r21
		pop r20
		pop r19
		pop r16
		ret

SelectTool6:									;Selection method - Tool box 6, ERASER
		push r16
		push r19
		push r20
		push r21
		push r22
		push r25
		push r26
		push YL
		push YH

		ldi r19,43 								;= x1low
		ldi r20,0 								;= x1high
		ldi r21,3 								;= y1low
		ldi r22,1 								;= y1highSquare
		call MouseOnToolSquare					;Compare mouse position to 20x20 square at position r19-r22

		cpi r16, $ff
		BRNE SelectTool6End						;if tool not selected, END
												;else tool selected
		ldi YL,$25								;CurrentDrawingMode memory $0125
		ldi YH,$01								
		ldi r19,$05								
		ST Y,r19								;Sets CurrentDrawingMode to EraserTool
		
		rcall ResetTools
		call DrawSelectedTool					;Draws black square around selected tool box

	SelectTool6End:
		pop YH
		pop YL
		pop r26
		pop r25
		pop r22
		pop r21
		pop r20
		pop r19
		pop r16
		ret


ResetTools:										;Resets all Tools to initial value 
		rcall RectangleToolReset
		rcall EllipseToolReset
		rcall TriangleToolReset
		rcall LineToolReset
		ret
		

ResetBrush:										;Resets Brush to initial value
		push r16
		push ZL
		push ZH

		ldi ZL,$55								;Load address of the BrushSize into Z register.
		ldi ZH,$01
		ldi r16,3
		ST Z,r16								;Set the BrushSize to 3 (i.e. circle of radius 3)

		pop ZH
		pop ZL
		pop r16
		ret

RectangleToolReset:
		push r16
		push ZL
		push ZH
		ldi ZL, $30
		ldi ZH, $01
		ldi r16, $00
		ST Z+, r16 								;$0130
		ST Z+, r16 								;$0131
		ST Z+, r16 								;$0132
		ST Z+, r16 								;$0133
		ST Z+, r16 								;$0134
		pop ZH
		pop ZL
		pop r16
		ret							;Resets Rectangle to initial value

EllipseToolReset:
		push r16
		push ZL
		push ZH
		ldi ZL, $35
		ldi ZH, $01
		ldi r16, $00
		ST Z+, r16 								;$0135
		ST Z+, r16 								;$0136
		ST Z+, r16 								;$0137
		ST Z+, r16 								;$0138
		ST Z+, r16 								;$0139
		pop ZH
		pop ZL
		pop r16
		ret							;Resets Ellipse to initial value

TriangleToolReset:
		push r16
		push ZL
		push ZH
		ldi ZL, $40
		ldi ZH, $01
		ldi r16, $00
		ST Z+, r16								;$0141
		ST Z+, r16								;$0142
		ST Z+, r16 								;$0143
		ST Z+, r16 								;$0144
		ST Z+, r16 								;$0145
		ST Z+, r16								;$0146
		ST Z+, r16 								;$0147
		ST Z+, r16 								;$0148
		pop ZH
		pop ZL
		pop r16
		ret							;Resets Triangle to initial value

LineToolReset:
		push r16
		push ZL
		push ZH
		ldi ZL, $50
		ldi ZH, $01
		ldi r16, $00
		ST Z+, r16 								;$0150
		ST Z+, r16 								;$0151
		ST Z+, r16 								;$0152
		ST Z+, r16 								;$0153
		ST Z+, r16 								;$0154
		pop ZH
		pop ZL
		pop r16
		ret								;Resets Line to initial value

CustomColoursReset:
		push r16
		push ZL
		push ZH
		ldi ZL, $60
		ldi ZH, $01
		ldi r16, $00							;set custom colours to black.
		ST Z+, r16 								;$0160
		ST Z+, r16 								;$0161
		ST Z+, r16 								;$0162
		ST Z+, r16 								;$0163
		ST Z+, r16 								;$0164
		ST Z+, r16 								;$0165
		pop ZH
		pop ZL
		pop r16
		ret							;Resets CustomColour to initial value

		
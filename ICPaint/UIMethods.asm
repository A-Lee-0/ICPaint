/*
 * UIMethods.asm
 *
 *  Created: 22/11/2016 14:03:46
 *   Author: al4413
 */ 

 DrawUserInterface:
		push r25
		push r26
		push YL
		push YH
		push ZL
		push ZH

		call SaveForegroundColourToTemp		;Stores current ForegroundColour into TempForegroundColour in memory
		call DrawSidebar					;Draw Grey rectangle as background to user interface

	;RED SLIDER BAR
		ldi r25, COLOUR_REDL
		ldi r26, COLOUR_REDH
		call SetForegroundColour			;Set Foreground Colour to RED.
		
		ldi YL,7
		ldi YH,0
		ldi ZL,110
		ldi ZH,0
		
		call DrawSliderBar									
		adiw Z,1
		call DrawRedSliderBar				;Draw a slider bar of the foreground colour at position in Y,Z

	;GREEN SLIDER BAR
		ldi r25, COLOUR_GREENL
		ldi r26, COLOUR_GREENH
		call SetForegroundColour			;Set Foreground Colour to GREEN.
		ldi YL,7
		ldi YH,0
		ldi ZL,135
		ldi ZH,0
		
		call DrawSliderBar
		adiw Z,1
		call DrawGreenSliderBar				;Draw a slider bar of the foreground colour at position in Y,Z

	;BLUE SLIDER BAR
		ldi r25, COLOUR_BLUEL
		ldi r26, COLOUR_BLUEH
		call SetForegroundColour			;Set Foreground Colour to BLUE.
		
		ldi YL,7
		ldi YH,0
		ldi ZL,160
		ldi ZH,0
		
		call DrawSliderBar					;Draw a slider bar of the foreground colour at position in Y(x),Z(y)
		adiw Z,1
		call DrawBlueSliderBar
		
	;BRUSH SIZE SLIDER BAR
		ldi r25, COLOUR_WHITEL
		ldi r26, COLOUR_WHITEH
		call SetForegroundColour			;Set Foreground Colour to WHITE.
		
		ldi YL,7
		ldi YH,0
		ldi ZL,$75
		ldi ZH,$01
		call DrawSliderBar

		call LoadForegroundColourFromTemp

	;COLOUR SQUARES
		rcall DrawColours
		rcall DrawSelectedColour
		rcall DrawSelectedTool

	;TOOL ICONS
		call SaveForegroundColourToTemp		;Backup current ForegroundColour into TempForegroundColour in memory.
		
		rcall DrawRectangleTool				;First Tool: Draws the rectangle tool icon on screen.
		rcall DrawEllipseTool				;Second Tool: Draws the Ellipse tool icon on screen.
		rcall DrawTriangleTool				;Third Tool: Draws the triangle tool icon on screen.
		rcall DrawPaintBrushTool			;Fourth Tool: Draws the Paint Brush tool icon on screen.	
		rcall DrawLineTool					;Fifth Tool: Draws the Line tool icon on screen.
		rcall DrawEraserTool				;Sixth Tool: Draws the Eraser tool icon on screen.
		
		call LoadForegroundColourFromTemp	;Reloads saved foreground colour from TempForegroundColour in memory.
	
	;BRUSH SIZE DISPLAY
		rcall DrawBrushSizeTool				;Draws a circle of radius = brush size above the Brush Size slider bar.

		pop ZH
		pop ZL
		pop YH
		pop YL
		pop r26
		pop r25
		ret
		
DrawColours:								;To user interface, uploads the 12 colours squares. 
		push r25
		push r26
		push YL
		push YH
		push ZL
		push ZH

		call SaveForegroundColourToTemp				
		
		ldi r25, COLOUR_REDL				;Square 1, red colour. 
		ldi r26, COLOUR_REDH
		call SetForegroundColour
		ldi YL, 5									 
		ldi YH, 0
		ldi ZL, 5
		ldi ZH, 0
		call DrawColouredSquare

		ldi r25, COLOUR_GREENL				;Square 2, green colour. 

		ldi r26, COLOUR_GREENH
		call SetForegroundColour
		ldi YL, 30
		ldi YH, 0
		ldi ZL, 5
		ldi ZH, 0
		call DrawColouredSquare

		ldi r25, COLOUR_BLUEL				;Square 3, blue colour. 

		ldi r26, COLOUR_BLUEH
		call SetForegroundColour
		ldi YL, 55
		ldi YH, 0
		ldi ZL, 5
		ldi ZH, 0
		call DrawColouredSquare

		ldi r25, COLOUR_CYANL				;Square 4, cyan  colour. 
		ldi r26, COLOUR_CYANH
		call SetForegroundColour
		ldi YL, 5
		ldi YH, 0
		ldi ZL, 30
		ldi ZH, 0
		call DrawColouredSquare

		ldi r25, COLOUR_MAGENTAL			;Square 5, magenta colour. 
		ldi r26, COLOUR_MAGENTAH
		call SetForegroundColour
		ldi YL, 30
		ldi YH, 0
		ldi ZL, 30
		ldi ZH, 0
		call DrawColouredSquare

		ldi r25, COLOUR_YELLOWL				;Square 6, yellow colour. 
		ldi r26, COLOUR_YELLOWH
		call SetForegroundColour
		ldi YL, 55
		ldi YH, 0
		ldi ZL, 30
		ldi ZH, 0
		call DrawColouredSquare

		ldi r25, COLOUR_WHITEL				;Square 7, white colour. 
		ldi r26, COLOUR_WHITEH
		call SetForegroundColour
		ldi YL, 5
		ldi YH, 0
		ldi ZL, 55
		ldi ZH, 0
		call DrawColouredSquare

		ldi r25, COLOUR_GREYL				;Square 8, grey colour. 
		ldi r26, COLOUR_GREYH
		call SetForegroundColour
		ldi YL, 30
		ldi YH, 0
		ldi ZL, 55
		ldi ZH, 0
		call DrawColouredSquare

		ldi r25, COLOUR_BLACKL				;Square 9, black colour. 
		ldi r26, COLOUR_BLACKH
		call SetForegroundColour
		ldi YL, 55
		ldi YH, 0
		ldi ZL, 55
		ldi ZH, 0
		call DrawColouredSquare

		ldi ZL,$60							;Square 10, Custom colour 1. 
		ldi ZH,$01
		ld r25, Z+
		ld r26, Z+
		call SetForegroundColour
		ldi YL, 5
		ldi YH, 0
		ldi ZL, 80
		ldi ZH, 0
		call DrawColouredSquare

		ldi ZL,$62							;Square 11, Custom colour 2. 
		ldi ZH,$01
		ld r25, Z+
		ld r26, Z+
		call SetForegroundColour
		ldi YL, 30
		ldi YH, 0
		ldi ZL, 80
		ldi ZH, 0
		call DrawColouredSquare

		ldi ZL,$64							;Square 12, Custom colour 3. 
		ldi ZH,$01
		ld r25, Z+
		ld r26, Z+
		call SetForegroundColour
		ldi YL, 55
		ldi YH, 0
		ldi ZL, 80
		ldi ZH, 0
		call DrawColouredSquare
		
		call LoadForegroundColourFromTemp

		pop ZH
		pop ZL
		pop YH
		pop YL
		pop r26
		pop r25
		ret


DrawRectangleTool:							;First Tool: Draws the rectangle square tool on screen to select "DrawRectangle"
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26
		push r27

		ldi r25, COLOUR_WHITEL				;Draws filled white square (background of the icon)
		ldi r26, COLOUR_WHITEH
		call SetForegroundColour
		ldi r17,5							;= x1low
		ldi r18,0							;= x1high
		ldi r19,185							;= y1low
		ldi r20,0							;= y1high
		ldi r21,37							;= x2low
		ldi r22,0							;= x2high
		ldi r23,217							;= y2low
		ldi r24, 0							;= y2high
		ldi r27, $ff						;= booleanfilled
		call DrawRectangle

		ldi r25, COLOUR_BLACKL				;Draws non-filled black rectangle around icon
		ldi r26, COLOUR_BLACKH
		call SetForegroundColour
		ldi r17,5							;= x1low
		ldi r18,0							;= x1high
		ldi r19,185							;= y1low
		ldi r20,0							;= y1high
		ldi r21,37							;= x2low
		ldi r22,0							;= x2high
		ldi r23,217							;= y2low
		ldi r24, 0							;= y2high
		ldi r27, $00						;= boolean nonfilled
		call DrawRectangle

	;Draws non-filled black rectangle inside icon. 
		ldi r17,10							;= x1low
		ldi r18,0							;= x1high
		ldi r19,194							;= y1low
		ldi r20,0							;= y1high
		ldi r21,32							;= x2low
		ldi r22,0							;= x2high
		ldi r23,208							;= y2low
		ldi r24, 0							;= y2high
		ldi r27, $00						;= boolean nonfilled
		call DrawRectangle

		pop r27
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r18
		pop r17
		ret


DrawEllipseTool:							;Second Tool: Draws the Ellipse square tool on screen to select "DrawEllipse"
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26
		push r27

		ldi r25, COLOUR_WHITEL				;Draws filled white square (background of the icon)
		ldi r26, COLOUR_WHITEH
		call SetForegroundColour
		ldi r17,43							;= x1low
		ldi r18,0							;= x1high
		ldi r19,185							;= y1low
		ldi r20,0							;= y1high
		ldi r21,75							;= x2low
		ldi r22,0							;= x2high
		ldi r23,217							;= y2low
		ldi r24, 0							;= y2high
		ldi r27, $ff						;= booleanfilled
		call DrawRectangle

		ldi r25, COLOUR_BLACKL				;Draws non-filled black rectangle around icon.
		ldi r26, COLOUR_BLACKH
		call SetForegroundColour
		ldi r17,43							;= x1low
		ldi r18,0							;= x1high
		ldi r19,185							;= y1low
		ldi r20,0							;= y1high
		ldi r21,75							;= x2low
		ldi r22,0							;= x2high
		ldi r23,217							;= y2low
		ldi r24, 0							;= y2high
		ldi r27, $00						;= boolean nonfilled
		call DrawRectangle
											
	;Draws non-filled black ellipse inside icon. 
		ldi r19,59							;= x1low
		ldi r20,0							;= x1high
		ldi r21, 201						;= y1low
		ldi r22,0							;= y1high
		ldi r23,10							;= x2low
		ldi r24,0							;= x2high
		ldi r25,8							;= y2low
		ldi r26, 0							;= y2high
		ldi r27, $00						;= boolean nonfilled
		call DrawEllipseWithAxes

		pop r27
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r18
		pop r17
		ret


DrawTriangleTool:							;Third Tool: Draws the triangle square tool on screen to select "DrawTriangle"
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26
		push r27
		push r28
		push r29

		ldi r25, COLOUR_WHITEL				;Draws filled white square (background of the icon)							
		ldi r26, COLOUR_WHITEH
		call SetForegroundColour
		ldi r17,5							;= x1low
		ldi r18,0 							;= x1high
		ldi r19,222 						;= y1low
		ldi r20,0 							;= y1high
		ldi r21,37 							;= x2low
		ldi r22,0 							;= x2high
		ldi r23,254 						;= y2low
		ldi r24, 0 							;= y2high
		ldi r27, $ff 						;= booleanfilled
		call DrawRectangle

		ldi r25, COLOUR_BLACKL
		ldi r26, COLOUR_BLACKH
		call SetForegroundColour
		ldi r17,5 							;= x1low
		ldi r18,0 							;= x1high
		ldi r19,222 						;= y1low
		ldi r20,0 							;= y1high
		ldi r21,37 							;= x2low
		ldi r22,0 							;= x2high
		ldi r23,254 						;= y2low
		ldi r24, 0 							;= y2high
		ldi r27, $00 						;= booleanfilled
		call DrawRectangle
		
											;Draws non-filled black triangle inside icon. 
		ldi r17,10 							;= x1low
		ldi r18,0 							;= x1high
		ldi r19,231 						;= y1low
		ldi r20,0 							;= y1high
		ldi r21,10 							;= x2low
		ldi r22,0 							;= x2high
		ldi r23,245 						;= y2low
		ldi r24, 0 							;= y2high
		ldi r25,32 							;= x3low
		ldi r26,0 							;= x3high
		ldi r27,245 						;= y3low
		ldi r28, 0 							;= yhigh
		ldi r29, $00 						;= booleanfilled
		call DrawTriangle

		pop r29
		pop r28
		pop r27
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r18
		pop r17
		ret

DrawPaintBrushTool:								;Fourth Tool: Draws the Pencil square tool on screen to select "Draw"															
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26
		push r27
		push r28
		push r29

		ldi r25, COLOUR_WHITEL				;Draws filled white square (background of the icon)
		ldi r26, COLOUR_WHITEH
		call SetForegroundColour
		ldi r17,43							;= x1low
		ldi r18,0							;= x1high
		ldi r19,222							;= y1low
		ldi r20,0							;= y1high
		ldi r21,75							;= x2low
		ldi r22,0							;= x2high
		ldi r23,254							;= y2low
		ldi r24, 0							;= y2high
		ldi r27, $ff						;= booleanfilled
		call DrawRectangle

		ldi r25, COLOUR_BLACKL				;Draws non-filled black rectangle around icon.
		ldi r26, COLOUR_BLACKH
		call SetForegroundColour
		ldi r17,43							;= x1low
		ldi r18,0							;= x1high
		ldi r19,222							;= y1low
		ldi r20,0							;= y1high
		ldi r21,75							;= x2low
		ldi r22,0							;= x2high
		ldi r23,254							;= y2low
		ldi r24, 0							;= y2high
		ldi r27, $00						;= boolean nonfilled
		call DrawRectangle

											;Draws filled black triangle inside icon as the pencil peak. 
		ldi r17,48							;= x0low
		ldi r18,0							;= x0high
		ldi r19,227							;= y0low
		ldi r20,0							;= y0high
		ldi r21,50							;= x1low
		ldi r22,0							;= x1high
		ldi r23,233							;= y1low
		ldi r24, 0							;= y1high
		ldi r25,54							;= x2low
		ldi r26,0							;= x2high
		ldi r27,229							;= y2low
		ldi r28, 0							;= y2high
		ldi r29, $ff						;= boolean filled
		call DrawTriangle

											;Draws first black line to form pencil icon. 
		ldi r17,54							;= x0low
		ldi r18,0							;= x0high
		ldi r19,229							;= y0low
		ldi r20, 0							;= y0high
		ldi r21,69							;= x1low
		ldi r22,0							;= x1high
		ldi r23,244							;= y1low
		ldi r24, 0							;= y1high
		call DrawLine
		
											;Draws second black line to form pencil icon. 
		ldi r17,50							;= x0low
		ldi r18,0							;= x0high
		ldi r19,233							;= y0low
		ldi r20, 0							;= y0high
		ldi r21,65							;= x1low
		ldi r22,0							;= x1high
		ldi r23,248							;= y1low
		ldi r24, 0							;= y1high
		call DrawLine
		
											;Draws third black line to form pencil icon. 
		ldi r17,69							;= x0low
		ldi r18,0							;= x0high
		ldi r19,244							;= y0low
		ldi r20, 0							;= y0high
		ldi r21,65							;= x1low
		ldi r22,0							;= x1high
		ldi r23,248							;= y1low
		ldi r24, 0							;= y1high
		call DrawLine					
		
		
		pop r29
		pop r28
		pop r27
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r18
		pop r17
		ret

DrawLineTool:								;Fifth Tool: Draws the Line square tool on screen to select "DrawLine"	
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26
		push r27
		push r28
		push r29

		ldi r25, COLOUR_WHITEL				;Draws filled white square (background of the icon)
		ldi r26, COLOUR_WHITEH
		call SetForegroundColour
		ldi r17,5							;= x1low
		ldi r18,0 							;= x1high
		ldi r19,3 							;= y1low
		ldi r20,1 							;= y1high
		ldi r21,37 							;= x2low
		ldi r22,0 							;= x2high
		ldi r23,35 							;= y2low
		ldi r24,1 							;= y2high
		ldi r27, $ff 						;= boolean filled
		call DrawRectangle

		ldi r25, COLOUR_BLACKL				;Draws non-filled black rectangle around icon.
		ldi r26, COLOUR_BLACKH
		call SetForegroundColour
		ldi r17,5							;= x1low
		ldi r18,0 							;= x1high
		ldi r19,3 							;= y1low
		ldi r20,1 							;= y1high
		ldi r21,37 							;= x2low
		ldi r22,0 							;= x2high
		ldi r23,35 							;= y2low
		ldi r24,1 							;= y2high
		ldi r27, $00 						;= boolean nonfilled
		call DrawRectangle
		
	;Draws filled black Line inside icon. 
		ldi r17,10 							;= x1low
		ldi r18,0 							;= x1high
		ldi r19,8 							;= y1low
		ldi r20,1 							;= y1high
		ldi r21,32 							;= x2low
		ldi r22,0 							;= x2high
		ldi r23,30 							;= y2low
		ldi r24,1 							;= y2high
		ldi r27, $ff 						;= booleanfilled
		call DrawLine						;Draws a line from x0,y0 to x1,y1	

		pop r29
		pop r28
		pop r27
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r18
		pop r17
		ret

DrawEraserTool:								;Sixth Tool: Draws the Eraser square tool on screen to select "DrawPencil" in white
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26
		push r27
		push r28
		push r29

		ldi r25, COLOUR_WHITEL				;Draws filled white square (background of the icon)
		ldi r26, COLOUR_WHITEH
		call SetForegroundColour
		ldi r17,43							;= x1low
		ldi r18,0 							;= x1high
		ldi r19,3 							;= y1low
		ldi r20,1 							;= y1high
		ldi r21,75 							;= x2low
		ldi r22,0 							;= x2high
		ldi r23,35 							;= y2low
		ldi r24,1 							;= y2high
		ldi r27, $ff 						;= boolean filled
		call DrawRectangle

		ldi r25, COLOUR_BLACKL				;Draws non-filled black rectangle around icon.
		ldi r26, COLOUR_BLACKH
		call SetForegroundColour
		ldi r17,43							;= x1low
		ldi r18,0 							;= x1high
		ldi r19,3 							;= y1low
		ldi r20,1 							;= y1high
		ldi r21,75 							;= x2low
		ldi r22,0 							;= x2high
		ldi r23,35 							;= y2low
		ldi r24,1 							;= y2high
		ldi r27, $00 						;= booleanfilled
		call DrawRectangle

	;Draws first black line to form Eraser icon. 
		ldi r17,48							;= x1low
		ldi r18,0 							;= x1high
		ldi r19,15 							;= y1low
		ldi r20,1 							;= y1high
		ldi r21,55 							;= x2low
		ldi r22,0 							;= x2high
		ldi r23,8 							;= y2low
		ldi r24,1 							;= y2high
		call DrawLine
		
	;Draws second black line to form Eraser icon.
		ldi r17,52 							;= x1low
		ldi r18,0 							;= x1high
		ldi r19,19 							;= y1low
		ldi r20,1 							;= y1high
		ldi r21,59 							;= x2low
		ldi r22,0 							;= x2high
		ldi r23,12 							;= y2low
		ldi r24,1 							;= y2high
		call DrawLine
		
	;Draws third black line to form Eraser icon.
		ldi r17,60 							;= x1low
		ldi r18,0 							;= x1high
		ldi r19,27 							;= y1low
		ldi r20,1 							;= y1high
		ldi r21,67 							;= x2low
		ldi r22,0 							;= x2high
		ldi r23,20 							;= y2low
		ldi r24,1 							;= y2high
		call DrawLine

	;Draws fourth black line to form Eraser icon.
		ldi r17,55 							;= x2low
		ldi r18,0 							;= x2high
		ldi r19,8 							;= y2low
		ldi r20,1 							;= y2high
		ldi r21,67 							;= x2low
		ldi r22,0 							;= x2high
		ldi r23,20 							;= y2low
		ldi r24,1 							;= y2high
		call DrawLine

	;Draws fifth black line to form Eraser icon.
		ldi r17,60 							;= x0low
		ldi r18,0 							;= x0high
		ldi r19,27 							;= y0low
		ldi r20,1 							;= y0high
		ldi r21,48							 	;= x1low
		ldi r22,0 							;= x1high
		ldi r23,15 							;= y1low
		ldi r24,1 							;= y1high
		call DrawLine

	;Draws sixth black line to form Eraser icon.
		ldi r17,60 							;= x1low
		ldi r18,0 							;= x1high
		ldi r19,27 							;= y1low
		ldi r20,1 							;= y1high
		ldi r21,67 							;= x2low
		ldi r22,0							;= x2high
		ldi r23,20 							;= y2low
		ldi r24,1 							;= y2high

	;Draws  black triangle to fill Eraser icon.
		ldi r25,52 							;= x1low
		ldi r26,0 							;= x1high
		ldi r27,19 							;= y1low
		ldi r28,1 							;= y1high
		ldi r29, $ff 						;= booleanfilled
		call DrawTriangle

	;Draws  black triangle to fill Eraser icon.
		ldi r17,59 							;= x2low
		ldi r18,0 							;= x2high
		ldi r19,12 							;= y2low
		ldi r20,1 							;= y2high
		ldi r21,67 							;= x2low
		ldi r22,0 							;= x2high
		ldi r23,20 							;= y2low
		ldi r24,1 							;= y2high

		ldi r25,52 							;= x1low
		ldi r26,0 							;= x1high
		ldi r27,19 							;= y1low
		ldi r28,1 							;= y1high
		ldi r29, $ff 						;= booleanfilled
		call DrawTriangle



		pop r29
		pop r28
		pop r27
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r18
		pop r17
		ret

DrawBrushSizeTool:							;Seventh Tool-> Draws the brush square tool on screen
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26
		push r27
		push r28
		push r29

		call SaveForegroundColourToTemp

		ldi r25, COLOUR_WHITEL				;Draws filled white square (background of the icon)
		ldi r26, COLOUR_WHITEH
		call SetForegroundColour
		ldi r17, 5							;x1low
		ldi r18, 0							;x1high
		ldi r19, $28 						;y1low
		ldi r20, $01 						;y1high
		ldi r21, 75 						;x2low
		ldi r22, 0							;x2high
		ldi r23, $6E 						;y2low
		ldi r24, $01 						;y2high
		ldi r27, $ff 						;boolean filled
		call DrawRectangle

		ldi r25, COLOUR_BLACKL				;Draws non-filled black rectangle around icon.
		ldi r26, COLOUR_BLACKH
		call SetForegroundColour
		ldi r27, $00 						;boolean non-filled
		call DrawRectangle

		call LoadForegroundColourFromTemp
		ldi ZL,$55							;load BrushSize memory address into Z register
		ldi ZH,$01							
		ld r23,Z							;radiuslow
		ldi r24,0							;radiushigh
		ldi r19,40							;xlow
		ldi r20,0							;xhigh
		ldi r21,$4B							;ylow
		ldi r22,$01							;yhigh
		ldi r27,$ff 						;booleanfilled
		call DrawCircle
		call PaintPixel								;paint a single pixel in the middle of the circle, for a circle of 'zero' radius.

		ldi r25, COLOUR_BLACKL				;Draws non-filled black circle around icon.
		ldi r26, COLOUR_BLACKH
		call SetForegroundColour
		ldi r27,$00 						;boolean non-filled
		call DrawCircle


	;	r19 = xlow
	;	r20 = xhigh
	;	r21 = ylow
	;	r22 = yhigh
	;	r23 = radiuslow
	;	r24 = radiushigh
	;	r27 = booleanfilled

		call LoadForegroundColourFromTemp					;Overwrite current ForegroundColour with TempForegroundColour in memory.

		pop r29
		pop r28
		pop r27
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r18
		pop r17
		ret
		

DrawGreenSliderBar:							;Draws a slider bar of the foreground colour at position in Y,Z
		push r16
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26
		push YL
		push YH
		push ZL
		push ZH

		ldi r22, 0								;set red value to 0
		ldi r23, $ff							;set green value to -1, so it is set to 0 for the first loop.
		ldi r24, 0								;set blue value to 0
		ldi r16, $ff
		
		GreenSliderLoop:						;Draws gradient colour of green inside the green slider bar
			adiw Y,1							;move position on screen
			subi r23, $ff						;increase greenness of colour
			subi r16, $ff						;increment loop counter
			push r16
			push r23							;saves Greenness to stack

			ldi r22, 0							;set red value to 0
			ldi r24, 0							;set blue value to 0

			call ColourFrom3Bytes				;creates a 2 byte colour in r25/26 from the separate rgb bytes in r22-24
			call SetForegroundColour 	;Set the foreground colour on the driver to the value stored in r25/26.
			

			mov r17,YL
			mov r18,YH
			mov r19,ZL
			mov r20,ZH

			mov r21,YL
			mov r22,YH
			adiw Z,13
			mov r23,ZL
			mov r24,ZH
			sbiw Z,13
			call DrawLine					;Draws a line of the greenness colour created by colour from 3bytes
			pop r23							;loads green back from stack

			pop r16
			cpi r16,63						;checks counter to create new colour in loop until the end of slider bar (64 pixels long) 
			BRNE GreenSliderLoop
		
		pop ZH
		pop ZL
		pop YH
		pop YL
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r18
		pop r17
		pop r16
		ret

DrawBlueSliderBar: 							;Draws a slider bar of the foreground colour at position in Y,Z
		push r16
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26
		push YL
		push YH
		push ZL
		push ZH

		ldi r22, 0							;Set red value to 0
		ldi r23, 0							;Set green value to 0
		ldi r24, $ff						;Set blue value to -1, so it is set to 0 for the first loop.
		ldi r16, $ff
		BlueSliderLoop:						;Draws gradient colour of blue inside the blue slider bar
			subi r24, $ff					;Increase blueness of colour
			subi r16, $ff					;Increment loop counter
			push r16
			push r24						;Saves blueness to stack
			ldi r22, 0						;Set red value to 0
			ldi r23, 0						;Set green value to 0

			call ColourFrom3Bytes	
			call SetForegroundColour
			
			adiw Y,1						;Move position on screen
			mov r17,YL
			mov r18,YH
			mov r19,ZL
			mov r20,ZH

			mov r21,YL
			mov r22,YH
			adiw Z,13
			mov r23,ZL
			mov r24,ZH
			sbiw Z,13
			call DrawLine

			adiw Y,1						;Move position on screen
			mov r17,YL
			mov r18,YH
			mov r19,ZL
			mov r20,ZH

			mov r21,YL
			mov r22,YH
			adiw Z,13
			mov r23,ZL
			mov r24,ZH
			sbiw Z,13
			call DrawLine					;Draws a line of the blueness colour created by colour from 3bytes

			pop r24							;Loads blue back from stack

			pop r16
			cpi r16,31
			BRNE BlueSliderLoop				;Checks counter to create new colour in loop until the end of slider bar (32  double pixels long) 
		
		pop ZH
		pop ZL
		pop YH
		pop YL
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r18
		pop r17
		pop r16
		ret


DrawRedSliderBar: 							;Draws a slider bar of the foreground colour at position in Y,Z
		push r16
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26
		push YL
		push YH
		push ZL
		push ZH

		ldi r22, $ff						;Set red value to -1, so it is set to 0 for the first loop.
		ldi r23, 0							;Set green value to 0
		ldi r24, 0							;Set blue value to 0
		ldi r16, $ff
		RedSliderLoop:						;Draws gradient colour of red inside the red slider bar
			subi r22, $ff					;Increase redness of colour
			subi r16, $ff					;Increment loop counter
			push r16
			push r22						;Saves redness to stack
			ldi r23, 0						;Set green value to 0
			ldi r24, 0						;Set blue value to 0

			call ColourFrom3Bytes
			call SetForegroundColour
			
			adiw Y,1						;Move position on screen
			mov r17,YL
			mov r18,YH
			mov r19,ZL
			mov r20,ZH

			mov r21,YL
			mov r22,YH
			adiw Z,13
			mov r23,ZL
			mov r24,ZH
			sbiw Z,13
			call DrawLine

			adiw Y,1						;Move position on screen
			mov r17,YL
			mov r18,YH
			mov r19,ZL
			mov r20,ZH

			mov r21,YL
			mov r22,YH
			adiw Z,13
			mov r23,ZL
			mov r24,ZH
			sbiw Z,13
			call DrawLine					;Draws a line of the blueness colour created by colour from 3bytes

			pop r22							;Loads red back from stack

			pop r16
			cpi r16,31
			BRNE RedSliderLoop				;Checks counter to create new colour in loop until the end of slider bar (32  double pixels long) 
		
		pop ZH
		pop ZL
		pop YH
		pop YL
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r18
		pop r17
		pop r16
		ret

DrawSlider:									;Draws a slider at x-position r21,r22 for a slider bar with top y-position in r23/r24.
		push r17
		push r18
		push r19
		push r20
		push ZL
		push ZH
		
		mov ZL, r23
		mov ZH, r24
		SBIW Z, 1
		mov r17, r21
		mov r18, r22
		mov r19, ZL 						;Copies r23 to r19
		mov r20, ZH							;Copies r24 to r20

		call DrawSliderTopPointer	;Draws a small slider triangle with top-corner in r17-r20

		ADIW z, 17							;15 leaves space for 2
		mov r19, ZL
		mov r20, ZH

		call DrawSliderBottomPointer	;Draws a small slider triangle with bottom-corner in 
		
		pop Zh
		pop ZL
		pop r20
		pop r19
		pop r18
		pop r17
		ret
		

					

DrawSliderTopPointer:						;Draws a small slider triangle with bottom-corner in r17-r20
		
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26
		push r27
		push r28
		push r29
		push ZL
		push ZH

		call SaveForegroundColourToTemp

	;x1
		mov ZL, r17							;x0low bottom
		mov ZH, r18							;x0high bottom
		adiw Z,1 							;adds one to x0 to calculate x1 
		mov r21, ZL 						;move x1low to r21
		mov r22, ZH 						;move x1high to r22
	;y1
		mov ZL, r19							;y0low bottom
		mov ZH, r20							;y0high bottom
		sbiw Z,1							;Substracts one from y0 to calculate y1 
		mov r23, ZL							;move y1low to r23
		mov r24, ZH							;move y1high to r24
	
	;x2
		mov ZL, r17							;x0low bottom
		mov ZH, r18							;x0high bottom 
		sbiw Z,1							;Substracts one from x0 to calculate x2
		mov r25, ZL							;Move x2low to r25
		mov r26, ZH							;Move x2high to r26
	;y2
		mov ZL, r19							;y0low botoom 
		mov ZH, r20							;y0high bottom 
		sbiw Z,1							;Lowers y1  by one and sets as y2
		mov r27, ZL							;Move y2low to r27
		mov r28, ZH							;Move y2high to r28
		
		ldi r29,$ff 						;Boolean filled on


		push r17							;saves bottom-corner coordinate
		push r18
		push r21
		push r22
		push r27
		
		ldi r17, 0					 
		ldi r18, 0
		ldi r21, 80
		ldi r22, 0

		ldi r27,$ff

		ldi r25, COLOUR_GREYL
		ldi r26, COLOUR_GREYH
		call SetForegroundColour

		call DrawRectangle					;Draws grey rentangle at same height of SliderTopPointer to reset previous triangle pointer

		pop r27 
		pop r22 
		pop r21
		pop r18
		pop r17


		ldi r25, COLOUR_BLACKL
		ldi r26, COLOUR_BLACKH
		call SetForegroundColour 						;Sets foreground colour black 



		call DrawTriangle								;Draws Triangle at position stored in r17 to r28
		call LoadForegroundColourFromTemp				;Loads the colour back to where it was from temp
		
		

		pop ZH
		pop ZL
		pop r29
		pop r28
		pop r27
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		ret


DrawSliderBottomPointer:						;Draw a small slider triangle with bottom-point in r17-r20
		push r21
		push r22
		push r23
		push r24	
		push r25
		push r26
		push r27
		push r28
		push r29
		push ZL
		push ZH

		call SaveForegroundColourToTemp	

	;x1
		mov ZL, r17 							;x0low bottom 
		mov ZH, r18 							;x0high bottom
		adiw Z,1 								;adds one to x0 to calculate x1  
		mov r21, ZL 							;move x1low to r21
		mov r22, ZH 							;move x1high to r22
	;y1
		mov ZL, r19 							;y0low bottom
		mov ZH, r20 							;y0high bottom 
		adiw Z,1 								;adds one to y0 to calculate y1  
		mov r23, ZL								;move y1low to r23
		mov r24, ZH 							;move y1high to r24

	;x2
		mov ZL, r17								;x0low bottom 
		mov ZH, r18 							;x0high bottom 
		sbiw Z,1 								;Subtracts 1 to x0 to calculate x2
		mov r25, ZL								;move x2low to r25
		mov r26, ZH 							;move x2high to r26
	;y2
		mov ZL, r19	 							;y0low bottom 
		mov ZH, r20 							;y0high bottom 
		adiw Z,1 								;Adds one to y0 to calculate y2
		mov r27, ZL 							;move y2low to r27
		mov r28, ZH 							;move y2high to r28
			
			
		push r17
		push r18
		push r21
		push r22
		push r27
		
		ldi r17, 0
		ldi r18, 0
		ldi r21, 80
		ldi r22, 0

		ldi r25, COLOUR_GREYL
		ldi r26, COLOUR_GREYH
		call SetForegroundColour	

		call DrawRectangle							;Draws grey rentangle at same height of SliderTopPointer to reset previous triangle pointer
	
		pop r27
		pop r22
		pop r21
		pop r18
		pop r17

		ldi r25, COLOUR_BLACKL
		ldi r26, COLOUR_BLACKH
		call SetForegroundColour					;Sets foreground colour black 
		
		ldi r29,$ff									;Boolean filled on
		
		call DrawTriangle							;Draw a Triangle with points specified by r17-r28, and filled boolean flag in r29
		call LoadForegroundColourFromTemp	;Loads foreground colour back to what stored in temp
		
		pop ZH
		pop ZL
		pop r29
		pop r28
		pop r27
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		ret

	
DrawSliderBar:									;Draws a black slider bar, at x-position (r17-r20) and y-position (r21-r24) 
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26
		push r27
		push YL
		push YH
		push ZL
		push ZH
		
		mov r17,YL								;move x0low into r17
		mov r18,YH								;move x0high into r18
		mov r19,ZL								;move y0low into r19
		mov r20,ZH								;move y0high into r20
		adiw Y, 60	
		adiw Y, 5								;add 65, length of the slider bar
		adiw Z, 15
		mov r21, YL								;move x1low into r21
		mov r22, YH								;move x1high into r22	
		mov r23, ZL								;move y1low into r23
		mov r24, ZH								;move y1high into r24
		sbiw Y,60
		sbiw Y,5
		sbiw Z,15
		ldi r27, $ff 							;Boolean on
		call DrawRectangle						;Draws a non-filled rectangle using the coordinates stored in r17 to r24 
		
		ldi r25, COLOUR_BLACKL
		ldi r26, COLOUR_BLACKH
		call SetForegroundColour				;Set the foreground colour on the driver to black

		mov r17,YL								;move x0low into r17
		mov r18,YH								;move x0high into r18
		mov r19,ZL								;move y0low into r19
		mov r20,ZH								;move y0high into r20
		adiw Y, 60
		adiw Y, 5
		adiw Z, 15
		mov r21, YL								;move x1low into r21
		mov r22, YH								;move x1high into r22
		mov r23, ZL								;move y1low into r23
		mov r24, ZH								;move y1high into r24
		ldi r27, $00							;Boolean off
		call DrawRectangle						;Draws a non-filled rectangle using the coordinates stored in r17 to r24 


		pop ZH
		pop ZL
		pop YH
		pop YL
		pop r27
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r18
		pop r17
		ret



DrawColouredSquare:								;Draws a 20x20 black square, at x-position (r17-r20) and y-position (r21-r24)
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26
		push r27
		push YL
		push YH
		push ZL
		push ZH

		mov r17, YL								;move x0low into r17
		mov r18, YH								;move x0high into r18
		mov r19, ZL								;move y0low into r19
		mov r20, ZH								;move y0high into r20
		adiw Y, 20
		adiw Z, 20
		mov r21, YL								;move x1low into r21
		mov r22, YH								;move x1high into r22
		mov r23, ZL								;move y1low into r23
		mov r24, ZH								;move y1high into r24
		sbiw Y,20
		sbiw Z,20
		ldi r27, $ff							;Boolean on
		call DrawRectangle						;Draws a filled rectangle using the coordinates stored in r17 to r24 

		ldi r25, COLOUR_BLACKL
		ldi r26, COLOUR_BLACKH
		call SetForegroundColour				;Set the foreground colour on the driver to black


		mov r17, YL								;move x0low into r17
		mov r18, YH								;move x0high into r18
		mov r19, ZL								;move y0low into r19
		mov r20, ZH								;move y0high into r20
		adiw Y, 20
		adiw Z, 20
		mov r21, YL 							;move x1low into r21
		mov r22, YH								;move x1high into r22
		mov r23, ZL								;move y1low into r23
		mov r24, ZH								;move y1high into r24
		ldi r27, $00							;Boolean off
		call DrawRectangle						;Draws a non-filled rectangle using the coordinates stored in r17 to r24 

		pop ZH
		pop ZL
		pop YH
		pop YL
		pop r27
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r18
		pop r17
		ret


DrawSidebar:
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26
		push r27
		ldi r25, COLOUR_GREYL									
		ldi r26, COLOUR_GREYH									
		call SetForegroundColour				;Set the foreground colour on the driver to GREY
		ldi r17, $00
		ldi r18, $00
		ldi r19, $00
		ldi r20, $00
		ldi r21, 80
		ldi r22, $00
		ldi r23, $df
		ldi r24, $01
		ldi r27, $ff							;Boolean on
		call DrawRectangle						;Draws a non-filled rectangle using the coordinates stored in r17 to r24 
		pop r27
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r18
		pop r17
		ret

DrawSelectedColour:								;Draws a selection box around the ColourSquareSelected square from memory
		push r16
		push r19
		push r20
		push r21
		push r22
		push ZL
		push ZH
		ldi ZL,$56
		ldi ZH,$01
		ld r16,Z								;Loads the ColourSquareSelected memory value into r16
		
		ldi r19,5
		ldi r20,0
		ldi r21,5
		ldi r22,0
		cpi r16,1								;if colour 1 selected, draw Selection box around it
		BREQ SelectedColour1
		rcall ColourDeselected					;else draw Deselection box around it (grey box)
		rjmp TestColour2
	  SelectedColour1:
		rcall ColourSelected
		
	TestColour2:
		ldi r19,30
		ldi r20,0
		ldi r21,5
		ldi r22,0
		cpi r16,2								;if colour 2 selected, draw Selection box around it
		BREQ SelectedColour2
		rcall ColourDeselected					;else draw Deselection box around it (grey box)
		rjmp TestColour3
	  SelectedColour2:
		rcall ColourSelected
		
	TestColour3:
		ldi r19,55
		ldi r20,0
		ldi r21,5
		ldi r22,0
		cpi r16,3								;if colour 3 selected, draw Selection box around it
		BREQ SelectedColour3
		rcall ColourDeselected					;else draw Deselection box around it (grey box)
		rjmp TestColour4
	  SelectedColour3:
		rcall ColourSelected
		
	TestColour4:
		ldi r19,5
		ldi r20,0
		ldi r21,30
		ldi r22,0
		cpi r16,4								;if colour 4 selected, draw Selection box around it
		BREQ SelectedColour4									
		rcall ColourDeselected					;else draw Deselection box around it (grey box)
		rjmp TestColour5										
	  SelectedColour4:
		rcall ColourSelected
		
	TestColour5:
		ldi r19,30
		ldi r20,0
		ldi r21,30
		ldi r22,0
		cpi r16,5								;if colour 5 selected, draw Selection box around it
		BREQ SelectedColour5									
		rcall ColourDeselected					;else draw Deselection box around it (grey box)
		rjmp TestColour6										
	  SelectedColour5:
		rcall ColourSelected
		
	TestColour6:
		ldi r19,55
		ldi r20,0
		ldi r21,30
		ldi r22,0
		cpi r16,6								;if colour 6 selected, draw Selection box around it
		BREQ SelectedColour6									
		rcall ColourDeselected					;else draw Deselection box around it (grey box)
		rjmp TestColour7										
	  SelectedColour6:
		rcall ColourSelected
		
	TestColour7:
		ldi r19,5
		ldi r20,0
		ldi r21,55
		ldi r22,0
		cpi r16,7								;if colour 7 selected, draw Selection box around it
		BREQ SelectedColour7									
		rcall ColourDeselected					;else draw Deselection box around it (grey box)
		rjmp TestColour8										
	  SelectedColour7:
		rcall ColourSelected
		
	TestColour8:
		ldi r19,30
		ldi r20,0
		ldi r21,55
		ldi r22,0
		cpi r16,8								;if colour 8 selected, draw Selection box around it
		BREQ SelectedColour8									
		rcall ColourDeselected					;else draw Deselection box around it (grey box)
		rjmp TestColour9										
	  SelectedColour8:
		rcall ColourSelected
		
	TestColour9:
		ldi r19,55
		ldi r20,0
		ldi r21,55
		ldi r22,0
		cpi r16,9								;if colour 9 selected, draw Selection box around it
		BREQ SelectedColour9
		rcall ColourDeselected					;else draw Deselection box around it (grey box)
		rjmp TestColour10
	  SelectedColour9:
		rcall ColourSelected
		
	TestColour10:
		ldi r19,5
		ldi r20,0
		ldi r21,80
		ldi r22,0
		cpi r16,10								;if colour 10 selected, draw Selection box around it
		BREQ SelectedColour10				
		rcall ColourDeselected					;else draw Deselection box around it (grey box)
		rjmp TestColour11
	  SelectedColour10:
		rcall ColourSelected
		
	TestColour11:
		ldi r19,30
		ldi r20,0
		ldi r21,80
		ldi r22,0
		cpi r16,11								;if colour 11 selected, draw Selection box around it
		BREQ SelectedColour11
		rcall ColourDeselected					;else draw Deselection box around it (grey box)
		rjmp TestColour12
	  SelectedColour11:
		rcall ColourSelected
		
	TestColour12:
		ldi r19,55
		ldi r20,0
		ldi r21,80
		ldi r22,0
		cpi r16,12								;if colour 12 selected, draw Selection box around it
		BREQ SelectedColour12
		rcall ColourDeselected
		rjmp DrawSelectedColourEnd				;else draw Deselection box around it (grey box)
	  SelectedColour12:
		rcall ColourSelected
	
	DrawSelectedColourEnd:
		pop ZH
		pop ZL
		pop r22
		pop r21
		pop r20
		pop r19
		pop r16
		ret

DrawSelectedTool:								;Draws a selection box around the ToolSquareSelected square, with coordinates in r19 to r22, from memory.
		push r16
		push r19
		push r20
		push r21
		push r22
		push ZL
		push ZH
		ldi ZL,$25
		ldi ZH,$01
		ld r16,Z								;load the ToolSelected memory value into r19
		
		ldi r19,43
		ldi r20,0
		ldi r21,222
		ldi r22,0
		cpi r16,0								;if Tool 1 selected, draw Selection box around it
		BREQ SelectedTool0
		rcall ToolDeselected					;else draw Deselection box around it
		rjmp TestTool1
	  SelectedTool0:
		rcall ToolSelected

	TestTool1:									;Coordinates of the box in r19 to r22 
		ldi r19,5 ;
		ldi r20,0
		ldi r21,185
		ldi r22,0
		cpi r16,1								;if Tool 2 selected, draw Selection box around it
		BREQ SelectedTool1
		rcall ToolDeselected					;else draw Deselection box around it
		rjmp TestTool2
	  SelectedTool1:
		rcall ToolSelected
		
	TestTool2:									;Coordinates of the box in r19 to r22 
		ldi r19,43
		ldi r20,0
		ldi r21,185
		ldi r22,0
		cpi r16,2								;if Tool 2 selected, draw Selection box around it
		BREQ SelectedTool2
		rcall ToolDeselected					;else draw Deselection box around it
		rjmp TestTool3
	  SelectedTool2:
		rcall ToolSelected
		
	TestTool3:									;Coordinates of the box in r19 to r22 
		ldi r19,5
		ldi r20,0
		ldi r21,222
		ldi r22,0
		cpi r16,3								;if Tool 3 selected, draw Selection box around it
		BREQ SelectedTool3
		rcall ToolDeselected					;else draw Deselection box around it
		rjmp TestTool4
	  SelectedTool3:
		rcall ToolSelected
		
	TestTool4:
		ldi r19,5
		ldi r20,0
		ldi r21,3
		ldi r22,1
		cpi r16,4								;if Tool 4 selected, draw Selection box around it
		BREQ SelectedTool4
		rcall ToolDeselected					;else draw Deselection box around it
		rjmp TestTool5
	  SelectedTool4:
		rcall ToolSelected
		
		
	TestTool5:
		ldi r19,43
		ldi r20,0
		ldi r21,3
		ldi r22,1
		cpi r16,5								;if Tool 5 selected, draw Selection box around it
		BREQ SelectedTool5
		rcall ToolDeselected					;else draw Deselection box around it
		rjmp DrawSelectedToolEnd
	  SelectedTool5:
		rcall ToolSelected
	
	DrawSelectedToolEnd:
		pop ZH
		pop ZL
		pop r22
		pop r21
		pop r20
		pop r19
		pop r16
		ret
		
ColourSelected:									;take the top left coord of a colour square in r19 to r22, and draw a BLACK square around it.
		push r25
		push r26
		
		call SaveForegroundColourToTemp	;Save the foreground colour from driver to memory 
		ldi r25, COLOUR_BLACKL
		ldi r26, COLOUR_BLACKH
		call SetForegroundColour				;Set the foreground colour on the driver to BLACK
		rcall ColourSelectionBox				;take the top left coord of a colour square in r19-22, and draw a square of the ForegroundColour around it.
		
		call LoadForegroundColourFromTemp;Set back the saved foreground colour from memory to driver
		
		pop r26
		pop r25
		ret
		
ColourDeselected:								;take the top left coord of a colour square in r19-22, and draw a GREY square around it.
		push r25
		push r26
		
		call SaveForegroundColourToTemp	;Save the foreground colour from driver to memory 
		ldi r25, COLOUR_GREYL
		ldi r26, COLOUR_GREYH
		call SetForegroundColour				;Set the foreground colour on the driver to GREY
		rcall ColourSelectionBox				;take the top left coord of a colour square in r19-22, and draw a square of the ForegroundColour around it.
		
		call LoadForegroundColourFromTemp;Set back the saved foreground colour from memory to driver 
		
		pop r26
		pop r25
		ret

ToolSelected:									;take the top left coord of a colour square in r19-22, and draw a BLACK square around it.
		push r25
		push r26
		
		call SaveForegroundColourToTemp	;Save the foreground colour from driver to memory 
		ldi r25, COLOUR_BLACKL
		ldi r26, COLOUR_BLACKH
		call SetForegroundColour				;Set the foreground colour on the driver to BLACK
		rcall ToolSelectionBox					;take the top left coord of a tool square in r19-22, and draw a square of the ForegroundColour around it.
		
		call LoadForegroundColourFromTemp;Set back the saved foreground colour from memory to driver 
		
		pop r26
		pop r25
		ret
		
ToolDeselected:									;take the top left coord of a colour square in r19-22, and draw a GREY square around it.
		push r25
		push r26
		
		call SaveForegroundColourToTemp	;Save foreground colour from before and safe to memory
		ldi r25, COLOUR_GREYL
		ldi r26, COLOUR_GREYH
		call SetForegroundColour				;Set the foreground colour on the driver to GREY
		rcall ToolSelectionBox					;take the top left coord of a tool square in r19-22, and draw a square of the ForegroundColour around it.
		
		call LoadForegroundColourFromTemp;Set back the saved foreground colour from memory to driver 
		
		pop r26
		pop r25
		ret

ColourSelectionBox:								;take the top left coord of a colour square in r19-22, and draw a square of the ForegroundColour around it.
		push r16
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26
		
		mov r17,r19 							;move xlow to r17
		mov r18,r20 							;move xhigh to r18
		mov r19,r21								;move ylow to r19
		mov r20,r22								;move yhigh to r20
		
				;subtract 1 from x and y position, so selection box will be around colour square
		ldi r16,$00
		subi r17,$01  							;detract 1 to xlow 									
		sbc  r18,r16  							;leaves xhigh same value
		subi r19,$01  							;detract 1 to ylow
		sbc  r20,r16  							;leaves yhigh same value

		mov r21,r17	 							;copies xlow to r21					
		mov r22,r18  							;copies xhigh to r22
		mov r23,r19  							;copies ylow to r23
		mov r24,r20  							;copies yhigh to r24
		
		ldi r25,22								;Values used for 2 byte addition below
		ldi r26,0

		add r21,r25								;Add 22 to x and y of point 2, to get other corner of selection box
		adc r22,r26
		add r23,r25
		adc r24,r25
		

		ldi r27, $00 							;Boolean off
		call DrawRectangle						;Draws a rectangle at coordinates in r17 to r24

		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r18
		pop r17
		pop r16
		ret

ToolSelectionBox:								;take the top left coord of a tool square in r19-22, and draw a square of the ForegroundColour around it.
		push r16
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26
		
		mov r17,r19								;move xlow to r17
		mov r18,r20								;move xhigh to r18
		mov r19,r21								;move ylow to r19
		mov r20,r22								;move yhigh to r20
		
				;subtract 1 from x and y position, so selection box will be around colour square
		ldi r16,$00
		subi r17,$01							;detract 1 to xlow  to r17								
		sbc  r18,r16							;leaves xhigh same value
		subi r19,$01							;detract 1 to ylow to r19
		sbc  r20,r16							;leaves yhigh same value

		mov r21,r17								;copies xlow to r21
		mov r22,r18								;copies xhigh to r22
		mov r23,r19								;copies ylow to r23
		mov r24,r20								;copies yhigh to r24
		
		ldi r25,34								;values used for 2 byte addition below.
		ldi r26,0

		add r21,r25								;add 34 to x and y of point 2, to get other corner of selection box.
		adc r22,r26
		add r23,r25
		adc r24,r25
		

		ldi r27, $00 							;Boolean off
		call DrawRectangle						;Draws a rectangle at coordinates in r17 to r24

		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r18
		pop r17
		pop r16
		ret

SelectRedSliderColour:							;Returns the clicked red value in r22, and updates the selected custom colour with the new red value. 
		push r16
		push r17
		push r18
		push r19
		push r20
		push r21

		ldi r19,7								;load position of top left corner of slider into r19 to r22
		ldi r20,0
		ldi r21,110
		ldi r22,0
		call MouseOnBar							;returns $ff if cursor on slider, else $00

		cpi r16, $ff											
		BRNE SelectRedSliderColourEnd	;if r16 not equal to $ff...
												;... NOP
		call CursorLoad							;else, loads mouse position into r19-r22 
		subi r19,7								;Detracts 7 from yhigh coordinate
		lsr r19									;Divides it by 2, since there are 32 out of 64 points available for colour selection
		mov r22,r19								;Copies yhigh value to r22
		
		push ZL
		push ZH

		ldi ZL,$57								;update slider value in memory.
		ldi ZH,$01
		ST Z, r22								;Stores yhigh value in Z register
	
		pop ZH
		pop ZL

		call UpdateSavedColour									

		call CursorLoad
		mov r21,r19
		mov r22,r20
		ldi r23,110
		ldi r24,0

		call DrawSlider							;draw a slider at x-position r21,r22 for a slider bar with top y-position in r23/r24.

	SelectRedSliderColourEnd:					;NOP
		pop r21
		pop r20
		pop r19
		pop r18
		pop r17
		pop r16
		ret

SelectGreenSliderColour:						;returns the clicked green value in r23, and updates the selected custom colour with the new green value
		push r16
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22
												;load position of top left corner of slider into r19 to r22
		ldi r19,7
		ldi r20,0
		ldi r21,135
		ldi r22,0
		call MouseOnBar							;returns $ff if cursor on slider, else $00

		cpi r16, $ff											
		BRNE SelectGreenSliderColourEnd	;if r16 not equal to $ff..
												;... NOP
		call CursorLoad							;else, loads mouse position into r19-r22 
		subi r19,7								;Detracts 7 from yhigh coordinate
		mov r23,r19								;Copies yhigh value to r22

		push ZL
		push ZH

		ldi ZL,$58								;Updates slider value in memory.
		ldi ZH,$01
		ST Z, r23								;Stores yhigh value in Z register

		pop ZH
		pop ZL

		call UpdateSavedColour		

		call CursorLoad							;else, loads mouse position into r19-r22 
		mov r21,r19
		mov r22,r20
		ldi r23,135
		ldi r24,0

		call DrawSlider							;Draws a slider at x-position r21,r22 for a slider bar with top y-position in r23/r24.

	SelectGreenSliderColourEnd:					;NOP
		pop r22
		pop r21
		pop r20
		pop r19
		pop r18
		pop r17
		pop r16
		ret

SelectBlueSliderColour:							;returns the clicked blue value in r24, and updates the selected custom colour with the new blue value
		push r16
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22

		ldi r19,7								;load position of top left corner of slider into r19 to r22
		ldi r20,0
		ldi r21,160
		ldi r22,0
		call MouseOnBar							;returns $ff if cursor on slider, else $00

		cpi r16, $ff
		BRNE SelectBlueSliderColourEnd	;if r16 not equal to $ff..
												;... NOP
		call CursorLoad							;else, loads mouse position into r19-r22 
		subi r19,7								;Detracts 7 from yghigh coordinate
		lsr r19									;Divides it by 2, since there are 32 out of 64 points available for colour selection
		mov r24,r19												

		push ZL
		push ZH
		
		ldi ZL,$59								;Updates slider value in memory
		ldi ZH,$01
		ST Z, r24								;Stores yhigh value in Z register

		pop ZH
		pop ZL

		call UpdateSavedColour		

		call CursorLoad							;Loads graphics cursor (mouse) position from microprocessor memory into r19-r22		
		mov r21,r19
		mov r22,r20
		ldi r23,160
		ldi r24,0

		call DrawSlider							;draw a slider at x-position r21,r22 for a slider bar with top y-position in r23/r24.

	SelectBlueSliderColourEnd:
		pop r22
		pop r21
		pop r20
		pop r19
		pop r18
		pop r17
		pop r16
		ret

SelectBrushSliderSize:							;returns the clicked blue value in r19, and updates the slider value for the x coordinate to memory $0155
		push r16
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22

		ldi r19,7 								;xlow
		ldi r20,0								;xhigh
		ldi r21,$75 							;ylow
		ldi r22,$01								;yhigh
		call MouseOnBar 						;returns $ff if cursor on slider, else $00

		cpi r16, $ff
		BRNE SelectBrushSliderSizeEnd	;if r16 not equal to $ff..
												;... NOP
		call CursorLoad							;else, loads mouse position into r19-r22 
		subi r19,7								;Detracts 7 from yghigh coordinate
		lsr r19									;Divides it by 2, since there are 32 out of 64 points available for size selection

		push ZL
		push ZH
		
		ldi ZL,$55								;Updates slider value in memory
		ldi ZH,$01
		ST Z, r19								;Stores xlow value in Z register

		pop ZH
		pop ZL

		call DrawBrushSizeTool					;Draws the brush square tool on screen

		call CursorLoad							;Loads mouse position into r19-r22 
		mov r21,r19
		mov r22,r20
		ldi r23,$75
		ldi r24,$01

		call DrawSlider							;Draw a slider at x-position r21,r22 for a slider bar with top y-position in r23/r24.

	SelectBrushSliderSizeEnd:					;NOP
		pop r22
		pop r21
		pop r20
		pop r19
		pop r18
		pop r17
		pop r16
		ret

SetSlidersToForegroundColour:					;Takes values for RGB sliders and sets it as foreground colour, 
		push r22
		push r23
		push r24
		push r25
		push r26
		push ZL
		push ZH

		call LoadForegroundColour				;Loads foreground colour 
		call ThreeBytesFromColour				;Creates separate rgb bytes in r22-24 from a 2 byte colour in r25/26
		
		ldi ZL,$57								;Loads memory pointer 0157 in register Z
		ldi ZH,$01
		ST Z+,r22 								;Stores r22 into memory 0157
		ST Z+,r23 								;Stores r23 into memory 0158
		ST Z+,r24 								;Stores r24 into memory 0159

	;red slider
		push r24
		push r23
		
		lsl r22									;Multiplies by 2 000RRRRR -> 00RRRRR0	
		subi r22, 249							;adding 7
		mov r21, r22 
		ldi r22, $00

		ldi r23, 110 ;ylow
		ldi r24, 0   ;yhigh

		call DrawSlider							;draw a slider at x-position r21,r22 for a slider bar with top y-position in r23/r24.

	;green slider
		pop r23

		subi r23, 249							;adding 7
		mov r21, r23
		ldi r22, $00

		ldi r23, 135 							;ylow
		ldi r24, 0 								;yhigh

		call DrawSlider							;draw a slider at x-position r21,r22 for a slider bar with top y-position in r23/r24.

	;blue slider

		pop r24
		lsl r24									;Multiplies by 2 000BBBBB -> 00BBBBB0
		subi r24, 249							;adding 7
		mov r21, r24
		ldi r22, $00

		ldi r23, 160							;ylow
		ldi r24, 0 								;yhigh


		call DrawSlider							;draw a slider at x-position r21,r22 for a slider bar with top y-position in r23/r24.

		pop ZH
		pop ZL
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		ret

UpdateSavedColour:								;Calculates the 2 byte colour from the RBG slider positions, saves it to memory, and sets the foreground colour to it.
		push r17
		push r22
		push r23
		push r24
		push r25
		push r26
		push ZL
		push ZH

		ldi ZL,$56 
		ldi ZH,$01
		ld r17,Z 								;Loads r17 with the data in memory
		
		cpi r17,10								;00001010
		BREQ UpdateSavedColour1
		cpi r17,11								;00001011
		BREQ UpdateSavedColour2
		cpi r17,12								;00001100
		BREQ UpdateSavedColour3

		jmp UpdateSavedColourEnd

	UpdateSavedColour1:
		ldi ZL,$57
		ldi ZH,$01;ColourSlider
		LD r22,Z+								;$0157
		LD r23,Z+								;$0158
		LD r24,Z+								;$0159
		call ColourFrom3Bytes	
		
		ldi ZL,$60
		ldi ZH,$01								;Custom colours memories, RED
		ST Z+,r25 								;$0160
		ST Z+,r26 								;$0161
		call SetForegroundColour 
		call DrawColours
		call DrawBrushSizeTool
		jmp UpdateSavedColourEnd

	UpdateSavedColour2:							;Loads to r22,r23,r24  ColourSlider memories and creates a colour 
		ldi ZL,$57
		ldi ZH,$01
		LD r22,Z+ ;$0157, ColourSlider memories
		LD r23,Z+ ;$0158
		LD r24,Z+ ;$0159
		call ColourFrom3Bytes					;Creates a 2 byte colour in r25/26 from the separate RBG bytes in r22-24
		
		
		
		ldi ZL,$62
		ldi ZH,$01								;Custom colours memories, GREEN
		ST Z+,r25 
		ST Z+,r26
		call SetForegroundColour 		
		call DrawColours						;To user interface, uploads the 12 colours squares
		call DrawBrushSizeTool					;Draws the brush square tool on screen
		jmp UpdateSavedColourEnd

	UpdateSavedColour3:							;Loads to r22,r23,r24  ColourSlider memories and creates a colour  
		ldi ZL,$57
		ldi ZH,$01
		LD r22,Z+
		LD r23,Z+
		LD r24,Z+
		call ColourFrom3Bytes					;Creates a 2 byte colour in r25/26 from the separate RBG bytes in r22-24
		
		ldi ZL,$64
		ldi ZH,$01								;Custom colours memories, BLUE
		ST Z+,r25
		ST Z+,r26
		call SetForegroundColour
		call DrawColours						;To user interface, uploads the 12 colours squares
		call DrawBrushSizeTool					;Draws the brush square tool on screen

	UpdateSavedColourEnd:
		pop ZH
		pop ZL
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r17
		ret


		
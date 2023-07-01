/*
 * GraphicalMethods.asm
 *
 *  Created: 14/11/2016 15:44:17
 *   Author: AL4413
 */

ThreeBytesFromColour:						;creates separate rgb bytes in r22-24 from a 2 byte colour in r25/26
											;In two bytes, data stored as RRRRRGGG GGGBBBBB
		;Extract 5 Red bits from the high byte (r26)
		mov r22, r26	;RRRRRGGG			;Move low byte into r22
		LSR r22			;0RRRRRGG			;shift right, to move Red bits into lowest 5 bits.
		LSR r22			;00RRRRRG
		LSR r22			;000RRRRR		

		;Extract 6 Green bits from Both bytes.
		mov r23, r25	;GGGBBBBB			;Move low byte into r23
		lsr r23			;0GGGBBBB			;Shift right, to move Green bits into lowest 3 bits.
		lsr r23			;00GGGBBB
		lsr r23			;000GGGBB
		lsr r23			;0000GGGB
		lsr r23			;00000GGG
		mov r24,r26		;RRRRRGGG			;Move high byte into r24
		ANDI r24,$07	;00000GGG			;AND with 0b00000111, to clear Red bits out of the byte.
		lsl r24			;0000GGG0			;Shift left, to move green bits into [5:3]
		lsl r24			;000GGG00
		lsl r24			;00GGG000
		OR r23,r24		;00GGGGGG			;OR with r23, to merge both sections of Green data into the same byte.
		
		;Extract 5 Blue bits from the low byte (r25)
		mov r24, r25	;GGGBBBBB			;Move high byte into r24
		ANDI r24,$1F	;000BBBBB			;AND with 0b00011111, to clear Green bits out of byte.
		ret

ColourFrom3Bytes:		;creates a 2 byte colour in r25/26 from the separate rgb bytes in r22-24
		;r22 = red data		000RRRRR
		;r23 = green data	00GGGGGG
		;r24 = blue data	000BBBBB
		push r22
		push r23
		push r24
		
		;Create lower byte of 2 byte colour
		mov r25,r24		;000BBBBB			;Move Blue data into r25.
		mov r24,r23		;00GGGGGG			;Move Green data into r24, so we can modify it without losing any data.
		lsl r24			;0GGGGGG0			;Shift Green data left, to get lowest 3 bits into bits [7:5].
		lsl r24			;GGGGGG00
		lsl r24			;GGGGG000
		lsl r24			;GGGG0000
		lsl r24			;GGG00000
		OR r25,r24		;GGGBBBBB			;merge blue data with lower 3 green bits, to finish r25.
						;r25 done.
		
		;Create upper byte of 2 byte colour
		mov r26,r23		;00GGGGGG			;Move Green data into r26.
		lsr r26			;000GGGGG			;Shift Green data right, to get top 3 bits into bits [2:0].
		lsr r26			;0000GGGG
		lsr r26			;00000GGG
	
		lsl r22			;00RRRRR0			;Shift Red data left, to get it into bits [7:3]
		lsl r22			;0RRRRR00
		lsl r22			;RRRRR000
		OR r26,r22		;RRRRRGGG			;Merge red data with top 3 green bits to finish r26.

		pop r24
		pop r23
		pop r22
		ret

SetForegroundColour:						;Set the foreground colour on the driver to the value stored in r25/26, and update the ForegroundColour in memory with the new value.
		push r17
		push r18
		push r22
		push r23
		push r24
		push r25
		push r26
		push YL
		push YH

		ldi YL, $20							;Load address for the ForegroundColour into Y register.
		ldi YH, $01
		
		ST Y+, r25							;Update saved ForegroundColour with new colour.
		ST Y+, r26
		
		call ThreeBytesFromColour			;Break up the 2 Byte colour into three separate bytes for RGB.
	
		ldi r17, $63						;Foreground Colour Register 0 (FGCR0). Stores RED bits for foreground colour, bits [4:0].
		mov r18, r22						;Red Value
		call WriteReg

		ldi r17, $64						;Foreground Colour Register 1 (FGCR1). Stores GREEN bits for foreground colour, bits [5:0].
		mov r18,r23							;Green Value
		call WriteReg

		ldi r17, $65						;Foreground Colour Register 2 (FGCR2). Stores BLUE bits for foreground colour, bits [4:0].
		mov r18,r24							;Blue Value
		call WriteReg

		pop YH
		pop YL
		pop r26
		pop r25
		pop r24		
		pop r23
		pop r22
		pop r18
		pop r17
		ret

LoadForegroundColour:						;Load ForegroundColour from memory into r25 and r26
		push ZL
		push ZH

		ldi ZL, $20							;Load address for the ForegroundColour into Z register.						
		ldi ZH, $01
		
		LD r25, Z+							;Load ForegroundColour into registers r25/r26.
		LD r26, Z+
		
		pop ZH
		pop ZL
		ret
		
SaveForegroundColourToTemp:					;Backup current ForegroundColour into TempForegroundColour in memory.
		push r25
		push r26
		push ZL
		push ZH
		
		ldi ZL,$20							;Load address for the ForegroundColour into Z register.	
		ldi ZH,$01
		ld r25,Z+							;Load ForegroundColour into registers r25/r26.
		ld r26,Z+
		ST Z+, r25							;Save ForegroundColour to TempForegroundColour in memory.
		ST Z+, r26

		pop ZH
		pop ZL
		pop r26
		pop r25
		ret

LoadForegroundColourFromTemp:				;Overwrite current ForegroundColour with TempForegroundColour in memory.
		push r25
		push r26
		push ZL
		push ZH

		ldi ZL,$22							;Load address for the TempForegroundColour into Z register.	
		ldi ZH,$01
		ld r25,Z+							;Load TempForegroundColour into registers r25/r26.
		ld r26,Z+
		call SetForegroundColour			;Set the foreground colour on the driver to the value stored in r25/26.

		pop ZH
		pop ZL
		pop r26
		pop r25
		ret
	
Paint:										;Call the appropriate method according to the value in CurrentDrawingMode.
		push r16
		push r17
		push ZL
		push ZH
		
		call MouseOnCanvas
		cpi r16, $ff
		BRNE PaintEnd

		ldi ZL,$25							;Load address for the CurrentDrawingMode into Z register.	
		ldi ZH,$01
		LD r17,Z							;Load CurrentDrawingMode into r17.
		
		cpi r17, $00					
		in r16,sreg
		SBRC r16,1							;If CurrentDrawingMode = 0, call PaintBrush...
		call PaintBrush						;...else skip this line.

		cpi r17, $01
		in r16,sreg
		SBRC r16,1							;If CurrentDrawingMode = 1, call PaintRectangle...
		call PaintRectangle					;...else skip this line.

		cpi r17, $02
		in r16,sreg
		SBRC r16,1							;If CurrentDrawingMode = 2, call PaintEllipse...
		call PaintEllipse					;...else skip this line.
		
		cpi r17, $03
		in r16,sreg
		SBRC r16,1							;If CurrentDrawingMode = 3, call PaintTriangle...
		call PaintTriangle					;...else skip this line.

		cpi r17, $04
		in r16,sreg
		SBRC r16,1							;If CurrentDrawingMode = 4, call PaintLine...
		call PaintLine						;...else skip this line.

		cpi r17, $05
		in r16,sreg
		SBRC r16,1							;If CurrentDrawingMode = 5, call Eraser...
		call Eraser							;...else skip this line.
	PaintEnd:
		pop ZH
		pop ZL
		pop r17
		pop r16
		ret

PaintLine:									;Takes position clicked on by user, either saves it, or draws a line between it and the saved position. Immediately repeated points are ignored.
		push r17
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r27
		push ZL
		push ZH

		ldi ZL,$50							;Load address for the LineDrawingState into Z register.
		ldi ZH,$01
		LD r17,Z+							;Load LineDrawingState into r17 to see if this is the first position or the second position for the Line.
		CPI r17,$00							;If LineDrawingState = 0, then go to PaintLinePoint1...
		BRNE PaintLinePoint2				;...else go to PaintLinePoint2
	
	PaintLinePoint1:						;Save point 1 to memory, and change LineDrawingState to 1.
		call CheckCursorAgainstMemory		;Compares mouse position to the position stored in LineDrawingPosition. Returns $ff if they are the same, $00 otherwise.
		cpi r16,$ff
		BREQ PaintLineEnd					;If saved LineDrawingPosition = current position, do nothing. I.e. cannot start a line from the same point as last line ended.

		ldi ZL,$50							;Load address for the LineDrawingState into Z register.
		ldi ZH,$01
		ldi r17, $01				
		ST Z+,r17							;Update LineDrawingState to 1.
		
		call CursorLoad						;Loads the mouse position into registers r19-r22
		ST Z+,r19							;Save the current mouse position to the LineDrawingPosition memory addresses.
		ST Z+,r20
		ST Z+,r21
		ST Z+,r22

		rjmp PaintLineEnd					;Pop back registers from stack, and return.
				
	PaintLinePoint2:						;Read point 1 back from memory, and draw a Line between it and the current mouse position.
		call CheckCursorAgainstMemory		;Compares mouse position to the position stored in LineDrawingPosition. Returns $ff if they are the same, $00 otherwise.
		cpi r16,$ff
		BREQ PaintLineEnd					;If saved LineDrawingPosition = current position, do nothing. I.e. cannot have a line starting and ending at the same point.

		ldi ZL,$50							;Load address for the LineDrawingState into Z register.
		ldi ZH,$01
		ldi r17, $00						
		ST Z+,r17							;Reset status to 0, i.e. no points specified.
		
		call CursorLoad						;Loads the mouse position into registers r19-r22
		mov r24, r22						;Move current mouse position into registers r21-r24, in preparation for the DrawLine method.
		mov r23, r21
		mov r22, r20
		mov r21, r19

		LD r17,Z+							;Load saved LineDrawingPosition into r17-r20
		LD r18,Z+
		LD r19,Z+
		LD r20,Z+					

		call DrawLine						;Draws a line between the saved LineDrawingPosition and the current mouse position.

		ldi ZL,$51							;Load address for the LineDrawingPosition into Z register.
		ldi ZH,$01
		ST Z+,r21							;Save the current mouse position to the LineDrawingPosition memory addresses.
		ST Z+,r22
		ST Z+,r23
		ST Z+,r24

	PaintLineEnd:							;pop register values back from stack and return.
		pop ZH
		pop ZL
		pop r27
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r17
		ret

PaintTriangle:								;Takes position clicked on by user, either saves it, or draws a triangle with it and the saved positions as vertices. Immediately repeated points are ignored.
		push r16
		push r17
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r27
		push r28
		push r29
		push ZL
		push ZH

		ldi ZL,$40							;Load address for the TriangleDrawingState into Z register. 
		ldi ZH,$01
		LD r17,Z							;Load TriangleDrawingState into r17 to see if this is the first, second or third position for the triangle.

		cpi r17,$01							;If TriangleDrawingState = 1, then go to PaintTrianglePoint2...
		BREQ PaintTrianglePoint2
		
		cpi r17,$02							;...else if TriangleDrawingState = 2, then go to PaintTrianglePoint3...
		BREQ PaintTrianglePoint3

	
	PaintTrianglePoint1:					;...else go to PaintTrianglePoint1. Save point 1 to memory, and progress TriangleDrawingState to 1
		ldi ZL,$45							;Load address for TriangleDrawingPosition2 into Z register.
		ldi ZH,$01
		call CheckCursorAgainstMemory		;Compares mouse position to the position stored in TriangleDrawingPosition2. Returns $ff if they are the same, $00 otherwise.
		cpi r16,$ff
		BREQ PaintTriangleEnd				;If saved TriangleDrawingPosition2 = current position, do nothing. I.e. cannot start a triangle from the same point as last triangle ended.

		ldi ZL,$40							;Load address for TriangleDrawingState into Z register.
		ldi ZH,$01
		ldi r17, $01
		ST Z+,r17							;Update TriangleDrawingState to 1.
		
		call CursorLoad						;Loads the mouse position into registers r19-r22
		ST Z+,r19							;Save the current mouse position to the TriangleDrawingPosition1 memory addresses.
		ST Z+,r20
		ST Z+,r21
		ST Z+,r22

		rjmp PaintTriangleEnd				;Pop back registers from stack, and return.

	PaintTrianglePoint2:					;save point 2 to memory, and progress TriangleDrawingState to 2.
		ldi ZL,$41							;Load address for TriangleDrawingPosition1 into Z register.
		ldi ZH,$01	
		call CheckCursorAgainstMemory		;Compares mouse position to the position stored in TriangleDrawingPosition1.
		cpi r16,$ff
		BREQ PaintTriangleEnd				;If saved TriangleDrawingPosition1 = current position, do nothing. I.e. cannot have a triangle wih identical first two vertices.

		ldi ZL,$40							;Load address for TriangleDrawingState into Z register.
		ldi ZH,$01
		ldi r17, $02						;Update TriangleDrawingState to 2.
		ST Z+,r17					
		call CursorLoad						;Loads the mouse position into registers r19-r22
		
		ldi ZL,$45							;Load address for TriangleDrawingPosition2 into Z register.
		ldi ZH,$01
		ST Z+,r19							;Save the current mouse position to the PaintTrianglePoint2 memory addresses
		ST Z+,r20
		ST Z+,r21
		ST Z+,r22

		rjmp PaintTriangleEnd				;Pop back registers from stack, and return.
				
	PaintTrianglePoint3:					;Read TriangleDrawingPositions 1 and 2 back from memory, and draw a triangle using them and the current mouse position as vertices.
		ldi ZL,$45							;Load address for TriangleDrawingPosition2 into Z register.
		ldi ZH,$01
		call CheckCursorAgainstMemory		;Compares mouse position to the position stored in TriangleDrawingPosition2.
		cpi r16,$ff
		BREQ PaintTriangleEnd				;If saved TriangleDrawingPosition2 = current position, do nothing. I.e. cannot have a triangle wih identical last two vertices.

		ldi ZL,$40							;Load address for TriangleDrawingState into Z register.
		ldi ZH,$01
		ldi r17, $00						;Reset TriangleDrawingState to 0.
		ST Z+,r17
		
		call CursorLoad						;Loads the mouse position into registers r19-r22
		mov r28, r22						;Move mouse position into registers 25-28, in preparation for the DrawTriangle method.
		mov r27, r21
		mov r26, r20
		mov r25, r19

		LD r17,Z+							;Load TriangleDrawingPosition1 into r17-r20
		LD r18,Z+
		LD r19,Z+
		LD r20,Z+

		LD r21,Z+							;Load TriangleDrawingPosition1 into r21-r24
		LD r22,Z+
		LD r23,Z+
		LD r24,Z+
		
		ldi r29,$ff							;Set filled boolean to true.

		call DrawTriangle					;Draw a Triangle with points specified by r17-r28, and filled boolean flag in r29.

		ldi ZL,$45							;Load address for TriangleDrawingPosition2 into Z register.
		ldi ZH,$01
		ST Z+,r25							;Save the current mouse position to the PaintTrianglePoint2 memory addresses.
		ST Z+,r26
		ST Z+,r27
		ST Z+,r28

	PaintTriangleEnd:						;Pop back registers from stack, and return.
		pop ZH
		pop ZL
		pop r29
		pop r28
		pop r27
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r17
		pop r16
		ret

PaintEllipse:								;Takes position clicked on by user, and either saves it, or draws an ellipse with it and the saved position as a center, and corner of the bounding rectangle. Immediately repeated points are ignored.
		push r17
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26
		push r27
		push ZL
		push ZH

		ldi ZL,$35							;Load address for the EllipseDrawingState into Z register. 
		ldi ZH,$01
		LD r17,Z+							;Load EllipseDrawingState into r17 to see if this is the first or second position for the ellipse.

		cpi r17,$00							
		BRNE PaintEllipsePoint2				;If EllipseDrawingState = 0 then Point 1, else Point 2.

	PaintEllipsePoint1:						;Save point 1 to memory, and change EllipseDrawingState to 1.
		call CheckCursorAgainstMemory		;Compares mouse position to the position stored in EllipseDrawingPosition.
		cpi r16,$ff
		BREQ PaintEllipseEnd				;If saved EllipseDrawingPosition = current position, do nothing. I.e. cannot start an ellipse from the end position of the previous ellipse.
		
		ldi ZL,$35							;Load address for the EllipseDrawingState into Z register. 
		ldi ZH,$01
		ldi r17, $01				
		ST Z+,r17							;Progress EllipseDrawingState to 1, i.e. origin saved.
		
		call CursorLoad						;Loads the current mouse position into registers r19-r22
		
		ST Z+,r19							;Save the current mouse position to the EllipseDrawingPosition memory addresses.
		ST Z+,r20	
		ST Z+,r21
		ST Z+,r22

		jmp PaintEllipseEnd					;pop back registers, and return.

	PaintEllipsePoint2:						;Read EllipseDrawingPosition back from memory, and draw an ellipse using it as the centre, and the current mouse position as a bounding rectangle.
		call CheckCursorAgainstMemory		;Compares mouse position to the position stored in EllipseDrawingPosition.
		cpi r16,$ff
		BREQ PaintEllipseEnd				;if saved position = current position, do nothing, i.e. cannot have an ellipse with zero size.

		ldi ZL,$35							;Load address for the EllipseDrawingState into Z register. 
		ldi ZH,$01
		ldi r17, $00						;reset status to no points specified.
		ST Z+,r17
		
		call CursorLoad						;Loads the current mouse position into registers r19-r22
		
		mov r26, r22						;move current mouse position into registers 21-24, in preparation for the DrawEllipse method.
		mov r25, r21
		mov r24, r20
		mov r23, r19


		LD r19,Z+							;Load the saved position from the EllipseDrawingPosition memory addresses into r19-r22.
		LD r20,Z+
		LD r21,Z+
		LD r22,Z+
		
		ldi r27,$ff							;Set boolean filled argument to true.
		
		call SetActiveWindowToCanvas		;Set active window to Canvas, so drawing the ellipse does not overwrite parts of the UI.
		call DrawEllipse					;Draw ellipse centred on saved position, and with x and y axes defined by  difference between saved point x,y positions, and current mouse x,y positions.
		call SetActiveWindowToScreen		;Reset active window to whole screen, so UI elements can be redrawn.

		ldi ZL,$36							;Load address for the EllipseDrawingPosition into Z register. 
		ldi ZH,$01
		ldi ZH,$01
		ST Z+,r23							;Save the current mouse position to the EllipseDrawingPosition memory addresses.
		ST Z+,r24
		ST Z+,r25
		ST Z+,r26


	PaintEllipseEnd:						;pop back registers and return.
		pop ZH
		pop ZL
		pop r27
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r17
		ret

PaintRectangle:								;Takes position clicked on by user, and either saves it, or draws a rectangle with it and the saved position as opposite corners of the rectangle. Immediately repeated points are ignored.
		push r17
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r27
		push ZL
		push ZH

		ldi ZL,$30							;Load address for the RectangleDrawingState into Z register. 
		ldi ZH,$01
		LD r17,Z+							;Load RectangleDrawingState into r17 to see if this is the first or second position for the rectangle.

		cpi r17,$00							
		BRNE PaintRectanglePoint2			;If RectangleDrawingState = 0 then Point 1, else Point 2.
	
	PaintRectanglePoint1:					;Save point 1 to memory, and change RectangleDrawingState to 1.
		call CheckCursorAgainstMemory		;Compares mouse position to the position stored in RectangleDrawingPosition.
		cpi r16,$ff
		BREQ PaintRectangleEnd				;If saved RectangleDrawingPosition = current position, do nothing. I.e. cannot start a rectangle from the end position of the previous rectangle.
		
		ldi ZL,$30							;Load address for the RectangleDrawingState into Z register.
		ldi ZH,$01
		ldi r17, $01				
		ST Z+,r17							;Progress RectangleDrawingState to 1, i.e. one corner already saved.
		
		call CursorLoad						;Loads the mouse position into registers r19-r22
		
		ST Z+,r19							;Save the current mouse position to the RectangleDrawingPosition memory addresses.
		ST Z+,r20
		ST Z+,r21
		ST Z+,r22

		rjmp PaintRectangleEnd				;pop back registers and return.
			
	PaintRectanglePoint2:					;Read RectangleDrawingPosition back from memory, and draw a rectangle using it and the current mouse position as opposite corners.
		call CheckCursorAgainstMemory		;Compares mouse position to the position stored in RectangleDrawingPosition.
		cpi r16,$ff
		BREQ PaintRectangleEnd				;If saved position = current position, do nothing, i.e. cannot have a rectangle with identical start and end points.

		ldi ZL,$30							;Load address for the RectangleDrawingState into Z register.
		ldi ZH,$01
		ldi r17, $00						
		ST Z+,r17							;Reset status to no points specified.
		
		call CursorLoad						;Loads the current mouse position into registers r19-r22
		
		mov r24, r22						;Move current mouse position into registers 21-24, in preparation for the DrawRectangle method.
		mov r23, r21
		mov r22, r20
		mov r21, r19

		LD r17,Z+							;Load the saved position from the RectangleDrawingPosition memory addresses into r19-r22.
		LD r18,Z+
		LD r19,Z+
		LD r20,Z+
		
		ldi r27,$ff							;Set boolean filled argument to true.

		call DrawRectangle					;Draw a rectangle of the foreground colour with corners at the saved position and the current mouse position.

		ldi ZL,$31							;Load address for the RectangleDrawingPosition into Z register.
		ldi ZH,$01
		ST Z+,r21							;Save the current mouse position to the RectangleDrawingPosition memory addresses.
		ST Z+,r22
		ST Z+,r23
		ST Z+,r24

	PaintRectangleEnd:						;pop back registers and return.
		pop ZH
		pop ZL
		pop r27
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r17
		ret
	
Eraser:										;Draw a white circle of radius BrushSize to the canvas centred at the current mouse position.
		push r25
		push r26
		
		rcall SaveForegroundColourToTemp	;Backup current ForegroundColour into TempForegroundColour in memory.

		ldi r25, COLOUR_WHITEL
		ldi r26, COLOUR_WHITEH
		call SetForegroundColour			;Set foreground colour to white.
		
		call PaintBrush						;Draws a white circle to the canvas at the current mouse position (i.e. erase).

		rcall LoadForegroundColourFromTemp	;Restore foreground colour to its value at the start of the method.
		
		pop r26
		pop r25
		ret		

PaintPixel:									;Set the pixel at coordinates stored in r19-r22 to the current foreground colour.
		push r17
		push r25
		push r26
		
		call MemCursorWrite					;Move Memory cursor on driver to the position in r19-r22.
		
		ldi r17, $02						;Write to the 'Memory Read/Write Command' register on the driver, the register that allows us to access the internal memory of the driver.
		call DriverCommandW					;Tell the driver to put subsequent DriverDataW data into register $02.
		
		call LoadForegroundColour			;Load the current foreground colour from memory into registers r25/r26.
		
		MOV r17, r26
		call DriverDataW					;Write the high colour byte to the Driver memory.
		
		MOV r17, r25
		call DriverDataW					;Write the low colour byte to the Driver memory.
		
		pop r26
		pop r25
		pop r17
		
		rcall DriverWait					;Wait for the WAIT pin from the Driver to be cleared before continuing.
		ret

PaintBrush: 								;Draw a circle of radius BrushSize of the foreground colour to the canvas centred at the current mouse position.
		push r19
		push r20
		push r21
		push r22
		push r23
		push r27

		call SetActiveWindowToCanvas		;Set active window to Canvas, so drawing the circle does not overwrite parts of the UI.
		
		call CursorLoad						;Loads the mouse position into registers r19-r22.
		
		ldi ZL,$55							;Load address for the BrushSize into Z register.
		ldi ZH,$01							
		ld r23,Z							;Load BrushSize into r23, as the radius for the circle.
		ldi r27,$ff 						;Set boolean filled argument to true.
		
		call DrawCircle						;Draw a circle with centre in r19-r22, radius in r23, filled boolean in r27
		
		call PaintPixel						;Paint a single pixel in the middle of the circle, for a circle of 'zero' radius.

		call SetActiveWindowToScreen		;Reset active window to whole screen, so UI elements can be redrawn.

	PaintBrushEnd:							;pop registers back and return.
		pop r27
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		ret
		
FillScreen:									;Fills the screen with the foreground colour
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r27
		
		ldi r17, $00						;Store (0,0) in registers r17-r20 as top left corner of rectangle.
		ldi r18, $00
		ldi r19, $00
		ldi r20, $00
		
		ldi r21, $1f						;Store (799,479) in registers r21-r24 as bottom right corner of rectangle.
		ldi r22, $03
		ldi r23, $df
		ldi r24, $01
		
		ldi r27, $ff						;Set boolean filled argument to true.
		
		rcall DrawRectangle					;Draw rectangle over the entire screen.
		
		pop r27
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r18
		pop r17
		ret

DrawRectangle:								;Draws Rectangle with opposite corners stored in r17-r20 and r21-r24. Boolean filled flag in r27.
		;	r17 = x0low
		;	r18 = x0high
		;	r19 = y0low
		;	r20 = y0high
		;	r21 = x1low
		;	r22 = x1high
		;	r23 = y1low
		;	r24 = y1high
		;	r27 = booleanfilled
		push r17
		push r18

		;Write x0 position to Driver
		push r18							;Save x0high to stack, so we can use r17 and r18 for the WriteReg method. 
		mov r18,r17							;Move x0low to r18, in preparation for the WriteReg method.
		ldi r17,$91							;Draw Line/Square Horizontal Start Address Register bits [7:0] (DLHSR0)
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		pop r18								;Recover x0high from stack into r18.
		ldi r17,$92							;Draw Line/Square Horizontal Start Address Register bits [9:8] (DLHSR1)
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.

		;Write y0 position to Driver
		ldi r17,$93							;Draw Line/Square Vertical Start Address Register bits [7:0] (DLVSR0) 
		mov r18,r19							
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		ldi r17,$94							;Draw Line/Square Vertical Start Address Register bit [8] (DLVSR1) 
		mov r18,r20				
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.

		;Write x1 position to Driver
		ldi r17,$95							;Draw Line/Square Horizontal End Address Register bits [7:0] (DLHER0) 
		mov r18,r21
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		ldi r17,$96							;Draw Line/Square Horizontal End Address Register bits [9:8] (DLHER1) 
		mov r18,r22
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.

		;Write y1 position to Driver
		ldi r17,$97							;Draw Line/Square Vertical End Address Register bits [7:0] (DLVER0)
		mov r18,r23
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		ldi r17,$98							;Draw Line/Square Vertical End Address Register bit [8] (DLVER1)
		mov r18,r24
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.

		;Trigger the drawing on the driver.
		ldi r17,$90							;Drawing Control Register (DCR). Triggers the Drawing functions on the driver (bit 7), and sets what shape is to be drawn (bits 6-4 and 0).
		cpi r27,$ff							
		BREQ RectangleFilled				;If filled boolean = $ff, then draw a filled rectangle...
		rjmp RectangleEmpty					;...else draw an empty rectangle.
	
	RectangleFilled:
		ldi r18,$B0							;0b10110000 - Start drawing [7] a rectangle [4], and specify as filled [5].
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		rjmp DrawRectEnd
	
	RectangleEmpty:
		ldi r18,$90							;0b10010000 - Start drawing [7] a rectangle [4], and specify as unfilled [5].
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
	
	DrawRectEnd:							;pop registers back and return.
		pop r18
		pop r17
		ret

DrawCircle:									;Draws Circle with centre stored in r19-r22 and radius in r23. Boolean filled flag in r27.
		;	r19 = xlow
		;	r20 = xhigh
		;	r21 = ylow
		;	r22 = yhigh
		;	r23 = radius
		;	r27 = booleanfilled
		push r17
		push r18

		;Write centre x position to Driver
		ldi r17, $99						;Draw Circle Center Horizontal Address Register bits [7:0] (DCHR0) 
		mov r18, r19
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		ldi r17, $9A						;Draw Circle Center Horizontal Address Register bits [9:8] (DCHR1) 
		mov r18, r20
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.

		;Write centre y position to Driver
		ldi r17, $9B						;Draw Circle Center Vertical Address Register bits [7:0] (DCVR0) 
		mov r18, r21
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		ldi r17, $9C						;Draw Circle Center Vertical Address Register bit [8] (DCVR0) 
		mov r18, r22
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
  
		;Write radius to Driver
		ldi r17, $9D						;Draw Circle Radius Register (DCRR)
		mov r18, r23
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.

		;Trigger the drawing on the driver
		ldi r17, $90						;Drawing Control Register (DCR). Triggers the Drawing functions on the driver (bit 7), and sets what shape is to be drawn (bits 6-4 and 0).
		
		cpi r27,$ff	
		BREQ CircleFilled					;If filled boolean = $ff, then draw a filled circle...
		rjmp CircleEmpty					;...else draw an unfilled one.

	CircleFilled:
		ldi r18,$60							;0b01100000 - Start drawing a circle [6], and specify as filled [5].
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.					
		rjmp DrawCircleEnd

	CircleEmpty:
		ldi r18,$40							;0b01000000 - Start drawing a circle [6], and specify as non-filled [5].
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		
	DrawCircleEnd:							;pop back registers and return.
		pop r18
		pop r17
		ret

DrawEllipse:								;Draws ellipse with centre stored in r19-r22 and a corner of bounding rectangle in r23-r26. Boolean filled flag in r27.
		;supply origin	r19-r22
		;supply corner r23-r26
		;filled r27
		push r16
		push r23
		push r24
		push r25
		push r26
		push r30
		push r31

		;Need to extract the semi-major and semi-minor axes from the two coordinates.
		;If origin has larger x than corner, then axis = origin x - corner x, else axis = corner x - origin x.
		;Therefore check top byte first:
		
		cp r24,r20		
		in r16,SREG
		SBRC r16,0	
		jmp CaseNX							;If corner has x less than origin, then go to CaseNX.

		cp r20,r24		
		in r16,SREG
		SBRC r16,0
		jmp CasePX							;If corner has x greater than origin, then go to CasePX
		
		;If most significant bytes are equal, check lower byte:
		cp r23,r19		
		in r16,SREG
		SBRC r16,0
		jmp CaseNX							;If corner has x less than origin, then go to CaseNX
											;...else go to CasePX
	
	CasePX:									;Corner x > origin x, therefore axis = corner x - origin x.
		SUB r23,r19
		SBC r24,r20							;Subtract origin x from corner x.
		jmp CaseY							;Continue to sorting Y-axis.

	CaseNX:									;Corner x < origin x, therefore axis = origin x - corner x.
		mov r30,r23							;Move corner x into r30/r31, so we can move origin x into r23/r24.
		mov r31,r24
		mov r23,r19							;Move origin x into r23/r24
		mov r24,r20
		
		SUB r23,r30							;Subtract corner x from origin x.
		SBC r24,r31
		
		
	CaseY:									;Now sort Y axis:
		;If origin has larger y than corner, then axis = origin y - corner y, else axis = corner y - origin y.
		;Therefore check top byte first:
		cp r26,r22							
		in r16,SREG
		SBRC r16,0
		jmp CaseNY							;If corner has y less than origin, then go to CaseNY.

		cp r22,r26
		in r16,SREG
		SBRC r16,0
		jmp CasePY							;If corner has y greater than origin, then go to CasePY.
		
		;If most significant bytes are equal, check lower byte:
		cp r25,r21
		in r16,SREG
		SBRC r16,0
		jmp CaseNY							;If corner has y less than origin, then go to CaseNY.
											;...else go to CasePY
	
	CasePY:									;Corner y > origin y, therefore axis = corner y - origin y.
		SUB r25,r21
		SBC r26,r22							;Subtract origin y from corner y.
		jmp DrawEllipseEnd					;Draw ellipse, then pop registers back and return.

	CaseNY:									;Corner y < origin y, therefore axis = origin y - corner y.
		mov r30,r25							;Move corner y into r30/r31, so we can move origin y  into r25/r26.
		mov r31,r26
		mov r25,r21							;Move origin y into r23/r24
		mov r26,r22
		
		SUB r25,r30							;Subtract corner y from origin y.
		SBC r26,r31	
	
	DrawEllipseEnd:							;Draw ellipse, then pop registers back and return.
		call DrawEllipseWithAxes			;Draw ellipse with center in r19-r22, and axes in r23-r26. Filled flag in r27.
		pop r31
		pop r30
		pop r26
		pop r25
		pop r24
		pop r23
		pop r16
		ret


DrawEllipseWithAxes:						;Draw ellipse with center in r19-r22, and axes in r23-r26. Filled flag in r27.
;	r19 = xlow
;	r20 = xhigh
;	r21 = ylow
;	r22 = yhigh
;	r23 = xaxislow
;	r24 = xaxishigh
;	r25 = yaxislow
;	r26 = yaxishigh
;	r27 = booleanfilled
		push r17
		push r18
		
		;Write centre x position to driver:
		ldi r17, $A5						;Draw Ellipse Center Horizontal Address Register bits [7:0] (DEHR0)
		mov r18, r19
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		ldi r17, $A6						;Draw Ellipse Center Horizontal Address Register bits [9:8] (DEHR1)
		mov r18, r20
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		
		;Write centre y position to driver:
		ldi r17, $A7						;Draw Ellipse Center Vertical Address Register bits [7:0] (DEVR0) 
		mov r18, r21
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		ldi r17, $A8						;Draw Ellipse Center Vertical Address Register bit [8] (DEVR1) 
		mov r18, r22
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.

		;Write x axis length to driver:
		ldi r17, $A1						;Draw Ellipse X-axis Setting Register bits [7:0] (ELL_A0) 
		mov r18, r23
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		ldi r17, $A2						;Draw Ellipse X-axis Setting Register bits [9:8] (ELL_A1) 
		mov r18, r24
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		
		;Write y axis length to driver:
		ldi r17, $A3						;Draw Ellipse Y-axis Setting Register bits [7:0] (ELL_B0) 
		mov r18, r25
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		ldi r17, $A4						;Draw Ellipse Y-axis Setting Register bits [9:8] (ELL_B1) 
		mov r18, r26
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
	  
		;Trigger the drawing on the driver
		ldi r17, $A0						;Draw Ellipse/Ellipse Curve Control Register. Triggers the Drawing functions on the driver (bit 7), and sets what shape is to be drawn (bits 6-4 and 0).
		cpi r27,$ff	
		BREQ DEWAFilled						;If boolean filled value = $ff then draw a filled ellipse...
		rjmp DEWAEmpty						;...else draw an empty ellipse.
		
	DEWAFilled:
		ldi r18,$C0							;0b11000000 - Start drawing [7] an ellipse [5:4], and specify as filled [6].
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		rjmp DEWAEnd						;pop registers back, and return.
		
	DEWAEmpty:
		ldi r18,$80							;0b10000000 - Start drawing [7] an ellipse [5:4], and specify as unfilled [6].
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		
	DEWAEnd:								;Pop registers back, and return.
		pop r18
		pop r17
		ret

DrawLine:									;Draws a straight line between point r17-r20 and point r21-r24.
	;	r17 = x0low
	;	r18 = x0high
	;	r19 = y0low
	;	r20 = y0high
	;	r21 = x1low
	;	r22 = x1high
	;	r23 = y1low
	;	r24 = y1high
	
		push r17
		push r18
		
		;Write x0 position to Driver:
		push r18							;Save x0high to stack, so we can use r17 and r18 for the WriteReg method. 
		mov r18,r17							;Move x0low to r18, in preparation for the WriteReg method.
		ldi r17,$91							;Draw Line/Square Horizontal Start Address Register bits [7:0] (DLHSR0)
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		pop r18								;Recover x0high from stack into r18.
		ldi r17,$92							;Draw Line/Square Horizontal Start Address Register bits [9:8] (DLHSR1)
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.

		;Write y0 position to Driver:
		ldi r17,$93							;Draw Line/Square Vertical Start Address Register bits [7:0] (DLVSR0) 
		mov r18,r19
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		ldi r17,$94							;Draw Line/Square Vertical Start Address Register bit [8] (DLVSR1) 
		mov r18,r20
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.

		;Write x1 position to Driver:
		ldi r17,$95							;Draw Line/Square Horizontal End Address Register bits [7:0] (DLHER0) 
		mov r18,r21
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		ldi r17,$96							;Draw Line/Square Horizontal End Address Register bits [9:8] (DLHER1) 
		mov r18,r22
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.

		;Write y1 position to Driver:
		ldi r17,$97							;Draw Line/Square Vertical End Address Register bits [7:0] (DLVER0)
		mov r18,r23
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		ldi r17,$98							;Draw Line/Square Vertical End Address Register bit [8] (DLVER1)
		mov r18,r24
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
  
		;Trigger the drawing on the driver:
		ldi r17,$90							;Drawing Control Register (DCR). Triggers the Drawing functions on the driver (bit 7), and sets what shape is to be drawn (bits 6-4 and 0).
		ldi r18,$80							;0b10010000 - Start drawing [7] a line [4], and specify as filled [5].
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		
		pop r18								;pop registers back and return.
		pop r17
		ret


DrawTriangle:								;Draws a triangle specified by points r17-r20,r21-r24,r25-r28. Boolean filled flag in r29.
		;	r17 = x0low
		;	r18 = x0high
		;	r19 = y0low
		;	r20 = y0high
		;	r21 = x1low
		;	r22 = x1high
		;	r23 = y1low
		;	r24 = y1high
		;	r25 = x2low
		;	r26 = x2high
		;	r27 = y2low
		;	r28 = y2high
		;	r29 = booleanfilled

		push r17
		push r18
		
		;Write x0 position to Driver
		push r18							;Save x0high to stack, so we can use r17 and r18 for the WriteReg method. 
		mov r18,r17							;Move x0low to r18, in preparation for the WriteReg method.
		ldi r17,$91							;Draw Line/Square Horizontal Start Address Register bits [7:0] (DLHSR0)
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		pop r18								;Recover x0high from stack into r18.
		ldi r17,$92							;Draw Line/Square Horizontal Start Address Register bits [9:8] (DLHSR1)
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		
		;Write y0 position to Driver
		ldi r17,$93							;Draw Line/Square Vertical Start Address Register bits [7:0] (DLVSR0) 
		mov r18,r19
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		ldi r17,$94							;Draw Line/Square Vertical Start Address Register bit [8] (DLVSR1) 
		mov r18,r20
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.

		;Write x1 position to Driver
		ldi r17,$95							;Draw Line/Square Horizontal End Address Register bits [7:0] (DLHER0) 
		mov r18,r21
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		ldi r17,$96							;Draw Line/Square Horizontal End Address Register bits [9:8] (DLHER1) 
		mov r18,r22
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.

		;Write y1 position to Driver
		ldi r17,$97							;Draw Line/Square Vertical End Address Register bits [7:0] (DLVER0)
		mov r18,r23
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		ldi r17,$98							;Draw Line/Square Vertical End Address Register bit [8] (DLVER1)
		mov r18,r24
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		
		;Write x2 position to Driver
		ldi r17,$A9
		mov r18,r25
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		ldi r17,$AA
		mov r18,r26
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.

		;Write y2 position to Driver
		ldi r17,$AB							;Draw Triangle Point 2 Horizontal Address Register bits [7:0] (DTPH0) 
		mov r18,r27
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		ldi r17,$AC							;Draw Triangle Point 2 Horizontal Address Register bits [9:8] (DTPH1) 
		mov r18,r28
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.

		;Trigger the drawing on the driver.
		ldi r17,$90							;Drawing Control Register (DCR). Triggers the Drawing functions on the driver (bit 7), and sets what shape is to be drawn (bits 6-4 and 0).
		cpi r29,$ff
		BREQ triFilled						;If filled boolean = $ff, then draw a filled triangle...
		rjmp triEmpty						;...else draw an empty triangle.
		
	triFilled:
		ldi r18,$A1							;0b10100001 - Start drawing [7] a triangle [0], and specify as filled [5].
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		rjmp DrawTriEnd						;pop registers back and return.
		
	triEmpty:
		ldi r18,$81							;0b10000001 - Start drawing [7] a triangle [0], and specify as unfilled [5].
		call WriteReg						;Writes the data in r18 to the Driver register address in r17.
		
	DrawTriEnd:								;pop registers back and return.
		pop r18
		pop r17
		call DriverWait
		ret
		

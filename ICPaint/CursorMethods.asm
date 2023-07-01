;
; CursorMethods.asm
;
; Created: 17/11/2016 16:42:35
; Authors: AL4413, MV914
;
 
MemCursorWrite:										;Writes to driver board the memory 46-49, cursor position from r19-r22 
		push r17
		push r18
		ldi r17, $46
		mov r18, r19
		call WriteReg
		ldi r17, $47
		mov r18, r20
		call WriteReg
		ldi r17, $48
		mov r18, r21
		call WriteReg
		ldi r17, $49
		mov r18, r22
		call WriteReg
		pop r18
		pop r17
		ret
		

CursorDisplay:										;Send the current mouse position to the Driver.
		call CursorLoad								;Read cursor position from memory into r19, r20, r21, r22
		call CursorWrite							;Write the cursor position from the registers into the driver
		ret

CursorLoad:											;Loads graphics cursor (mouse) position from microprocessor memory into r19-r22 
		push YL
		push YH
		ldi YL,$10									;Sets address to save cursor position
		ldi YH,$01
		LD r19, Y+									;Load X position into r19,r20 registers
		LD r20, Y+	
		LD r21, Y+									;Load Y position into r21, r22 registers
		LD r22, Y+
		pop YH
		pop YL
		ret

CursorWrite:										;Writes mouse position (graphic cursor) from r19-r22 to driver board. 
		push r17
		push r18 
		ldi r17, $80
		mov r18, r19
		call WriteReg
		ldi r17, $81
		mov r18, r20
		call WriteReg
		ldi r17, $82
		mov r18, r21
		call WriteReg
		ldi r17, $83
		mov r18, r22
		call WriteReg
		pop r18
		pop r17
		ret

SetCursorShape:										;Graphic cursor shape
		push r17
		push r18 
		ldi r17, $41								;Memory address
		ldi r18, $88								;Write cursor shape active 
		call WriteReg
		call CursorShapeMouse						;Loads mouse icon data to memory
		call CursorEnable							;Writes graphic cursor to layer 1 of the LCDScreen
		pop r18
		pop r17
		ret

CursorShapeMouse:									;Loads mouse icon data to memory 
		push r17
		push r18
		push ZL
		push ZH
		ldi r17,$85
		ldi r18,$ff
		call WriteReg

		ldi ZL, low(MouseCursorData*2)
		ldi ZH, high(MouseCursorData*2)				;Loads binary string (mouse icon) into Z register
		ldi r17, $02								;Write to the 'memory' register on the driver
		call DriverCommandW
		ldi r18, $00								;Set r18 to 0 for the loop counter
		
	CursorShapeMouseLoop:
		lpm r17,Z+
		call DriverDataW
		subi r18, $ff
		cpi r18, $00
		in r17,sreg
		SBRS r17,1
		jmp CursorShapeMouseLoop
		nop
		pop ZH
		pop ZL
		pop r18
		pop r17
		ret

CursorEnable:										;Tells the driver to write the graphic cursor to layer 1
		push r17
		push r18 
		ldi r17, $41
		ldi r18, $80								;Write to layer 1 
		call WriteReg
		pop r18
		pop r17
		ret


CursorDisable:										;Disables writing the graphic cursor to layer 1 
		push r17
		push r18 
		ldi r17, $41
		ldi r18, $00
		call WriteReg
		pop r18
		pop r17
		ret

CheckCursorAgainstMemory:							;Compares current mouse position to position stored in memory at Z register address.
													;Returns to r16. $ff if positions match. $00 if positions different.
		push r23
		push r24
		push r25
		push r26
		push ZL
		push ZH


		call CursorLoad								;Loads the mouse position into registers r19-r22
		ld r23,Z+
		ld r24,Z+
		ld r25,Z+
		ld r26,Z+
		
		ldi r16, $ff								;Loads $00 to r16, positions match
		
		cp r19,r23
		BRNE CCAMFalse
		cp r20,r24
		BRNE CCAMFalse
		cp r21,r25
		BRNE CCAMFalse
		cp r22,r26
		BRNE CCAMFalse

		rjmp CCAMEnd
	
	CCAMFalse:
		ldi r16, $00								;Loads $00 to r16, positions different

	CCAMEnd:
		pop ZH
		pop ZL
		pop r26
		pop r25
		pop r24
		pop r23
		ret

MouseOnToolSquare:									;Compare mouse position r23-r26, to 20x20 square at position r19-r22.
		push r23
		push r24
		push r25
		push r26

		mov r23,r19
		subi r23,$E0
		mov r24,r20
		mov r25,r21
		subi r25,$E0
		mov r26,r22
		call MouseInsideRectangle					;Checks if the mouse is in the SliderBar

		pop r26
		pop r25
		pop r24
		pop r23
		ret

MouseOnBar:											;Compare mouse position r23-r26, to 64x16 SliderBar at position r19-r22.
		push r23
		push r24
		push r25
		push r26
		push YL
		push YH

		mov YL,r19
		mov YH,r20
		adiw Y,1
		mov r19,YL
		mov r20,YH

		mov ZL,r21
		mov ZH,r22

		adiw Y, 63	
		adiw Z, 15

		mov r23,YL
		mov r24,YH
		mov r25,ZL
		mov r26,ZH
		call MouseInsideRectangle					;Checks if the mouse is in the SliderBar

		pop YH
		pop YL
		pop r26
		pop r25
		pop r24
		pop r23
		ret

MouseOnColourSquare:								;Compare mouse position to 20x20 square at position r19-r22. General method for each of the colour squares.
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26

		mov r23,r19
		subi r23,$EC
		mov r24,r20
		mov r25,r21
		subi r25,$EC
		mov r26,r22
		call MouseInsideRectangle					;Checks if the mouse is in the correspondent colour square

		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		ret

MouseOnScreen:										;Compare mouse position to screen size 
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26

		ldi	r19, $00								;x0(0)
		ldi	r20, $00
		ldi	r21, $00								;y0(0)
		ldi	r22, $00
		ldi r23, $1f								;x1(799)
		ldi r24, $03	
		ldi r25, $df								;y1(479)
		ldi r26, $01

		call MouseInsideRectangle					;Checks if the mouse is in the Screen
	
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		ret

MouseOnCanvas:										;Compare mouse position to canvas (drawing region).
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26

		ldi	r19, 81									;x0
		ldi	r20, $00
		ldi	r21, $00								;y0
		ldi	r22, $00
		ldi r23, $1f								;x1
		ldi r24, $03	
		ldi r25, $df								;y1
		ldi r26, $01

		Call MouseInsideRectangle					;Checks if the mouse is in the Canvas
	
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		ret

MouseInsideRectangle:								;Compare mouse position to rectangle defined by registers r19-r26
													;Set r16 = ff if mouse inside region, 00 if mouse outside region.
		push YL
		push YH
		push ZL
		push ZH
		ldi r16, $aa
		mov YL, r19									;Move x0 into Y
		mov YH, r20
		mov ZL, r21									;Move y0 into Z
		mov ZH, r22
		call CursorLoad								;Load cursor position into r19-r22
		
	case1:											;Mouse x < x0 -> outside
			
			cp YH,r20								;if mouse x > x0, cannot say the mouse is outside region. Go to case 2.
			in r17,sreg
			SBRC r17,0
			jmp case2

			cp r20,YH								;if mouse x < x0, mouse outside region. return 0.
			in r17,sreg
			SBRC r17,0
			jmp MIREnd
			
			

			cp YL,r19								;if mouse x > x0, cannot say the mouse is outside region. Go to case 2.
			in r17,sreg
			SBRC r17,0
			jmp case2

			cp r19,YL								;if mouse x < x0, mouse outside region. return 0.
			in r17,sreg
			SBRC r17,0
			jmp MIREnd

	case2:											;mouse y < y0 -> outside			
			cp ZH,r22								;if mouse y > y0, cannot say the mouse is outside region. Go to case 3.
			in r17,sreg
			SBRC r17,0
			jmp case3

			cp r22,ZH								;if mouse y < y0, mouse outside region. return 0.
			in r17,sreg
			SBRC r17,0
			jmp MIREnd
					
			cp ZL,r21								;if mouse y > y0, cannot say the mouse is outside region. Go to case 3.
			in r17,sreg
			SBRC r17,0
			jmp case3

			cp r21,ZL								;if mouse y < y0, mouse outside region. return 0.
			in r17,sreg
			SBRC r17,0
			jmp MIREnd

	case3:											;mouse x > x1 -> outside
			mov YL, r23								;move x1 into Y register
			mov YH, r24
			
			cp r20,YH								;if mouse x < x1, cannot say the mouse is outside region. Go to case 4.
			in r17,sreg
			SBRC r17,0
			jmp case4

			cp YH,r20								;if mouse x > x0, mouse outside region. return 0.
			in r17,sreg
			SBRC r17,0
			jmp MIREnd

			cp r19,YL								;if mouse x < x0, cannot say the mouse is outside region. Go to case 4.
			in r17,sreg
			SBRC r17,0
			jmp case4

			cp YL,r19								;if mouse x > x0, mouse outside region. return 0.
			in r17,sreg
			SBRC r17,0
			jmp MIREnd

	case4:											;mouse y > y1 -> outside
			mov ZL, r25								;move y1 into Z register
			mov ZH, r26	
			
			cp r22,ZH								;if mouse y < y0, cannot say the mouse is outside region. Therefore mouse inside region -> Go to MIRPass
			in r17,sreg
			SBRC r17,0
			jmp MIRPass

			cp ZH,r22								;if mouse y > y0, mouse outside region. return 0.
			in r17,sreg
			SBRC r17,0
			jmp MIREnd

			cp r21,ZL								;if mouse y < y0, cannot say the mouse is outside region. Therefore mouse inside region -> Go to MIRPass.
			in r17,sreg
			SBRC r17,0
			jmp MIRPass

			cp ZL,r21								;if mouse y > y0, mouse outside region. return 0.
			in r17,sreg
			SBRC r17,0
			jmp MIREnd

	MIRPass:
		ldi r16, $FF
	MIREnd:
		pop ZH
		pop ZL
		pop YH
		pop YL
		ret


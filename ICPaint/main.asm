;
; ICPaint.asm
;
; Created: 24/11/2016 13:07:26
; Author : AL4413
;

.DEVICE ATmega128
.include "m128def.inc"	

.ORG	$0

JMP Init

.include "Definitions.inc"
.include "DelayMethods.asm"
.include "SerialMethods.asm"
.include "GraphicalMethods.asm"
.include "LCDInitMethods.asm"
.include "CursorMethods.asm"
.include "UIMethods.asm"
.include "ToolMethods.asm"

MouseCursorData:				;Data string to set mouse cursor to windows style pointer.
	.DB 0b00101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b00001010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b00010010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b00010100,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b00010101,0b00101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b00010101,0b01001010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b00010101,0b01010010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b00010101,0b01010100,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b00010101,0b01010101,0b00101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b00010101,0b01010101,0b01001010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b00010101,0b01010101,0b01010010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b00010101,0b01010101,0b01010100,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b00010101,0b01010100,0b00000000,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b00010101,0b00010100,0b00101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b00010100,0b10000101,0b00101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b00010010,0b10000101,0b00001010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b00001010,0b10100001,0b01001010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10100001,0b01001010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101000,0b00101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010,0b10101010

;***** MEMORY ADDRESSES FOR PROGRAM VARIABLES *****
;			  CursorPosition 	0110,0111,0112,0113
;	   PreviousMousePosition 	0114,0115,0116,0117
;		  LargeMousePosition 	0118,0119,011A,011B
; PreviousLargeMousePosition	011C,011D,011E,011F
;			ForegroundColour 	0120,0121
;		TempForegroundColour	0122,0123
;		  CurrentDrawingMode	0125
;	   RectangleDrawingState	0130
;	RectangleDrawingPosition	0131,0132,0133,0134
;		 EllipseDrawingState	0135
;	  EllipseDrawingPosition	0136,0137,0138,0139
;		TriangleDrawingState	0140
;	TriangleDrawingPosition1	0141,0142,0143,0144
;	TriangleDrawingPosition2	0145,0146,0147,0148
;			LineDrawingState	0150
;		 LineDrawingPosition	0151,0152,0153,0154
;				   BrushSize	0155
;		ColourSquareSelected	0156
;				ColourSlider	0157,0158,0159
;			   CustomColours	0160,0161, 0162,0163, 0164,0165
;MouseSpeed smaller = faster	0170



Init:                
		;Stack Pointer Setup Code   
		ldi r16, $0F						;Stack Pointer Setup to 0x0FFF
		out SPH,r16							;Stack Pointer High Byte 
		ldi r16, $FF						;Stack Pointer Setup 
		out SPL,r16							;Stack Pointer Low Byte 
	
		;RAMPZ Setup -  1 = EPLM acts on upper 64K, 0 = EPLM acts on lower 64K 
		ldi  r16, $00						;Lower memory page arithmetic
		out RAMPZ, r16			
   
   
		;Port A does not need to be set up here, as it will be set in the HexButton method when reading which key has been pressed.
		;Port B does not need to be set up here, as it will be set in the SPI_MasterInit method later.
   
		;Port C Setup. Lowest two bits as Outputs (Chip Select and RESET pins to LCD Driver), and rest as inputs (WAIT,INTERUPT pins from LCD Driver)
		ldi r16, $03						;Lowest two bits as Outputs. Upper 6 bits as Inputs.
		out DDRC , r16						;Set Port C Direction Register to value in r16
		ldi r16, $FC						;Enable pull up resistors on input pins to prevent current spikes from high impedence input. Set initial values of output pins to zero. 
		out PORTC, r16						;Enable pull up resistors and set initial Port C values.

		;Port D Setup. Set as Outputs, and connected to LEDs for debug purposes.
		ldi r16, $ff						;Set all 8 pins as outputs.
		out DDRD , r16						;Set Port D Direction Register to value in r16
		ldi r16, $00						;Initial Port D value = $00.
		out PORTD, r16						;Output $00 to Port D.
			
		;Port E is unused.

		;Port F Setup. Set as inputs for connecting to joystick potentiometers.
		ldi r16, $00						;Set all 8 pins as inputs.
		STS DDRF, r16						;PSet Port F Direction Register to value in r16
		ldi r16, $FF						;Enable pull up resistors on all pins to prevent current spikes from high impedence input.
		STS PORTF, r16						;Enable pull up resistors.

		call SPI_MasterInit					;Configure device as master, and set clock rate.
		
		;Reset LCD Driver, to clear any existing settings
		ldi r16,$00
		out PORTC, r16						;drive the Chip Select and RESET pins on the LCD Driver low (active)
		call DEL49ms						;wait, to let the Driver reset.
		ldi r16,$03
		out PORTC, r16						;drive the Chip Select and RESET pins on the LCD Driver high (inactive)

		;Configures the Analog to Digital Converter
		ldi r16, $83 						;ADC Interrupt Disabled, ADC Enable
		out ADCSR, r16 						;ADC single shot Mode, Prescaler:CK/8
		
	
;		rcall NewScreen		

		call LCDTurnOn						;Sets configuration values for LCD screen, including screen size, and VSync/HSync setting.
		call SetCursorShape					;Write Mouse pointer image data to Driver.
		call PaintReset						;Enable LCD screen, reset Tools, reset Custom Colours, set selected colour to black and tool to paintbrush, move mouse to center of screen, draw UI

		rjmp Main							;Begin main program loop.

;The main program loop. Everything within the program after initialisation is run from here.
Main:
		call SpeedModeTest					;Sets the MouseSpeed variable depending on whether the fast or slow motion button are pressed.
		call MouseMove						;Moves the mouse according to the position of the joystick.
		call CursorDisplay 					;Send the current mouse position to the Driver.
		
		;check if we are clicking:
		call HexButton						;read button code from hexbutton board into r17
		SBRS r17, 7						;if the button code corresponds to button '1'...
		rjmp MainEnd						;...then skip this line, and do not run any of the 'mouse click' methods. This reduces the number of operations the program has to do per loop.
		
		call Paint							;If clicking on canvas, do drawing operations
	
		call SelectColours					;If clicking on Colour Squares, set selected colour.
			
		call SelectTool1					;If clicking on Tool icons, set selected tool, and reset.
		call SelectTool2
		call SelectTool3
		call SelectTool4
		call SelectTool5
		call SelectTool6

		call SelectRedSliderColour			;If clicking on colour sliders, set custom colour to new colour.
		call SelectGreenSliderColour		
		call SelectBlueSliderColour			
		
		call SelectBrushSliderSize			;If clicking on Brush size slider, set brush size.

	MainEnd:
		;check if reset button is pressed:
		call HexButton						;Read button code from hexbutton board into r17
		SBRC r18, 0							;If reset button ('D') pressed, then call PaintReset
		rcall PaintReset					;Reset Tools, reset Custom Colours, set selected colour to black and tool to paintbrush, move mouse to center of screen, redraw UI.
		
		call DEL15ms

		rjmp Main
		

SpeedModeTest:								;Sets the MouseSpeed variable depending on whether the fast or slow motion button are pressed.
		push r16
		push r17
		push r18
		push ZL
		push ZH

		ldi ZL,$70							;Load address for the MouseSpeed into Z register.
		ldi ZH,$01					
		ldi r16,3							;divide joystick offset by 2^3 = 8 before applying to mouse position
		ST Z,r16							;Set MouseSpeed = 3 (default)

		;check if slow-mo button is pressed:
		call HexButton						;read button code from hexbutton board into r17
		SBRC r17, 4							;if pressing 'A' key...
		rjmp SpeedModeTestSlow				;...set speed to Slow
		SBRC r17,5							;if pressing '3' key...
		rjmp SpeedModeTestFast				;...set speed to Fast.
		
		rjmp SpeedModeTestEnd				;If pressing neither, leave speed at default.

	SpeedModeTestSlow:
		ldi r16,5							;divide joystick offset by 2^5 = 32 before applying to mouse position
		ST Z,r16							;Set MouseSpeed = 5 (slow)

		jmp SpeedModeTestEnd				;pop back registers and return.
		
	SpeedModeTestFast:
		ldi r16,1							;divide joystick offset by 2^1 = 2 before applying to mouse position
		ST Z,r16							;Set MouseSpeed = 1 (fast)
			
	SpeedModeTestEnd:						;pop back registers and return.
		pop ZH
		pop ZL
		pop r18
		pop r17
		pop r16
		ret

MouseMove:									;Moves the mouse according to the position of the joystick.
		push r16
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push YL
		push YH
		push ZL
		push ZH

		;Copy mouse position to PreviousMousePosition
		ldi YL,$10							;Load address for the CursorPosition into Y register.
		ldi YH,$01
		LD r16, Y+							;Load old CursorPosition into r16-r19
		LD r17, Y+
		LD r18, Y+
		LD r19, Y+
		ST Y+, r16							;Store old CursorPosition into PreviousMousePosition memory.
		ST Y+, r17
		ST Y+, r18
		ST Y+, r19

		;Copy large mouse position to PreviousLargeMousePosition
		ldi YL,$18							;Load address for the LargeMousePosition into Y register.
		ldi YH,$01
		LD r16, Y+							;Load old LargeMousePosition into r16-r19
		LD r17, Y+	
		LD r18, Y+
		LD r19, Y+
		ST Y+, r16							;Store old LargeMousePosition into PreviousLargeMousePosition memory.
		ST Y+, r17
		ST Y+, r18
		ST Y+, r19

		;get joystick xpos
		ldi r18,$00							
		call ADCsel							;select X potentiometer for DCATrig
		call DCATrig						;returns result of ADC in r19/r20

		lsr r20								;divide potentiometer value by 32 -> range from 0 to 31
		ror r19								;so we can see if the joystick is in the centre.
		lsr r20
		ror r19
		lsr r19
		lsr r19
		lsr r19

		cpi r19,21							;if joystick inside deadzone (central 1/32 of the range), jump to trying the y axis (i.e. don't change the x position). 21 = measured centre x position (691) / 32.
		BREQ MouseMoveY
		
		ldi YL,$18							;Load address for the LargeMousePosition x component into Y register.
		ldi YH,$01	
		LD ZL,Y+							;load large mouse x position into Z register
		LD ZH,Y+

		call DCATrig						;Returns result of ADC in r19/r20, i.e. the x value of the joystick.
		
		ldi r17,$B3							;Load measured centre x position (691) into r17/r18.
		ldi r18,$02

		ldi YL,$70							;Load address for the MouseSpeed into Y register.
		ldi YH,$01
		ld r25,Y							;Load MouseSpeed into r25
		ldi r26,0							;Set loopCounter to zero.
	  MouseMoveXLoop:						;Divides changes to Mouse position by 2 as many times as MouseSpeed.
			subi r26,$ff					;add 1 to loop counter
			lsr r18							;divides joystick centre position by 2
			ror r17
			lsr r20							;divides joystick position by 2
			ror r19
			cpse r26,r25					;If divided by 2 as many times as MouseSpeed, continue, else loop again.
			rjmp MouseMoveXLoop			

		add ZL,r19							;add joystick value to new large mouse position.
		adc ZH,r20
		sub ZL,r17							;subtract centre joystick value from new large mouse position.
		sbc ZH,r18		

		ldi YL,$18							;Load address for the LargeMousePosition x component into Y register.
		ldi YH,$01
		ST Y+, ZL							;Update LargeMousePosition x component with new value.
		ST Y+, ZH

		lsr ZH								;Divide new LargeMousePosition by 32
		ror ZL
		lsr ZH
		ror ZL
		lsr ZH
		ror ZL
		lsr ZH
		ror ZL
		lsr ZH
		ror ZL

		ldi YL,$10							;Load address for the CursorPosition x component into Y register.
		ldi YH,$01
		ST Y+, ZL							;Update CursorPosition x component with new value.
		ST Y+, ZH

		call MouseOnScreen					;If Mouse on screen, return $FF into r16, else return $00
		cpi r16,$ff
		BREQ MouseMoveY						;If mouse still on screen after changing x position, continue to changing y position...
											;...else reset mouse position to old mouse position:
											
		;if mouse off-screen, reset to old mouse position.
		ldi YL,$14							;Load address for the PreviousMousePosition x component into Y register.
		ldi YH,$01
		LD ZL,Y+							;Load PreviousMousePosition x component into Z register
		LD ZH,Y+

		ldi YL,$10							;Load address for the CursorPosition x component into Y register.
		ldi YH,$01
		ST Y+, ZL							;Update CursorPosition x component with old value.
		ST Y+, ZH

		ldi YL,$1C							;Load address for the PreviousLargeMousePosition x component into Y register.
		ldi YH,$01
		LD ZL,Y+							;Load PreviousLargeMousePosition x component into Z register.
		LD ZH,Y+

		ldi YL,$18							;Load address for the LargeMousePosition x component into Y register.
		ldi YH,$01
		ST Y+, ZL							;Update LargeMousePosition x component with old value.
		ST Y+, ZH

	MouseMoveY:
		;get joystick ypos
		ldi r18,$01		
		call ADCsel							;select Y potentiometer for DCATrig
		call DCATrig						;Returns result of ADC in r19/r20, i.e. the y value of the joystick.
		
		lsr r20								;divide potentiometer value by 32 -> range from 0 to 31
		ror r19								;so we can see if the joystick is in the centre.
		lsr r20
		ror r19
		lsr r19
		lsr r19
		lsr r19

		cpi r19,21							;if joystick inside deadzone (central 1/32 of the range), jump to the end (i.e. don't change the y position). 21 = measured centre x position (688) / 32.
		BREQ MouseMoveEnd

		ldi YL,$1A							;Load address for the LargeMousePosition y component into Y register.
		ldi YH,$01
		LD ZL,Y+							;Load large mouse y position into Z register.
		LD ZH,Y+	

		call DCATrig						;Returns result of ADC in r19/r20, i.e. the y value of the joystick.

		ldi r17,$b0							;Load measured centre x position (688) into r17/r18.
		ldi r18,$02

		ldi YL,$70							;Load address for the MouseSpeed into Y register.
		ldi YH,$01
		ld r25,Y							;Load MouseSpeed into r25
		ldi r26,0							;Set loopCounter to zero.
		MouseMoveYLoop:						;Divides changes to Mouse position by 2 as many times as MouseSpeed.
			subi r26,$ff					;add 1 to loop counter
			lsr r18							;divides joystick centre position by 2
			ror r17
			lsr r20							;divides joystick position by 2
			ror r19
			cpse r26,r25					;If divided by 2 as many times as MouseSpeed, continue, else loop again.
			rjmp MouseMoveYLoop

		;operations backwards on y, as y position measured from top of screen, not bottom
		sub ZL,r19							;subtract joystick value from new large mouse position.
		sbc ZH,r20
		add ZL,r17							;add centre joystick value to new large mouse position.
		adc ZH,r18

		ldi YL,$1A							;Load address for the LargeMousePosition y component into Y register.
		ldi YH,$01
		ST Y+, ZL							;Update LargeMousePosition y component with new value.
		ST Y+, ZH

		lsr ZH								;Divide new LargeMousePosition by 32
		ror ZL
		lsr ZH
		ror ZL
		lsr ZH
		ror ZL
		lsr ZH
		ror ZL
		lsr ZH
		ror ZL

		ldi YL,$12							;Load address for the CursorPosition y component into Y register.
		ldi YH,$01
		ST Y+, ZL							;Update CursorPosition y component with new value.
		ST Y+, ZH

		call MouseOnScreen					;If Mouse on screen, return $FF into r16, else return $00
		cpi r16,$ff
		BREQ MouseMoveEnd					;If mouse still on screen after changing y position, continue to end...
											;...else reset mouse position to old mouse position:

		;if mouse off-screen, reset to old mouse position.
		ldi YL,$16							;Load address for the PreviousMousePosition y component into Y register.
		ldi YH,$01
		LD ZL,Y+							;Load PreviousMousePosition y component into Z register
		LD ZH,Y+

		ldi YL,$12							;Load address for the CursorPosition y component into Y register.
		ldi YH,$01
		ST Y+, ZL							;Update CursorPosition y component with old value.
		ST Y+, ZH

		ldi YL,$1E							;Load address for the PreviousLargeMousePosition y component into Y register.
		ldi YH,$01
		LD ZL,Y+							;Load PreviousLargeMousePosition y component into Z register.
		LD ZH,Y+

		ldi YL,$1A							;Load address for the LargeMousePosition y component into Y register.
		ldi YH,$01
		ST Y+, ZL							;Update LargeMousePosition y component with old value.
		ST Y+, ZH

	MouseMoveEnd:
		pop ZH
		pop ZL
		pop YH
		pop YL
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
		
PaintReset:									;Enable LCD screen, reset Tools, reset Custom Colours, set selected colour to black and tool to paintbrush, move mouse to center of screen, draw UI
		push r16
		push r25
		push r26
		push YL
		push YH

		rcall NewScreen						;Enable LCD screen, turns on the backlight, and sets every pixel white.
		
		ldi YL,$10							;Load address of the CursorPosition into Y register.
		ldi YH,$01
		ldi r16,$90							;xlow
		st Y+,r16
		ldi r16,$01							;xhigh
		st Y+,r16							;Set x value of CursorPosition to $0190 = 400, i.e. halfway across screen.
		
		ldi r16,$f0							;ylow
		st Y+,r16
		ldi r16,$00							;yhigh
		st Y+,r16							;Set y value of CursorPosition to $00F0 = 240 , i.e. halfway down screen.

		ldi YL,$18							;Load address of the LargeMousePosition into Y register.
		ldi YH,$01
		ldi r16,$00							;xlow
		st Y+,r16
		ldi r16,$32							;xhigh
		st Y+,r16							;Set x value of LargeMousePosition to $3200 = 12800 = 400*32, i.e. halfway across screen.
		
		ldi r16,$00							;ylow cursor
		st Y+,r16
		ldi r16,$1E							;yhigh cursor
		st Y+,r16							;Set y value of LargeMousePosition to $1E00 = 7860 = 240*32 , i.e. halfway down screen.

		call ResetTools						;Clear any saved points for drawing tools.
		call ResetBrush
		call CustomColoursReset				;Reset custom colours to black.

		ldi YL,$25							;Load address of CurrentDrawingMode into Y register.
		ldi YH,$01
		ldi r16,$00							
		ST Y,r16							;Set the CurrentDrawingMode to 0 (Paint Brush).

		ldi YL,$56							;Load address of the ColourSquareSelected into Y register.	
		ldi YH,$01
		ldi r16,9
		ST Y,r16							;Set the ColourSquareSelected to 9 (Black).

		ldi r25, COLOUR_BLACKL				
		ldi r26, COLOUR_BLACKH
		call SetForegroundColour			;Set Initial ForegroundColour to Black, so user paints in black

		call DrawUserInterface				;Redraw the user interface. This happens after the custom colours are reset and the foreground colour changed, so the custom colour icons display correctly, and the brush size icon has the correct center colour.
		
		call DEL49ms						;A couple of delays to reduce the flickering that occurs when the Reset button is held on the button pad.
		call DEL49ms

		pop YH
		pop YL
		pop r26
		pop r25
		pop r16
		ret

NewScreen:									;Enable LCD screen, turns on the backlight, and sets every pixel white.
		call SaveForegroundColourToTemp		;Backup the current foreground colour, so we can draw in another colour until the end of the method.
		
		ldi r16, $ff						;Load $ff into r16 as boolean TRUE argument for DisplayOn method.
		call DisplayOn						;Turn the LCD display on.
		
		ldi r16, $ff
		call GPIOX							;Enable TFT - display enable tied to GPIOX
		
		ldi r16, $ff						;Load $ff into r16 as boolean TRUE argument for PWM1config method. I.e. turn on the backlight.
		ldi r17, $0A						;set clock rate as 2^10 times slower than the Driver system clock.
		call PWM1config						;Turn on the backlight, and set the power management clock rate to 1024 times slower than driver system clock.
		
		ldi r16, $3f
		call PWM1out
		ldi r25, COLOUR_WHITEL				;Load colour white into r25/26.
		ldi r26, COLOUR_WHITEH
		call SetForegroundColour			;Set foreground colour to white.
			
		call FillScreen						;Draw a white rectangle over the entire screen.
		
		call LoadForegroundColourFromTemp	;Reset foreground colour to saved colour, so the foreground colour has not been altered from outside this method.
		ret

HexButton:									;Returns 2 bytes r17/r18, containing state of all 16 buttons on number pad. 1 = pressed, 0 = unpressed.
		push r16
		push r19
		
		;GetButtons 123A
		ldi r16, $08
		out DDRA, r16						;Set pin 3 as an output, and all other pins as inputs.
		ldi r16, $F7		
		out PORTA, r16						;Drive pin 3 low, and enable pull up resistors on all other pins. If any buttons on row 0 are pressed, they connect a pull up to low, and low drags the pull up resistor low.
		call DEL100mus						;Delay a small amount so any capacitance in the button pad is filled before trying to read in the state.
		In r17, PINA
		ori r17,$0f							;Throw away any connections that are not columns
		com r17								;invert, so 1 is pressed, and 0 is unpressed

		;GetButtons 456B
		ldi r16, $04
		out DDRA, r16						;Set pin 2 as an output, and all other pins as inputs.
		ldi r16, $FB		
		out PORTA, r16						;Drive pin 2 low, and enable pull up resistors on all other pins. If any buttons on row 2 are pressed, they connect a pull up to low, and low drags the pull up resistor low.
		call DEL100mus						;Delay a small amount so any capacitance in the button pad is filled before trying to read in the state.
		In r18, PINA
		ori r18,$0f							;Throw away any connections that are not columns
		com r18								;invert, so 1 is pressed, and 0 is unpressed
		lsr r18								;shift right, so line 2 state in bits [3:0]
		lsr r18
		lsr r18
		lsr r18
		or r17,r18							;Merge states of buttons 123A456B into a single byte


		;GetButtons 789C
		ldi r16, $02
		out DDRA, r16						;Set pin 1 as an output, and all other pins as inputs.
		ldi r16, $FD		
		out PORTA, r16						;Drive pin 1 low, and enable pull up resistors on all other pins. If any buttons on row 3 are pressed, they connect a pull up to low, and low drags the pull up resistor low.
		call DEL100mus						;Delay a small amount so any capacitance in the button pad is filled before trying to read in the state.
		In r18, PINA
		ori r18,$0f							;Throw away any connections that are not columns
		com r18								;invert, so 1 is pressed, and 0 is unpressed

		;GetButtons *0#D
		ldi r16, $01
		out DDRA, r16						;Set pin 0 as an output, and all other pins as inputs.
		ldi r16, $FE		
		out PORTA, r16						;Drive pin 0 low, and enable pull up resistors on all other pins. If any buttons on row 4 are pressed, they connect a pull up to low, and low drags the pull up resistor low.
		call DEL100mus						;Delay a small amount so any capacitance in the button pad is filled before trying to read in the state.
		In r19, PINA
		ori r19,$0f							;Throw away any connections that are not columns
		com r19								;invert, so 1 is pressed, and 0 is unpressed
		lsr r19								;shift right, so line 4 state in bits [3:0]
		lsr r19
		lsr r19
		lsr r19
		or r18,r19
		out portD,r18						;Merge states of buttons 789C*0#D into a single byte

		pop r19
		pop r16
		ret

ADCsel:										;Select channel based on value in r18, i.e which pin in PORTF to pass to the ADC.
		out ADMUX, r18 						;Tell the multiplexer which input to output to the ADC.
		ret

DCATrig:									;Returns result of Analogue to Digital Conversion (ADC) in r19/r20
		SBI ADCSR, 6 						;Set the 'ADC Start Conversion' bit in the ADC Status Register (ADCSR), making it convert the voltage on the selected PORTF pin to a 10 bit digital number
	DCATrigLoop:	
		SBIS ADCSR, 4 						;If ADC Interrupt flag is not high...
		RJMP DCATrigLoop 					;...loop until ADC Interrupt flag is high.
		SBI ADCSR, 4 						;...else reset ADC Interrupt flag and continue.
		IN r19, ADCL 						;Move the low byte of ADC result into r19
		IN r20, ADCH 						; Read in High Byte
		RET




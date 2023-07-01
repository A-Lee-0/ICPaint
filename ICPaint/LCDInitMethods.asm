/*
 * LCDInitMethods.asm
 *
 *  Created: 14/11/2016 15:45:32
 *   Author: AL4413
 */ 
 
DisplayOn:						;Boolean 'on' argument in r16 ($00=off,$ff=on). 
								;Sets the 'LCD Display Off' bit in the 'Power and Display Control Register' (PWRR)
		push r17
		push r18
		
		ldi r17, $01				;Power and Display Control Register (PWRR). Turns LCD screen on/off, Sets mode to normal/sleep, can perform a software reset.
		cpi r16, $ff 			;If r16 = $ff...
		BREQ DisplayOnTrue		;...then turn on the display
		rjmp DisplayOnFalse		;...else turn off the display.
		
	DisplayOnTrue: 
		
		ldi r18,$80				;Sets the 'LCD Display Off' bit to 1, turning the screen on.

		call WriteReg			;writes the data in r18 to the Driver register address in r17.

		rjmp DisplayOnEnd		;clean up registers and return.
		
	DisplayOnFalse:
		ldi r18,$00				;Sets the 'LCD Display Off' bit to 0, turning the screen off.
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		
	DisplayOnEnd:				;pops values back into registers and returns.

		pop r18
		pop r17
		ret

GPIOX:							;Boolean 'on' argument in r16 ($00=off,$ff=on)
		push r17
		push r18
		
		ldi r17,$C7
		cpi r16,$ff 
		BREQ GPIOXTrue
		rjmp GPIOXFalse
		
	GPIOXTrue: 
		ldi r18,$01
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		rjmp GPIOXEnd
		
	GPIOXFalse:
		ldi r18,$00
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		
	GPIOXEnd:
		pop r18
		pop r17
		ret

PWM1config:						;PWM1 Control Register (P1CR) - PWM1 Enable/Disable in bit 7. 
								;Boolean 'on' argument in r16 ($00=off,$ff=on), turning backlight on/off
								;clock value in r17. Frequency = Driver System Clock / (2^r17)
		push r17
		push r18
		
		mov r18, r17			;move data into r18 in preparation for WriteReg
		ANDI r18,$0f			;clear top four bits to ensure bad data doesn't set other bits.
		ldi r17, $8A			;PWM1 Control Register (P1CR).
		
		cpi r16,$ff 
		breq PWM1configTrue
		rjmp PWM1configFalse
		
	PWM1configTrue:				;sets bit 7 to true in PWM1 Control Register, turning backlight on.
		ORI r18,$80				;set bit 7 true - enable backllight.
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		rjmp PWM1configEnd
		
	PWM1configFalse:			;sets bit 7 to false in PWM1 Control Register, turning backlight off.
		ORI r18,$00				;set bit 7 false - disable backlight.
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		
	PWM1configEnd:				;pops values back into registers and returns.
		pop r18
		pop r17
		ret

PWM1out:   						;writes the value in r16 to the PWM1 Duty Cycle Register (P1DCR), setting the back light brightness.
		push r18
		push r17
		
		mov r18,r16
		ldi r17,$8B				;PWM1 Duty Cycle Register (P1DCR).
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		
		pop r17
		pop r18
		ret

LCDTurnOn:						;Sets configuration values for LCD screen, including screen size, and VSync/HSync setting.
		push r17
		push r18
		
		ldi r17,$88				;Phase Locked Loop Control Register 1 (PLLC1)
		ldi r18,$0b
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		
		ldi r17,$89				;Phase Locked Loop Control Register 2 (PLLC2)
		ldi r18,$02
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		call DEL15ms			;RA8875 datasheet says delay of >100us necessary - 15ms should be enough.

		ldi r17,$10				;System Configuration Register (SYSR). Controls 8/16 bit colour, and 8/16 bit microprocessor interface.
		ldi r18,$0c				;16bit colour, 8 bit microprocessor interface
		call WriteReg			;writes the data in r18 to the Driver register address in r17.

		ldi r17,$04	 			;Pixel Clock Setting Register (PCLK). Sets the relative pixel clock to the sytem clock, and whether pixel data is fetched on a rising or falling edge.
		ldi r18,$81	 			;Data fetched on falling edge. Pixel clock period is twice system clock (i.e. half the speed).
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
 
		;Horizontal settings
		ldi r17,$14	 			;Horizontal Display Width Register (HDWR). Horizontal display width(pixels) = (HDWR + 1)*8
		ldi r18,$63				;$63 = 99 -> (99 + 1) * 8 = 800 pixels wide
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		
		ldi r17,$16	 			;Horizontal Non-Display Period Register (HNDR)
		ldi r18,$03	 			;Horizontal Non-Display Period (pixels) = (HNDR + 1)*8
		call WriteReg			;writes the data in r18 to the Driver register address in r17.

		ldi r17,$17	 			;HSYNC Start Position Register (HSTR).
		ldi r18,$03	 			;HSYNC Start Position = 32 pixels
		call WriteReg			;writes the data in r18 to the Driver register address in r17.

		ldi r17,$18	 			;HSYNC Pulse Width Register (HPWR). Sets HSYNC Polarity and the Pulse width of HSYNC. HSYNC Pulse Width (pixels) = (HPW + 1)x8
		ldi r18,$0B	 			;HPW = 11 -> pulse width = 96 pixels. Polarity = low active.
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
 
		;Vertical settings
		ldi r17,$19				;Vertical Display Height Register bits [7:0] (VDHR0). Vertical pixels = VDHR + 1.
		ldi r18,$df	 			;$01DF = 479 -> 480 pixels
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		
		ldi r17,$1a	 			;Vertical Display Height Register bit [8] (VDHR1). Vertical pixels = VDHR + 1.
		ldi r18,$01	 			;$01DF = 479 -> 480 pixels
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		
		ldi r17,$1b	 			;Vertical Non-Display Period Register bits [7:0] (VNDR0)
		ldi r18,$20	 			;Vertical Non-Display area = 32 lines
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		
		ldi r17,$1c	 			;Vertical Non-Display Period Register bit [8] (VNDR1)
		ldi r18,$00				;Vertical Non-Display area = 32 lines
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		
		ldi r17,$1d				;VSYNC Start Position Register bits [7:0] (VSTR0).
		ldi r18,$16	 			;VSYNC Start Position = 22 pixels
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		
		ldi r17,$1e	 			;VSYNC Start Position Register bit [8] (VSTR0).
		ldi r18,$00	 			;VSYNC Start Position = 22 pixels
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		
		ldi r17,$1f	 			;VSYNC Pulse Width Register (VPWR). Sets VSYNC Polarity and the Pulse width of VSYNC. VSYNC Pulse Width (pixels) = (VPW + 1)x8
		ldi r18,$01	 			;VPW = 1 -> pulse width = 2 pixels. Polarity = low active.
		call WriteReg			;writes the data in r18 to the Driver register address in r17.

		rcall SetActiveWindowToScreen	;Set Active Window to rectangle from (0,0) to (799,479) - i.e make entire screen drawable region.
		
		pop r18
		pop r17
		ret
		

SetActiveWindowToScreen:		;Set Active Window to rectangle from (0,0) to (799,479) - i.e make entire screen drawable region.
		push r17
		push r18

		;X0
		ldi r17,$30				;Horizontal Start Point of Active Window bits [7:0] (HSAW0)
		ldi r18,0				;0 pixels from left of screen.
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		ldi r17,$31				;Horizontal Start Point of Active Window bit [8] (HSAW1)
		ldi r18,0
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		
		;Y0
		ldi r17,$32				;Vertical Start Point of Active Window bits [7:0] (VSAW0)
		ldi r18,0				;0 pixels from top of screen.
		call WriteReg
		ldi r17,$33				;Vertical Start Point of Active Window bit [8] (VSAW1)
		ldi r18,0
		call WriteReg			;writes the data in r18 to the Driver register address in r17.

		;X1
		ldi r17,$34				;Horizontal End Point of Active Window bits [7:0] (HEAW0)
		ldi r18,$1F				;799 pixels from left of screen
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		ldi r17,$35				;Horizontal End Point of Active Window bit [8] (HEAW1)
		ldi r18,$03
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		
		;Y1
		ldi r17,$36				;Vertical End Point of Active Window bits [7:0] (VEAW0)
		ldi r18,$DF				;479 pixels from top of screen
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		ldi r17,$37				;Vertical End Point of Active Window bit [8] (VEAW1)
		ldi r18,$01
		call WriteReg			;writes the data in r18 to the Driver register address in r17.

		pop r18
		pop r17
		ret
	

SetActiveWindowToCanvas:		;Set Active Window to rectangle from (81,0) to (799,479) - i.e make only the Canvas the drawable region.
		push r17
		push r18

		;X0
		ldi r17,$30				;Horizontal Start Point of Active Window bits [7:0] (HSAW0)
		ldi r18,81				;81 pixels from left of screen.
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		ldi r17,$31				;Horizontal Start Point of Active Window bit [8] (HSAW1)
		ldi r18,0
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		
		;Y0
		ldi r17,$32				;Vertical Start Point of Active Window bits [7:0] (VSAW0)
		ldi r18,0				;0 pixels from top of screen.
		call WriteReg
		ldi r17,$33				;Vertical Start Point of Active Window bit [8] (VSAW1)
		ldi r18,0
		call WriteReg			;writes the data in r18 to the Driver register address in r17.

		;X1
		ldi r17,$34				;Horizontal End Point of Active Window bits [7:0] (HEAW0)
		ldi r18,$1F				;799 pixels from left of screen
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		ldi r17,$35				;Horizontal End Point of Active Window bit [8] (HEAW1)
		ldi r18,$03
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		
		;Y1
		ldi r17,$36				;Vertical End Point of Active Window bits [7:0] (VEAW0)
		ldi r18,$DF				;479 pixels from top of screen
		call WriteReg			;writes the data in r18 to the Driver register address in r17.
		ldi r17,$37				;Vertical End Point of Active Window bit [8] (VEAW1)
		ldi r18,$01
		call WriteReg			;writes the data in r18 to the Driver register address in r17.

		pop r18
		pop r17
		ret

		
		



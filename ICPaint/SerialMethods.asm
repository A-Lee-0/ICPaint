/*
 * SerialMethods.asm
 *
 *  Created: 24/11/2016 13:11:57
 *   Author: AL4413
 */ 
SerialTestLoop: 				;Debug method - writes $ff to register $63 on the driver (foreground colour low byte), and then reads it back. Used with oscilliscope on MISO/MOSI pins to see data transfer.
		call SerialTestWrite

		call SerialTestRead		;read value back from register 63 on driver

		call DEL100mus
		call DEL100mus
		call DEL100mus
		call DEL100mus
		call DEL100mus
		call DEL100mus
		call DEL100mus
		call DEL100mus
		jmp SerialTestLoop

SerialTestWrite:				;Debug method - writes $ff to register $63 on the driver (foreground colour low byte)
		ldi r17,$63
		ldi r18,$ff
		call WriteReg
		ret

SerialTestRead:					;Debug method - reads value of register $63 back from driver and outputs it to Port D.	
		ldi r17,$63
		call ReadReg
		out portd,r17
		ret

SPI_MasterInit:					;Configure device as master, and set clock rate. Set I/O directions on portB as required for 4 wire SPI
		push r17
		
		;Set MOSI, Serial Clock (SCK), SS*  as outputs, all others inputs
		ldi r17,(1<<DDB2)|(1<<DDB1)|(1<<DDB0)	
		out DDRB,r17
		
		; Enable SPI, Configure this device as Master, set clock rate fck/16
		ldi r17,(1<<SPE)|(1<<MSTR)|(1<<SPR0)
		out SPCR,r17
		
		pop r17
		ret

SPI_MasterTransmit:				;Send data from r16 to the Driver via SPI.
		out SPDR,r16			;Start transmission of data (held in r16)
	Wait_Transmit:				;Wait for transmission to complete
		sbis SPSR,SPIF			;If transmission complete, return, else wait more.
		rjmp Wait_Transmit
		ret 

DriverWait:						;Wait until WAIT pin from driver is cleared. Used to make sure instructions are not sent to the driver while it is busy.
		push r16
		
	DriverWaitStart:
		IN r16, PINC			;input from port C, to check INT and WAIT pins
		ANDI r16, $04			;AND with 00000100, to isolate wait pin from input
		CPI r16, $00			;compare with $00, to see if WAIT pin is set. If WAIT pin set, loop until WAIT pin cleared.
		BREQ DriverWaitStart	;If WAIT pin = 1, jump back to start of loop else finish, and return.

	DriverWaitEnd:
		pop r16
		ret
	
DriverDataR:					;read data from driver into r17 from register address specified by previous DriverCommandW.
		push r16

		ldi r16,$02				;chip select - lcd input active. ($02 so the Chip Select pin is driven low (active), while the RESET pin is kept high (inactive).)
		out PORTc,r16

		ldi r16,$40				;Writes 0b01(000000) to driver, so it knows to transmit data from register on the next SCK 
		rcall SPI_MasterTransmit

		ldi r16,$00				;dummy data transmit, to fill SPDR register with data from driver (SPI works with full Duplex)
		rcall SPI_MasterTransmit
		in r17, SPDR

		ldi r16,$03				;chip select - lcd inactive. ($03 so the Chip Select pin is driven high (inactive), while the RESET pin is kept high (inactive).)
		out PORTc,r16
		
		pop r16
		ret

DriverDataW: 					;write data in r17 to the register on the driver with address specified by previous DriverCommandW.
		push r16
		
		ldi r16,$02				;chip select - lcd input active. ($02 so the Chip Select pin is driven low (active), while the RESET pin is kept high (inactive).)
		out PORTc,r16
	
		ldi r16,$00				;Writes 0b00(0000000) to driver, so it knows the next byte sent is data to write to a register.
		rcall SPI_MasterTransmit		
		
		mov r16,r17				;move data into r16, so SPI_MasterTransmit method can send it.
		rcall SPI_MasterTransmit
		
		ldi r16,$03				;chip select - lcd inactive. ($03 so the Chip Select pin is driven high (inactive), while the RESET pin is kept high (inactive).)
		out PORTc,r16

		pop r16
		ret

DriverStatusR:					;reads data into r17 from the status register on the driver.
		push r16

		ldi r16,$02				;chip select - lcd input active. ($02 so the Chip Select pin is driven low (active), while the RESET pin is kept high (inactive).)
		out PORTC,r16

		ldi r16,$c0				;Writes 0b11(0000000) to driver, so it knows the next byte sent is data to write to a register.
		rcall SPI_MasterTransmit

		ldi r16,$00				;dummy data transmit, to fill SPDR register with data from driver
		rcall SPI_MasterTransmit
		in r17, SPDR

		ldi r16,$03				;chip select - lcd inactive. ($03 so the Chip Select pin is driven high (inactive), while the RESET pin is kept high (inactive).)
		out PORTC,r16

		pop r16
		ret

DriverCommandW:					;write address in r17 to the driver, so subsequent DriverDataR/DriverDataW calls act on 
		push r16

		ldi r16,$02				;chip select - lcd input active. ($02 so the Chip Select pin is driven low (active), while the RESET pin is kept high (inactive).)
		out PORTC,r16

		ldi r16,$80				;Writes 0b10(0000000) to driver, so it knows the next byte sent is data to write to a register.
		rcall SPI_MasterTransmit
		
		mov r16,r17				;Move register address into r16, so SPI_MasterTransmit method can send it.
		rcall SPI_MasterTransmit

		ldi r16,$03				;chip select - lcd inactive. ($03 so the Chip Select pin is driven high (inactive), while the RESET pin is kept high (inactive).)
		out PORTC,r16

		pop r16
		ret

WriteReg:						;write data in r18 to driver register with address in r17
		rcall DriverCommandW	;tell driver we're working with register with address in r17
		mov r17,r18				;move data to write into r17 in preparation for DriverDataW
		rcall DriverDataW		;write data in r17 to register on driver.
		rcall DriverWait		;wait for driver to no longer be busy.
		ret

ReadReg:						;read data into r17 from driver register with address in r17
		rcall DriverCommandW	;tell driver we're working with register with address in r17
		rcall DriverDataR		;read data from driver register into r17
		rcall DriverWait		;wait for driver to no longer be busy.
		ret

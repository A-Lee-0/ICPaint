/*
 * Pong.asm
 *
 *  Created: 24/11/2016 13:11:26
 *   Author: AL4413
 */ 

;pong
;Player1 cursor position stored in 0200,0201
;Player2 cursor position stored in 0202,0203
;Ball position stored in 0204,0205,0206,0207
;Ball vertical speed stored in 0208
;Ball up ($00) or down ($FF) stored in 0209
;Ball left ($00) or right ($FF) stored in 020A
;Ball minimum height stored in 0210,0211
;Ball maximum height stored in 0212,0213
;Player1 score stored in 0214
;Player2 score stored in 0215

PongStart:
		ldi ZL, $10
		ldi ZH, $02
		
		;load ball top and bottom bounds.
		ldi r16,80		;40 pixel buffer on screen, and y position in memory doubled -> 80.
		st Z+,r16
		ldi r16,0
		st Z+,r16
		ldi r16,$6E		;40 pixel buffer on screen, and y position in memory doubled -> 878.
		st Z+,r16
		ldi r16,$03
		st Z+,r16
		
		
		
		call PongNewScreen
		rcall PongResetScores
		rcall PongNewRound
		
		jmp PongMainLoop
		
PongNewRound:			;resets positions and velocities to initial values
		push r16
		push ZL
		push ZH
		
		ldi ZL, $00
		ldi ZH, $02
		ldi r16,200		;load initial player1 cursor y position.
		st Z+,r16
		ldi r16,0
		st Z+,r16
		
		ldi r16,200		;load initial player2 cursor y position.
		st Z+,r16
		ldi r16,0
		st Z+,r16
		
		ldi r16,$90		;load initial ball xy position.
		st Z+,r16
		ldi r16,$01
		st Z+,r16
		ldi r16,200
		st Z+,r16
		ldi r16,0
		st Z+,r16
		
		ldi r16,$00		;load initial ball vertical direction
		st Z+,r16
		ldi r16,$00		;load initial ball horizontal direction
		st Z+,r16
		
		call PongScreenUpdate
		
		pop ZH
		pop ZL
		pop r16
		ret

PongResetScores:
		push r16
		push ZL
		push ZH
		
		ldi ZL, $14
		ldi ZH, $02
		
		ldi r16,$00		;Set Player1 score to 0
		st Z+,r16
		ldi r16,$00		;Set Player2 score to 0
		st Z+,r16
		
		pop ZH
		pop ZL
		pop r16
		ret
		
PongNewScreen:
		ldi r25, RA8875_BLACKL
		ldi r26, RA8875_BLACKH
		call SetForegroundColour
		call FillScreen
		
		ldi r25, RA8875_WHITEL
		ldi r26, RA8875_WHITEH
		call SetForegroundColour
		ldi r17,0
		ldi r18,0
		ldi r19,40
		ldi r20,0
		ldi r21,$1f	;800
		ldi r22,$03
		ldi r23,40
		ldi r24,0
		call DrawLine
		ldi r17,0
		ldi r18,0
		ldi r19,$b7	;439
		ldi r20,$01
		ldi r21,$1f	;800
		ldi r22,$03
		ldi r23,$b7	;439
		ldi r24,$01
		call DrawLine
		
		call CursorDisable
		ret
		
PongMainLoop:
		;call PongMoveBall	;move ball
		
		;call PongMoveAI			;move player2
		;call PongMovePlayer1	;get inputs and move player 1
		call PongScreenUpdate	;draw new screen state.
		;call PongWinTest		;check if either player has won, and change score appropriately.
		
		
		call DEL49ms			;wait
		rjmp PongMainLoop

PongDrawScores:
		push r17
		push r18
		push r19
		push r20
		
		ldi r17,9
		ldi r18,0
		ldi r19,9
		ldi r20,0
		rcall PongDrawScoreBox
		
		ldi r17,39
		ldi r18,0
		ldi r19,9
		ldi r20,0
		rcall PongDrawScoreBox
		
		ldi r17,69
		ldi r18,0
		ldi r19,9
		ldi r20,0
		rcall PongDrawScoreBox
		
		ldi r17,$16	;790
		ldi r18,$03
		ldi r19,9
		ldi r20,0
		rcall PongDrawScoreBox
		
		ldi r17,$f8	;760
		ldi r18,$02
		ldi r19,9
		ldi r20,0
		rcall PongDrawScoreBox
		
		ldi r17,$da	;730
		ldi r18,$02
		ldi r19,9
		ldi r20,0
		rcall PongDrawScoreBox
		
		pop r20
		pop r19
		pop r18
		pop r17
		ret
		
PongDrawScoreBox:			;Draws a scorebox at the position stored in r17-r20 (of the foreground colour).
		push r21
		push r22
		push r23
		push r24
		push r27
		push YL
		push YH
		
		mov YL,r17
		mov YH,r18
		adiw Y,19
		mov r21,YL
		mov r22,YH
		
		mov YL,r19
		mov YH,r20
		adiw Y,19
		mov r23,YL
		mov r24,YH
		
		ldi r27,$ff
		
		call DrawRectangle
		
		pop YH
		pop YL
		pop r27
		pop r24
		pop r23
		pop r22
		pop r21
		ret

PongDrawScorePip:			;Draws a score pip at the position stored in r17-r20 (in black).
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26
		push r27
		push YL
		push YH
		
		call SaveForegroundColourToTemp
		ldi r25, RA8875_BLACKL
		ldi r26, RA8875_BLACKH
		call SetForegroundColour
		
		mov YL,r17
		mov YH,r18
		adiw Y,17
		mov r21,YL
		mov r22,YH
		
		mov YL,r19
		mov YH,r20
		adiw Y,17
		mov r23,YL
		mov r24,YH
		
		ldi r27,$ff
		
		call DrawRectangle
		call LoadForegroundColourFromTemp
		pop YH
		pop YL
		pop r27
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		ret
		
PongScreenUpdate:
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r27
		push YL
		push YH
		push ZL
		push ZH
		ldi r25, RA8875_BLACKL
		ldi r26, RA8875_BLACKH
		call SetForegroundColour
		
		ldi r17,0
		ldi r18,0
		ldi r19,41
		ldi r20,0
		ldi r21,$1f	;800
		ldi r22,$03
		ldi r23,$b6	;439
		ldi r24,$01
		ldi r27,$ff
		call DrawRectangle
		
		ldi r25, RA8875_WHITEL
		ldi r26, RA8875_WHITEH
		call SetForegroundColour
		
		;draw player 1 cursor
		ldi r17,24
		ldi r18,0
		
		ldi ZL,$00
		ldi ZH,$02
		ld YL, Z+
		ld YH, Z+
		sbiw Y, 20
		mov r19,YL
		mov r20,YH
		
		ldi r21,39
		ldi r22,0
		
		ldi ZL,$00
		ldi ZH,$02
		ld YL, Z+
		ld YH, Z+
		adiw Y, 20
		mov r23,YL
		mov r24,YH
		ldi r27, $00
		call DrawRectangle
		
		;draw player 2 cursor
		ldi r17,$f8
		ldi r18,$02
		
		ldi ZL,$02
		ldi ZH,$02
		ld YL, Z+
		ld YH, Z+
		sbiw Y, 20
		mov r19,YL
		mov r20,YH
		
		ldi r21,$07
		ldi r22,$03
		
		ldi ZL,$02
		ldi ZH,$02
		ld YL, Z+
		ld YH, Z+
		adiw Y, 20
		mov r23,YL
		mov r24,YH
		ldi r27, $00
		call DrawRectangle
		
		;draw ball
		ldi ZL,$04
		ldi ZH,$02
		ld YL, Z+
		ld YH, Z+
		sbiw Y, 5
		mov r17,YL
		mov r18,YH
		
		ldi ZL,$06
		ldi ZH,$02
		ld YL, Z+
		ld YH, Z+
		sbiw Y, 5
		mov r19,YL
		mov r20,YH
		lsr r20
		ror r19
		
		ldi ZL,$04
		ldi ZH,$02
		ld YL, Z+
		ld YH, Z+
		sbiw Y, 5
		mov r21,YL
		mov r22,YH
		
		
		ldi ZL,$06
		ldi ZH,$02
		ld YL, Z+
		ld YH, Z+
		adiw Y, 5
		mov r23,YL
		mov r24,YH
		lsr	r24
		ror r23
		ldi r27, $00
		call DrawRectangle	
		
		pop ZH
		pop ZL
		pop YH
		pop YL
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

PongMoveAI:
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push ZL
		push ZH
		
		call PongLoadBallScreenPosition
		call PongLoadPlayer2Position	;load the position of player 2's cursor.
		ld r24,Z+	
		
		sub r21,r23
		cpc r22,r24
		BRGE PongMoveAIDown
		rjmp PongMoveAIUp
		
	PongMoveAIDown:
		mov ZL,r23
		mov ZH,r24
		adiw Z, $01
		mov r23,ZL
		mov r24,ZH
		rjmp PongMoveAIEnd
		
	PongMoveAIUp:
		mov ZL,r23
		mov ZH,r24
		sbiw Z, $01
		mov r23,ZL
		mov r24,ZH
		
	PongMoveAIEnd:
		ldi ZL, $02
		ldi ZH, $02
		st Z+, r23	;store the new position of player 2's cursor.
		st Z+, r24
		pop ZH
		pop ZL
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		ret

		
PongMovePlayer1:
		;read y value off joystick (using adc)
		;update Player1 cursor position
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

		;get joystick ypos
		ldi YL,$00		;sets address to save cursor position
		ldi YH,$02
		LD ZL, Y+		;load ypos into Z register
		LD ZH, Y+
		
		ldi r18,$01
		call ADCsel
		call DCATrig

	;if ADC result > 767...
		cpi r20,$03		
		in r17,sreg
		SBRC r17,1
		SBIW Z,$01		;...add one to ypos
		
		ldi YL,$00		;reset Y to look at ypos
		ldi YH,$02
		ST Y+, ZL		;update ypos with new value
		ST Y+, ZH
		
		call PongMouseOnScreen
		cpi r16,$ff
		in r17,sreg
		SBRS r17,1
		ADIW Z,$01
		
		ldi YL,$00		;reset Y to look at ypos
		ldi YH,$02
		ST Y+, ZL		;update ypos with new value
		ST Y+, ZH
		
	;if ADC result < 256...
		cpi r20,$00		
		in r17,sreg
		SBRC r17,1
		ADIW Z,$01		;...subtract one from ypos
		
		ldi YL,$00		;reset Y to look at ypos
		ldi YH,$02
		ST Y+, ZL		;update ypos with new value
		ST Y+, ZH
		
		call PongMouseOnScreen
		cpi r16,$ff
		in r17,sreg
		SBRS r17,1
		SBIW Z,$01
		
		ldi YL,$00		;reset Y to look at ypos
		ldi YH,$02
		ST Y+, ZL		;update ypos with new value
		ST Y+, ZH

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
		
PongMouseOnScreen: ;Compare mouse position to screen size.
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26

		ldi	r19, 0	;x0
		ldi	r20, 0
		ldi	r21, 60	;y0
		ldi	r22, 0
		ldi r23, $1f	;x1
		ldi r24, $03	
		ldi r25, $a5	;y1
		ldi r26, $01

		call MouseInsideRectangle
	
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		ret
		
PongMoveBall:
		push r17
		push r19
		push r20
		push r21
		push r22
		push YL
		push YH
		
		call PongLoadBallPosition	;load ball position into r19-22
		ldi ZL, $08
		ldi ZH, $02
		ld r17,Z+	;the vertical velocity of the ball.
		ld r18,Z+	;the up/down boolean of the ball.
		
		cpi r18,$ff
		BREQ PongMoveBallDown
	
	PongMoveBallUp:
		sub r21,r17
		sbci r22, 0
		jmp PongMoveBallLR
	
	PongMoveBallDown:
		sub r21,r17
		ldi r17,0
		adc r22, r17 
	
	PongMoveBallLR:
		ld r18,Z+	;the left/right boolean of the ball.
		cpi r18,$ff
		BREQ PongMoveBallRight
	
	PongMoveBallLeft:
		mov YL,r19
		mov YH,r20
		sbiw Y,1
		mov r19,YL
		mov r20,YH
		rjmp PongMoveBallEnd
	
	PongMoveBallRight:
		mov YL,r19
		mov YH,r20
		adiw Y,1
		mov r19,YL
		mov r20,YH
	
	PongMoveBallEnd:
		call PongSetBallPosition
		call PongCheckBallLimits	;checks to make sure ball has not escaped off the top or bottom of playing area.
		pop YH
		pop YL
		pop r22
		pop r21
		pop r20
		pop r19
		pop r17
		ret
		
PongCheckBallLimits:
		push r16
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		push r25
		push r26
		push ZL
		push ZH
		
		ldi ZL,$10
		ldi ZH,$02
		ld r23, Z+	;read in min and max allowed y positions of ball from memory. Set in PongStart.
		ld r24, Z+
		ld r25, Z+
		ld r26, Z+
		call PongLoadBallPosition	;Loads the ball position into r19-r22
		sub r23,r21
		cpc r24,r22
		BRGE PongLowerLimitExceeded
		sub r21,r25
		cpc r22,r26
		BRGE PongUpperLimitExceeded
		rjmp PongCheckBallLimitsEnd
	
	PongLowerLimitExceeded:
		ldi ZL,$10
		ldi ZH,$02
		ld r21, Z+	;read in min allowed y position of ball from memory. Set in PongStart.
		ld r22, Z+
		call PongSetBallPosition ;set ball position to on the boundary
		ldi ZL,$09
		ldi ZL,$02
		ldi r16,$FF
		st Z,r16
		rjmp PongCheckBallLimitsEnd
		
	PongUpperLimitExceeded:
		ldi ZL,$12
		ldi ZH,$02
		ld r21, Z+	;read in min allowed y position of ball from memory. Set in PongStart.
		ld r22, Z+
		call PongSetBallPosition ;set ball position to on the boundary
		ldi ZL,$09
		ldi ZL,$02
		ldi r16,$00
		st Z,r16
		rjmp PongCheckBallLimitsEnd
		
	PongCheckBallLimitsEnd:
		pop ZH
		pop ZL
		pop r26
		pop r25
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r16
		ret


PongLoadPlayer1Position:		;loads player1 position into r23/r24
		push ZL
		push ZH
		ldi ZL, $00
		ldi ZH, $02
		ld r23,Z+	;load the position of player 1's cursor.
		ld r24,Z+	
		pop ZH
		pop ZL
		ret
		
PongLoadPlayer2Position:		;loads player2 position into r23/r24
		push ZL
		push ZH
		ldi ZL, $02
		ldi ZH, $02
		ld r23,Z+	;load the position of player 2's cursor.
		ld r24,Z+	
		pop ZH
		pop ZL
		ret
		
PongLoadBallPosition:	;Loads the ball position into r19-r22
		push ZL
		push ZH
		
		ldi ZL,$04
		ldi ZH,$02
		ld r19, Z+
		ld r20, Z+
		ld r21, Z+
		ld r22, Z+
		
		pop ZH
		pop ZL
		ret
		
PongLoadBallScreenPosition:	;Loads the ball's displayed position into r19-r22
		push ZL
		push ZH
		
		ldi ZL,$04
		ldi ZH,$02
		ld r19, Z+
		ld r20, Z+
		ld r21, Z+
		ld r22, Z+
		lsr r22
		ror r21 
		
		pop ZH
		pop ZL
		ret
		
PongSetBallPosition:	;Sets the ball position from r19-r22 to memory.
		push ZL
		push ZH
		
		ldi ZL,$04
		ldi ZH,$02
		st Z+, r19
		st Z+, r20
		st Z+, r21
		st Z+, r22
		
		pop ZH
		pop ZL
		ret
	
PongWinTest:
		push r17
		push r19
		push r20
		push r21
		push r22
		push r23
		push r24
		
		;has player1 won?		
		call PongLoadBallScreenPosition		;Loads the ball position into r19-r22
		ldi r23, $f3
		ldi r24, $02						;Loads Right edge of game region into r23,r24
		
		sub r23,r19
		cpc r24,r20
		BRLT PongPlayer2DeflectTest 		;if ball position > right edge, do deflection test.
		
		;has player2 won?	
		ldi r23, 45
		ldi r24, 0
		
		sub r19,r23							;Loads Left edge of game region into r23,r24
		cpc r20,r24
		BRLT PongPlayer1DeflectTest			;If ball position < left edge, do deflection test.
		
		rjmp PongWinTestEnd					;if neither edges being tested, leave.
		
	PongPlayer2DeflectTest:
		call PongLoadBallScreenPosition
		call PongLoadPlayer2Position	;Loads player2 position into r23/r24
		mov YL,r23
		mov YH,r24
		adiw Y,25
		sub YL,r21
		sbc YH,r22
		BRLT PongPlayer2LoseJmp	;if the ball position is greater than the baton position + spacing, then player 2 has lost
		mov YL,r23
		mov YH,r24
		sbiw Y,25
		sub r21,YL
		cpc r22,YH
		BRLT PongPlayer2LoseJmp
		rjmp PongPlayer2Deflect

	PongPlayer2LoseJmp:
		rjmp PongPlayer2Lose
		
	PongPlayer1DeflectTest:
		call PongLoadBallScreenPosition
		call PongLoadPlayer1Position	;Loads player2 position into r23/r24
		mov YL,r23
		mov YH,r24
		adiw Y,25
		sub YL,r21
		sbc YH,r22
		BRLT PongPlayer1Lose	;if the ball position is greater than the baton position + spacing, then player 2 has lost
		mov YL,r23
		mov YH,r24
		sbiw Y,25
		sub r21,YL
		cpc r22,YH
		BRLT PongPlayer1Lose
		rjmp PongPlayer1Deflect
		
	PongPlayer1Deflect:
		ldi YL,$0A
		ldi YH,$02
		ldi r17,$ff
		st Y,r17
		call PongLoadBallScreenPosition ;Loads Ball position into r19-r22
		call PongLoadPlayer1Position	;Loads player1 position into r23/r24
		sub r23,r21
		cpc r24,r22
		BRGE PongPlayerDeflectN 		;If player position is larger than ball position, then new velocity is negative (Up)...
		rjmp PongPlayerDeflectP			;...else new velocity is positive (Down).
		
	PongPlayer2Deflect:
		ldi YL,$0A
		ldi YH,$02
		ldi r17,$00
		st Y,r17
		call PongLoadBallScreenPosition ;Loads Ball position into r19-r22
		call PongLoadPlayer2Position	;Loads player2 position into r23/r24
		sub r23,r21
		cpc r24,r22
		BRGE PongPlayerDeflectN 		;If player position is larger than ball position, then new velocity is negative (Up)...
		rjmp PongPlayerDeflectP	
		
	  PongPlayerDeflectP:				;...else new velocity is positive (Down).
		neg r23
		ldi YL,$08
		ldi YH,$02
		st Y+,r23	;set speed to difference in positions
		ldi r17,$FF	
		st Y+,r17	;set direction to Down
		rjmp PongWinTestEnd
		
	  PongPlayerDeflectN:				;Player position is larger than ball position, then new velocity is negative...
		ldi YL,$08
		ldi YH,$02
		st Y+,r23	;set speed to difference in positions
		ldi r17,$00	
		st Y+,r17	;set direction to Up
		rjmp PongWinTestEnd
	
	PongPlayer1Lose: ;increment player2 score, and reset
		ldi YL,$15
		ldi YH,$02
		ld r17,Y
		inc r17
		st Y,r17
		cpi r17,3
		BREQ PongPlayer1GameLose
		
		call PongRoundDefeat
		call PongNewRound
		rjmp PongWinTestEnd
		
	  PongPlayer1GameLose:	
		call PongGameDefeat
		call PongResetScores
		call PongNewRound
		rjmp PongWinTestEnd
		
	PongPlayer2Lose: ;increment player1 score and reset
		ldi YL,$14
		ldi YH,$02
		ld r17,Y
		inc r17
		st Y,r17
		cpi r17,3
		BREQ PongPlayer2GameLose
		
		call PongRoundVictory
		call PongNewRound
		rjmp PongWinTestEnd
		
	  PongPlayer2GameLose:
		call PongGameVictory
		call PongResetScores
		call PongNewRound
		rjmp PongWinTestEnd
		
	PongWinTestEnd:
		pop YH
		pop YL
		pop r24
		pop r23
		pop r22
		pop r21
		pop r20
		pop r19
		pop r17
		ret
	
PongRoundDefeat:
		ret
PongRoundVictory:
		ret
PongGameDefeat:
		ret
PongGameVictory:
		ret
	
	
	
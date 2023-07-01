;********************   DELAY ROUTINES ********************************************
BigDEL:
             rcall Del49ms
             rcall Del49ms
             rcall Del49ms
             rcall Del49ms
             rcall Del49ms
             ret
;
DEL15ms:
;
; This is a 15 msec delay routine. Each cycle costs
; rcall           -> 3 CC
; ret              -> 4 CC
; 2*LDI        -> 2 CC 
; SBIW         -> 2 CC * 19997
; BRNE        -> 1/2 CC * 19997
; 

            LDI XH, HIGH(19997)
            LDI XL, LOW (19997)
	COUNT:  
            SBIW XL, 1
            BRNE COUNT
            RET
;
DEL4P1ms:
            LDI XH, HIGH(5464)
            LDI XL, LOW (5464)
	COUNT1:
            SBIW XL, 1
            BRNE COUNT1
            RET 
;
DEL100mus:
            LDI XH, HIGH(131)
            LDI XL, LOW (131)
	COUNT2:
            SBIW XL, 1
            BRNE COUNT2
            RET 
;
DEL49ms:
            LDI XH, HIGH(65535)
            LDI XL, LOW (65535)
	COUNT3:
            SBIW XL, 1
            BRNE COUNT3
            RET 

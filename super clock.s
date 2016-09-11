;------------------------------------------------------------------------------
;  File Description      :  Assembly code for LAB33.
;
;------------------------------------------------------------------------------
  .equ __33fj12GP202, 1
  .include "p33FJ12GP202.inc"
__FOSCSEL: .pword FNOSC_FRC 
__FOSC:    .pword OSCIOFNC_ON
;------------------------------------------------------------------------------
; Global Declarations:
;------------------------------------------------------------------------------
.global __reset                   ; The label for the first line of code. 
.global __T1Interrupt    ;Declare Timer 1 ISR name global
.global __INT0Interrupt    ;Declare INTERRUPT 0 ISR name global
.global __INT1Interrupt    ;Declare INTERRUPT 1 ISR name global
.global __INT2Interrupt    ;Declare INTERRUPT 2 ISR name global
.global _wreg_init  ;Provide global scope to _wreg_init routine In order to call
; this routine from a C file,place "wreg_init" in an "extern" declaration in the C file.
.global _main    ;The label for the first line of code. If the assembler 
        ;encounters "_main", it invokes the start-up code that initializes data sections

 .section .xdata, "d"

SEG15:	.SPACE 2
SEG14:	.SPACE 2
SEG13:	.SPACE 2
SEG12:	.SPACE 2
SEG11:	.SPACE 2
SEG10:	.SPACE 2
COUNT:	.SPACE 2
MIN:		.SPACE 2
HOUER:	.SPACE 2
SEC:		.SPACE 2
ALARMMIN:	.SPACE 2
ALARMHOUER:	.SPACE 2

;------------------------------------------------------------------------------
; Start of Code Section in Program Memory
;------------------------------------------------------------------------------
.text
__reset:
        MOV     #__SP_init, W15     ; Initalize the Stack Pointer
        MOV     #__SPLIM_init, W0   ; Initialize the Stack Pointer Limit Register
        MOV     W0, SPLIM
        NOP                         ; Add NOP to follow SPLIM initialization

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
	CLR		TRISB
	CLR		TRISA
	BSET		TRISB,#7
	BSET		TRISA,#0
	BSET		TRISA,#1
	BSET		TRISA,#2
	BSET		TRISB,#8
	MOV		#0XFFFF,W0
	MOV		W0,AD1PCFGL
	MOV		#0b0111110000000000,W0
	MOV		W0,PORTB
	CLR		PORTA
;-----------------------------------------------------------------------------
	CLR		COUNT
	CLR		MIN
	CLR		HOUER
	CLR		SEC

	MOV		#0X003F,W0
	MOV		W0,SEG15
	MOV		W0,SEG14
	MOV		W0,SEG13
	MOV		W0,SEG12
	MOV		W0,SEG11
	MOV		W0,SEG10

	MOV		#5,W0
	MOV		W0,ALARMHOUER
	CLR		ALARMMIN
;-----------------------------------------------------------------------------
	CLR 		INTCON1

	MOV		#0X0001,W0	
	MOV		W0,INTCON2

	CLR		IFS0
	CLR		IFS1

	MOV		#0X0008,W0
	MOV		W0,IEC0

	MOV		#0X7000,W0	
	MOV		W0,IPC0

	MOV		#3685,W0
	MOV		W0,PR1

	CLR		TMR1
	
	MOV		#0x8000,W0
	MOV		W0,T1CON
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
MAIN:
	BTSC		PORTB,#7
	BRA		SUIT
	DO		#50,ZZ
	REPEAT	#16000
ZZ:	NOP

	BSET		PORTA,#3
	CLR		ALARMMIN
	CLR		ALARMHOUER

QQ:	BTSC		PORTA,#2
	BRA		WW
	DO		#50,YY
	REPEAT	#16000
YY:	NOP
	INC		ALARMHOUER

WW:	BTSC		PORTB,#8
	BRA		VP
	DO		#50,XX
	REPEAT	#16000
XX:	NOP
	INC		ALARMMIN

VP:	BTSC		PORTB,#7
	BRA		QQ
	DO		#50,UU
	REPEAT	#16000
UU:	NOP
	BCLR		PORTA,#3

SUIT:	MOV		HOUER, W0
	XOR		ALARMHOUER, WREG
	BTSS		SR,#Z
	BRA		FIN
	MOV		MIN, W0
	XOR		ALARMMIN, WREG
	BTSS		SR,#Z
	BRA		FIN
	BSET 		PORTA,#4
	GOTO		MAIN
FIN:
	BCLR		PORTA,#4
	GOTO		MAIN
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
__T1Interrupt:

	BCLR 		IFS0, #T1IF  

S0:	BTSC		PORTB,#15
	BRA		S1
	MOV		#0XFF80,W0
	IOR		SEG14
	BCLR		SEG14,#14
	MOV 		SEG14,W0
	MOV		W0,PORTB
	BRA		TOTO

S1:	BTSC		PORTB,#14
	BRA		S2
	MOV		#0XFF80,W0
	IOR		SEG13
	BCLR		SEG13,#13
	MOV 		SEG13,W0
	MOV		W0,PORTB
	BRA		TOTO

S2:	BTSC		PORTB,#13
	BRA		S3
	MOV		#0XFF80,W0
	IOR		SEG12
	BCLR		SEG12,#12
	MOV 		SEG12,W0
	MOV		W0,PORTB
	BRA		TOTO

S3:	BTSC		PORTB,#12
	BRA		S4
	MOV		#0XFF80,W0
	IOR		SEG11
	BCLR		SEG11,#11
	MOV 		SEG11,W0
	MOV		W0,PORTB
	BRA		TOTO

S4:	BTSC		PORTB,#11
	BRA		S5
	MOV		#0XFF80,W0
	IOR		SEG10
	BCLR		SEG10,#10
	MOV 		SEG10,W0
	MOV		W0,PORTB
	BRA		TOTO

S5:	MOV		#0XFF80,W0
	IOR		SEG15
	BCLR		SEG15,#15
	MOV 		SEG15,W0
	MOV		W0,PORTB
	
TOTO:
	BTSC		PORTA,#0
	BRA		AA
	DO		#50,AG
	REPEAT	#16000
AG:	NOP
	BRA		HPL

AA:	BTSC		PORTA,#1
	BRA		BB
	DO		#50,AH
	REPEAT	#16000
AH:	NOP
	BRA		MPL
	
BB:	INC		COUNT
	MOV		#1000,W0
	XOR		COUNT,WREG
	BTSS		SR,#Z
	RETFIE
	CLR		COUNT

	INC		SEC
	MOV		#60,W0
	XOR		SEC,WREG
	BTSS		SR,#Z		 
	BRA		AFFICHAGE

	CLR		SEC
MPL:	INC		MIN
	MOV		#60,W0
	XOR		MIN,WREG
	BTSS		SR,#Z		 
	BRA		AFFICHAGE

	CLR		MIN
HPL:	INC		HOUER
	MOV		#25,W0
	XOR		HOUER,WREG
	BTSS		SR,#Z		 
	BRA		AFFICHAGE
	CLR		HOUER

AFFICHAGE:
	MOV 		SEC,W0
	CALL		BINBCD
	MOV		W0,W7
	MOV		#0X000F,W1
	AND.W		W0,W1,W0
	CALL		BCD7S
	MOV		W0,SEG10
	MOV		W7,W0
	SWAP.B	W0
	MOV		#0X000F,W1
	AND.W		W0,W1,W0
	CALL		BCD7S
	MOV		W0,SEG11

	MOV 		MIN,W0
	CALL		BINBCD
	MOV		W0,W7
	MOV		#0X000F,W1
	AND.W		W0,W1,W0
	CALL		BCD7S
	MOV		W0,SEG12
	MOV		W7,W0
	SWAP.B	W0
	MOV		#0X000F,W1
	AND.W		W0,W1,W0
	CALL		BCD7S
	MOV		W0,SEG13

	MOV 		HOUER,W0
	CALL		BINBCD
	MOV		W0,W7
	MOV		#0X000F,W1
	AND.W		W0,W1,W0
	CALL		BCD7S
	MOV		W0,SEG14
	MOV		W7,W0
	SWAP.B	W0
	MOV		#0X000F,W1
	AND.W		W0,W1,W0
	CALL		BCD7S
	MOV		W0,SEG15

	RETFIE

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------

BINBCD:
; Set TBLPAG to the page that contains the BINBCDT
		MOV 	#tblpage(BINBCDT), w1
		MOV 	w1, _TBLPAG
; Make a pointer to BINBCDT for table instructions
		MOV 	#tbloffset(BINBCDT), w1
		BCLR	SR,#C			; CLEAR CARRY BIT
		RLC		W0,W0			; MULTIPLY BY 2
		ADD		W0,W1,W0
; Load the first data value
		TBLRDL 	[w0], w0
		RETURN
BCD7S:
; Set TBLPAG to the page that contains the BCD7ST
		MOV 	#tblpage(BCD7ST), w1
		MOV 	w1, _TBLPAG
; Make a pointer to BCD7ST for table instructions
		MOV 	#tbloffset(BCD7ST), w1
		BCLR	SR,#C			; CLEAR CARRY BIT
		RLC		W0,W0			; MULTIPLY BY 2
		ADD		W0,W1,W0
; Load the first data value
		TBLRDL 	[w0], w0
		RETURN
;--------End of All Code Sections ---------------------------------------------
;----------  TABLES
;;;;;;;  BINARY TO BCD TABLE (0 TO 59) 
BINBCDT:
.word 0x0000,0x0001,0x0002,0x0003,0x0004,0x0005,0x0006,0x0007,0x0008,0x0009 
.word 0x0010,0x0011,0x0012,0x0013,0x0014,0x0015,0x0016,0x0017,0x0018,0x0019 
.word 0x0020,0x0021,0x0022,0x0023,0x0024,0x0025,0x0026,0x0027,0x0028,0x0029 
.word 0x0030,0x0031,0x0032,0x0033,0x0034,0x0035,0x0036,0x0037,0x0038,0x0039 
.word 0x0040,0x0041,0x0042,0x0043,0x0044,0x0045,0x0046,0x0047,0x0048,0x0049 
.word 0x0050,0x0051,0x0052,0x0053,0x0054,0x0055,0x0056,0x0057,0x0058,0x0059 
;;;;;;;  BCD TO 7 SEGMENT DISPLAY TABLE (0 TO 15) 
BCD7ST: ; NEW
.word 0x003F,0x0006,0x005B,0x004F,0x0066,0x006D,0x007D,0x0007
.word 0x007F,0x006F,0x0077,0x007C,0x0058,0x005E,0x0079,0x0071

;;;;;;;;;;;;;;;;;;;;INTERRUPT 0 Interrupt Service Routine
__INT0Interrupt:
       	
	BCLR 		IFS0, #INT0IF           ;Clear the INT0 Interrupt flag Status

	RETFIE 	
;-------- End of All Code Sections --------------------------------------------

.end 
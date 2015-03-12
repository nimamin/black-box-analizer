
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2143
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _Imask=R4
	.DEF _Omask=R6
	.DEF _Lines=R8
	.DEF _Columns=R10
	.DEF _D=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _uartRecieve
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x6A:
	.DB  0xFF,0x0,0xFF,0x0,0x0,0x0,0x8,0x0
	.DB  0x2,0x0
_0x0:
	.DB  0xD,0x49,0x6E,0x70,0x75,0x74,0x20,0x4D
	.DB  0x61,0x73,0x6B,0x20,0x3D,0x20,0x30,0x58
	.DB  0x25,0x30,0x33,0x58,0xD,0x45,0x6E,0x74
	.DB  0x65,0x72,0x20,0x6E,0x65,0x77,0x20,0x56
	.DB  0x61,0x6C,0x75,0x65,0x3A,0x0,0xD,0x4F
	.DB  0x75,0x74,0x70,0x75,0x74,0x20,0x4D,0x61
	.DB  0x73,0x6B,0x20,0x3D,0x20,0x30,0x58,0x25
	.DB  0x30,0x33,0x58,0xD,0x45,0x6E,0x74,0x65
	.DB  0x72,0x20,0x6E,0x65,0x77,0x20,0x56,0x61
	.DB  0x6C,0x75,0x65,0x3A,0x0,0xD,0x43,0x6F
	.DB  0x6C,0x75,0x6D,0x6E,0x73,0x20,0x3D,0x20
	.DB  0x25,0x64,0xD,0x45,0x6E,0x74,0x65,0x72
	.DB  0x20,0x6E,0x65,0x77,0x20,0x56,0x61,0x6C
	.DB  0x75,0x65,0x3A,0x0,0xD,0x44,0x65,0x6C
	.DB  0x61,0x79,0x20,0x54,0x69,0x6D,0x65,0x72
	.DB  0x20,0x4D,0x6F,0x64,0x65,0x20,0x3D,0x20
	.DB  0x25,0x64,0x20,0x77,0x69,0x74,0x63,0x68
	.DB  0x20,0x6D,0x65,0x61,0x6E,0x73,0x20,0x25
	.DB  0x64,0x20,0x6D,0x69,0x63,0x72,0x6F,0x20
	.DB  0x73,0x65,0x63,0x6F,0x75,0x6E,0x64,0x2E
	.DB  0x0,0xD,0x44,0x65,0x6C,0x61,0x79,0x20
	.DB  0x54,0x69,0x6D,0x65,0x72,0x20,0x4D,0x6F
	.DB  0x64,0x65,0x20,0x3D,0x20,0x25,0x64,0x20
	.DB  0x77,0x69,0x74,0x63,0x68,0x20,0x6D,0x65
	.DB  0x61,0x6E,0x73,0x20,0x25,0x64,0x20,0x6D
	.DB  0x69,0x6C,0x69,0x20,0x73,0x65,0x63,0x6F
	.DB  0x75,0x6E,0x64,0x2E,0x0,0xD,0x52,0x65
	.DB  0x73,0x65,0x74,0xD,0x0,0xD,0x49,0x6E
	.DB  0x70,0x75,0x74,0x20,0x4D,0x61,0x73,0x6B
	.DB  0x20,0x3D,0x20,0x30,0x58,0x25,0x30,0x33
	.DB  0x58,0x2C,0x0,0x9,0x4F,0x75,0x74,0x70
	.DB  0x75,0x74,0x20,0x4D,0x61,0x73,0x6B,0x20
	.DB  0x3D,0x20,0x30,0x58,0x25,0x30,0x33,0x58
	.DB  0x2C,0x0,0x9,0x43,0x6F,0x6C,0x75,0x6D
	.DB  0x6E,0x73,0x20,0x3D,0x20,0x25,0x64,0x2E
	.DB  0x0,0xD,0x49,0x6E,0x70,0x75,0x74,0x20
	.DB  0x50,0x69,0x6E,0x73,0x20,0x43,0x6F,0x75
	.DB  0x6E,0x74,0x20,0x3D,0x20,0x25,0x64,0x2C
	.DB  0x0,0x9,0x4F,0x75,0x74,0x70,0x75,0x74
	.DB  0x20,0x50,0x69,0x6E,0x73,0x20,0x43,0x6F
	.DB  0x75,0x6E,0x74,0x20,0x3D,0x20,0x25,0x64
	.DB  0x2C,0x0,0x9,0x4C,0x69,0x6E,0x65,0x73
	.DB  0x20,0x43,0x6F,0x75,0x6E,0x74,0x20,0x3D
	.DB  0x20,0x25,0x64,0x2E,0xD,0x0,0xD,0x50
	.DB  0x72,0x65,0x73,0x73,0x20,0x69,0x20,0x66
	.DB  0x6F,0x72,0x20,0x49,0x6E,0x70,0x75,0x74
	.DB  0x20,0x4D,0x61,0x73,0x6B,0x2C,0x0,0x20
	.DB  0x71,0x20,0x66,0x6F,0x72,0x20,0x6F,0x75
	.DB  0x74,0x70,0x75,0x74,0x20,0x4D,0x61,0x73
	.DB  0x6B,0x2C,0x0,0xD,0x63,0x20,0x66,0x6F
	.DB  0x72,0x20,0x43,0x6F,0x6C,0x75,0x6D,0x6E
	.DB  0x73,0x2C,0x0,0x20,0x64,0x20,0x66,0x6F
	.DB  0x72,0x20,0x44,0x65,0x6C,0x61,0x79,0x2C
	.DB  0x0,0x20,0x61,0x6E,0x64,0x20,0x67,0x20
	.DB  0x66,0x6F,0x72,0x20,0x53,0x63,0x61,0x6E
	.DB  0x2E,0x0,0xD,0xD,0x3E,0x0,0x8,0x20
	.DB  0x8,0x0,0xD,0x56,0x61,0x6C,0x75,0x65
	.DB  0x20,0x6D,0x75,0x73,0x74,0x20,0x62,0x65
	.DB  0x20,0x6C,0x65,0x73,0x73,0x20,0x74,0x68
	.DB  0x61,0x6E,0x20,0x30,0x78,0x46,0x46,0x46
	.DB  0x2E,0x0,0xD,0x4F,0x75,0x74,0x70,0x75
	.DB  0x74,0x20,0x4D,0x61,0x73,0x6B,0x20,0x3D
	.DB  0x20,0x30,0x58,0x25,0x30,0x33,0x58,0xD
	.DB  0x0,0xD,0x49,0x6E,0x70,0x75,0x74,0x20
	.DB  0x4D,0x61,0x73,0x6B,0x20,0x3D,0x20,0x30
	.DB  0x58,0x25,0x30,0x33,0x58,0xD,0x0,0xD
	.DB  0x45,0x72,0x72,0x6F,0x72,0x20,0x49,0x6E
	.DB  0x70,0x75,0x74,0x20,0x4F,0x75,0x74,0x70
	.DB  0x75,0x74,0x20,0x6D,0x61,0x73,0x6B,0x73
	.DB  0x2E,0x20,0x4F,0x75,0x74,0x70,0x75,0x74
	.DB  0x20,0x4D,0x61,0x73,0x6B,0x20,0x3D,0x20
	.DB  0x30,0x58,0x25,0x30,0x33,0x58,0xD,0x0
	.DB  0x43,0x6F,0x6C,0x75,0x6D,0x6E,0x73,0x20
	.DB  0x3D,0x20,0x25,0x64,0xD,0x0,0x44,0x65
	.DB  0x6C,0x61,0x79,0x20,0x54,0x69,0x6D,0x65
	.DB  0x72,0x20,0x4D,0x6F,0x64,0x65,0x20,0x3D
	.DB  0x20,0x25,0x64,0x20,0x77,0x69,0x74,0x63
	.DB  0x68,0x20,0x6D,0x65,0x61,0x6E,0x73,0x20
	.DB  0x25,0x64,0x20,0x6D,0x69,0x63,0x72,0x6F
	.DB  0x20,0x73,0x65,0x63,0x6F,0x75,0x6E,0x64
	.DB  0x2E,0xD,0x0,0x44,0x65,0x6C,0x61,0x79
	.DB  0x20,0x54,0x69,0x6D,0x65,0x72,0x20,0x4D
	.DB  0x6F,0x64,0x65,0x20,0x3D,0x20,0x25,0x64
	.DB  0x20,0x77,0x69,0x74,0x63,0x68,0x20,0x6D
	.DB  0x65,0x61,0x6E,0x73,0x20,0x25,0x64,0x20
	.DB  0x6D,0x69,0x6C,0x69,0x20,0x73,0x65,0x63
	.DB  0x6F,0x75,0x6E,0x64,0x2E,0xD,0x0,0x49
	.DB  0x3A,0x25,0x64,0x9,0x51,0x3A,0x25,0x64
	.DB  0x9,0x43,0x3A,0x25,0x64,0xD,0x0,0x49
	.DB  0x6E,0x20,0x6D,0x61,0x73,0x6B,0x3A,0x25
	.DB  0x30,0x33,0x58,0x9,0x4F,0x75,0x74,0x20
	.DB  0x6D,0x61,0x73,0x6B,0x3A,0x25,0x30,0x33
	.DB  0x58,0xD,0x0,0x25,0x30,0x33,0x58,0x3A
	.DB  0x9,0x0,0x25,0x30,0x32,0x58,0x9,0x0
	.DB  0xD,0xD,0x54,0x68,0x65,0x20,0x50,0x45
	.DB  0x45,0x4C,0x20,0x53,0x63,0x61,0x6E,0x65
	.DB  0x72,0x20,0x50,0x72,0x6F,0x67,0x72,0x61
	.DB  0x6D,0x20,0x73,0x74,0x61,0x72,0x74,0x65
	.DB  0x64,0x2E,0x0,0xD,0x50,0x72,0x65,0x73
	.DB  0x73,0x20,0x47,0x20,0x66,0x6F,0x72,0x20
	.DB  0x53,0x63,0x61,0x6E,0x20,0x74,0x68,0x65
	.DB  0x20,0x50,0x45,0x45,0x4C,0x20,0x63,0x68
	.DB  0x69,0x70,0x2E,0xD,0x50,0x72,0x65,0x73
	.DB  0x73,0x20,0x3F,0x20,0x66,0x6F,0x72,0x20
	.DB  0x6D,0x6F,0x72,0x65,0x20,0x68,0x65,0x6C
	.DB  0x70,0x2E,0xD,0xD,0x3E,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  _0x6A*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include "micro.h"
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include <stdlib.h>
;#include <delay.h>
;
;int Imask = 0XFF;	// Input mask register
;int Omask = 0XFF;	// Output mask register
;int Icount;			// input pins count
;int Ocount;			// output pins count
;int Is[20];			// arrey of input pins
;int Os[20];			// arrey of output pins
;int Lines;			// lines count of the file
;int Columns = 8;	// columns count of the file
;int D = 2;			// cycle delay code nomber
;bool GoCommand = false;		// a public flag indicating the user's start request signal.
;
;//-------------------------------------------------------------------------------------------------
;//
;// Calcute the parameters(Icount, Ocount, Is[], Os[], Lines) from Imask and Omask.
;//
;//-----------------
;void generatePrameters()
; 0000 0018 {

	.CSEG
_generatePrameters:
; 0000 0019 	int i;
; 0000 001A 
; 0000 001B 	Icount = 0;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	LDI  R30,LOW(0)
	STS  _Icount,R30
	STS  _Icount+1,R30
; 0000 001C 	for (i = 0; i < 20; i++)
	__GETWRN 16,17,0
_0x4:
	__CPWRN 16,17,20
	BRGE _0x5
; 0000 001D 	{
; 0000 001E 		if ((1 << i) & Imask)
	CALL SUBOPT_0x0
	AND  R30,R4
	AND  R31,R5
	SBIW R30,0
	BREQ _0x6
; 0000 001F 		{
; 0000 0020 			Is[Icount++] = 1 << i;
	LDI  R26,LOW(_Icount)
	LDI  R27,HIGH(_Icount)
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0x0
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
; 0000 0021 		}
; 0000 0022 	}
_0x6:
	__ADDWRN 16,17,1
	RJMP _0x4
_0x5:
; 0000 0023 	for (i = Icount; i < 20; i++) Is[i] = 0;
	__GETWRMN 16,17,0,_Icount
_0x8:
	__CPWRN 16,17,20
	BRGE _0x9
	MOVW R30,R16
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
	__ADDWRN 16,17,1
	RJMP _0x8
_0x9:
; 0000 0025 Ocount = 0;
	LDI  R30,LOW(0)
	STS  _Ocount,R30
	STS  _Ocount+1,R30
; 0000 0026 	for (i = 0; i < 8; i++)
	__GETWRN 16,17,0
_0xB:
	__CPWRN 16,17,8
	BRGE _0xC
; 0000 0027 	{
; 0000 0028 		if ((1 << i) & Omask)
	CALL SUBOPT_0x0
	AND  R30,R6
	AND  R31,R7
	SBIW R30,0
	BREQ _0xD
; 0000 0029 		{
; 0000 002A 			Os[Ocount++] = 1 << i;
	LDI  R26,LOW(_Ocount)
	LDI  R27,HIGH(_Ocount)
	CALL SUBOPT_0x1
	LDI  R26,LOW(_Os)
	LDI  R27,HIGH(_Os)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0x0
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
; 0000 002B 		}
; 0000 002C 	}
_0xD:
	__ADDWRN 16,17,1
	RJMP _0xB
_0xC:
; 0000 002D 	for (i = Ocount; i < 20; i++) Os[i] = 0;
	__GETWRMN 16,17,0,_Ocount
_0xF:
	__CPWRN 16,17,20
	BRGE _0x10
	MOVW R30,R16
	LDI  R26,LOW(_Os)
	LDI  R27,HIGH(_Os)
	LSL  R30
	ROL  R31
	CALL SUBOPT_0x3
	__ADDWRN 16,17,1
	RJMP _0xF
_0x10:
; 0000 002F Lines = 1 << (Icount - 1);
	CALL SUBOPT_0x4
	SBIW R30,1
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	MOVW R8,R30
; 0000 0030 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;//-------------------------------------------------------------------------------------------------
;//
;// Interrup vactor for uart recieve interrupt.
;//
;//-----------------
;interrupt [USART_RXC] void uartRecieve(void)
; 0000 0039 {
_uartRecieve:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 003A 	static int state = 0;
; 0000 003B 	static int data;
; 0000 003C 	char newchar;
; 0000 003D 	static int ec = 0;
; 0000 003E 
; 0000 003F 	cli();
	ST   -Y,R17
;	newchar -> R17
	cli
; 0000 0040 	newchar = UDR;
	IN   R17,12
; 0000 0041 	LED_turn(1, on);
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
; 0000 0042 
; 0000 0043 	switch (state)
	LDS  R30,_state_S0000001000
	LDS  R31,_state_S0000001000+1
; 0000 0044 	{
; 0000 0045 		case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x14
; 0000 0046 			data = 0;
	LDI  R30,LOW(0)
	STS  _data_S0000001000,R30
	STS  _data_S0000001000+1,R30
; 0000 0047 			ec = 0;
	STS  _ec_S0000001000,R30
	STS  _ec_S0000001000+1,R30
; 0000 0048 			switch (newchar)
	MOV  R30,R17
	LDI  R31,0
; 0000 0049 			{
; 0000 004A 				case 'I':
	CPI  R30,LOW(0x49)
	LDI  R26,HIGH(0x49)
	CPC  R31,R26
	BREQ _0x19
; 0000 004B 				case 'i':
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x1A
_0x19:
; 0000 004C 					state = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x7
; 0000 004D 					printf("\rInput Mask = 0X%03X\rEnter new Value:", Imask);
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x8
; 0000 004E 					break;
	RJMP _0x17
; 0000 004F 				case 'Q':
_0x1A:
	CPI  R30,LOW(0x51)
	LDI  R26,HIGH(0x51)
	CPC  R31,R26
	BREQ _0x1C
; 0000 0050 				case 'q':
	CPI  R30,LOW(0x71)
	LDI  R26,HIGH(0x71)
	CPC  R31,R26
	BRNE _0x1D
_0x1C:
; 0000 0051 				case 'o':
	RJMP _0x1E
_0x1D:
	CPI  R30,LOW(0x6F)
	LDI  R26,HIGH(0x6F)
	CPC  R31,R26
	BRNE _0x1F
_0x1E:
; 0000 0052 				case 'O':
	RJMP _0x20
_0x1F:
	CPI  R30,LOW(0x4F)
	LDI  R26,HIGH(0x4F)
	CPC  R31,R26
	BRNE _0x21
_0x20:
; 0000 0053 					state = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x7
; 0000 0054 					printf("\rOutput Mask = 0X%03X\rEnter new Value:", Omask);
	__POINTW1FN _0x0,38
	CALL SUBOPT_0x9
; 0000 0055 					break;
	RJMP _0x17
; 0000 0056 				case 'C':
_0x21:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BREQ _0x23
; 0000 0057 				case 'c':
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x24
_0x23:
; 0000 0058 					state = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x7
; 0000 0059 					printf("\rColumns = %d\rEnter new Value:", Columns);
	__POINTW1FN _0x0,77
	CALL SUBOPT_0xA
; 0000 005A 					break;
	RJMP _0x17
; 0000 005B 				case 'D':
_0x24:
	CPI  R30,LOW(0x44)
	LDI  R26,HIGH(0x44)
	CPC  R31,R26
	BREQ _0x26
; 0000 005C 				case 'd':
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRNE _0x27
_0x26:
; 0000 005D 					state = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x7
; 0000 005E 					if (D < 6) printf("\rDelay Timer Mode = %d witch means %d micro secound.", D, delayTime(D));
	CALL SUBOPT_0xB
	BRGE _0x28
	__POINTW1FN _0x0,108
	RJMP _0x65
; 0000 005F 					else printf("\rDelay Timer Mode = %d witch means %d mili secound.", D, delayTime(D));
_0x28:
	__POINTW1FN _0x0,161
_0x65:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xC
; 0000 0060 					printf("\rEnter new Value:");
	__POINTW1FN _0x0,20
	RJMP _0x66
; 0000 0061 					break;
; 0000 0062 				case 'R':
_0x27:
	CPI  R30,LOW(0x52)
	LDI  R26,HIGH(0x52)
	CPC  R31,R26
	BREQ _0x2B
; 0000 0063 				case 'r':
	CPI  R30,LOW(0x72)
	LDI  R26,HIGH(0x72)
	CPC  R31,R26
	BRNE _0x2C
_0x2B:
; 0000 0064 					Imask = 0XFF;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	MOVW R4,R30
; 0000 0065 					Omask = 0XFF;
	MOVW R6,R30
; 0000 0066 					Columns = 8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	MOVW R10,R30
; 0000 0067 					printf("\rReset\r");
	__POINTW1FN _0x0,213
	RJMP _0x66
; 0000 0068 					break;
; 0000 0069 				case '/':
_0x2C:
	CPI  R30,LOW(0x2F)
	LDI  R26,HIGH(0x2F)
	CPC  R31,R26
	BREQ _0x2E
; 0000 006A 				case '?':
	CPI  R30,LOW(0x3F)
	LDI  R26,HIGH(0x3F)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2F
_0x2E:
; 0000 006B 					printf("\rInput Mask = 0X%03X,", Imask);
	__POINTW1FN _0x0,221
	CALL SUBOPT_0x8
; 0000 006C 					printf("\tOutput Mask = 0X%03X,", Omask);
	__POINTW1FN _0x0,243
	CALL SUBOPT_0x9
; 0000 006D 					printf("\tColumns = %d.", Columns);
	__POINTW1FN _0x0,266
	CALL SUBOPT_0xA
; 0000 006E 					if (D < 6) printf("\rDelay Timer Mode = %d witch means %d micro secound.", D, delayTime(D));
	CALL SUBOPT_0xB
	BRGE _0x30
	__POINTW1FN _0x0,108
	RJMP _0x67
; 0000 006F 					else printf("\rDelay Timer Mode = %d witch means %d mili secound.", D, delayTime(D));
_0x30:
	__POINTW1FN _0x0,161
_0x67:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xC
; 0000 0070 					generatePrameters();
	RCALL _generatePrameters
; 0000 0071 					printf("\rInput Pins Count = %d,", Icount);
	__POINTW1FN _0x0,281
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x4
	CALL SUBOPT_0xD
; 0000 0072 					printf("\tOutput Pins Count = %d,", Ocount);
	__POINTW1FN _0x0,305
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Ocount
	LDS  R31,_Ocount+1
	CALL SUBOPT_0xD
; 0000 0073 					printf("\tLines Count = %d.\r", Lines);
	__POINTW1FN _0x0,330
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R8
	CALL SUBOPT_0xD
; 0000 0074 
; 0000 0075 					printf("\rPress i for Input Mask,");
	__POINTW1FN _0x0,350
	CALL SUBOPT_0xE
; 0000 0076 					printf(" q for output Mask,");
	__POINTW1FN _0x0,375
	CALL SUBOPT_0xE
; 0000 0077 					printf("\rc for Columns,");
	__POINTW1FN _0x0,395
	CALL SUBOPT_0xE
; 0000 0078 					printf(" d for Delay,");
	__POINTW1FN _0x0,411
	CALL SUBOPT_0xE
; 0000 0079 					printf(" and g for Scan.");
	__POINTW1FN _0x0,425
	CALL SUBOPT_0xE
; 0000 007A 					printf("\r\r>");
	__POINTW1FN _0x0,442
	RJMP _0x66
; 0000 007B 					break;
; 0000 007C 				case 'G':
_0x2F:
	CPI  R30,LOW(0x47)
	LDI  R26,HIGH(0x47)
	CPC  R31,R26
	BREQ _0x33
; 0000 007D 				case 'g':
	CPI  R30,LOW(0x67)
	LDI  R26,HIGH(0x67)
	CPC  R31,R26
	BRNE _0x35
_0x33:
; 0000 007E 					GoCommand = true;
	LDI  R30,LOW(1)
	STS  _GoCommand,R30
; 0000 007F 					break;
	RJMP _0x17
; 0000 0080 				default:
_0x35:
; 0000 0081 					printf("\b \b");
	__POINTW1FN _0x0,446
_0x66:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 0082 					break;
; 0000 0083 			}
_0x17:
; 0000 0084 			break;
	RJMP _0x13
; 0000 0085 		case 1:
_0x14:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x36
; 0000 0086 			if ((newchar < '0') || (newchar > '9'))
	CPI  R17,48
	BRLO _0x38
	CPI  R17,58
	BRLO _0x37
_0x38:
; 0000 0087 			{
; 0000 0088 				if (data > 0xFFF)
	CALL SUBOPT_0xF
	CPI  R26,LOW(0x1000)
	LDI  R30,HIGH(0x1000)
	CPC  R27,R30
	BRLT _0x3A
; 0000 0089 				{
; 0000 008A 					printf("\rValue must be less than 0xFFF.");
	__POINTW1FN _0x0,450
	CALL SUBOPT_0xE
; 0000 008B 					break;
	RJMP _0x13
; 0000 008C 				}
; 0000 008D 				if ((data > 0x3ff) && ((data >> 10) & Omask))
_0x3A:
	CALL SUBOPT_0xF
	CPI  R26,LOW(0x400)
	LDI  R30,HIGH(0x400)
	CPC  R27,R30
	BRLT _0x3C
	CALL SUBOPT_0x10
	AND  R30,R6
	AND  R31,R7
	SBIW R30,0
	BRNE _0x3D
_0x3C:
	RJMP _0x3B
_0x3D:
; 0000 008E 				{
; 0000 008F 					Omask = ~(data >> 10);
	CALL SUBOPT_0x10
	COM  R30
	COM  R31
	MOVW R6,R30
; 0000 0090 					printf("\rOutput Mask = 0X%03X\r", Omask);
	__POINTW1FN _0x0,482
	CALL SUBOPT_0x9
; 0000 0091 					Imask = data;
	RJMP _0x68
; 0000 0092 				}
; 0000 0093 				else if (data > 0) Imask = data;
_0x3B:
	CALL SUBOPT_0x11
	BRGE _0x3F
_0x68:
	__GETWRMN 4,5,0,_data_S0000001000
; 0000 0094 				printf("\rInput Mask = 0X%03X\r", Imask);
_0x3F:
	__POINTW1FN _0x0,505
	CALL SUBOPT_0x8
; 0000 0095 				printf("\r>");
	CALL SUBOPT_0x12
; 0000 0096 				state = 0;
	CALL SUBOPT_0x13
; 0000 0097 			}
; 0000 0098 			else
	RJMP _0x40
_0x37:
; 0000 0099 			{
; 0000 009A 				data = data * 10 + newchar - '0';
	CALL SUBOPT_0x14
; 0000 009B 			}
_0x40:
; 0000 009C 			break;
	RJMP _0x13
; 0000 009D 		case 2:
_0x36:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x41
; 0000 009E 			if ((newchar < '0') || (newchar > '9'))
	CPI  R17,48
	BRLO _0x43
	CPI  R17,58
	BRLO _0x42
_0x43:
; 0000 009F 			{
; 0000 00A0 				if (data > 0)
	CALL SUBOPT_0x11
	BRGE _0x45
; 0000 00A1 				{
; 0000 00A2 					if ((Imask > 0x3ff) && ((Imask >> 10) & data))
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0x47
	MOVW R26,R4
	LDI  R30,LOW(10)
	CALL __ASRW12
	CALL SUBOPT_0xF
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BRNE _0x48
_0x47:
	RJMP _0x46
_0x48:
; 0000 00A3 					{
; 0000 00A4 						Omask = ~(data >> 10);
	CALL SUBOPT_0x10
	COM  R30
	COM  R31
	MOVW R6,R30
; 0000 00A5 						printf("\rError Input Output masks. Output Mask = 0X%03X\r", Omask);
	__POINTW1FN _0x0,527
	CALL SUBOPT_0x9
; 0000 00A6 					}
; 0000 00A7 					Omask = data;
_0x46:
	__GETWRMN 6,7,0,_data_S0000001000
; 0000 00A8 				}
; 0000 00A9 				printf("\rOutput Mask = 0X%03X\r", Omask);
_0x45:
	__POINTW1FN _0x0,482
	CALL SUBOPT_0x9
; 0000 00AA 				printf("\r>");
	CALL SUBOPT_0x12
; 0000 00AB 				state = 0;
	CALL SUBOPT_0x13
; 0000 00AC 			}
; 0000 00AD 			else
	RJMP _0x49
_0x42:
; 0000 00AE 			{
; 0000 00AF 				data = data * 10 + newchar - '0';
	CALL SUBOPT_0x14
; 0000 00B0 			}
_0x49:
; 0000 00B1 			break;
	RJMP _0x13
; 0000 00B2 		case 3:
_0x41:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x4A
; 0000 00B3 			if ((newchar < '0') || (newchar > '9'))
	CPI  R17,48
	BRLO _0x4C
	CPI  R17,58
	BRLO _0x4B
_0x4C:
; 0000 00B4 			{
; 0000 00B5 				if (data > 0) Columns = data;
	CALL SUBOPT_0x11
	BRGE _0x4E
	__GETWRMN 10,11,0,_data_S0000001000
; 0000 00B6 				printf("Columns = %d\r", Columns);
_0x4E:
	__POINTW1FN _0x0,576
	CALL SUBOPT_0xA
; 0000 00B7 				printf("\r>");
	CALL SUBOPT_0x12
; 0000 00B8 				state = 0;
	CALL SUBOPT_0x13
; 0000 00B9 			}
; 0000 00BA 			else
	RJMP _0x4F
_0x4B:
; 0000 00BB 			{
; 0000 00BC 				data = data * 10 + newchar - '0';
	CALL SUBOPT_0x14
; 0000 00BD 			}
_0x4F:
; 0000 00BE 			break;
	RJMP _0x13
; 0000 00BF 		case 4:
_0x4A:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x13
; 0000 00C0 			if ((newchar < '0') || (newchar > '9'))
	CPI  R17,48
	BRLO _0x52
	CPI  R17,58
	BRLO _0x51
_0x52:
; 0000 00C1 			{
; 0000 00C2 				if ((data > 0) && (data < 10)) D = data;
	CALL SUBOPT_0x11
	BRGE _0x55
	CALL SUBOPT_0xF
	SBIW R26,10
	BRLT _0x56
_0x55:
	RJMP _0x54
_0x56:
	__GETWRMN 12,13,0,_data_S0000001000
; 0000 00C3 				if (D < 6) printf("Delay Timer Mode = %d witch means %d micro secound.\r", D, delayTime(D));
_0x54:
	CALL SUBOPT_0xB
	BRGE _0x57
	__POINTW1FN _0x0,590
	RJMP _0x69
; 0000 00C4 				else printf("Delay Timer Mode = %d witch means %d mili secound.\r", D, delayTime(D));
_0x57:
	__POINTW1FN _0x0,643
_0x69:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xC
; 0000 00C5 				printf("\r>");
	CALL SUBOPT_0x12
; 0000 00C6 				state = 0;
	CALL SUBOPT_0x13
; 0000 00C7 			}
; 0000 00C8 			else
	RJMP _0x59
_0x51:
; 0000 00C9 			{
; 0000 00CA 				data = data * 10 + newchar - '0';
	CALL SUBOPT_0x14
; 0000 00CB 			}
_0x59:
; 0000 00CC 			break;
; 0000 00CD 	}
_0x13:
; 0000 00CE 	sei();
	sei
; 0000 00CF 	LED_turn(1, off);
	CALL SUBOPT_0x5
	CALL SUBOPT_0x15
; 0000 00D0 }
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;//-------------------------------------------------------------------------------------------------
;//
;// start scanning the black box.
;//
;//-----------------
;void start()
; 0000 00D8 {
_start:
; 0000 00D9 	int i, k, data, c;
; 0000 00DA 	int columns, lines, imask, omask, icount, ocount;
; 0000 00DB 
; 0000 00DC 	GoCommand = false;
	SBIW R28,14
	CALL __SAVELOCR6
;	i -> R16,R17
;	k -> R18,R19
;	data -> R20,R21
;	c -> Y+18
;	columns -> Y+16
;	lines -> Y+14
;	imask -> Y+12
;	omask -> Y+10
;	icount -> Y+8
;	ocount -> Y+6
	LDI  R30,LOW(0)
	STS  _GoCommand,R30
; 0000 00DD 	cli();
	cli
; 0000 00DE 	LED_turn(0, on);
	CALL SUBOPT_0x16
	CALL SUBOPT_0x6
; 0000 00DF 
; 0000 00E0 	// DDRA = imask & 0xff;
; 0000 00E1 	// DDRB &= 0xfc;
; 0000 00E2 	// DDRB |= (imask >> 8) & 0x3;
; 0000 00E3 	// if(imask > 0x3ff) DDRC = (imask >> 10) & 0xff;
; 0000 00E4 
; 0000 00E5 	generatePrameters();
	RCALL _generatePrameters
; 0000 00E6 	columns = Columns;	lines = Lines;
	__PUTWSR 10,11,16
	__PUTWSR 8,9,14
; 0000 00E7 	imask = Imask;	omask = Omask;
	__PUTWSR 4,5,12
	__PUTWSR 6,7,10
; 0000 00E8 	icount = Icount;	ocount = Ocount;
	CALL SUBOPT_0x4
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDS  R30,_Ocount
	LDS  R31,_Ocount+1
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00E9 
; 0000 00EA 	putchar('\r');
	LDI  R30,LOW(13)
	ST   -Y,R30
	CALL _putchar
; 0000 00EB 	printf("I:%d\tQ:%d\tC:%d\r", icount, ocount, columns);
	__POINTW1FN _0x0,695
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL SUBOPT_0x17
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CALL SUBOPT_0x17
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	CALL SUBOPT_0x17
	LDI  R24,12
	CALL _printf
	ADIW R28,14
; 0000 00EC 	printf("In mask:%03X\tOut mask:%03X\r", imask, omask);
	__POINTW1FN _0x0,711
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CALL SUBOPT_0x17
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	CALL SUBOPT_0x17
	LDI  R24,8
	CALL _printf
	ADIW R28,10
; 0000 00ED 
; 0000 00EE 	for(k = 0; k < lines; k++)
	__GETWRN 18,19,0
_0x5B:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x5C
; 0000 00EF 	{
; 0000 00F0 		i = k << 1;
	MOVW R30,R18
	LSL  R30
	ROL  R31
	MOVW R16,R30
; 0000 00F1 		printf("%03X:\t", i);
	__POINTW1FN _0x0,739
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	CALL SUBOPT_0xD
; 0000 00F2 
; 0000 00F3 		Write(i, imask);
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _Write
; 0000 00F4 		delay(D);
	CALL SUBOPT_0x18
; 0000 00F5 		data = Read() & omask;
; 0000 00F6 		printf("%02X\t", data);
; 0000 00F7 
; 0000 00F8 		for(c = 0; c < columns; c++)
	LDI  R30,LOW(0)
	STD  Y+18,R30
	STD  Y+18+1,R30
_0x5E:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x5F
; 0000 00F9 		{
; 0000 00FA 			clock();
	RCALL _clock
; 0000 00FB 			delay(D);
	CALL SUBOPT_0x18
; 0000 00FC 			data = Read() & omask;
; 0000 00FD 			printf("%02X\t", data);
; 0000 00FE 		}
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	RJMP _0x5E
_0x5F:
; 0000 00FF 		//putchar('\n');
; 0000 0100 		putchar('\r');
	LDI  R30,LOW(13)
	ST   -Y,R30
	CALL _putchar
; 0000 0101 	}
	__ADDWRN 18,19,1
	RJMP _0x5B
_0x5C:
; 0000 0102 	printf("\r\r>");
	__POINTW1FN _0x0,442
	CALL SUBOPT_0xE
; 0000 0103 	LED_turn(0, off);
	CALL SUBOPT_0x16
	CALL SUBOPT_0x15
; 0000 0104 	sei();
	sei
; 0000 0105 }
	JMP  _0x20A0001
;
;//-------------------------------------------------------------------------------------------------
;//
;// main function.
;//
;//-----------------
;void main(void)
; 0000 010D {
_main:
; 0000 010E 	micro_init();
	RCALL _micro_init
; 0000 010F 
; 0000 0110 	LED_turn(0, off);	// Go LED
	CALL SUBOPT_0x16
	CALL SUBOPT_0x15
; 0000 0111 	LED_turn(1, off);	// Recieve LED
	CALL SUBOPT_0x5
	CALL SUBOPT_0x15
; 0000 0112 	LED_turn(2, on);	// Power on LED
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x6
; 0000 0113 	printf("\r\rThe PEEL Scaner Program started.");
	__POINTW1FN _0x0,752
	CALL SUBOPT_0xE
; 0000 0114 	printf("\rPress G for Scan the PEEL chip.\rPress ? for more help.\r\r>");
	__POINTW1FN _0x0,787
	CALL SUBOPT_0xE
; 0000 0115 
; 0000 0116 	while (1)
_0x60:
; 0000 0117 	{
; 0000 0118 		if (GoCommand)
	LDS  R30,_GoCommand
	CPI  R30,0
	BREQ _0x63
; 0000 0119 			start();
	RCALL _start
; 0000 011A 	}
_0x63:
	RJMP _0x60
; 0000 011B }
_0x64:
	RJMP _0x64
;//-------------------------------------------------------------------------------------------------
;// micro modules with ATmega64 microcontroller
;// By TAB Electric.
;//-------------------------------------------------------------------------------------------------
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include <stdlib.h>
;#include "micro.h"
;
;//-------------------------------------------------------------------------------------------------
;//
;// Initialaize the USART
;//
;//----------------------
;void micro_USART_Init(void)
; 0001 0011 {

	.CSEG
_micro_USART_Init:
; 0001 0012 	// USART0 initialization
; 0001 0013 	// Communication Parameters: 8 Data, 1 Stop, No Parity
; 0001 0014 	// USART0 Receiver: Off
; 0001 0015 	// USART0 Transmitter: On
; 0001 0016 	// USART0 Mode: Asynchronous
; 0001 0017 	// USART0 Baud rate: 57600
; 0001 0018 	UCSRA = 0x02;
	LDI  R30,LOW(2)
	OUT  0xB,R30
; 0001 0019 	UCSRB = 0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0001 001A 	UCSRC = 0x06;
	LDI  R30,LOW(6)
	OUT  0x20,R30
; 0001 001B 	UBRRH = (UBRR >> 8) & 0xFF;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0001 001C 	UBRRL = UBRR & 0xFF;
	LDI  R30,LOW(16)
	OUT  0x9,R30
; 0001 001D }
	RET
;
;//-------------------------------------------------------------------------------------------------
;//
;// Microcontroller's Initialization.
;//
;//--------------------------------
;void micro_init(void)
; 0001 0025 {
_micro_init:
; 0001 0026 	MCUCR = 0X01;	//Write the Interrupt Vector Change Enable (IVCE) bit to one.
	LDI  R30,LOW(1)
	OUT  0x35,R30
; 0001 0027 
; 0001 0028 	DDRA = 0XFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0001 0029 	DDRB = 0XFF;
	OUT  0x17,R30
; 0001 002A 	DDRC = 0X00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0001 002B 	DDRD = 0XFC;
	LDI  R30,LOW(252)
	OUT  0x11,R30
; 0001 002C 	PORTA = 0X00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0001 002D 	PORTB = 0X00;
	OUT  0x18,R30
; 0001 002E 	PORTC = 0XFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0001 002F 	PORTD = 0X00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0001 0030 
; 0001 0031 	SFIOR = 0X00;	//Special Function IO Register.	Bit 3 – ACME: Analog Comparator Multiplexer Enable is off. Bit 2 – PUD: Pull-up disable
	OUT  0x30,R30
; 0001 0032 
; 0001 0033 	micro_USART_Init();
	RCALL _micro_USART_Init
; 0001 0034 
; 0001 0035 	sei();
	sei
; 0001 0036 }
	RET
;
;//-------------------------------------------------------------------------------------------------
;//
;// Turns LEDs on or off.
;//
;//-----------------
;void LED_turn(int i, on_off b)
; 0001 003E {
_LED_turn:
; 0001 003F 	if (b) PORTD &= ~(1 << (5 + i));
;	i -> Y+1
;	b -> Y+0
	LD   R30,Y
	CPI  R30,0
	BREQ _0x20003
	CALL SUBOPT_0x19
	COM  R30
	AND  R30,R1
	RJMP _0x20024
; 0001 0040 	else PORTD |= 1 << (5 + i);
_0x20003:
	CALL SUBOPT_0x19
	OR   R30,R1
_0x20024:
	OUT  0x12,R30
; 0001 0041 }
	JMP  _0x20A0002
;
;//-------------------------------------------------------------------------------------------------
;//
;// Toggles LEDs.
;//
;//-----------------
;void LED_toggle(int i)
; 0001 0049 {
; 0001 004A 	PORTD ^= 1 << (5 + i);
;	i -> Y+0
; 0001 004B }
;
;//-------------------------------------------------------------------------------------------------
;//
;// Read the ouput of the black box.
;//
;//-----------------
;int Read()
; 0001 0053 {
_Read:
; 0001 0054 	return PINC;
	IN   R30,0x13
	LDI  R31,0
	RET
; 0001 0055 }
;
;//-------------------------------------------------------------------------------------------------
;//
;// Send the encoded parameter k with input mask imask to the black box.
;//
;//-----------------
;void Write(int k, int imask)
; 0001 005D {
_Write:
; 0001 005E 	int i;
; 0001 005F 	int data = 0;
; 0001 0060 	for(i = 0; i < 20; i++)
	CALL __SAVELOCR4
;	k -> Y+6
;	imask -> Y+4
;	i -> R16,R17
;	data -> R18,R19
	__GETWRN 18,19,0
	__GETWRN 16,17,0
_0x20006:
	__CPWRN 16,17,20
	BRGE _0x20007
; 0001 0061 	{
; 0001 0062 		if (k & (1 << i)) data |= Is[i];
	CALL SUBOPT_0x0
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x20008
	MOVW R30,R16
	CALL SUBOPT_0x2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	__ORWRR 18,19,30,31
; 0001 0063 	}
_0x20008:
	__ADDWRN 16,17,1
	RJMP _0x20006
_0x20007:
; 0001 0064 	PORTA = data & 0xff;
	MOV  R30,R18
	OUT  0x1B,R30
; 0001 0065 	PORTB = (data >> 8) & 0x3;
	MOVW R30,R18
	CALL __ASRW8
	ANDI R30,LOW(0x3)
	OUT  0x18,R30
; 0001 0066 	if(imask > 0x3ff)
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x400)
	LDI  R30,HIGH(0x400)
	CPC  R27,R30
	BRLT _0x20009
; 0001 0067 	{
; 0001 0068 		DDRC = (imask >> 10) & 0xff;
	LDI  R30,LOW(10)
	CALL __ASRW12
	OUT  0x14,R30
; 0001 0069 		PORTC = (data >> 10) & 0xff;
	MOVW R26,R18
	LDI  R30,LOW(10)
	CALL __ASRW12
	OUT  0x15,R30
; 0001 006A 	}
; 0001 006B }
_0x20009:
	CALL __LOADLOCR4
	ADIW R28,8
	RET
;
;//-------------------------------------------------------------------------------------------------
;//
;// Decoder of the delay code nomber.
;//
;//-----------------
;int delayTime(int d)
; 0001 0073 {
_delayTime:
; 0001 0074 	switch (d)
;	d -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
; 0001 0075 	{
; 0001 0076 		case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2000D
; 0001 0077 			return(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x20A0003
; 0001 0078 			break;
; 0001 0079 		case 2:
_0x2000D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2000E
; 0001 007A 			return(5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP _0x20A0003
; 0001 007B 			break;
; 0001 007C 		case 3:
_0x2000E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2000F
; 0001 007D 			return(25);
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	RJMP _0x20A0003
; 0001 007E 			break;
; 0001 007F 		case 4:
_0x2000F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20010
; 0001 0080 			return(125);
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	RJMP _0x20A0003
; 0001 0081 			break;
; 0001 0082 		case 5:
_0x20010:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x20011
; 0001 0083 			return(625);
	LDI  R30,LOW(625)
	LDI  R31,HIGH(625)
	RJMP _0x20A0003
; 0001 0084 			break;
; 0001 0085 		case 6:
_0x20011:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x20012
; 0001 0086 			return(5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP _0x20A0003
; 0001 0087 			break;
; 0001 0088 		case 7:
_0x20012:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x20013
; 0001 0089 			return(25);
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	RJMP _0x20A0003
; 0001 008A 			break;
; 0001 008B 		case 8:
_0x20013:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x20014
; 0001 008C 			return(125);
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	RJMP _0x20A0003
; 0001 008D 			break;
; 0001 008E 		case 9:
_0x20014:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x2000C
; 0001 008F 			return(625);
	LDI  R30,LOW(625)
	LDI  R31,HIGH(625)
	RJMP _0x20A0003
; 0001 0090 			break;
; 0001 0091 	}
_0x2000C:
; 0001 0092 }
	RJMP _0x20A0003
;
;//-------------------------------------------------------------------------------------------------
;//
;// Delay for the predetermined code nombers.
;//
;//-----------------
;void delay(int d)
; 0001 009A {
_delay:
; 0001 009B 	switch (d)
;	d -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
; 0001 009C 	{
; 0001 009D 		case 0:
	SBIW R30,0
	BRNE _0x20019
; 0001 009E 			nop();
	nop
; 0001 009F 			break;
	RJMP _0x20018
; 0001 00A0 		case 1:
_0x20019:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2001A
; 0001 00A1 			delay_us(1);
	__DELAY_USB 3
; 0001 00A2 			break;
	RJMP _0x20018
; 0001 00A3 		case 2:
_0x2001A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2001B
; 0001 00A4 			delay_us(5);
	__DELAY_USB 13
; 0001 00A5 			break;
	RJMP _0x20018
; 0001 00A6 		case 3:
_0x2001B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2001C
; 0001 00A7 			delay_us(25);
	__DELAY_USB 67
; 0001 00A8 			break;
	RJMP _0x20018
; 0001 00A9 		case 4:
_0x2001C:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2001D
; 0001 00AA 			delay_us(125);
	__DELAY_USW 250
; 0001 00AB 			break;
	RJMP _0x20018
; 0001 00AC 		case 5:
_0x2001D:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x2001E
; 0001 00AD 			delay_us(625);
	__DELAY_USW 1250
; 0001 00AE 			break;
	RJMP _0x20018
; 0001 00AF 		case 6:
_0x2001E:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x2001F
; 0001 00B0 			delay_ms(5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP _0x20025
; 0001 00B1 			break;
; 0001 00B2 		case 7:
_0x2001F:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x20020
; 0001 00B3 			delay_ms(25);
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	RJMP _0x20025
; 0001 00B4 			break;
; 0001 00B5 		case 8:
_0x20020:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x20021
; 0001 00B6 			delay_ms(125);
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	RJMP _0x20025
; 0001 00B7 			break;
; 0001 00B8 		case 9:
_0x20021:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x20023
; 0001 00B9 			delay_ms(625);
	LDI  R30,LOW(625)
	LDI  R31,HIGH(625)
	RJMP _0x20025
; 0001 00BA 			break;
; 0001 00BB 		default:
_0x20023:
; 0001 00BC 			delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
_0x20025:
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0001 00BD 			break;
; 0001 00BE 	}
_0x20018:
; 0001 00BF }
_0x20A0003:
	ADIW R28,2
	RET
;
;
;//-------------------------------------------------------------------------------------------------
;//
;// Send the clock signal for the clock pin of the black box.
;//
;//-----------------
;void clock()
; 0001 00C8 {
_clock:
; 0001 00C9 	PORTA ^= 1;
	IN   R30,0x1B
	LDI  R26,LOW(1)
	EOR  R30,R26
	OUT  0x1B,R30
; 0001 00CA }
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET
_put_usart_G100:
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x20A0002:
	ADIW R28,3
	RET
__print_G100:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x1A
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x1A
	RJMP _0x20000C9
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0x1B
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x1C
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1D
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1D
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1E
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1E
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x1A
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x1A
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CA
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x1C
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x1A
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x1C
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000C9:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
_0x20A0001:
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG

	.DSEG
_Icount:
	.BYTE 0x2
_Ocount:
	.BYTE 0x2
_Is:
	.BYTE 0x28
_Os:
	.BYTE 0x28
_GoCommand:
	.BYTE 0x1
_state_S0000001000:
	.BYTE 0x2
_data_S0000001000:
	.BYTE 0x2
_ec_S0000001000:
	.BYTE 0x2
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	MOV  R30,R16
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_Is)
	LDI  R27,HIGH(_Is)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDS  R30,_Icount
	LDS  R31,_Icount+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _LED_turn

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	STS  _state_S0000001000,R30
	STS  _state_S0000001000+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x8:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x9:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R6
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xA:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R10
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R12,R30
	CPC  R13,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xC:
	MOVW R30,R12
	CALL __CWD1
	CALL __PUTPARD1
	ST   -Y,R13
	ST   -Y,R12
	CALL _delayTime
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,8
	CALL _printf
	ADIW R28,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xD:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0xE:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xF:
	LDS  R26,_data_S0000001000
	LDS  R27,_data_S0000001000+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	RCALL SUBOPT_0xF
	LDI  R30,LOW(10)
	CALL __ASRW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	RCALL SUBOPT_0xF
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	__POINTW1FN _0x0,443
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(0)
	STS  _state_S0000001000,R30
	STS  _state_S0000001000+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x14:
	LDS  R30,_data_S0000001000
	LDS  R31,_data_S0000001000+1
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R26,R30
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	SBIW R26,48
	STS  _data_S0000001000,R26
	STS  _data_S0000001000+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _LED_turn

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x18:
	ST   -Y,R13
	ST   -Y,R12
	CALL _delay
	CALL _Read
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	AND  R30,R26
	AND  R31,R27
	MOVW R20,R30
	__POINTW1FN _0x0,746
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	IN   R1,18
	LDD  R30,Y+1
	SUBI R30,-LOW(5)
	LDI  R26,LOW(1)
	CALL __LSLB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1A:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1B:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1C:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1D:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__ASRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __ASRW12R
__ASRW12L:
	ASR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRW12L
__ASRW12R:
	RET

__ASRW8:
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:

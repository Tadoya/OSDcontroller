
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATxmega32A4
;Program type             : Application
;Clock frequency          : 2.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : float, width, precision
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATxmega32A4
	#pragma AVRPART MEMORY PROG_FLASH 34816
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 12287
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x2000

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU CCP=0x34
	.EQU RAMPD=0x38
	.EQU RAMPX=0x39
	.EQU RAMPY=0x3A
	.EQU RAMPZ=0x3B
	.EQU EIND=0x3C
	.EQU WDT_CTRL=0x80
	.EQU PMIC_CTRL=0xA2
	.EQU NVM_ADDR0=0X01C0
	.EQU NVM_ADDR1=NVM_ADDR0+1
	.EQU NVM_ADDR2=NVM_ADDR1+1
	.EQU NVM_DATA0=NVM_ADDR0+4
	.EQU NVM_CMD=NVM_ADDR0+0xA
	.EQU NVM_CTRLA=NVM_ADDR0+0xB
	.EQU NVM_CTRLB=NVM_ADDR0+0xC
	.EQU NVM_STATUS=NVM_ADDR0+0xF
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIO0=0x00
	.EQU GPIO1=0x01
	.EQU GPIO2=0x02
	.EQU GPIO3=0x03
	.EQU GPIO4=0x04
	.EQU GPIO5=0x05
	.EQU GPIO6=0x06
	.EQU GPIO7=0x07
	.EQU GPIO8=0x08
	.EQU GPIO9=0x09
	.EQU GPIO10=0x0A
	.EQU GPIO11=0x0B
	.EQU GPIO12=0x0C
	.EQU GPIO13=0x0D
	.EQU GPIO14=0x0E
	.EQU GPIO15=0x0F

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

	.EQU __SRAM_START=0x2000
	.EQU __SRAM_END=0x2FFF
	.EQU __DSTACK_SIZE=0x0400
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
	.DEF _col_pointer=R2
	.DEF _row_pointer=R4
	.DEF _title_pointer=R6
	.DEF _ten_ms=R8
	.DEF _a=R11
	.DEF _b=R10
	.DEF _c=R13
	.DEF _d=R12

;GPIO0-GPIO15 INITIALIZATION VALUES
	.EQU __GPIO0_INIT=0x00
	.EQU __GPIO1_INIT=0x00
	.EQU __GPIO2_INIT=0x00
	.EQU __GPIO3_INIT=0x00
	.EQU __GPIO4_INIT=0x00
	.EQU __GPIO5_INIT=0x00
	.EQU __GPIO6_INIT=0x00
	.EQU __GPIO7_INIT=0x00
	.EQU __GPIO8_INIT=0x00
	.EQU __GPIO9_INIT=0x00
	.EQU __GPIO10_INIT=0x00
	.EQU __GPIO11_INIT=0x00
	.EQU __GPIO12_INIT=0x00
	.EQU __GPIO13_INIT=0x00
	.EQU __GPIO14_INIT=0x00
	.EQU __GPIO15_INIT=0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION VALUES
	.EQU __R2_INIT=0x01
	.EQU __R3_INIT=0x00
	.EQU __R4_INIT=0x01
	.EQU __R5_INIT=0x00
	.EQU __R6_INIT=0x00
	.EQU __R7_INIT=0x00
	.EQU __R8_INIT=0x00
	.EQU __R9_INIT=0x00
	.EQU __R10_INIT=0x00
	.EQU __R11_INIT=0x00
	.EQU __R12_INIT=0x00
	.EQU __R13_INIT=0x00
	.EQU __R14_INIT=0x00

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
	JMP  _rtcxm_overflow_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _tcc0_overflow_isr
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
	JMP  0x00
	JMP  _usartd0_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x3:
	.DB  0xF2,0xF1,0xF0,0xEF,0xEE,0xED,0xF3,0xFB
	.DB  0xA9,0xAA,0xAB,0xAC,0xAD,0xAE,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x48,0x0,0x0,0x0,0x0,0x46
	.DB  0x3F,0x40,0x0,0x0,0x45,0x49,0x41,0x47
	.DB  0xA,0x1,0x2,0x3,0x4,0x5,0x6,0x7
	.DB  0x8,0x9,0x44,0x43,0x4A,0x0,0x4B,0x42
	.DB  0x4C,0xB,0xC,0xD,0xE,0xF,0x10,0x11
	.DB  0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19
	.DB  0x1A,0x1B,0x1C,0x1D,0x1E,0x1F,0x20,0x21
	.DB  0x22,0x23,0x24,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B
	.DB  0x2C,0x2D,0x2E,0x2F,0x30,0x31,0x32,0x33
	.DB  0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B
	.DB  0x3C,0x3D,0x3E
_0x5E:
	.DB  0x1
_0x0:
	.DB  0x43,0x48,0x45,0x43,0x4B,0x21,0xD,0x0
	.DB  0x43,0x4C,0x45,0x41,0x52,0x21,0xD,0x0
	.DB  0x4F,0x53,0x44,0x20,0x4F,0x4E,0x21,0xD
	.DB  0x0,0x4F,0x53,0x44,0x20,0x4F,0x46,0x46
	.DB  0x21,0xD,0x0,0x72,0x61,0x6E,0x67,0x65
	.DB  0x20,0x6F,0x66,0x20,0x63,0x6F,0x6C,0x75
	.DB  0x6D,0x6E,0x20,0x69,0x73,0x20,0x31,0x7E
	.DB  0x32,0x37,0xD,0x0,0x43,0x6F,0x6C,0x20
	.DB  0x50,0x6F,0x69,0x6E,0x74,0x65,0x72,0x20
	.DB  0x3A,0x20,0x0,0x72,0x61,0x6E,0x67,0x65
	.DB  0x20,0x6F,0x66,0x20,0x72,0x6F,0x77,0x20
	.DB  0x69,0x73,0x20,0x31,0x7E,0x31,0x32,0xD
	.DB  0x0,0x52,0x6F,0x77,0x20,0x50,0x6F,0x69
	.DB  0x6E,0x74,0x65,0x72,0x20,0x3A,0x20,0x0
	.DB  0x43,0x48,0x41,0x54,0x21,0xD,0x0,0x54
	.DB  0x69,0x74,0x6C,0x65,0x20,0x69,0x73,0x20
	.DB  0x74,0x6F,0x6F,0x20,0x6C,0x6F,0x6E,0x67
	.DB  0x21,0x28,0x4D,0x61,0x78,0x3A,0x31,0x35
	.DB  0x29,0xD,0x0,0x54,0x49,0x54,0x4C,0x45
	.DB  0x21,0xD,0x0,0x4F,0x53,0x44,0x20,0x43
	.DB  0x4F,0x4E,0x4E,0x45,0x43,0x54,0x20,0x3A
	.DB  0x20,0x4F,0x4B,0xD,0x0,0x4F,0x4E,0x54
	.DB  0x49,0x4D,0x45,0x52,0x20,0x4F,0x4E,0xD
	.DB  0x0,0x4F,0x4E,0x54,0x49,0x4D,0x45,0x52
	.DB  0x20,0x4F,0x46,0x46,0xD,0x0,0x4F,0x4E
	.DB  0x54,0x49,0x4D,0x45,0x52,0x20,0x53,0x45
	.DB  0x54,0xD,0x0,0x44,0x41,0x54,0x45,0x20
	.DB  0x53,0x45,0x54,0xD,0x0,0x53,0x45,0x43
	.DB  0x4F,0x4E,0x44,0x20,0x3A,0x20,0x30,0x0
	.DB  0x45,0x4E,0x43,0x4F,0x44,0x45,0x52,0x20
	.DB  0x4F,0x4E,0xD,0x0,0x45,0x4E,0x43,0x4F
	.DB  0x44,0x45,0x52,0x20,0x4F,0x46,0x46,0xD
	.DB  0x0,0x45,0x4E,0x43,0x4F,0x44,0x45,0x52
	.DB  0x20,0x56,0x41,0x4C,0x55,0x45,0x20,0x52
	.DB  0x45,0x53,0x45,0x54,0x21,0x21,0xD,0x0
	.DB  0x25,0x34,0x2E,0x33,0x66,0x4D,0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x7B
	.DW  _OSDchr
	.DW  _0x3*2

	.DW  0x08
	.DW  _0x30
	.DW  _0x0*2

	.DW  0x08
	.DW  _0x31
	.DW  _0x0*2+8

	.DW  0x09
	.DW  _0x32
	.DW  _0x0*2+16

	.DW  0x0A
	.DW  _0x33
	.DW  _0x0*2+25

	.DW  0x19
	.DW  _0x3A
	.DW  _0x0*2+35

	.DW  0x19
	.DW  _0x3A+25
	.DW  _0x0*2+35

	.DW  0x0F
	.DW  _0x3A+50
	.DW  _0x0*2+60

	.DW  0x02
	.DW  _0x3A+65
	.DW  _0x0*2+6

	.DW  0x16
	.DW  _0x41
	.DW  _0x0*2+75

	.DW  0x16
	.DW  _0x41+22
	.DW  _0x0*2+75

	.DW  0x0F
	.DW  _0x41+44
	.DW  _0x0*2+97

	.DW  0x02
	.DW  _0x41+59
	.DW  _0x0*2+6

	.DW  0x07
	.DW  _0x4D
	.DW  _0x0*2+112

	.DW  0x1C
	.DW  _0x55
	.DW  _0x0*2+119

	.DW  0x08
	.DW  _0x55+28
	.DW  _0x0*2+147

	.DW  0x02
	.DW  _0x5D
	.DW  _0x0*2+6

	.DW  0x01
	.DW  _timer_pointer
	.DW  _0x5E*2

	.DW  0x12
	.DW  _0x6F
	.DW  _0x0*2+155

	.DW  0x0C
	.DW  _0x6F+18
	.DW  _0x0*2+173

	.DW  0x0D
	.DW  _0x6F+30
	.DW  _0x0*2+185

	.DW  0x0D
	.DW  _0x6F+43
	.DW  _0x0*2+198

	.DW  0x0A
	.DW  _0x6F+56
	.DW  _0x0*2+211

	.DW  0x0B
	.DW  _0x6F+66
	.DW  _0x0*2+221

	.DW  0x0C
	.DW  _0x6F+77
	.DW  _0x0*2+232

	.DW  0x0D
	.DW  _0x6F+89
	.DW  _0x0*2+244

	.DW  0x17
	.DW  _0x6F+102
	.DW  _0x0*2+257

	.DW  0x12
	.DW  _0xB8
	.DW  _0x0*2+155

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x2080060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  RAMPD,R30
	OUT  RAMPX,R30
	OUT  RAMPY,R30

;MEMORY MAPPED EEPROM ACCESS IS USED
	LDS  R31,NVM_CTRLB
	ORI  R31,0x08
	STS  NVM_CTRLB,R31

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,0xD8
	OUT  CCP,R31
	STS  PMIC_CTRL,R30

;DISABLE WATCHDOG
	LDS  R26,WDT_CTRL
	CBR  R26,2
	SBR  R26,1
	OUT  CCP,R31
	STS  WDT_CTRL,R26

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
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

	OUT  RAMPZ,R24

;GPIO0-GPIO15 INITIALIZATION
	LDI  R30,__GPIO0_INIT
	OUT  GPIO0,R30
	;__GPIO1_INIT = __GPIO0_INIT
	OUT  GPIO1,R30
	;__GPIO2_INIT = __GPIO0_INIT
	OUT  GPIO2,R30
	;__GPIO3_INIT = __GPIO0_INIT
	OUT  GPIO3,R30
	;__GPIO4_INIT = __GPIO0_INIT
	OUT  GPIO4,R30
	;__GPIO5_INIT = __GPIO0_INIT
	OUT  GPIO5,R30
	;__GPIO6_INIT = __GPIO0_INIT
	OUT  GPIO6,R30
	;__GPIO7_INIT = __GPIO0_INIT
	OUT  GPIO7,R30
	;__GPIO8_INIT = __GPIO0_INIT
	OUT  GPIO8,R30
	;__GPIO9_INIT = __GPIO0_INIT
	OUT  GPIO9,R30
	;__GPIO10_INIT = __GPIO0_INIT
	OUT  GPIO10,R30
	;__GPIO11_INIT = __GPIO0_INIT
	OUT  GPIO11,R30
	;__GPIO12_INIT = __GPIO0_INIT
	OUT  GPIO12,R30
	;__GPIO13_INIT = __GPIO0_INIT
	OUT  GPIO13,R30
	;__GPIO14_INIT = __GPIO0_INIT
	OUT  GPIO14,R30
	;__GPIO15_INIT = __GPIO0_INIT
	OUT  GPIO15,R30

;GLOBAL REGISTER VARIABLES INITIALIZATION
	LDI  R30,__R2_INIT
	MOV  R2,R30
	LDI  R30,__R3_INIT
	MOV  R3,R30
	LDI  R30,__R4_INIT
	MOV  R4,R30
	LDI  R30,__R5_INIT
	MOV  R5,R30
	;__R6_INIT = __R5_INIT
	MOV  R6,R30
	;__R7_INIT = __R5_INIT
	MOV  R7,R30
	;__R8_INIT = __R5_INIT
	MOV  R8,R30
	;__R9_INIT = __R5_INIT
	MOV  R9,R30
	;__R10_INIT = __R5_INIT
	MOV  R10,R30
	;__R11_INIT = __R5_INIT
	MOV  R11,R30
	;__R12_INIT = __R5_INIT
	MOV  R12,R30
	;__R13_INIT = __R5_INIT
	MOV  R13,R30

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
	.ORG 0x2400

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 2014-01-27
;Author  : NeVaDa
;Company :
;Comments:
;
;
;Chip type               : ATxmega32A4
;Program type            : Application
;AVR Core Clock frequency: 2.000000 MHz
;Memory model            : Small
;Data Stack size         : 1024
;*****************************************************/
;
;// I/O Registers definitions
;#include <io.h>
;
;// Standard Input/Output functions
;#include <stdio.h>
;#include <delay.h>
;#include <stdio.h>
;#include <string.h>
;
;// Declare your global variables here
;// Array of character addresses in MAX7456
;const char OSDchr[256]={  0xF2,  0xF1,  0xF0,  0xEF, 0xEE,  0xED, 0xF3,            // 0-6 progress bar
;  0xFB,0xA9,0xAA,0xAB,0xAC,0xAD,0xAE,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,      // 7-33
;  0x48, 0,0,0,0, 0x46,0x3F,0x40, 0,0, 0x45,0x49,0x41,0x47,                         // 34; 35-38; 39-41; 42-43; 44-47
;  0x0A, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x44, 0x43, 0x4A,    // 48-60
;  0, 0x4B, 0x42, 0x4C,                                                             // 61; 62-64
;  0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,    // 65-77  A-M
;  0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F, 0x20, 0x21, 0x22, 0x23, 0x24,    // 78-90  N-Z
;  0, 0, 0, 0, 0, 0,                                                                // 91-96
;  0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x2F, 0x30, 0x31,    // 97-109   a-m
;  0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D, 0x3E     // 110-122  n-z
;};

	.DSEG
;int col_pointer=1, row_pointer=1, title_pointer;
;int ten_ms;
;
;char ch[30]="";
;unsigned char a,b,c,d;
;long int sum;
;bit flag_com=0;
;
;//////////////////////////////////////////////////////////////encorder///////////////////////////////////////////////////////////////////
;#define SELECT_MDR0 0b00001000     // Select MDR0
;#define SELECT_MDR1 0b00010000     // Select MDR1
;#define SELECT_DTR  0b00011000     // Select DTR
;#define SELECT_CNTR 0b00100000     // Select CNTR
;#define SELECT_OTR  0b00101000     // Select OTR
;#define SELECT_STR  0b00110000     // Select STR
;
;#define CLR_REG     0b00000000     // CLR  register
;#define RD_REG      0b01000000     // RD   register
;#define WR_REG      0b10000000     // WR   register
;#define LOAD_REG    0b11000000     // LOAD register
;#define NON_QUAD            0b00000000      // non-quadrature counter mode.
;#define X1_QUAD             0b00000001      // x1 quadrature counter mode.
;#define X2_QUAD             0b00000010      // x2 quadrature counter mode.
;#define X4_QUAD             0b00000011      // x4 quadrature counter mode.
;#define FREE_RUN            0b00000000      // free-running count mode.
;#define SINGLE_CYCLE        0b00000100      // single-cycle count mode.
;#define RANGE_LIMIT         0b00001000      // range-limit count mode.
;#define MODULO_N            0b00001100      // modulo-n count mode.
;#define DISABLE_INDEX       0b00000000      // disable index.
;#define INDEX_AS_LOAD_CNTR  0b00010000      // configure index as the "load CNTR" input(clears CNTR to 0).
;#define INDEX_AS_RESET_CNTR 0b00100000      // configure index as the "reset CNTR" input(clears CNTR to 0).
;#define INDEX_AS_LOAD_OTR   0b00110000      // configure index as the "load OTR" input(transfer CNTR to OTR).
;#define ASYCHRONOUS_INDEX   0b00000000      // Asynchronous index
;#define SYNCHRONOUS_INDEX   0b01000000      // Synchoronous index
;#define FILTER_CDF_1        0b00000000      // Filter clock division factor = 1
;#define FILTER_CDF_2        0b10000000      // Filter clock division factor = 2
;#define FOUR_BYTE_COUNT_MODE    0b00000000       // 4-byte counter mode
;#define THREE_BYTE_COUNT_MODE   0b00000001       // 3-byte counter mode
;#define TWO_BYTE_COUNT_MODE     0b00000010       // 2-byte counter mode
;#define ENABLE_COUNTING         0b00000000       // Enable counting
;#define DISABLE_COUNTING        0b00000100       // Disable counting
;#define FLAG_ON_IDX             0b00010000       // FLAG on IDX (B4 of STR)
;#define FLAG_ON_CMP             0b00100000       // FLAG on CMP (B5 of STR)
;#define FLAG_ON_BW              0b01000000       // FLAG on BW (B6 of STR)
;#define FLAG_ON_CY              0b10000000       // FLAG on CY (B7 of STR)
;#define LS7366_SS_H_L  PORTD.OUT = 0x00;    // Device Select or Start
;#define LS7366_SS_L_H  PORTD.OUT = 0x10;    // Device Unselect or End
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;// System Clocks initialization
;
;
;void system_clocks_init(void)
; 0000 0061 {

	.CSEG
_system_clocks_init:
; 0000 0062 unsigned char n,s;
; 0000 0063 
; 0000 0064 // Optimize for speed
; 0000 0065 #pragma optsize-
; 0000 0066 // Save interrupts enabled/disabled state
; 0000 0067 s=SREG;
	ST   -Y,R17
	ST   -Y,R16
;	n -> R17
;	s -> R16
	IN   R16,63
; 0000 0068 // Disable interrupts
; 0000 0069 #asm("cli")
	cli
; 0000 006A 
; 0000 006B // Internal 2 MHz RC oscillator initialization
; 0000 006C // Enable the internal 2 MHz RC oscillator
; 0000 006D OSC.CTRL|=OSC_RC2MEN_bm;
	LDS  R30,80
	ORI  R30,1
	STS  80,R30
; 0000 006E 
; 0000 006F // System Clock prescaler A division factor: 1
; 0000 0070 // System Clock prescalers B & C division factors: B:1, C:1
; 0000 0071 // ClkPer4: 2000.000 kHz
; 0000 0072 // ClkPer2: 2000.000 kHz
; 0000 0073 // ClkPer:  2000.000 kHz
; 0000 0074 // ClkCPU:  2000.000 kHz
; 0000 0075 n=(CLK.PSCTRL & (~(CLK_PSADIV_gm | CLK_PSBCDIV1_bm | CLK_PSBCDIV0_bm))) |
; 0000 0076 	CLK_PSADIV_1_gc | CLK_PSBCDIV_1_1_gc;
	LDS  R30,65
	ANDI R30,LOW(0x80)
	MOV  R17,R30
; 0000 0077 CCP=CCP_IOREG_gc;
	LDI  R30,LOW(216)
	OUT  0x34,R30
; 0000 0078 CLK.PSCTRL=n;
	STS  65,R17
; 0000 0079 
; 0000 007A // Disable the autocalibration of the internal 2 MHz RC oscillator
; 0000 007B DFLLRC2M.CTRL&= ~DFLL_ENABLE_bm;
	LDS  R30,104
	ANDI R30,0xFE
	STS  104,R30
; 0000 007C 
; 0000 007D // Wait for the internal 2 MHz RC oscillator to stabilize
; 0000 007E while ((OSC.STATUS & OSC_RC2MRDY_bm)==0);
_0x4:
	LDS  R30,81
	ANDI R30,LOW(0x1)
	BREQ _0x4
; 0000 007F 
; 0000 0080 // Select the system clock source: 2 MHz Internal RC Osc.
; 0000 0081 n=(CLK.CTRL & (~CLK_SCLKSEL_gm)) | CLK_SCLKSEL_RC2M_gc;
	LDS  R30,64
	ANDI R30,LOW(0xF8)
	MOV  R17,R30
; 0000 0082 CCP=CCP_IOREG_gc;
	LDI  R30,LOW(216)
	OUT  0x34,R30
; 0000 0083 CLK.CTRL=n;
	STS  64,R17
; 0000 0084 
; 0000 0085 // Disable the unused oscillators: 32 MHz, 32 kHz, external clock/crystal oscillator, PLL
; 0000 0086 OSC.CTRL&= ~(OSC_RC32MEN_bm | OSC_RC32KEN_bm | OSC_XOSCEN_bm | OSC_PLLEN_bm);
	LDS  R30,80
	ANDI R30,LOW(0xE1)
	STS  80,R30
; 0000 0087 
; 0000 0088 // Peripheral Clock output: Disabled
; 0000 0089 PORTCFG.CLKEVOUT=(PORTCFG.CLKEVOUT & (~PORTCFG_CLKOUT_gm)) | PORTCFG_CLKOUT_OFF_gc;
	LDS  R30,180
	ANDI R30,LOW(0xFC)
	STS  180,R30
; 0000 008A 
; 0000 008B // Restore interrupts enabled/disabled state
; 0000 008C SREG=s;
	OUT  0x3F,R16
; 0000 008D // Restore optimization for size if needed
; 0000 008E #pragma optsize_default
; 0000 008F }
	RJMP _0x20A0007
;
;// Watchdog Timer initialization
;void watchdog_init(void)
; 0000 0093 {
_watchdog_init:
; 0000 0094 unsigned char s,n;
; 0000 0095 
; 0000 0096 // Optimize for speed
; 0000 0097 #pragma optsize-
; 0000 0098 // Save interrupts enabled/disabled state
; 0000 0099 s=SREG;
	ST   -Y,R17
	ST   -Y,R16
;	s -> R17
;	n -> R16
	IN   R17,63
; 0000 009A // Disable interrupts
; 0000 009B #asm("cli")
	cli
; 0000 009C 
; 0000 009D // Watchdog Timer: Off
; 0000 009E n=(WDT.CTRL & (~WDT_ENABLE_bm)) | WDT_CEN_bm;
	LDS  R30,128
	ANDI R30,0xFD
	ORI  R30,1
	MOV  R16,R30
; 0000 009F CCP=CCP_IOREG_gc;
	LDI  R30,LOW(216)
	OUT  0x34,R30
; 0000 00A0 WDT.CTRL=n;
	STS  128,R16
; 0000 00A1 // Watchdog window mode: Off
; 0000 00A2 n=(WDT.WINCTRL & (~WDT_WEN_bm)) | WDT_WCEN_bm;
	LDS  R30,129
	ANDI R30,0xFD
	ORI  R30,1
	MOV  R16,R30
; 0000 00A3 CCP=CCP_IOREG_gc;
	LDI  R30,LOW(216)
	OUT  0x34,R30
; 0000 00A4 WDT.WINCTRL=n;
	STS  129,R16
; 0000 00A5 
; 0000 00A6 // Restore interrupts enabled/disabled state
; 0000 00A7 SREG=s;
	OUT  0x3F,R17
; 0000 00A8 // Restore optimization for size if needed
; 0000 00A9 #pragma optsize_default
; 0000 00AA }
	RJMP _0x20A0007
;
;// Event System initialization
;void event_system_init(void)
; 0000 00AE {
_event_system_init:
; 0000 00AF // Event System Channel 0 source: None
; 0000 00B0 EVSYS.CH0MUX=EVSYS_CHMUX_OFF_gc;
	LDI  R30,LOW(0)
	STS  384,R30
; 0000 00B1 // Event System Channel 1 source: None
; 0000 00B2 EVSYS.CH1MUX=EVSYS_CHMUX_OFF_gc;
	STS  385,R30
; 0000 00B3 // Event System Channel 2 source: None
; 0000 00B4 EVSYS.CH2MUX=EVSYS_CHMUX_OFF_gc;
	STS  386,R30
; 0000 00B5 // Event System Channel 3 source: None
; 0000 00B6 EVSYS.CH3MUX=EVSYS_CHMUX_OFF_gc;
	STS  387,R30
; 0000 00B7 // Event System Channel 4 source: None
; 0000 00B8 EVSYS.CH4MUX=EVSYS_CHMUX_OFF_gc;
	STS  388,R30
; 0000 00B9 // Event System Channel 5 source: None
; 0000 00BA EVSYS.CH5MUX=EVSYS_CHMUX_OFF_gc;
	STS  389,R30
; 0000 00BB // Event System Channel 6 source: None
; 0000 00BC EVSYS.CH6MUX=EVSYS_CHMUX_OFF_gc;
	STS  390,R30
; 0000 00BD // Event System Channel 7 source: None
; 0000 00BE EVSYS.CH7MUX=EVSYS_CHMUX_OFF_gc;
	STS  391,R30
; 0000 00BF 
; 0000 00C0 // Event System Channel 0 Digital Filter Coefficient: 1 Sample
; 0000 00C1 EVSYS.CH0CTRL=(EVSYS.CH0CTRL & (~(EVSYS_QDIRM_gm | EVSYS_QDIEN_bm | EVSYS_QDEN_bm | EVSYS_DIGFILT_gm))) |
; 0000 00C2 	EVSYS_DIGFILT_1SAMPLE_gc;
	LDS  R30,392
	ANDI R30,LOW(0x80)
	STS  392,R30
; 0000 00C3 // Event System Channel 1 Digital Filter Coefficient: 1 Sample
; 0000 00C4 EVSYS.CH1CTRL=EVSYS_DIGFILT_1SAMPLE_gc;
	LDI  R30,LOW(0)
	STS  393,R30
; 0000 00C5 // Event System Channel 2 Digital Filter Coefficient: 1 Sample
; 0000 00C6 EVSYS.CH2CTRL=(EVSYS.CH2CTRL & (~(EVSYS_QDIRM_gm | EVSYS_QDIEN_bm | EVSYS_QDEN_bm | EVSYS_DIGFILT_gm))) |
; 0000 00C7 	EVSYS_DIGFILT_1SAMPLE_gc;
	LDS  R30,394
	ANDI R30,LOW(0x80)
	STS  394,R30
; 0000 00C8 // Event System Channel 3 Digital Filter Coefficient: 1 Sample
; 0000 00C9 EVSYS.CH3CTRL=EVSYS_DIGFILT_1SAMPLE_gc;
	LDI  R30,LOW(0)
	STS  395,R30
; 0000 00CA // Event System Channel 4 Digital Filter Coefficient: 1 Sample
; 0000 00CB EVSYS.CH4CTRL=(EVSYS.CH4CTRL & (~(EVSYS_QDIRM_gm | EVSYS_QDIEN_bm | EVSYS_QDEN_bm | EVSYS_DIGFILT_gm))) |
; 0000 00CC 	EVSYS_DIGFILT_1SAMPLE_gc;
	LDS  R30,396
	ANDI R30,LOW(0x80)
	STS  396,R30
; 0000 00CD // Event System Channel 5 Digital Filter Coefficient: 1 Sample
; 0000 00CE EVSYS.CH5CTRL=EVSYS_DIGFILT_1SAMPLE_gc;
	LDI  R30,LOW(0)
	STS  397,R30
; 0000 00CF // Event System Channel 6 Digital Filter Coefficient: 1 Sample
; 0000 00D0 EVSYS.CH6CTRL=EVSYS_DIGFILT_1SAMPLE_gc;
	STS  398,R30
; 0000 00D1 // Event System Channel 7 Digital Filter Coefficient: 1 Sample
; 0000 00D2 EVSYS.CH7CTRL=EVSYS_DIGFILT_1SAMPLE_gc;
	STS  399,R30
; 0000 00D3 
; 0000 00D4 // Event System Channel 0 output: Disabled
; 0000 00D5 // Note: the correct direction for the Event System Channel 0 output
; 0000 00D6 // is configured in the ports_init function
; 0000 00D7 PORTCFG.CLKEVOUT=(PORTCFG.CLKEVOUT & (~PORTCFG_EVOUT_gm)) | PORTCFG_EVOUT_OFF_gc;
	LDS  R30,180
	ANDI R30,LOW(0xCF)
	STS  180,R30
; 0000 00D8 }
	RET
;
;// Ports initialization
;void ports_init(void)
; 0000 00DC {
_ports_init:
; 0000 00DD // PORTA initialization
; 0000 00DE // OUT register
; 0000 00DF PORTA.OUT=0x00;
	LDI  R30,LOW(0)
	STS  1540,R30
; 0000 00E0 // Bit0: Input
; 0000 00E1 // Bit1: Input
; 0000 00E2 // Bit2: Input
; 0000 00E3 // Bit3: Input
; 0000 00E4 // Bit4: Input
; 0000 00E5 // Bit5: Input
; 0000 00E6 // Bit6: Input
; 0000 00E7 // Bit7: Input
; 0000 00E8 PORTA.DIR=0x00;
	STS  1536,R30
; 0000 00E9 // Bit0 Output/Pull configuration: Totempole/No
; 0000 00EA // Bit0 Input/Sense configuration: Sense both edges
; 0000 00EB // Bit0 inverted: Off
; 0000 00EC // Bit0 slew rate limitation: Off
; 0000 00ED PORTA.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1552,R30
; 0000 00EE // Bit1 Output/Pull configuration: Totempole/No
; 0000 00EF // Bit1 Input/Sense configuration: Sense both edges
; 0000 00F0 // Bit1 inverted: Off
; 0000 00F1 // Bit1 slew rate limitation: Off
; 0000 00F2 PORTA.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1553,R30
; 0000 00F3 // Bit2 Output/Pull configuration: Totempole/No
; 0000 00F4 // Bit2 Input/Sense configuration: Sense both edges
; 0000 00F5 // Bit2 inverted: Off
; 0000 00F6 // Bit2 slew rate limitation: Off
; 0000 00F7 PORTA.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1554,R30
; 0000 00F8 // Bit3 Output/Pull configuration: Totempole/No
; 0000 00F9 // Bit3 Input/Sense configuration: Sense both edges
; 0000 00FA // Bit3 inverted: Off
; 0000 00FB // Bit3 slew rate limitation: Off
; 0000 00FC PORTA.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1555,R30
; 0000 00FD // Bit4 Output/Pull configuration: Totempole/No
; 0000 00FE // Bit4 Input/Sense configuration: Sense both edges
; 0000 00FF // Bit4 inverted: Off
; 0000 0100 // Bit4 slew rate limitation: Off
; 0000 0101 PORTA.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1556,R30
; 0000 0102 // Bit5 Output/Pull configuration: Totempole/No
; 0000 0103 // Bit5 Input/Sense configuration: Sense both edges
; 0000 0104 // Bit5 inverted: Off
; 0000 0105 // Bit5 slew rate limitation: Off
; 0000 0106 PORTA.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1557,R30
; 0000 0107 // Bit6 Output/Pull configuration: Totempole/No
; 0000 0108 // Bit6 Input/Sense configuration: Sense both edges
; 0000 0109 // Bit6 inverted: Off
; 0000 010A // Bit6 slew rate limitation: Off
; 0000 010B PORTA.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1558,R30
; 0000 010C // Bit7 Output/Pull configuration: Totempole/No
; 0000 010D // Bit7 Input/Sense configuration: Sense both edges
; 0000 010E // Bit7 inverted: Off
; 0000 010F // Bit7 slew rate limitation: Off
; 0000 0110 PORTA.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1559,R30
; 0000 0111 // Interrupt 0 level: Disabled
; 0000 0112 // Interrupt 1 level: Disabled
; 0000 0113 PORTA.INTCTRL=(PORTA.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
; 0000 0114 	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
	LDS  R30,1545
	ANDI R30,LOW(0xF0)
	STS  1545,R30
; 0000 0115 // Bit0 pin change interrupt 0: Off
; 0000 0116 // Bit1 pin change interrupt 0: Off
; 0000 0117 // Bit2 pin change interrupt 0: Off
; 0000 0118 // Bit3 pin change interrupt 0: Off
; 0000 0119 // Bit4 pin change interrupt 0: Off
; 0000 011A // Bit5 pin change interrupt 0: Off
; 0000 011B // Bit6 pin change interrupt 0: Off
; 0000 011C // Bit7 pin change interrupt 0: Off
; 0000 011D PORTA.INT0MASK=0x00;
	LDI  R30,LOW(0)
	STS  1546,R30
; 0000 011E // Bit0 pin change interrupt 1: Off
; 0000 011F // Bit1 pin change interrupt 1: Off
; 0000 0120 // Bit2 pin change interrupt 1: Off
; 0000 0121 // Bit3 pin change interrupt 1: Off
; 0000 0122 // Bit4 pin change interrupt 1: Off
; 0000 0123 // Bit5 pin change interrupt 1: Off
; 0000 0124 // Bit6 pin change interrupt 1: Off
; 0000 0125 // Bit7 pin change interrupt 1: Off
; 0000 0126 PORTA.INT1MASK=0x00;
	STS  1547,R30
; 0000 0127 
; 0000 0128 // PORTB initialization
; 0000 0129 // OUT register
; 0000 012A PORTB.OUT=0x00;
	STS  1572,R30
; 0000 012B // Bit0: Input
; 0000 012C // Bit1: Input
; 0000 012D // Bit2: Input
; 0000 012E // Bit3: Input
; 0000 012F PORTB.DIR=0x00;
	STS  1568,R30
; 0000 0130 // Bit0 Output/Pull configuration: Totempole/No
; 0000 0131 // Bit0 Input/Sense configuration: Sense both edges
; 0000 0132 // Bit0 inverted: Off
; 0000 0133 // Bit0 slew rate limitation: Off
; 0000 0134 PORTB.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1584,R30
; 0000 0135 // Bit1 Output/Pull configuration: Totempole/No
; 0000 0136 // Bit1 Input/Sense configuration: Sense both edges
; 0000 0137 // Bit1 inverted: Off
; 0000 0138 // Bit1 slew rate limitation: Off
; 0000 0139 PORTB.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1585,R30
; 0000 013A // Bit2 Output/Pull configuration: Totempole/No
; 0000 013B // Bit2 Input/Sense configuration: Sense both edges
; 0000 013C // Bit2 inverted: Off
; 0000 013D // Bit2 slew rate limitation: Off
; 0000 013E PORTB.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1586,R30
; 0000 013F // Bit3 Output/Pull configuration: Totempole/No
; 0000 0140 // Bit3 Input/Sense configuration: Sense both edges
; 0000 0141 // Bit3 inverted: Off
; 0000 0142 // Bit3 slew rate limitation: Off
; 0000 0143 PORTB.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1587,R30
; 0000 0144 // Interrupt 0 level: Disabled
; 0000 0145 // Interrupt 1 level: Disabled
; 0000 0146 PORTB.INTCTRL=(PORTB.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
; 0000 0147 	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
	LDS  R30,1577
	ANDI R30,LOW(0xF0)
	STS  1577,R30
; 0000 0148 // Bit0 pin change interrupt 0: Off
; 0000 0149 // Bit1 pin change interrupt 0: Off
; 0000 014A // Bit2 pin change interrupt 0: Off
; 0000 014B // Bit3 pin change interrupt 0: Off
; 0000 014C PORTB.INT0MASK=0x00;
	LDI  R30,LOW(0)
	STS  1578,R30
; 0000 014D // Bit0 pin change interrupt 1: Off
; 0000 014E // Bit1 pin change interrupt 1: Off
; 0000 014F // Bit2 pin change interrupt 1: Off
; 0000 0150 // Bit3 pin change interrupt 1: Off
; 0000 0151 PORTB.INT1MASK=0x00;
	STS  1579,R30
; 0000 0152 
; 0000 0153 // PORTC initialization
; 0000 0154 // OUT register
; 0000 0155 PORTC.OUT=0x10;
	LDI  R30,LOW(16)
	STS  1604,R30
; 0000 0156 // Bit0: Input
; 0000 0157 // Bit1: Input
; 0000 0158 // Bit2: Input
; 0000 0159 // Bit3: Input
; 0000 015A // Bit4: Output
; 0000 015B // Bit5: Output
; 0000 015C // Bit6: Input
; 0000 015D // Bit7: Output
; 0000 015E PORTC.DIR=0xB0;
	LDI  R30,LOW(176)
	STS  1600,R30
; 0000 015F // Bit0 Output/Pull configuration: Totempole/No
; 0000 0160 // Bit0 Input/Sense configuration: Sense both edges
; 0000 0161 // Bit0 inverted: Off
; 0000 0162 // Bit0 slew rate limitation: Off
; 0000 0163 PORTC.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	LDI  R30,LOW(0)
	STS  1616,R30
; 0000 0164 // Bit1 Output/Pull configuration: Totempole/No
; 0000 0165 // Bit1 Input/Sense configuration: Sense both edges
; 0000 0166 // Bit1 inverted: Off
; 0000 0167 // Bit1 slew rate limitation: Off
; 0000 0168 PORTC.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1617,R30
; 0000 0169 // Bit2 Output/Pull configuration: Totempole/No
; 0000 016A // Bit2 Input/Sense configuration: Sense both edges
; 0000 016B // Bit2 inverted: Off
; 0000 016C // Bit2 slew rate limitation: Off
; 0000 016D PORTC.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1618,R30
; 0000 016E // Bit3 Output/Pull configuration: Totempole/No
; 0000 016F // Bit3 Input/Sense configuration: Sense both edges
; 0000 0170 // Bit3 inverted: Off
; 0000 0171 // Bit3 slew rate limitation: Off
; 0000 0172 PORTC.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1619,R30
; 0000 0173 // Bit4 Output/Pull configuration: Totempole/No
; 0000 0174 // Bit4 Input/Sense configuration: Sense both edges
; 0000 0175 // Bit4 inverted: Off
; 0000 0176 // Bit4 slew rate limitation: Off
; 0000 0177 PORTC.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1620,R30
; 0000 0178 // Bit5 Output/Pull configuration: Totempole/No
; 0000 0179 // Bit5 Input/Sense configuration: Sense both edges
; 0000 017A // Bit5 inverted: Off
; 0000 017B // Bit5 slew rate limitation: Off
; 0000 017C PORTC.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1621,R30
; 0000 017D // Bit6 Output/Pull configuration: Totempole/No
; 0000 017E // Bit6 Input/Sense configuration: Sense both edges
; 0000 017F // Bit6 inverted: Off
; 0000 0180 // Bit6 slew rate limitation: Off
; 0000 0181 //PORTC.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
; 0000 0182 // Bit6 Output/Pull configuration: Totempole/Pull-up (on input)
; 0000 0183 // Bit6 Input/Sense configuration: Sense both edges
; 0000 0184 // Bit6 inverted: Off
; 0000 0185 // Bit6 slew rate limitation: Off
; 0000 0186 PORTC.PIN6CTRL=PORT_OPC_PULLUP_gc | PORT_ISC_BOTHEDGES_gc;
	LDI  R30,LOW(24)
	STS  1622,R30
; 0000 0187 
; 0000 0188 // Bit7 Output/Pull configuration: Totempole/No
; 0000 0189 // Bit7 Input/Sense configuration: Sense both edges
; 0000 018A // Bit7 inverted: Off
; 0000 018B // Bit7 slew rate limitation: Off
; 0000 018C PORTC.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	LDI  R30,LOW(0)
	STS  1623,R30
; 0000 018D // Interrupt 0 level: Disabled
; 0000 018E // Interrupt 1 level: Disabled
; 0000 018F PORTC.INTCTRL=(PORTC.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
; 0000 0190 	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
	LDS  R30,1609
	ANDI R30,LOW(0xF0)
	STS  1609,R30
; 0000 0191 // Bit0 pin change interrupt 0: Off
; 0000 0192 // Bit1 pin change interrupt 0: Off
; 0000 0193 // Bit2 pin change interrupt 0: Off
; 0000 0194 // Bit3 pin change interrupt 0: Off
; 0000 0195 // Bit4 pin change interrupt 0: Off
; 0000 0196 // Bit5 pin change interrupt 0: Off
; 0000 0197 // Bit6 pin change interrupt 0: Off
; 0000 0198 // Bit7 pin change interrupt 0: Off
; 0000 0199 PORTC.INT0MASK=0x00;
	LDI  R30,LOW(0)
	STS  1610,R30
; 0000 019A // Bit0 pin change interrupt 1: Off
; 0000 019B // Bit1 pin change interrupt 1: Off
; 0000 019C // Bit2 pin change interrupt 1: Off
; 0000 019D // Bit3 pin change interrupt 1: Off
; 0000 019E // Bit4 pin change interrupt 1: Off
; 0000 019F // Bit5 pin change interrupt 1: Off
; 0000 01A0 // Bit6 pin change interrupt 1: Off
; 0000 01A1 // Bit7 pin change interrupt 1: Off
; 0000 01A2 PORTC.INT1MASK=0x00;
	STS  1611,R30
; 0000 01A3 
; 0000 01A4 // PORTD initialization
; 0000 01A5 // OUT register
; 0000 01A6 PORTD.OUT=0x18;
	LDI  R30,LOW(24)
	STS  1636,R30
; 0000 01A7 // Bit0: Input
; 0000 01A8 // Bit1: Input
; 0000 01A9 // Bit2: Input
; 0000 01AA // Bit3: Output
; 0000 01AB // Bit4: Output
; 0000 01AC // Bit5: Output
; 0000 01AD // Bit6: Input
; 0000 01AE // Bit7: Output
; 0000 01AF PORTD.DIR=0xB8;
	LDI  R30,LOW(184)
	STS  1632,R30
; 0000 01B0 // Bit0 Output/Pull configuration: Totempole/No
; 0000 01B1 // Bit0 Input/Sense configuration: Sense both edges
; 0000 01B2 // Bit0 inverted: Off
; 0000 01B3 // Bit0 slew rate limitation: Off
; 0000 01B4 PORTD.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	LDI  R30,LOW(0)
	STS  1648,R30
; 0000 01B5 // Bit1 Output/Pull configuration: Totempole/No
; 0000 01B6 // Bit1 Input/Sense configuration: Sense both edges
; 0000 01B7 // Bit1 inverted: Off
; 0000 01B8 // Bit1 slew rate limitation: Off
; 0000 01B9 PORTD.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1649,R30
; 0000 01BA // Bit2 Output/Pull configuration: Totempole/No
; 0000 01BB // Bit2 Input/Sense configuration: Sense both edges
; 0000 01BC // Bit2 inverted: Off
; 0000 01BD // Bit2 slew rate limitation: Off
; 0000 01BE PORTD.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1650,R30
; 0000 01BF // Bit3 Output/Pull configuration: Totempole/No
; 0000 01C0 // Bit3 Input/Sense configuration: Sense both edges
; 0000 01C1 // Bit3 inverted: Off
; 0000 01C2 // Bit3 slew rate limitation: Off
; 0000 01C3 PORTD.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1651,R30
; 0000 01C4 // Bit4 Output/Pull configuration: Totempole/No
; 0000 01C5 // Bit4 Input/Sense configuration: Sense both edges
; 0000 01C6 // Bit4 inverted: Off
; 0000 01C7 // Bit4 slew rate limitation: Off
; 0000 01C8 PORTD.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1652,R30
; 0000 01C9 // Bit5 Output/Pull configuration: Totempole/No
; 0000 01CA // Bit5 Input/Sense configuration: Sense both edges
; 0000 01CB // Bit5 inverted: Off
; 0000 01CC // Bit5 slew rate limitation: Off
; 0000 01CD PORTD.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1653,R30
; 0000 01CE // Bit6 Output/Pull configuration: Totempole/No
; 0000 01CF // Bit6 Input/Sense configuration: Sense both edges
; 0000 01D0 // Bit6 inverted: Off
; 0000 01D1 // Bit6 slew rate limitation: Off
; 0000 01D2 PORTD.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1654,R30
; 0000 01D3 // Bit7 Output/Pull configuration: Totempole/No
; 0000 01D4 // Bit7 Input/Sense configuration: Sense both edges
; 0000 01D5 // Bit7 inverted: Off
; 0000 01D6 // Bit7 slew rate limitation: Off
; 0000 01D7 PORTD.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1655,R30
; 0000 01D8 // Interrupt 0 level: Disabled
; 0000 01D9 // Interrupt 1 level: Disabled
; 0000 01DA PORTD.INTCTRL=(PORTD.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
; 0000 01DB 	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
	LDS  R30,1641
	ANDI R30,LOW(0xF0)
	STS  1641,R30
; 0000 01DC // Bit0 pin change interrupt 0: Off
; 0000 01DD // Bit1 pin change interrupt 0: Off
; 0000 01DE // Bit2 pin change interrupt 0: Off
; 0000 01DF // Bit3 pin change interrupt 0: Off
; 0000 01E0 // Bit4 pin change interrupt 0: Off
; 0000 01E1 // Bit5 pin change interrupt 0: Off
; 0000 01E2 // Bit6 pin change interrupt 0: Off
; 0000 01E3 // Bit7 pin change interrupt 0: Off
; 0000 01E4 PORTD.INT0MASK=0x00;
	LDI  R30,LOW(0)
	STS  1642,R30
; 0000 01E5 // Bit0 pin change interrupt 1: Off
; 0000 01E6 // Bit1 pin change interrupt 1: Off
; 0000 01E7 // Bit2 pin change interrupt 1: Off
; 0000 01E8 // Bit3 pin change interrupt 1: Off
; 0000 01E9 // Bit4 pin change interrupt 1: Off
; 0000 01EA // Bit5 pin change interrupt 1: Off
; 0000 01EB // Bit6 pin change interrupt 1: Off
; 0000 01EC // Bit7 pin change interrupt 1: Off
; 0000 01ED PORTD.INT1MASK=0x00;
	STS  1643,R30
; 0000 01EE 
; 0000 01EF // PORTE initialization
; 0000 01F0 // OUT register
; 0000 01F1 PORTE.OUT=0x00;
	STS  1668,R30
; 0000 01F2 // Bit0: Input
; 0000 01F3 // Bit1: Input
; 0000 01F4 // Bit2: Input
; 0000 01F5 // Bit3: Input
; 0000 01F6 PORTE.DIR=0x00;
	STS  1664,R30
; 0000 01F7 // Bit0 Output/Pull configuration: Totempole/No
; 0000 01F8 // Bit0 Input/Sense configuration: Sense both edges
; 0000 01F9 // Bit0 inverted: Off
; 0000 01FA // Bit0 slew rate limitation: Off
; 0000 01FB PORTE.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1680,R30
; 0000 01FC // Bit1 Output/Pull configuration: Totempole/No
; 0000 01FD // Bit1 Input/Sense configuration: Sense both edges
; 0000 01FE // Bit1 inverted: Off
; 0000 01FF // Bit1 slew rate limitation: Off
; 0000 0200 PORTE.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1681,R30
; 0000 0201 // Bit2 Output/Pull configuration: Totempole/No
; 0000 0202 // Bit2 Input/Sense configuration: Sense both edges
; 0000 0203 // Bit2 inverted: Off
; 0000 0204 // Bit2 slew rate limitation: Off
; 0000 0205 PORTE.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1682,R30
; 0000 0206 // Bit3 Output/Pull configuration: Totempole/No
; 0000 0207 // Bit3 Input/Sense configuration: Sense both edges
; 0000 0208 // Bit3 inverted: Off
; 0000 0209 // Bit3 slew rate limitation: Off
; 0000 020A PORTE.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  1683,R30
; 0000 020B // Interrupt 0 level: Disabled
; 0000 020C // Interrupt 1 level: Disabled
; 0000 020D PORTE.INTCTRL=(PORTE.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
; 0000 020E 	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
	LDS  R30,1673
	ANDI R30,LOW(0xF0)
	STS  1673,R30
; 0000 020F // Bit0 pin change interrupt 0: Off
; 0000 0210 // Bit1 pin change interrupt 0: Off
; 0000 0211 // Bit2 pin change interrupt 0: Off
; 0000 0212 // Bit3 pin change interrupt 0: Off
; 0000 0213 PORTE.INT0MASK=0x00;
	LDI  R30,LOW(0)
	STS  1674,R30
; 0000 0214 // Bit0 pin change interrupt 1: Off
; 0000 0215 // Bit1 pin change interrupt 1: Off
; 0000 0216 // Bit2 pin change interrupt 1: Off
; 0000 0217 // Bit3 pin change interrupt 1: Off
; 0000 0218 PORTE.INT1MASK=0x00;
	STS  1675,R30
; 0000 0219 
; 0000 021A // PORTR initialization
; 0000 021B // OUT register
; 0000 021C PORTR.OUT=0x00;
	STS  2020,R30
; 0000 021D // Bit0: Input
; 0000 021E // Bit1: Input
; 0000 021F PORTR.DIR=0x00;
	STS  2016,R30
; 0000 0220 // Bit0 Output/Pull configuration: Totempole/No
; 0000 0221 // Bit0 Input/Sense configuration: Sense both edges
; 0000 0222 // Bit0 inverted: Off
; 0000 0223 // Bit0 slew rate limitation: Off
; 0000 0224 PORTR.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  2032,R30
; 0000 0225 // Bit1 Output/Pull configuration: Totempole/No
; 0000 0226 // Bit1 Input/Sense configuration: Sense both edges
; 0000 0227 // Bit1 inverted: Off
; 0000 0228 // Bit1 slew rate limitation: Off
; 0000 0229 PORTR.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
	STS  2033,R30
; 0000 022A // Interrupt 0 level: Disabled
; 0000 022B // Interrupt 1 level: Disabled
; 0000 022C PORTR.INTCTRL=(PORTR.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
; 0000 022D 	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
	LDS  R30,2025
	ANDI R30,LOW(0xF0)
	STS  2025,R30
; 0000 022E // Bit0 pin change interrupt 0: Off
; 0000 022F // Bit1 pin change interrupt 0: Off
; 0000 0230 PORTR.INT0MASK=0x00;
	LDI  R30,LOW(0)
	STS  2026,R30
; 0000 0231 // Bit0 pin change interrupt 1: Off
; 0000 0232 // Bit1 pin change interrupt 1: Off
; 0000 0233 PORTR.INT1MASK=0x00;
	STS  2027,R30
; 0000 0234 }
	RET
;
;// Virtual Ports initialization
;void vports_init(void)
; 0000 0238 {
_vports_init:
; 0000 0239 // PORTA mapped to VPORT0
; 0000 023A // PORTB mapped to VPORT1
; 0000 023B PORTCFG.VPCTRLA=PORTCFG_VP1MAP_PORTB_gc | PORTCFG_VP0MAP_PORTA_gc;
	LDI  R30,LOW(16)
	STS  178,R30
; 0000 023C // PORTC mapped to VPORT2
; 0000 023D // PORTD mapped to VPORT3
; 0000 023E PORTCFG.VPCTRLB=PORTCFG_VP3MAP_PORTD_gc | PORTCFG_VP2MAP_PORTC_gc;
	LDI  R30,LOW(50)
	STS  179,R30
; 0000 023F }
	RET
;// Disable a Timer/Counter type 0
;void tc0_disable(TC0_t *ptc)
; 0000 0242 {
_tc0_disable:
; 0000 0243 // Timer/Counter off
; 0000 0244 ptc->CTRLA=(ptc->CTRLA & (~TC0_CLKSEL_gm)) | TC_CLKSEL_OFF_gc;
;	*ptc -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	ANDI R30,LOW(0xF0)
	ST   X,R30
; 0000 0245 // Issue a reset command
; 0000 0246 ptc->CTRLFSET=TC_CMD_RESET_gc;
	ADIW R26,9
	LDI  R30,LOW(12)
	RJMP _0x20A000C
; 0000 0247 }
;// Timer/Counter TCC0 initialization
;void tcc0_init(void)
; 0000 024A {
_tcc0_init:
; 0000 024B unsigned char s;
; 0000 024C unsigned char n;
; 0000 024D 
; 0000 024E // Note: the correct PORTC direction for the Compare Channels outputs
; 0000 024F // is configured in the ports_init function
; 0000 0250 
; 0000 0251 // Save interrupts enabled/disabled state
; 0000 0252 s=SREG;
	ST   -Y,R17
	ST   -Y,R16
;	s -> R17
;	n -> R16
	IN   R17,63
; 0000 0253 // Disable interrupts
; 0000 0254 #asm("cli")
	cli
; 0000 0255 
; 0000 0256 // Disable and reset the timer/counter just to be sure
; 0000 0257 tc0_disable(&TCC0);
	LDI  R30,LOW(2048)
	LDI  R31,HIGH(2048)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _tc0_disable
; 0000 0258 // Clock source: Peripheral Clock/1
; 0000 0259 TCC0.CTRLA=(TCC0.CTRLA & (~TC0_CLKSEL_gm)) | TC_CLKSEL_DIV1_gc;
	LDS  R30,2048
	ANDI R30,LOW(0xF0)
	ORI  R30,1
	STS  2048,R30
; 0000 025A // Mode: Normal Operation, Overflow Int./Event on TOP
; 0000 025B // Compare/Capture on channel A: Off
; 0000 025C // Compare/Capture on channel B: Off
; 0000 025D // Compare/Capture on channel C: Off
; 0000 025E // Compare/Capture on channel D: Off
; 0000 025F TCC0.CTRLB=(TCC0.CTRLB & (~(TC0_CCAEN_bm | TC0_CCBEN_bm | TC0_CCCEN_bm | TC0_CCDEN_bm | TC0_WGMODE_gm))) |
; 0000 0260 	TC_WGMODE_NORMAL_gc;
	LDS  R30,2049
	ANDI R30,LOW(0x8)
	STS  2049,R30
; 0000 0261 
; 0000 0262 // Capture event source: None
; 0000 0263 // Capture event action: None
; 0000 0264 TCC0.CTRLD=(TCC0.CTRLD & (~(TC0_EVACT_gm | TC0_EVSEL_gm))) |
; 0000 0265 	TC_EVACT_OFF_gc | TC_EVSEL_OFF_gc;
	LDS  R30,2051
	ANDI R30,LOW(0x10)
	STS  2051,R30
; 0000 0266 
; 0000 0267 // Overflow interrupt: Low Level
; 0000 0268 // Error interrupt: Disabled
; 0000 0269 TCC0.INTCTRLA=(TCC0.INTCTRLA & (~(TC0_ERRINTLVL_gm | TC0_OVFINTLVL_gm))) |
; 0000 026A 	TC_ERRINTLVL_OFF_gc | TC_OVFINTLVL_LO_gc;
	LDS  R30,2054
	ANDI R30,LOW(0xF0)
	ORI  R30,1
	STS  2054,R30
; 0000 026B 
; 0000 026C // Compare/Capture channel A interrupt: Disabled
; 0000 026D // Compare/Capture channel B interrupt: Disabled
; 0000 026E // Compare/Capture channel C interrupt: Disabled
; 0000 026F // Compare/Capture channel D interrupt: Disabled
; 0000 0270 TCC0.INTCTRLB=(TCC0.INTCTRLB & (~(TC0_CCDINTLVL_gm | TC0_CCCINTLVL_gm | TC0_CCBINTLVL_gm | TC0_CCAINTLVL_gm))) |
; 0000 0271 	TC_CCDINTLVL_OFF_gc | TC_CCCINTLVL_OFF_gc | TC_CCBINTLVL_OFF_gc | TC_CCAINTLVL_OFF_gc;
	LDS  R30,2055
	ANDI R30,LOW(0x0)
	STS  2055,R30
; 0000 0272 
; 0000 0273 // High resolution extension: Off
; 0000 0274 HIRESC.CTRL&= ~HIRES_HREN0_bm;
	LDS  R30,2192
	ANDI R30,0xFE
	STS  2192,R30
; 0000 0275 
; 0000 0276 // Advanced Waveform Extension initialization
; 0000 0277 // Optimize for speed
; 0000 0278 #pragma optsize-
; 0000 0279 // Disable locking the AWEX configuration registers just to be sure
; 0000 027A n=MCU.AWEXLOCK & (~MCU_AWEXCLOCK_bm);
	LDS  R30,153
	ANDI R30,0xFE
	MOV  R16,R30
; 0000 027B CCP=CCP_IOREG_gc;
	LDI  R30,LOW(216)
	OUT  0x34,R30
; 0000 027C MCU.AWEXLOCK=n;
	STS  153,R16
; 0000 027D // Restore optimization for size if needed
; 0000 027E #pragma optsize_default
; 0000 027F 
; 0000 0280 // Pattern generation: Off
; 0000 0281 // Dead time insertion: Off
; 0000 0282 AWEXC.CTRL&= ~(AWEX_PGM_bm | AWEX_CWCM_bm | AWEX_DTICCDEN_bm | AWEX_DTICCCEN_bm | AWEX_DTICCBEN_bm | AWEX_DTICCAEN_bm);
	LDS  R30,2176
	ANDI R30,LOW(0xC0)
	STS  2176,R30
; 0000 0283 
; 0000 0284 // Fault protection initialization
; 0000 0285 // Fault detection on OCD Break detection: On
; 0000 0286 // Fault detection restart mode: Latched Mode
; 0000 0287 // Fault detection action: None (Fault protection disabled)
; 0000 0288 AWEXC.FDCTRL=(AWEXC.FDCTRL & (~(AWEX_FDDBD_bm | AWEX_FDMODE_bm | AWEX_FDACT_gm))) |
; 0000 0289 	AWEX_FDACT_NONE_gc;
	LDS  R30,2179
	ANDI R30,LOW(0xE8)
	STS  2179,R30
; 0000 028A // Fault detect events:
; 0000 028B // Event channel 0: Off
; 0000 028C // Event channel 1: Off
; 0000 028D // Event channel 2: Off
; 0000 028E // Event channel 3: Off
; 0000 028F // Event channel 4: Off
; 0000 0290 // Event channel 5: Off
; 0000 0291 // Event channel 6: Off
; 0000 0292 // Event channel 7: Off
; 0000 0293 AWEXC.FDEVMASK=0b00000000;
	LDI  R30,LOW(0)
	STS  2178,R30
; 0000 0294 // Make sure the fault detect flag is cleared
; 0000 0295 AWEXC.STATUS|=AWEXC.STATUS & AWEX_FDF_bm;
	LDI  R26,LOW(2180)
	LDI  R27,HIGH(2180)
	MOV  R0,R26
	LD   R26,X
	LDS  R30,2180
	ANDI R30,LOW(0x4)
	OR   R30,R26
	MOV  R26,R0
	ST   X,R30
; 0000 0296 
; 0000 0297 // Clear the interrupt flags
; 0000 0298 TCC0.INTFLAGS=TCC0.INTFLAGS;
	LDS  R30,2060
	STS  2060,R30
; 0000 0299 // Set counter register
; 0000 029A TCC0.CNT=0x0000;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  2080,R30
	STS  2080+1,R31
; 0000 029B // Set period register
; 0000 029C TCC0.PER=0x4E1F;
	LDI  R30,LOW(19999)
	LDI  R31,HIGH(19999)
	STS  2086,R30
	STS  2086+1,R31
; 0000 029D // Set channel A Compare/Capture register
; 0000 029E TCC0.CCA=0x0000;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  2088,R30
	STS  2088+1,R31
; 0000 029F // Set channel B Compare/Capture register
; 0000 02A0 TCC0.CCB=0x0000;
	STS  2090,R30
	STS  2090+1,R31
; 0000 02A1 // Set channel C Compare/Capture register
; 0000 02A2 TCC0.CCC=0x0000;
	STS  2092,R30
	STS  2092+1,R31
; 0000 02A3 // Set channel D Compare/Capture register
; 0000 02A4 TCC0.CCD=0x0000;
	STS  2094,R30
	STS  2094+1,R31
; 0000 02A5 
; 0000 02A6 // Restore interrupts enabled/disabled state
; 0000 02A7 SREG=s;
	OUT  0x3F,R17
; 0000 02A8 }
	RJMP _0x20A0007
;
;// Timer/counter TCC0 Overflow/Underflow interrupt service routine
;interrupt [TCC0_OVF_vect] void tcc0_overflow_isr(void)
; 0000 02AC {
_tcc0_overflow_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 02AD // write your code here
; 0000 02AE     ten_ms++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 02AF     if(ten_ms>128) //128
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x7
; 0000 02B0     {
; 0000 02B1         ten_ms=0;
	CLR  R8
	CLR  R9
; 0000 02B2     }
; 0000 02B3 }
_0x7:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;// RTC initialization
;
;unsigned long int RTC_sec=0;
;bit RTC_flag=0;
;
;void rtcxm_init(void)
; 0000 02BB {
_rtcxm_init:
; 0000 02BC unsigned char s;
; 0000 02BD 
; 0000 02BE // RTC clock source: 1024 Hz from internal 32 kHz RC Oscillator
; 0000 02BF // Internal 32 kHz RC oscillator initialization
; 0000 02C0 // Enable the internal 32 kHz RC oscillator
; 0000 02C1 OSC.CTRL|=OSC_RC32KEN_bm;
	ST   -Y,R17
;	s -> R17
	LDS  R30,80
	ORI  R30,4
	STS  80,R30
; 0000 02C2 // Wait for the internal 32 kHz RC oscillator to stabilize
; 0000 02C3 while ((OSC.STATUS & OSC_RC32KRDY_bm)==0);
_0x8:
	LDS  R30,81
	ANDI R30,LOW(0x4)
	BREQ _0x8
; 0000 02C4 
; 0000 02C5 // Select the clock source and enable the RTC clock
; 0000 02C6 CLK.RTCCTRL=(CLK.RTCCTRL & (~CLK_RTCSRC_gm)) | CLK_RTCSRC_RCOSC_gc | CLK_RTCEN_bm;
	LDS  R30,67
	ANDI R30,LOW(0xF1)
	ORI  R30,LOW(0x5)
	STS  67,R30
; 0000 02C7 // Make sure that the RTC is stopped before initializing it
; 0000 02C8 RTC.CTRL=(RTC.CTRL & (~RTC_PRESCALER_gm)) | RTC_PRESCALER_OFF_gc;
	LDS  R30,1024
	ANDI R30,LOW(0xF8)
	STS  1024,R30
; 0000 02C9 
; 0000 02CA // Optimize for speed
; 0000 02CB #pragma optsize-
; 0000 02CC // Save interrupts enabled/disabled state
; 0000 02CD s=SREG;
	IN   R17,63
; 0000 02CE // Disable interrupts
; 0000 02CF #asm("cli")
	cli
; 0000 02D0 
; 0000 02D1 // Wait until the RTC is not busy
; 0000 02D2 while (RTC.STATUS & RTC_SYNCBUSY_bm);
_0xB:
	LDS  R30,1025
	ANDI R30,LOW(0x1)
	BRNE _0xB
; 0000 02D3 // Set the RTC period register
; 0000 02D4 RTC.PER=0x0400;
	LDI  R30,LOW(1024)
	LDI  R31,HIGH(1024)
	STS  1034,R30
	STS  1034+1,R31
; 0000 02D5 // Set the RTC count register
; 0000 02D6 RTC.CNT=0x0000;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  1032,R30
	STS  1032+1,R31
; 0000 02D7 // Set the RTC compare register
; 0000 02D8 RTC.COMP=0x0000;
	STS  1036,R30
	STS  1036+1,R31
; 0000 02D9 
; 0000 02DA // Restore interrupts enabled/disabled state
; 0000 02DB SREG=s;
	OUT  0x3F,R17
; 0000 02DC // Restore optimization for size if needed
; 0000 02DD #pragma optsize_default
; 0000 02DE 
; 0000 02DF // Set the clock prescaler: RTC Clock/1
; 0000 02E0 // and start the RTC
; 0000 02E1 RTC.CTRL=(RTC.CTRL & (~RTC_PRESCALER_gm)) | RTC_PRESCALER_DIV1_gc;
	LDS  R30,1024
	ANDI R30,LOW(0xF8)
	ORI  R30,1
	STS  1024,R30
; 0000 02E2 
; 0000 02E3 // RTC overflow interrupt: Low Level
; 0000 02E4 // RTC compare interrupt: Disabled
; 0000 02E5 RTC.INTCTRL=(RTC.INTCTRL & (~(RTC_OVFINTLVL_gm | RTC_COMPINTLVL_gm))) |
; 0000 02E6 	RTC_OVFINTLVL_LO_gc | RTC_COMPINTLVL_OFF_gc;
	LDS  R30,1026
	ANDI R30,LOW(0xF0)
	ORI  R30,1
	STS  1026,R30
; 0000 02E7 }
	LD   R17,Y+
	RET
;
;// RTC overflow interrupt service routine
;interrupt [RTC_OVF_vect] void rtcxm_overflow_isr(void)
; 0000 02EB {
_rtcxm_overflow_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 02EC // write your code here
; 0000 02ED     RTC_flag=1;
	SBI  0x0,1
; 0000 02EE     RTC_sec++;
	LDI  R26,LOW(_RTC_sec)
	LDI  R27,HIGH(_RTC_sec)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0000 02EF }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
;
;// Disable an USART
;void usart_disable(USART_t *pu)
; 0000 02F3 {
_usart_disable:
; 0000 02F4 // Rx and Tx are off
; 0000 02F5 pu->CTRLB=0;
;	*pu -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,4
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 02F6 // Ensure that all interrupts generated by the USART are off
; 0000 02F7 pu->CTRLA=0;
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,3
_0x20A000C:
	ST   X,R30
; 0000 02F8 }
	ADIW R28,2
	RET
;
;// USARTD0 initialization
;void usartd0_init(void)
; 0000 02FC {
_usartd0_init:
; 0000 02FD // Note: the correct PORTD direction for the RxD, TxD and XCK signals
; 0000 02FE // is configured in the ports_init function
; 0000 02FF 
; 0000 0300 // Transmitter is enabled
; 0000 0301 // Set TxD=1
; 0000 0302 PORTD.OUTSET=0x08;
	LDI  R30,LOW(8)
	STS  1637,R30
; 0000 0303 
; 0000 0304 // Communication mode: Asynchronous USART
; 0000 0305 // Data bits: 8
; 0000 0306 // Stop bits: 1
; 0000 0307 // Parity: Disabled
; 0000 0308 USARTD0.CTRLC=USART_CMODE_ASYNCHRONOUS_gc | USART_PMODE_DISABLED_gc | USART_CHSIZE_8BIT_gc;
	LDI  R30,LOW(3)
	STS  2469,R30
; 0000 0309 
; 0000 030A // Receive complete interrupt: Low Level
; 0000 030B // Transmit complete interrupt: Disabled
; 0000 030C // Data register empty interrupt: Disabled
; 0000 030D USARTD0.CTRLA=(USARTD0.CTRLA & (~(USART_RXCINTLVL_gm | USART_TXCINTLVL_gm | USART_DREINTLVL_gm))) |
; 0000 030E 	USART_RXCINTLVL_LO_gc | USART_TXCINTLVL_OFF_gc | USART_DREINTLVL_OFF_gc;
	LDS  R30,2467
	ANDI R30,LOW(0xC0)
	ORI  R30,0x10
	STS  2467,R30
; 0000 030F 
; 0000 0310 // Required Baud rate: 115200
; 0000 0311 // Real Baud Rate: 115107.9 (x1 Mode), Error: 0.1 %
; 0000 0312 USARTD0.BAUDCTRLA=0x0B;
	LDI  R30,LOW(11)
	STS  2470,R30
; 0000 0313 USARTD0.BAUDCTRLB=((0x09 << USART_BSCALE_bp) & USART_BSCALE_gm) | 0x00;
	LDI  R30,LOW(144)
	STS  2471,R30
; 0000 0314 
; 0000 0315 // Receiver: On
; 0000 0316 // Transmitter: On
; 0000 0317 // Double transmission speed mode: Off
; 0000 0318 // Multi-processor communication mode: Off
; 0000 0319 USARTD0.CTRLB=(USARTD0.CTRLB & (~(USART_RXEN_bm | USART_TXEN_bm | USART_CLK2X_bm | USART_MPCM_bm | USART_TXB8_bm))) |
; 0000 031A 	USART_RXEN_bm | USART_TXEN_bm;
	LDS  R30,2468
	ANDI R30,LOW(0xE0)
	ORI  R30,LOW(0x18)
	STS  2468,R30
; 0000 031B }
	RET
;
;// USARTD0 Receiver buffer
;#define RX_BUFFER_SIZE_USARTD0 8
;char rx_buffer_usartd0[RX_BUFFER_SIZE_USARTD0];
;
;#if RX_BUFFER_SIZE_USARTD0 <= 256
;unsigned char rx_wr_index_usartd0=0,rx_rd_index_usartd0=0,rx_counter_usartd0=0;
;#else
;unsigned int rx_wr_index_usartd0=0,rx_rd_index_usartd0=0,rx_counter_usartd0=0;
;#endif
;
;// This flag is set on USARTD0 Receiver buffer overflow
;bit rx_buffer_overflow_usartd0=0, command_flag=0;
;unsigned char command[31];  // 명령어 버퍼
;unsigned char command_size=0;         // 버퍼주소
;
;// USARTD0 Receiver interrupt service routine
;interrupt [USARTD0_RXC_vect] void usartd0_rx_isr(void)
; 0000 032E {
_usartd0_rx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 032F unsigned char status;
; 0000 0330 char data;
; 0000 0331 
; 0000 0332 status=USARTD0.STATUS;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,2465
; 0000 0333 data=USARTD0.DATA;
	LDS  R16,2464
; 0000 0334 if ((status & (USART_FERR_bm | USART_PERR_bm | USART_BUFOVF_bm)) == 0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x10
; 0000 0335    {
; 0000 0336    rx_buffer_usartd0[rx_wr_index_usartd0++]=data;
	LDS  R30,_rx_wr_index_usartd0
	SUBI R30,-LOW(1)
	STS  _rx_wr_index_usartd0,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer_usartd0)
	SBCI R31,HIGH(-_rx_buffer_usartd0)
	ST   Z,R16
; 0000 0337 #if RX_BUFFER_SIZE_USARTD0 == 256
; 0000 0338    // special case for receiver buffer size=256
; 0000 0339    if (++rx_counter_usartd0 == 0)
; 0000 033A       {
; 0000 033B #else
; 0000 033C    if (rx_wr_index_usartd0 == RX_BUFFER_SIZE_USARTD0) rx_wr_index_usartd0=0;
	LDS  R26,_rx_wr_index_usartd0
	CPI  R26,LOW(0x8)
	BRNE _0x11
	LDI  R30,LOW(0)
	STS  _rx_wr_index_usartd0,R30
; 0000 033D    if (++rx_counter_usartd0 == RX_BUFFER_SIZE_USARTD0)
_0x11:
	LDS  R26,_rx_counter_usartd0
	SUBI R26,-LOW(1)
	STS  _rx_counter_usartd0,R26
	CPI  R26,LOW(0x8)
	BRNE _0x12
; 0000 033E       {
; 0000 033F       rx_counter_usartd0=0;
	LDI  R30,LOW(0)
	STS  _rx_counter_usartd0,R30
; 0000 0340 #endif
; 0000 0341       rx_buffer_overflow_usartd0=1;
	SBI  0x0,2
; 0000 0342       }
; 0000 0343    }
_0x12:
; 0000 0344     command[command_size]=data;
_0x10:
	CALL SUBOPT_0x0
	ST   Z,R16
; 0000 0345     if(data=='>')
	CPI  R16,62
	BRNE _0x15
; 0000 0346     {
; 0000 0347         command_flag=1;
	SBI  0x0,3
; 0000 0348         command_size=0;
	LDI  R30,LOW(0)
	STS  _command_size,R30
; 0000 0349     }
; 0000 034A     if(command_size>=30) command_size=0;
_0x15:
	LDS  R26,_command_size
	CPI  R26,LOW(0x1E)
	BRLO _0x18
	LDI  R30,LOW(0)
	RJMP _0xCA
; 0000 034B     else command_size++;
_0x18:
	LDS  R30,_command_size
	SUBI R30,-LOW(1)
_0xCA:
	STS  _command_size,R30
; 0000 034C }
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;// Receive a character from USARTD0
;// USARTD0 is used as the default input device by the 'getchar' function
;#define _ALTERNATE_GETCHAR_
;
;#pragma used+
;char getchar(void)
; 0000 0354 {
; 0000 0355 char data;
; 0000 0356 
; 0000 0357 while (rx_counter_usartd0==0);
;	data -> R17
; 0000 0358 data=rx_buffer_usartd0[rx_rd_index_usartd0++];
; 0000 0359 #if RX_BUFFER_SIZE_USARTD0 != 256
; 0000 035A if (rx_rd_index_usartd0 == RX_BUFFER_SIZE_USARTD0) rx_rd_index_usartd0=0;
; 0000 035B #endif
; 0000 035C #asm("cli")
; 0000 035D --rx_counter_usartd0;
; 0000 035E #asm("sei")
; 0000 035F return data;
; 0000 0360 }
;#pragma used-
;
;// Write a character to the USARTD0 Transmitter
;// USARTD0 is used as the default output device by the 'putchar' function
;#define _ALTERNATE_PUTCHAR_
;
;#pragma used+
;void putchar(char c)
; 0000 0369 {
_putchar:
; 0000 036A while ((USARTD0.STATUS & USART_DREIF_bm) == 0);
;	c -> Y+0
_0x1E:
	LDS  R30,2465
	ANDI R30,LOW(0x20)
	BREQ _0x1E
; 0000 036B USARTD0.DATA=c;
	LD   R30,Y
	STS  2464,R30
; 0000 036C }
	RJMP _0x20A000A
;#pragma used-
;
;// SPIC initialization
;void spic_init(void)
; 0000 0371 {
_spic_init:
; 0000 0372 // SPIC is enabled
; 0000 0373 // SPI mode: 0
; 0000 0374 // Operating as: Master
; 0000 0375 // Data order: MSB First
; 0000 0376 // SCK clock prescaler: 4
; 0000 0377 // SCK clock doubled: On
; 0000 0378 // SCK clock frequency: 1000.000 kHz
; 0000 0379 SPIC.CTRL=SPI_ENABLE_bm | SPI_MODE_0_gc | SPI_MASTER_bm |
; 0000 037A 	SPI_PRESCALER_DIV4_gc | SPI_CLK2X_bm;
	LDI  R30,LOW(208)
	STS  2240,R30
; 0000 037B 
; 0000 037C // SPIC interrupt: Disabled
; 0000 037D SPIC.INTCTRL=(SPIC.INTCTRL & (~SPI_INTLVL_gm)) | SPI_INTLVL_OFF_gc;
	LDS  R30,2241
	ANDI R30,LOW(0xFC)
	STS  2241,R30
; 0000 037E 
; 0000 037F // Note: the MOSI (PORTC Bit 5), SCK (PORTC Bit 7) and
; 0000 0380 // /SS (PORTC Bit 4) signals are configured as outputs in the ports_init function
; 0000 0381 }
	RET
;
;// Macro used to drive the SPIC /SS signal low in order to select the slave
;#define SET_SPIC_SS_LOW {PORTC.OUTCLR=SPI_SS_bm;}
;// Macro used to drive the SPIC /SS signal high in order to deselect the slave
;#define SET_SPIC_SS_HIGH {PORTC.OUTSET=SPI_SS_bm;}
;
;// SPIC transmit/receive function in Master mode
;// c - data to be transmitted
;// Returns the received data
;#pragma used+
;unsigned char SPI1_Write(unsigned char c)
; 0000 038D {
_SPI1_Write:
; 0000 038E // Transmit data in Master mode
; 0000 038F SPIC.DATA=c;
;	c -> Y+0
	LD   R30,Y
	STS  2243,R30
; 0000 0390 // Wait for the data to be transmitted/received
; 0000 0391 while ((SPIC.STATUS & SPI_IF_bm)==0);
_0x21:
	LDS  R30,2242
	ANDI R30,LOW(0x80)
	BREQ _0x21
; 0000 0392 // Return the received data
; 0000 0393 return SPIC.DATA;
	LDS  R30,2243
	RJMP _0x20A000A
; 0000 0394 }
;#pragma used-
;
;// SPID initialization
;void spid_init(void)
; 0000 0399 {
_spid_init:
; 0000 039A // SPID is enabled
; 0000 039B // SPI mode: 0
; 0000 039C // Operating as: Master
; 0000 039D // Data order: MSB First
; 0000 039E // SCK clock prescaler: 4
; 0000 039F // SCK clock doubled: On
; 0000 03A0 // SCK clock frequency: 1000.000 kHz
; 0000 03A1 SPID.CTRL=SPI_ENABLE_bm | SPI_MODE_0_gc | SPI_MASTER_bm |
; 0000 03A2 	SPI_PRESCALER_DIV4_gc | SPI_CLK2X_bm;
	LDI  R30,LOW(208)
	STS  2496,R30
; 0000 03A3 
; 0000 03A4 // SPID interrupt: Disabled
; 0000 03A5 SPID.INTCTRL=(SPID.INTCTRL & (~SPI_INTLVL_gm)) | SPI_INTLVL_OFF_gc;
	LDS  R30,2497
	ANDI R30,LOW(0xFC)
	STS  2497,R30
; 0000 03A6 
; 0000 03A7 // Note: the MOSI (PORTD Bit 5), SCK (PORTD Bit 7) and
; 0000 03A8 // /SS (PORTD Bit 4) signals are configured as outputs in the ports_init function
; 0000 03A9 }
	RET
;
;// Macro used to drive the SPID /SS signal low in order to select the slave
;#define SET_SPID_SS_LOW {PORTD.OUTCLR=SPI_SS_bm;}
;// Macro used to drive the SPID /SS signal high in order to deselect the slave
;#define SET_SPID_SS_HIGH {PORTD.OUTSET=SPI_SS_bm;}
;
;// SPID transmit/receive function in Master mode
;// c - data to be transmitted
;// Returns the received data
;#pragma used+
;unsigned char spid_master_tx_rx(unsigned char c)
; 0000 03B5 {
_spid_master_tx_rx:
; 0000 03B6 // Transmit data in Master mode
; 0000 03B7 SPID.DATA=c;
;	c -> Y+0
	LD   R30,Y
	STS  2499,R30
; 0000 03B8 // Wait for the data to be transmitted/received
; 0000 03B9 while ((SPID.STATUS & SPI_IF_bm)==0);
_0x24:
	LDS  R30,2498
	ANDI R30,LOW(0x80)
	BREQ _0x24
; 0000 03BA // Return the received data
; 0000 03BB return SPID.DATA;
	LDS  R30,2499
	RJMP _0x20A000A
; 0000 03BC }
;#pragma used-
;////////////////////////////////////////////////////////////////////OSD Driver//////////////////////////////////////////////////////////////////////////////
;void MAX7456_SPI_WRITE(unsigned short ADDRESS, unsigned short DATA){
; 0000 03BF void MAX7456_SPI_WRITE(unsigned short ADDRESS, unsigned short DATA){
_MAX7456_SPI_WRITE:
; 0000 03C0   SET_SPIC_SS_LOW            //OSD_CS = 0;                // Selecting the OSD click
;	ADDRESS -> Y+2
;	DATA -> Y+0
	CALL SUBOPT_0x1
; 0000 03C1   delay_us(1);               //
; 0000 03C2   SPI1_Write(ADDRESS);       // Send the ADDRESS of registe in which you wish to wite DATA
; 0000 03C3   SPI1_Write(DATA);          // Send the DATA which you wish to wite
	LD   R30,Y
	ST   -Y,R30
	RCALL _SPI1_Write
; 0000 03C4   delay_us(1);               //
	CALL SUBOPT_0x2
; 0000 03C5   SET_SPIC_SS_HIGH           //OSD_CS = 1;                // Deselecting the OSD click
; 0000 03C6   delay_us(10);
; 0000 03C7 }
	RJMP _0x20A0006
;unsigned short MAX7456_SPI_READ(unsigned short ADDRESS){
; 0000 03C8 unsigned short MAX7456_SPI_READ(unsigned short ADDRESS){
_MAX7456_SPI_READ:
; 0000 03C9 unsigned short temp;
; 0000 03CA   SET_SPIC_SS_LOW            //OSD_CS = 0;                // Selecting the OSD click
	ST   -Y,R17
	ST   -Y,R16
;	ADDRESS -> Y+2
;	temp -> R16,R17
	CALL SUBOPT_0x1
; 0000 03CB   delay_us(1);               //
; 0000 03CC   SPI1_Write(ADDRESS);       // Send the ADDRESS of registe from which you wish to read DATA
; 0000 03CD   delay_us(1);               //
	__DELAY_USB 1
; 0000 03CE   temp  = SPI1_Write(0);     //SPI1_Read(0);      // Read the register DATA
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _SPI1_Write
	MOV  R16,R30
	CLR  R17
; 0000 03CF   SET_SPIC_SS_HIGH           //OSD_CS = 1;                // Deselecting the OSD click
	LDI  R30,LOW(16)
	STS  1605,R30
; 0000 03D0   delay_us(20);
	__DELAY_USB 13
; 0000 03D1 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0006
;
;void MAX7456_init(){
; 0000 03D3 void MAX7456_init(){
_MAX7456_init:
; 0000 03D4 unsigned short temp;
; 0000 03D5   MAX7456_SPI_WRITE(0x00, 0x0C);   // Setup Video Mode 0 register
	ST   -Y,R17
	ST   -Y,R16
;	temp -> R16,R17
	CALL SUBOPT_0x3
; 0000 03D6   temp  = MAX7456_SPI_READ(0xEC);  // Read OSD Black Level register
	LDI  R30,LOW(236)
	LDI  R31,HIGH(236)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _MAX7456_SPI_READ
	MOVW R16,R30
; 0000 03D7   temp&= 0xEF;
	__ANDWRN 16,17,239
; 0000 03D8   MAX7456_SPI_WRITE(0x6C, temp);  // Setup OSD Black Level register
	LDI  R30,LOW(108)
	LDI  R31,HIGH(108)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RCALL _MAX7456_SPI_WRITE
; 0000 03D9   MAX7456_SPI_WRITE(0x04, 0x04);  // Setup Display Memory Mode register
	CALL SUBOPT_0x4
	CALL SUBOPT_0x4
	RCALL _MAX7456_SPI_WRITE
; 0000 03DA   MAX7456_SPI_WRITE(0x02, 0x26);  // Horizotal offset for ~1/2 of character
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	CALL SUBOPT_0x5
; 0000 03DB }
	RJMP _0x20A0007
;
;void MAX7456_Write(unsigned short x, unsigned short y, unsigned short symbol)
; 0000 03DE   {
_MAX7456_Write:
; 0000 03DF   SET_SPIC_SS_LOW                 //OSD_CS = 0;                     // Selecting the OSD click
;	x -> Y+4
;	y -> Y+2
;	symbol -> Y+0
	LDI  R30,LOW(16)
	STS  1606,R30
; 0000 03E0   delay_us(1);                    //
	__DELAY_USB 1
; 0000 03E1   SPI1_Write(0x05);               // Address to Display Memory Address High
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _SPI1_Write
; 0000 03E2   if( ( x * 30 + y ) <= 255 )
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(30)
	CALL __MULB1W2U
	CALL SUBOPT_0x6
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRSH _0x27
; 0000 03E3     SPI1_Write(0);                // For first 255 matrix positions Write 0
	LDI  R30,LOW(0)
	RJMP _0xCB
; 0000 03E4   else
_0x27:
; 0000 03E5     SPI1_Write(1);                // For the rest of matrix positions Write 1
	LDI  R30,LOW(1)
_0xCB:
	ST   -Y,R30
	RCALL _SPI1_Write
; 0000 03E6   delay_us(1);
	CALL SUBOPT_0x2
; 0000 03E7   SET_SPIC_SS_HIGH                //OSD_CS = 1;                     // Deselecting the OSD click
; 0000 03E8   delay_us(10);
; 0000 03E9 
; 0000 03EA   MAX7456_SPI_WRITE(0x06, x * 30 + y );  // Set position in display matrix(16x30)
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(30)
	CALL __MULB1W2U
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x5
; 0000 03EB   MAX7456_SPI_WRITE(0x07, symbol);       // Set character on selected position
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x5
; 0000 03EC }
	ADIW R28,6
	RET
;////////////////////////////////////////////////function////////////////////////////////////////////////////////////////////////////////////////////////////
;void com_reset(void)                        // 명령어버퍼 초기화
; 0000 03EF {
_com_reset:
; 0000 03F0    for(command_size=30 ; command_size>0; command_size--) command[command_size]=NULL;
	LDI  R30,LOW(30)
	STS  _command_size,R30
_0x2A:
	LDS  R26,_command_size
	CPI  R26,LOW(0x1)
	BRLO _0x2B
	CALL SUBOPT_0x0
	LDI  R26,LOW(0)
	STD  Z+0,R26
	LDS  R30,_command_size
	SUBI R30,LOW(1)
	STS  _command_size,R30
	RJMP _0x2A
_0x2B:
; 0000 03F1 command_flag=0;
	CBI  0x0,3
; 0000 03F2 }
	RET
;void check(void)                             // 동작체크
; 0000 03F4 {
_check:
; 0000 03F5     static int a=0;
; 0000 03F6     MAX7456_Write(row_pointer,  col_pointer, OSDchr['C']);
	ST   -Y,R5
	ST   -Y,R4
	ST   -Y,R3
	ST   -Y,R2
	__GETB1MN _OSDchr,67
	CALL SUBOPT_0x7
; 0000 03F7     MAX7456_Write(row_pointer+2,  col_pointer+2, OSDchr['K']);
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R2
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _OSDchr,75
	CALL SUBOPT_0x7
; 0000 03F8     MAX7456_Write(row_pointer+1,  col_pointer+1, OSDchr['0'+a]);
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R2
	ADIW R30,1
	CALL SUBOPT_0x8
	CALL SUBOPT_0x7
; 0000 03F9     MAX7456_Write(row_pointer+3,  col_pointer+3, OSDchr['0'+a]);
	ADIW R30,3
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R2
	ADIW R30,3
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 03FA     if(a>=9)
	LDS  R26,_a_S0000018000
	LDS  R27,_a_S0000018000+1
	SBIW R26,9
	BRLT _0x2E
; 0000 03FB     a=0;
	LDI  R30,LOW(0)
	STS  _a_S0000018000,R30
	STS  _a_S0000018000+1,R30
; 0000 03FC     else
	RJMP _0x2F
_0x2E:
; 0000 03FD     a++;
	LDS  R30,_a_S0000018000
	LDS  R31,_a_S0000018000+1
	ADIW R30,1
	STS  _a_S0000018000,R30
	STS  _a_S0000018000+1,R31
; 0000 03FE     puts("CHECK!\r");
_0x2F:
	__POINTW1MN _0x30,0
	RJMP _0x20A000B
; 0000 03FF }

	.DSEG
_0x30:
	.BYTE 0x8
;void clear(void)
; 0000 0401 {

	.CSEG
_clear:
; 0000 0402     MAX7456_SPI_WRITE(0x04, 0x04);         // RAM초기화(화면초기화)
	CALL SUBOPT_0x4
	CALL SUBOPT_0x4
	RCALL _MAX7456_SPI_WRITE
; 0000 0403     puts("CLEAR!\r");
	__POINTW1MN _0x31,0
	RJMP _0x20A000B
; 0000 0404 }

	.DSEG
_0x31:
	.BYTE 0x8
;void on(void)
; 0000 0406 {

	.CSEG
_on:
; 0000 0407     MAX7456_SPI_WRITE(0x00, 0x0c);         // OSD ON
	CALL SUBOPT_0x3
; 0000 0408     puts("OSD ON!\r");
	__POINTW1MN _0x32,0
	RJMP _0x20A000B
; 0000 0409 }

	.DSEG
_0x32:
	.BYTE 0x9
;void off(void)
; 0000 040B {

	.CSEG
_off:
; 0000 040C     MAX7456_SPI_WRITE(0x00, 0x04);         // OSD OFF
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x4
	RCALL _MAX7456_SPI_WRITE
; 0000 040D     puts("OSD OFF!\r");
	__POINTW1MN _0x33,0
_0x20A000B:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _puts
; 0000 040E }
	RET

	.DSEG
_0x33:
	.BYTE 0xA
;void col(char value)                        // 가로 몇번째 칸에 쓸것인지 결정(1~27)
; 0000 0410 {

	.CSEG
_col:
; 0000 0411     if(value=='0')                                          // 1~9 칸 중
;	value -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x30)
	BRNE _0x34
; 0000 0412     {
; 0000 0413         col_pointer=(int)(command[4]-'0');                  // 포인터값에 왼쪽부터 몇번째칸인지 지정
	CALL SUBOPT_0xA
	MOVW R2,R30
; 0000 0414     }
; 0000 0415     else if(value=='1')                                     // 10~19 칸 중
	RJMP _0x35
_0x34:
	LD   R26,Y
	CPI  R26,LOW(0x31)
	BRNE _0x36
; 0000 0416     {
; 0000 0417         col_pointer=(int)(command[4]-'0'+10);
	CALL SUBOPT_0xA
	ADIW R30,10
	MOVW R2,R30
; 0000 0418     }
; 0000 0419     else if(value=='2')                                     // 20~27 칸 중
	RJMP _0x37
_0x36:
	LD   R26,Y
	CPI  R26,LOW(0x32)
	BRNE _0x38
; 0000 041A     {
; 0000 041B         if(command[4]>'7') puts("range of column is 1~27\r");
	__GETB2MN _command,4
	CPI  R26,LOW(0x38)
	BRLO _0x39
	__POINTW1MN _0x3A,0
	CALL SUBOPT_0xB
; 0000 041C         else
	RJMP _0x3B
_0x39:
; 0000 041D         col_pointer=((int)command[4]-'0'+20);
	CALL SUBOPT_0xA
	ADIW R30,20
	MOVW R2,R30
; 0000 041E     }
_0x3B:
; 0000 041F     else puts("range of column is 1~27\r");
	RJMP _0x3C
_0x38:
	__POINTW1MN _0x3A,25
	CALL SUBOPT_0xB
; 0000 0420     puts("Col Pointer : ");
_0x3C:
_0x37:
_0x35:
	__POINTW1MN _0x3A,50
	CALL SUBOPT_0xB
; 0000 0421     putchar('0'+col_pointer/100);
	MOVW R26,R2
	CALL SUBOPT_0xC
; 0000 0422     putchar('0'+col_pointer%100/10);
	MOVW R26,R2
	CALL SUBOPT_0xD
; 0000 0423     putchar('0'+col_pointer%10);
	MOVW R26,R2
	CALL SUBOPT_0xE
; 0000 0424     puts("\r");
	__POINTW1MN _0x3A,65
	RJMP _0x20A0009
; 0000 0425 }

	.DSEG
_0x3A:
	.BYTE 0x43
;void row(char value)                                        // 세로 몇번째 줄에 쓸것인지 결정(1~12)
; 0000 0427 {

	.CSEG
_row:
; 0000 0428     if(value=='0')
;	value -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x30)
	BRNE _0x3D
; 0000 0429     {                                                       // 1~9 줄 중
; 0000 042A         row_pointer=(int)(command[4]-'0');                  // 포인터값에 왼쪽부터 몇번째칸인지 지정
	CALL SUBOPT_0xA
	MOVW R4,R30
; 0000 042B     }
; 0000 042C     else if(value=='1')                                     // 10~12 줄 중
	RJMP _0x3E
_0x3D:
	LD   R26,Y
	CPI  R26,LOW(0x31)
	BRNE _0x3F
; 0000 042D     {
; 0000 042E         if(command[4]>'2') puts("range of row is 1~12\r");
	__GETB2MN _command,4
	CPI  R26,LOW(0x33)
	BRLO _0x40
	__POINTW1MN _0x41,0
	CALL SUBOPT_0xB
; 0000 042F         else
	RJMP _0x42
_0x40:
; 0000 0430         row_pointer=((int)command[4]-'0'+10);
	CALL SUBOPT_0xA
	ADIW R30,10
	MOVW R4,R30
; 0000 0431     }
_0x42:
; 0000 0432     else puts("range of row is 1~12\r");
	RJMP _0x43
_0x3F:
	__POINTW1MN _0x41,22
	CALL SUBOPT_0xB
; 0000 0433     puts("Row Pointer : ");
_0x43:
_0x3E:
	__POINTW1MN _0x41,44
	CALL SUBOPT_0xB
; 0000 0434     putchar('0'+row_pointer/100);
	MOVW R26,R4
	CALL SUBOPT_0xC
; 0000 0435     putchar('0'+row_pointer%100/10);
	MOVW R26,R4
	CALL SUBOPT_0xD
; 0000 0436     putchar('0'+row_pointer%10);
	MOVW R26,R4
	CALL SUBOPT_0xE
; 0000 0437     puts("\r");
	__POINTW1MN _0x41,59
_0x20A0009:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _puts
; 0000 0438 }
_0x20A000A:
	ADIW R28,1
	RET

	.DSEG
_0x41:
	.BYTE 0x3D
;void chat()       // ->문자입력; 했을 시 OSD에 문자입력이 나오도록함
; 0000 043A {

	.CSEG
_chat:
; 0000 043B     int j,k;
; 0000 043C     for(j=1;j<30;j++)                                       // ->(command[1])이후 ;가 나올때까지 uc의 총 길이는 0~29
	CALL __SAVELOCR4
;	j -> R16,R17
;	k -> R18,R19
	__GETWRN 16,17,1
_0x45:
	__CPWRN 16,17,30
	BRGE _0x46
; 0000 043D         {
; 0000 043E             k=j;                                            // j값은 순차적으로 k로 저장하고 2,3,4,5,....28, 29
	CALL SUBOPT_0xF
; 0000 043F             if(command[k]==';' && command[k+1]==13)          // (command[2], command[3]... command[29]중에) command[k]에 ; 가 나오면
	BRNE _0x48
	MOVW R30,R18
	__ADDW1MN _command,1
	LD   R26,Z
	CPI  R26,LOW(0xD)
	BREQ _0x49
_0x48:
	RJMP _0x47
_0x49:
; 0000 0440             {
; 0000 0441                 col_pointer=col_pointer+(k-1);              // 포인터를 입력된 문자개수에 위치시킴 ex) >abcde;라면 >;를 제외하고 총 5개 글자만큼 포인터를 이동
	MOVW R30,R18
	SBIW R30,1
	__ADDWRR 2,3,30,31
; 0000 0442                 //command[k]=NULL;                          // 해당 ';'가 들어있는 명령어배열은 비움
; 0000 0443                 for(k=k-1 ; k>0; k--)                       // 입력된 문자개수만큼                 ex) abcde; 에서 ;를 뺀만큼
	__SUBWRN 18,19,1
_0x4B:
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRGE _0x4C
; 0000 0444                 {
; 0000 0445                     col_pointer--;                          // 포인터를 역순으로
	MOVW R30,R2
	SBIW R30,1
	MOVW R2,R30
; 0000 0446                     MAX7456_Write(row_pointer, col_pointer, OSDchr[command[k]]);    // 입력된 글자를 출력해야 화면엔 abcde로 보임
	ST   -Y,R5
	ST   -Y,R4
	ST   -Y,R3
	ST   -Y,R2
	CALL SUBOPT_0x10
; 0000 0447                 }
	__SUBWRN 18,19,1
	RJMP _0x4B
_0x4C:
; 0000 0448                                                            //화면출력
; 0000 0449                 puts("CHAT!\r");
	__POINTW1MN _0x4D,0
	CALL SUBOPT_0xB
; 0000 044A                 com_reset();
	RCALL _com_reset
; 0000 044B             }
; 0000 044C         }
_0x47:
	__ADDWRN 16,17,1
	RJMP _0x45
_0x46:
; 0000 044D }
	CALL __LOADLOCR4
	RJMP _0x20A0006

	.DSEG
_0x4D:
	.BYTE 0x7
;void title()
; 0000 044F {

	.CSEG
_title:
; 0000 0450     int j,k;
; 0000 0451     for(j=3;j<30;j++)                                                           // ->(command[1])이후 ;가 나올때까지 uc의 총 길이는 0~29
	CALL __SAVELOCR4
;	j -> R16,R17
;	k -> R18,R19
	__GETWRN 16,17,3
_0x4F:
	__CPWRN 16,17,30
	BRGE _0x50
; 0000 0452         {
; 0000 0453             k=j;                                                                // j값은 순차적으로 k로 저장하고 2,3,4,5,....28, 29
	CALL SUBOPT_0xF
; 0000 0454             if(command[k]==';' && command[k+1]==13)                             // (command[2], command[3]... command[29]중에) command[k]에 ; 가 나오면
	BRNE _0x52
	MOVW R30,R18
	__ADDW1MN _command,1
	LD   R26,Z
	CPI  R26,LOW(0xD)
	BREQ _0x53
_0x52:
	RJMP _0x51
_0x53:
; 0000 0455             {
; 0000 0456                 title_pointer = title_pointer+(k-3);                            // 포인터를 입력된 문자개수에 위치시킴 ex) >abcde;라면 >;를 제외하고 총 5개 글자만큼 포인터를 이동
	MOVW R30,R18
	SBIW R30,3
	__ADDWRR 6,7,30,31
; 0000 0457                 if(title_pointer>=18) puts("Title is too long!(Max:15)\r");     // 최대 15글자까지 출력제한
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0x54
	__POINTW1MN _0x55,0
	RJMP _0xCC
; 0000 0458                 else
_0x54:
; 0000 0459                 {
; 0000 045A                     for(k=k-1 ; k>2; k--)                                       // 입력된 문자개수만큼                 ex) abcde; 에서 ;를 뺀만큼
	__SUBWRN 18,19,1
_0x58:
	__CPWRN 18,19,3
	BRLT _0x59
; 0000 045B                     {
; 0000 045C                       title_pointer--;                                          // 포인터를 역순으로
	MOVW R30,R6
	SBIW R30,1
	MOVW R6,R30
; 0000 045D                       MAX7456_Write(11, title_pointer, OSDchr[command[k]]);     // 입력된 글자를 출력해야 화면엔 abcde로 보임
	CALL SUBOPT_0x11
	ST   -Y,R7
	ST   -Y,R6
	CALL SUBOPT_0x10
; 0000 045E                     }
	__SUBWRN 18,19,1
	RJMP _0x58
_0x59:
; 0000 045F                     puts("TITLE!\r");                                           //화면출력
	__POINTW1MN _0x55,28
_0xCC:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _puts
; 0000 0460                 }
; 0000 0461                 com_reset();
	RCALL _com_reset
; 0000 0462             }
; 0000 0463         }
_0x51:
	__ADDWRN 16,17,1
	RJMP _0x4F
_0x50:
; 0000 0464 }
	CALL __LOADLOCR4
	RJMP _0x20A0006

	.DSEG
_0x55:
	.BYTE 0x24
;////////////////////////////////////////////////////////////encorder////////////////////////////////////////////////////////////////
;void init_LS7366(void) {
; 0000 0466 void init_LS7366(void) {

	.CSEG
_init_LS7366:
; 0000 0467 
; 0000 0468  LS7366_SS_L_H                                 // Initialize SS
	CALL SUBOPT_0x12
; 0000 0469 
; 0000 046A  LS7366_SS_H_L                                 // Set MDR0 X4 Count Mode
; 0000 046B  spid_master_tx_rx(SELECT_MDR0 | WR_REG);
	LDI  R30,LOW(136)
	ST   -Y,R30
	RCALL _spid_master_tx_rx
; 0000 046C  spid_master_tx_rx(X1_QUAD | FREE_RUN | DISABLE_INDEX | SYNCHRONOUS_INDEX | FILTER_CDF_1 );
	LDI  R30,LOW(65)
	ST   -Y,R30
	RCALL _spid_master_tx_rx
; 0000 046D  LS7366_SS_L_H
	CALL SUBOPT_0x12
; 0000 046E 
; 0000 046F  LS7366_SS_H_L                                 // Set MDR1 4 Bytes Counter Mode
; 0000 0470  spid_master_tx_rx(SELECT_MDR1 | WR_REG);
	LDI  R30,LOW(144)
	CALL SUBOPT_0x13
; 0000 0471  spid_master_tx_rx(FOUR_BYTE_COUNT_MODE | ENABLE_COUNTING);
; 0000 0472  LS7366_SS_L_H
	LDI  R30,LOW(16)
	STS  1636,R30
; 0000 0473 
; 0000 0474  LS7366_SS_H_L                               // Clear(0) CNTR Register
; 0000 0475  spid_master_tx_rx(SELECT_CNTR | CLR_REG);
; 0000 0476  LS7366_SS_L_H
; 0000 0477 }
;
;void reset_LS7366(void)
; 0000 047A {
_reset_LS7366:
; 0000 047B     LS7366_SS_H_L
_0x20A0008:
	LDI  R30,LOW(0)
	STS  1636,R30
; 0000 047C     spid_master_tx_rx(SELECT_CNTR | CLR_REG);
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _spid_master_tx_rx
; 0000 047D     LS7366_SS_L_H
	LDI  R30,LOW(16)
	STS  1636,R30
; 0000 047E }
	RET
;
;
;unsigned int encorder_pointer;
;char temp[30]="";
;void putstringc1(char *command)
; 0000 0484 {
_putstringc1:
; 0000 0485     int i=0;
; 0000 0486     while(*(command+i) !=0)
	ST   -Y,R17
	ST   -Y,R16
;	*command -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x5A:
	MOVW R30,R16
	CALL SUBOPT_0x6
	LD   R30,X
	CPI  R30,0
	BREQ _0x5C
; 0000 0487     {
; 0000 0488         putchar(*(command+i));
	MOVW R30,R16
	CALL SUBOPT_0x6
	LD   R30,X
	ST   -Y,R30
	RCALL _putchar
; 0000 0489         MAX7456_Write(1, encorder_pointer, OSDchr[*(command+i)]);
	CALL SUBOPT_0x14
	MOVW R30,R16
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CALL SUBOPT_0x15
; 0000 048A         encorder_pointer+=1;
	LDS  R30,_encorder_pointer
	LDS  R31,_encorder_pointer+1
	ADIW R30,1
	CALL SUBOPT_0x16
; 0000 048B         temp[i]=*(command+i);       //encorder의 출력 값이 다음타이밍(10ms)이후 들어온 값과 같은지 확인하기위한 용도의변수(중복된 값을 화면에 출력하는 낭비를 막기위해)
	MOVW R30,R16
	SUBI R30,LOW(-_temp)
	SBCI R31,HIGH(-_temp)
	MOVW R0,R30
	MOVW R30,R16
	CALL SUBOPT_0x6
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 048C         temp[i+1]=NULL;
	MOVW R30,R16
	__ADDW1MN _temp,1
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 048D         i++;
	__ADDWRN 16,17,1
; 0000 048E     }
	RJMP _0x5A
_0x5C:
; 0000 048F     MAX7456_Write(1, encorder_pointer, OSDchr[' ']);    //encorder값이 예를들어 1234였다가 123이되면 뒤에 4에 대한 잔상이 남는다 그것을 지우기위해 123뒤에 ' ' 을 넣어준다.
	CALL SUBOPT_0x14
	__GETB1MN _OSDchr,32
	CALL SUBOPT_0x9
; 0000 0490     encorder_pointer-=i;
	LDS  R30,_encorder_pointer
	LDS  R31,_encorder_pointer+1
	SUB  R30,R16
	SBC  R31,R17
	CALL SUBOPT_0x16
; 0000 0491     puts("\r");
	__POINTW1MN _0x5D,0
	CALL SUBOPT_0xB
; 0000 0492 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0006

	.DSEG
_0x5D:
	.BYTE 0x2
;////////////////////////////////////////////////////////////////RTC/////////////////////////////////////////////////////////////////
;unsigned char timer_pointer=1;
;unsigned char hour=0;
;void ontime_hour(void)
; 0000 0497 {

	.CSEG
_ontime_hour:
; 0000 0498     //hour=s%86400;
; 0000 0499     int a=RTC_sec%86400;
; 0000 049A     if(hour>=23 || a==0) hour=0;
	CALL SUBOPT_0x17
;	a -> R16,R17
	__GETD1N 0x15180
	CALL __MODD21U
	MOVW R16,R30
	LDS  R26,_hour
	CPI  R26,LOW(0x17)
	BRSH _0x60
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRNE _0x5F
_0x60:
	LDI  R30,LOW(0)
	RJMP _0xCD
; 0000 049B     else hour++;
_0x5F:
	LDS  R30,_hour
	SUBI R30,-LOW(1)
_0xCD:
	STS  _hour,R30
; 0000 049C     timer_pointer+=2;
	LDS  R30,_timer_pointer
	SUBI R30,-LOW(2)
	CALL SUBOPT_0x18
; 0000 049D     MAX7456_Write(1, timer_pointer, OSDchr[':']);               // :
	__GETB1MN _OSDchr,58
	CALL SUBOPT_0x9
; 0000 049E     timer_pointer--;
	CALL SUBOPT_0x19
; 0000 049F     MAX7456_Write(1, timer_pointer, OSDchr['0'+(hour%10)]);     // 1hour
	LDS  R26,_hour
	CLR  R27
	CALL SUBOPT_0x1A
; 0000 04A0     timer_pointer--;
	CALL SUBOPT_0x19
; 0000 04A1     MAX7456_Write(1, timer_pointer, OSDchr['0'+(hour/10)]);     // 10hour
	LDS  R26,_hour
	LDI  R27,0
	CALL SUBOPT_0x1B
; 0000 04A2 }
	RJMP _0x20A0007
;int minu=0;
;void ontime_min(void)
; 0000 04A5 {
_ontime_min:
; 0000 04A6     //min=s%3600;
; 0000 04A7     int a=RTC_sec%3600;
; 0000 04A8     if(minu>=59 || a==0)
	CALL SUBOPT_0x17
;	a -> R16,R17
	__GETD1N 0xE10
	CALL __MODD21U
	MOVW R16,R30
	CALL SUBOPT_0x1C
	SBIW R26,59
	BRGE _0x64
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRNE _0x63
_0x64:
; 0000 04A9     {
; 0000 04AA         minu=0;
	LDI  R30,LOW(0)
	STS  _minu,R30
	STS  _minu+1,R30
; 0000 04AB         ontime_hour();
	RCALL _ontime_hour
; 0000 04AC     }
; 0000 04AD     else minu++;
	RJMP _0x66
_0x63:
	LDS  R30,_minu
	LDS  R31,_minu+1
	ADIW R30,1
	CALL SUBOPT_0x1D
; 0000 04AE     timer_pointer+=5;
_0x66:
	LDS  R30,_timer_pointer
	SUBI R30,-LOW(5)
	CALL SUBOPT_0x18
; 0000 04AF     MAX7456_Write(1, timer_pointer, OSDchr[':']);                // :
	__GETB1MN _OSDchr,58
	CALL SUBOPT_0x9
; 0000 04B0     timer_pointer--;
	CALL SUBOPT_0x19
; 0000 04B1     MAX7456_Write(1, timer_pointer, OSDchr['0'+(minu%10)]);      // 1min
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1A
; 0000 04B2     timer_pointer--;
	CALL SUBOPT_0x19
; 0000 04B3     MAX7456_Write(1, timer_pointer, OSDchr['0'+(minu/10)]);      // 10min
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1B
; 0000 04B4     timer_pointer-=3;
	LDS  R30,_timer_pointer
	LDI  R31,0
	SBIW R30,3
	STS  _timer_pointer,R30
; 0000 04B5 }
_0x20A0007:
	LD   R16,Y+
	LD   R17,Y+
	RET
;void ontime_sec(void)
; 0000 04B7 {
_ontime_sec:
; 0000 04B8     unsigned long int a;
; 0000 04B9     RTC_flag=0;
	SBIW R28,4
;	a -> Y+0
	CBI  0x0,1
; 0000 04BA     if(hour>=24) RTC_sec=0;
	LDS  R26,_hour
	CPI  R26,LOW(0x18)
	BRLO _0x69
	CALL SUBOPT_0x1E
; 0000 04BB     else{
	RJMP _0x6A
_0x69:
; 0000 04BC     a=RTC_sec%60;
	LDS  R26,_RTC_sec
	LDS  R27,_RTC_sec+1
	LDS  R24,_RTC_sec+2
	LDS  R25,_RTC_sec+3
	__GETD1N 0x3C
	CALL __MODD21U
	CALL __PUTD1S0
; 0000 04BD     timer_pointer+=7;
	LDS  R30,_timer_pointer
	SUBI R30,-LOW(7)
	CALL SUBOPT_0x18
; 0000 04BE     MAX7456_Write(1, timer_pointer, OSDchr['0'+(a%10)]);    // 1sec
	CALL SUBOPT_0x1F
	CALL __MODD21U
	__ADDW1MN _OSDchr,48
	LD   R30,Z
	CALL SUBOPT_0x9
; 0000 04BF     timer_pointer--;
	CALL SUBOPT_0x19
; 0000 04C0     MAX7456_Write(1, timer_pointer, OSDchr['0'+(a/10)]);    // 10sec
	CALL SUBOPT_0x1F
	CALL __DIVD21U
	__ADDW1MN _OSDchr,48
	LD   R30,Z
	CALL SUBOPT_0x9
; 0000 04C1     timer_pointer-=6;
	LDS  R30,_timer_pointer
	LDI  R31,0
	SBIW R30,6
	STS  _timer_pointer,R30
; 0000 04C2     if(a==0) ontime_min();
	CALL SUBOPT_0x20
	CALL __CPD10
	BRNE _0x6B
	RCALL _ontime_min
; 0000 04C3     }
_0x6B:
_0x6A:
; 0000 04C4 }
_0x20A0006:
	ADIW R28,4
	RET
;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;bit ontime_flag=0;
;int date_pointer;
;void commands(void) //명령어 키조합
; 0000 04C9 {
_commands:
; 0000 04CA     if(command[1]=='A' && command[2]=='T' && command[3]==13)          // 연결확인
	__GETB2MN _command,1
	CPI  R26,LOW(0x41)
	BRNE _0x6D
	__GETB2MN _command,2
	CPI  R26,LOW(0x54)
	BRNE _0x6D
	__GETB2MN _command,3
	CPI  R26,LOW(0xD)
	BREQ _0x6E
_0x6D:
	RJMP _0x6C
_0x6E:
; 0000 04CB     {
; 0000 04CC         delay_us(100);
	__DELAY_USB 67
; 0000 04CD         puts("OSD CONNECT : OK\r");
	__POINTW1MN _0x6F,0
	CALL SUBOPT_0xB
; 0000 04CE         com_reset();
	RCALL _com_reset
; 0000 04CF     }
; 0000 04D0     else if(command[1]=='C' && command[2]=='K' && command[3]==13) // CHECK용
	RJMP _0x70
_0x6C:
	__GETB2MN _command,1
	CPI  R26,LOW(0x43)
	BRNE _0x72
	__GETB2MN _command,2
	CPI  R26,LOW(0x4B)
	BRNE _0x72
	__GETB2MN _command,3
	CPI  R26,LOW(0xD)
	BREQ _0x73
_0x72:
	RJMP _0x71
_0x73:
; 0000 04D1     {
; 0000 04D2         check();
	RCALL _check
; 0000 04D3         com_reset();
	RCALL _com_reset
; 0000 04D4     }
; 0000 04D5     else if(command[1]=='C' && command[2]=='R' && command[3]==13) // 화면 CLEAR
	RJMP _0x74
_0x71:
	__GETB2MN _command,1
	CPI  R26,LOW(0x43)
	BRNE _0x76
	__GETB2MN _command,2
	CPI  R26,LOW(0x52)
	BRNE _0x76
	__GETB2MN _command,3
	CPI  R26,LOW(0xD)
	BREQ _0x77
_0x76:
	RJMP _0x75
_0x77:
; 0000 04D6     {
; 0000 04D7         clear();
	RCALL _clear
; 0000 04D8         com_reset();
	RCALL _com_reset
; 0000 04D9     }
; 0000 04DA     else if(command[1]=='O' && command[2]=='N' && command[3]==13)     // OSD ON
	RJMP _0x78
_0x75:
	__GETB2MN _command,1
	CPI  R26,LOW(0x4F)
	BRNE _0x7A
	__GETB2MN _command,2
	CPI  R26,LOW(0x4E)
	BRNE _0x7A
	__GETB2MN _command,3
	CPI  R26,LOW(0xD)
	BREQ _0x7B
_0x7A:
	RJMP _0x79
_0x7B:
; 0000 04DB     {
; 0000 04DC         on();
	RCALL _on
; 0000 04DD         com_reset();
	RCALL _com_reset
; 0000 04DE     }
; 0000 04DF    else if(command[1]=='O' && command[2]=='F' && command[3]==13)   // OSD OFF
	RJMP _0x7C
_0x79:
	__GETB2MN _command,1
	CPI  R26,LOW(0x4F)
	BRNE _0x7E
	__GETB2MN _command,2
	CPI  R26,LOW(0x46)
	BRNE _0x7E
	__GETB2MN _command,3
	CPI  R26,LOW(0xD)
	BREQ _0x7F
_0x7E:
	RJMP _0x7D
_0x7F:
; 0000 04E0     {
; 0000 04E1         off();
	RCALL _off
; 0000 04E2         com_reset();
	RCALL _com_reset
; 0000 04E3     }
; 0000 04E4     else if(command[1]=='C' && command[2]=='L' && command[3]!= NULL && command[4]!= NULL && command[5] == 13)  //열
	RJMP _0x80
_0x7D:
	__GETB2MN _command,1
	CPI  R26,LOW(0x43)
	BRNE _0x82
	__GETB2MN _command,2
	CPI  R26,LOW(0x4C)
	BRNE _0x82
	__GETB2MN _command,3
	CPI  R26,LOW(0x0)
	BREQ _0x82
	__GETB2MN _command,4
	CPI  R26,LOW(0x0)
	BREQ _0x82
	__GETB2MN _command,5
	CPI  R26,LOW(0xD)
	BREQ _0x83
_0x82:
	RJMP _0x81
_0x83:
; 0000 04E5     {
; 0000 04E6         col(command[3]);
	__GETB1MN _command,3
	ST   -Y,R30
	RCALL _col
; 0000 04E7         com_reset();
	RCALL _com_reset
; 0000 04E8     }
; 0000 04E9     else if(command[1]=='R' && command[2]=='W'  && command[3]!= NULL && command[4] != NULL && command[5]==13) // 행
	RJMP _0x84
_0x81:
	__GETB2MN _command,1
	CPI  R26,LOW(0x52)
	BRNE _0x86
	__GETB2MN _command,2
	CPI  R26,LOW(0x57)
	BRNE _0x86
	__GETB2MN _command,3
	CPI  R26,LOW(0x0)
	BREQ _0x86
	__GETB2MN _command,4
	CPI  R26,LOW(0x0)
	BREQ _0x86
	__GETB2MN _command,5
	CPI  R26,LOW(0xD)
	BREQ _0x87
_0x86:
	RJMP _0x85
_0x87:
; 0000 04EA     {
; 0000 04EB         row(command[3]);
	__GETB1MN _command,3
	ST   -Y,R30
	RCALL _row
; 0000 04EC         com_reset();
	RCALL _com_reset
; 0000 04ED     }
; 0000 04EE     else if(command[1]=='T' && command[2]=='R' && command[3]==13)
	RJMP _0x88
_0x85:
	__GETB2MN _command,1
	CPI  R26,LOW(0x54)
	BRNE _0x8A
	__GETB2MN _command,2
	CPI  R26,LOW(0x52)
	BRNE _0x8A
	__GETB2MN _command,3
	CPI  R26,LOW(0xD)
	BREQ _0x8B
_0x8A:
	RJMP _0x89
_0x8B:
; 0000 04EF     {
; 0000 04F0         ontime_flag = ~ontime_flag;
	SBIS 0x0,4
	RJMP _0x8C
	CBI  0x0,4
	RJMP _0x8D
_0x8C:
	SBI  0x0,4
_0x8D:
; 0000 04F1         if(ontime_flag==1)
	SBIS 0x0,4
	RJMP _0x8E
; 0000 04F2         {
; 0000 04F3             //t_pointer=pointer;
; 0000 04F4             timer_pointer=19;
	LDI  R30,LOW(19)
	STS  _timer_pointer,R30
; 0000 04F5             puts("ONTIMER ON\r");
	__POINTW1MN _0x6F,18
	RJMP _0xCE
; 0000 04F6         }
; 0000 04F7         else puts("ONTIMER OFF\r");
_0x8E:
	__POINTW1MN _0x6F,30
_0xCE:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _puts
; 0000 04F8         com_reset();
	RCALL _com_reset
; 0000 04F9     }
; 0000 04FA     else if(command[1]=='T' && command[2]=='S' && command[3]!= NULL && command[4] != NULL && command[5]!= NULL && command[6] != NULL && command[7]==13)
	RJMP _0x90
_0x89:
	__GETB2MN _command,1
	CPI  R26,LOW(0x54)
	BRNE _0x92
	__GETB2MN _command,2
	CPI  R26,LOW(0x53)
	BRNE _0x92
	__GETB2MN _command,3
	CPI  R26,LOW(0x0)
	BREQ _0x92
	__GETB2MN _command,4
	CPI  R26,LOW(0x0)
	BREQ _0x92
	__GETB2MN _command,5
	CPI  R26,LOW(0x0)
	BREQ _0x92
	__GETB2MN _command,6
	CPI  R26,LOW(0x0)
	BREQ _0x92
	__GETB2MN _command,7
	CPI  R26,LOW(0xD)
	BREQ _0x93
_0x92:
	RJMP _0x91
_0x93:
; 0000 04FB     {
; 0000 04FC         timer_pointer=19;
	LDI  R30,LOW(19)
	STS  _timer_pointer,R30
; 0000 04FD         ontime_flag = 1;
	SBI  0x0,4
; 0000 04FE         hour=(command[3]-'0')*10+(command[4]-'0'-1);
	CALL SUBOPT_0x21
	SBIW R30,1
	ADD  R30,R26
	STS  _hour,R30
; 0000 04FF         minu=(command[5]-'0')*10+(command[6]-'0'-1);
	__GETB1MN _command,5
	CALL SUBOPT_0x22
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R26,R30
	__GETB1MN _command,6
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
; 0000 0500         ontime_min();
; 0000 0501         ontime_hour();
	RCALL _ontime_hour
; 0000 0502         puts("ONTIMER SET\r");
	__POINTW1MN _0x6F,43
	CALL SUBOPT_0xB
; 0000 0503         com_reset();
	RCALL _com_reset
; 0000 0504     }
; 0000 0505     else if(command[1]=='T' && command[2]=='H' && command[3]!= NULL && command[4] != NULL && command[5]==13)
	RJMP _0x96
_0x91:
	__GETB2MN _command,1
	CPI  R26,LOW(0x54)
	BRNE _0x98
	__GETB2MN _command,2
	CPI  R26,LOW(0x48)
	BRNE _0x98
	__GETB2MN _command,3
	CPI  R26,LOW(0x0)
	BREQ _0x98
	__GETB2MN _command,4
	CPI  R26,LOW(0x0)
	BREQ _0x98
	__GETB2MN _command,5
	CPI  R26,LOW(0xD)
	BREQ _0x99
_0x98:
	RJMP _0x97
_0x99:
; 0000 0506     {
; 0000 0507         hour=(command[3]-'0')*10+(command[4]-'0'-1);
	CALL SUBOPT_0x21
	SBIW R30,1
	ADD  R30,R26
	STS  _hour,R30
; 0000 0508         ontime_hour();
	RCALL _ontime_hour
; 0000 0509         com_reset();
	RCALL _com_reset
; 0000 050A     }
; 0000 050B     else if(command[1]=='T' && command[2]=='M' && command[3]!= NULL && command[4] != NULL && command[5]==13)
	RJMP _0x9A
_0x97:
	__GETB2MN _command,1
	CPI  R26,LOW(0x54)
	BRNE _0x9C
	__GETB2MN _command,2
	CPI  R26,LOW(0x4D)
	BRNE _0x9C
	__GETB2MN _command,3
	CPI  R26,LOW(0x0)
	BREQ _0x9C
	__GETB2MN _command,4
	CPI  R26,LOW(0x0)
	BREQ _0x9C
	__GETB2MN _command,5
	CPI  R26,LOW(0xD)
	BREQ _0x9D
_0x9C:
	RJMP _0x9B
_0x9D:
; 0000 050C     {
; 0000 050D         minu=(command[3]-'0')*10+(command[4]-'0'-1);
	__GETB1MN _command,3
	CALL SUBOPT_0x22
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R26,R30
	CALL SUBOPT_0xA
	CALL SUBOPT_0x23
; 0000 050E         ontime_min();
; 0000 050F         com_reset();
	RCALL _com_reset
; 0000 0510     }
; 0000 0511     else if(command[1]=='D' && command[2]=='T'&& command[3] != NULL && command[4]!= NULL && command[5] != NULL && command[6]!= NULL && command[7] != NULL && command[8]!= NULL && command[9] == 13   )
	RJMP _0x9E
_0x9B:
	__GETB2MN _command,1
	CPI  R26,LOW(0x44)
	BRNE _0xA0
	__GETB2MN _command,2
	CPI  R26,LOW(0x54)
	BRNE _0xA0
	__GETB2MN _command,3
	CPI  R26,LOW(0x0)
	BREQ _0xA0
	__GETB2MN _command,4
	CPI  R26,LOW(0x0)
	BREQ _0xA0
	__GETB2MN _command,5
	CPI  R26,LOW(0x0)
	BREQ _0xA0
	__GETB2MN _command,6
	CPI  R26,LOW(0x0)
	BREQ _0xA0
	__GETB2MN _command,7
	CPI  R26,LOW(0x0)
	BREQ _0xA0
	__GETB2MN _command,8
	CPI  R26,LOW(0x0)
	BREQ _0xA0
	__GETB2MN _command,9
	CPI  R26,LOW(0xD)
	BREQ _0xA1
_0xA0:
	RJMP _0x9F
_0xA1:
; 0000 0512     {
; 0000 0513         date_pointer=26;
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	CALL SUBOPT_0x24
; 0000 0514         MAX7456_Write(11, date_pointer, OSDchr[command[8]]);
	CALL SUBOPT_0x25
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _command,8
	CALL SUBOPT_0x15
; 0000 0515         date_pointer--;
	CALL SUBOPT_0x26
; 0000 0516         MAX7456_Write(11, date_pointer, OSDchr[command[7]]);
	CALL SUBOPT_0x27
	__GETB1MN _command,7
	CALL SUBOPT_0x15
; 0000 0517         date_pointer--;
	CALL SUBOPT_0x26
; 0000 0518         MAX7456_Write(11, date_pointer, OSDchr['/']);
	CALL SUBOPT_0x27
	__GETB1MN _OSDchr,47
	CALL SUBOPT_0x9
; 0000 0519         date_pointer--;
	CALL SUBOPT_0x26
; 0000 051A         MAX7456_Write(11, date_pointer, OSDchr[command[6]]);
	CALL SUBOPT_0x27
	__GETB1MN _command,6
	CALL SUBOPT_0x15
; 0000 051B         date_pointer--;
	CALL SUBOPT_0x26
; 0000 051C         MAX7456_Write(11, date_pointer, OSDchr[command[5]]);
	CALL SUBOPT_0x27
	__GETB1MN _command,5
	CALL SUBOPT_0x15
; 0000 051D         date_pointer--;
	CALL SUBOPT_0x26
; 0000 051E         MAX7456_Write(11, date_pointer, OSDchr['/']);
	CALL SUBOPT_0x27
	__GETB1MN _OSDchr,47
	CALL SUBOPT_0x9
; 0000 051F         date_pointer--;
	CALL SUBOPT_0x26
; 0000 0520         MAX7456_Write(11, date_pointer, OSDchr[command[4]]);
	CALL SUBOPT_0x27
	__GETB1MN _command,4
	CALL SUBOPT_0x15
; 0000 0521         date_pointer--;
	CALL SUBOPT_0x26
; 0000 0522         MAX7456_Write(11, date_pointer, OSDchr[command[3]]);
	CALL SUBOPT_0x27
	__GETB1MN _command,3
	CALL SUBOPT_0x15
; 0000 0523         puts("DATE SET\r");
	__POINTW1MN _0x6F,56
	CALL SUBOPT_0xB
; 0000 0524         com_reset();
	RCALL _com_reset
; 0000 0525     }
; 0000 0526     else if(command[1]=='T' && command[2]==':' && command[3]!=NULL)
	RJMP _0xA2
_0x9F:
	__GETB2MN _command,1
	CPI  R26,LOW(0x54)
	BRNE _0xA4
	__GETB2MN _command,2
	CPI  R26,LOW(0x3A)
	BRNE _0xA4
	__GETB2MN _command,3
	CPI  R26,LOW(0x0)
	BRNE _0xA5
_0xA4:
	RJMP _0xA3
_0xA5:
; 0000 0527     {
; 0000 0528         title_pointer=2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R6,R30
; 0000 0529         title();
	RCALL _title
; 0000 052A     }
; 0000 052B     else if(command[1]=='T' && command[2]=='E' && command[3]==13)
	RJMP _0xA6
_0xA3:
	__GETB2MN _command,1
	CPI  R26,LOW(0x54)
	BRNE _0xA8
	__GETB2MN _command,2
	CPI  R26,LOW(0x45)
	BRNE _0xA8
	__GETB2MN _command,3
	CPI  R26,LOW(0xD)
	BREQ _0xA9
_0xA8:
	RJMP _0xA7
_0xA9:
; 0000 052C     {
; 0000 052D         RTC_sec=0;
	CALL SUBOPT_0x1E
; 0000 052E         puts("SECOND : 0");
	__POINTW1MN _0x6F,66
	CALL SUBOPT_0xB
; 0000 052F         com_reset();
	RCALL _com_reset
; 0000 0530     }
; 0000 0531     else if(command[1]=='E' && command[2]=='N' && command[3]==13)
	RJMP _0xAA
_0xA7:
	__GETB2MN _command,1
	CPI  R26,LOW(0x45)
	BRNE _0xAC
	__GETB2MN _command,2
	CPI  R26,LOW(0x4E)
	BRNE _0xAC
	__GETB2MN _command,3
	CPI  R26,LOW(0xD)
	BREQ _0xAD
_0xAC:
	RJMP _0xAB
_0xAD:
; 0000 0532     {
; 0000 0533         flag_com=~flag_com;
	SBIS 0x0,0
	RJMP _0xAE
	CBI  0x0,0
	RJMP _0xAF
_0xAE:
	SBI  0x0,0
_0xAF:
; 0000 0534         if(flag_com==1)
	SBIS 0x0,0
	RJMP _0xB0
; 0000 0535         {
; 0000 0536             //e_pointer=pointer;
; 0000 0537             encorder_pointer=2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x16
; 0000 0538             puts("ENCODER ON\r");
	__POINTW1MN _0x6F,77
	RJMP _0xCF
; 0000 0539         }
; 0000 053A         else puts("ENCODER OFF\r");
_0xB0:
	__POINTW1MN _0x6F,89
_0xCF:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _puts
; 0000 053B         com_reset();
	RCALL _com_reset
; 0000 053C     }
; 0000 053D     else if(command[1]=='E' && command[2]=='R'&& command[3]==13)
	RJMP _0xB2
_0xAB:
	__GETB2MN _command,1
	CPI  R26,LOW(0x45)
	BRNE _0xB4
	__GETB2MN _command,2
	CPI  R26,LOW(0x52)
	BRNE _0xB4
	__GETB2MN _command,3
	CPI  R26,LOW(0xD)
	BREQ _0xB5
_0xB4:
	RJMP _0xB3
_0xB5:
; 0000 053E     {
; 0000 053F         //init_LS7366();
; 0000 0540         reset_LS7366();
	RCALL _reset_LS7366
; 0000 0541         puts("ENCODER VALUE RESET!!\r");
	__POINTW1MN _0x6F,102
	CALL SUBOPT_0xB
; 0000 0542         com_reset();
	RCALL _com_reset
; 0000 0543     }
; 0000 0544     else if(command[1] != NULL) //&& command[2] != NULL)   //문자입력
	RJMP _0xB6
_0xB3:
	__GETB1MN _command,1
	CPI  R30,0
	BREQ _0xB7
; 0000 0545     {
; 0000 0546          chat();
	RCALL _chat
; 0000 0547     }
; 0000 0548 }
_0xB7:
_0xB6:
_0xB2:
_0xAA:
_0xA6:
_0xA2:
_0x9E:
_0x9A:
_0x96:
_0x90:
_0x88:
_0x84:
_0x80:
_0x7C:
_0x78:
_0x74:
_0x70:
	RET

	.DSEG
_0x6F:
	.BYTE 0x7D
;///////////////////////////////////////////////////////************************************************************************************************//////////////////
;void main(void)
; 0000 054B {

	.CSEG
_main:
; 0000 054C // Declare your local variables here
; 0000 054D unsigned char n, i, ttemp=0;
; 0000 054E 
; 0000 054F // Interrupt system initialization
; 0000 0550 // Optimize for speed
; 0000 0551 #pragma optsize-
; 0000 0552 // Make sure the interrupts are disabled
; 0000 0553 #asm("cli")
;	n -> R17
;	i -> R16
;	ttemp -> R19
	LDI  R19,0
	cli
; 0000 0554 // Low level interrupt: On
; 0000 0555 // Round-robin scheduling for low level interrupt: Off
; 0000 0556 // Medium level interrupt: Off
; 0000 0557 // High level interrupt: Off
; 0000 0558 // The interrupt vectors will be placed at the start of the Application FLASH section
; 0000 0559 n=(PMIC.CTRL & (~(PMIC_RREN_bm | PMIC_IVSEL_bm | PMIC_HILVLEN_bm | PMIC_MEDLVLEN_bm | PMIC_LOLVLEN_bm))) |
; 0000 055A 	PMIC_LOLVLEN_bm;
	LDS  R30,162
	ANDI R30,LOW(0x38)
	ORI  R30,1
	MOV  R17,R30
; 0000 055B CCP=CCP_IOREG_gc;
	LDI  R30,LOW(216)
	OUT  0x34,R30
; 0000 055C PMIC.CTRL=n;
	STS  162,R17
; 0000 055D // Set the default priority for round-robin scheduling
; 0000 055E PMIC.INTPRI=0x00;
	LDI  R30,LOW(0)
	STS  161,R30
; 0000 055F // Restore optimization for size if needed
; 0000 0560 #pragma optsize_default
; 0000 0561 
; 0000 0562 // Watchdog timer initialization
; 0000 0563 watchdog_init();
	CALL _watchdog_init
; 0000 0564 
; 0000 0565 // System clocks initialization
; 0000 0566 system_clocks_init();
	CALL _system_clocks_init
; 0000 0567 
; 0000 0568 // Event system initialization
; 0000 0569 event_system_init();
	CALL _event_system_init
; 0000 056A 
; 0000 056B // Ports initialization
; 0000 056C ports_init();
	CALL _ports_init
; 0000 056D 
; 0000 056E // Virtual Ports initialization
; 0000 056F vports_init();
	CALL _vports_init
; 0000 0570 
; 0000 0571 // Timer/Counter TCC0 initialization
; 0000 0572 tcc0_init();
	CALL _tcc0_init
; 0000 0573 
; 0000 0574 // RTC initialization
; 0000 0575 rtcxm_init();
	RCALL _rtcxm_init
; 0000 0576 
; 0000 0577 // USARTD0 initialization
; 0000 0578 usartd0_init();
	RCALL _usartd0_init
; 0000 0579 
; 0000 057A // USARTD1 is disabled
; 0000 057B usart_disable(&USARTD1);
	LDI  R30,LOW(2480)
	LDI  R31,HIGH(2480)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _usart_disable
; 0000 057C 
; 0000 057D // USARTE0 is disabled
; 0000 057E usart_disable(&USARTE0);
	LDI  R30,LOW(2720)
	LDI  R31,HIGH(2720)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _usart_disable
; 0000 057F 
; 0000 0580 // SPIC initialization
; 0000 0581 spic_init();
	RCALL _spic_init
; 0000 0582 
; 0000 0583 // SPID initialization
; 0000 0584 spid_init();
	RCALL _spid_init
; 0000 0585 
; 0000 0586 // ENCORDER initialization
; 0000 0587 init_LS7366();
	RCALL _init_LS7366
; 0000 0588 
; 0000 0589 puts("OSD CONNECT : OK\r");
	__POINTW1MN _0xB8,0
	CALL SUBOPT_0xB
; 0000 058A MAX7456_init();
	RCALL _MAX7456_init
; 0000 058B // Globaly enable interrupts
; 0000 058C #asm("sei")
	sei
; 0000 058D 
; 0000 058E while (1)
_0xB9:
; 0000 058F       {
; 0000 0590       // Place your code here
; 0000 0591         if(command_flag==1)
	SBIS 0x0,3
	RJMP _0xBC
; 0000 0592          {
; 0000 0593              if(command_size>1)commands();
	LDS  R26,_command_size
	CPI  R26,LOW(0x2)
	BRLO _0xBD
	RCALL _commands
; 0000 0594          }
_0xBD:
; 0000 0595         if(ontime_flag==1 && RTC_flag==1) ontime_sec();
_0xBC:
	SBIS 0x0,4
	RJMP _0xBF
	SBIC 0x0,1
	RJMP _0xC0
_0xBF:
	RJMP _0xBE
_0xC0:
	RCALL _ontime_sec
; 0000 0596         if(flag_com==1 && (ten_ms%10)==0)
_0xBE:
	SBIS 0x0,0
	RJMP _0xC2
	MOVW R26,R8
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SBIW R30,0
	BREQ _0xC3
_0xC2:
	RJMP _0xC1
_0xC3:
; 0000 0597          {
; 0000 0598             LS7366_SS_H_L                     // Initialize SS
	LDI  R30,LOW(0)
	STS  1636,R30
; 0000 0599             spid_master_tx_rx(SELECT_OTR | LOAD_REG);   // Transfer CNTR to OTR in "parallel"
	LDI  R30,LOW(232)
	ST   -Y,R30
	RCALL _spid_master_tx_rx
; 0000 059A             LS7366_SS_L_H
	CALL SUBOPT_0x12
; 0000 059B             LS7366_SS_H_L                           //
; 0000 059C             spid_master_tx_rx(SELECT_OTR | RD_REG);     // Read 4 Bytes OTR Register
	LDI  R30,LOW(104)
	CALL SUBOPT_0x13
; 0000 059D             a = spid_master_tx_rx(0x00);            // B31 - B24  MSB
	MOV  R11,R30
; 0000 059E             b = spid_master_tx_rx(0x00);            // B23 - B16
	CALL SUBOPT_0x28
	MOV  R10,R30
; 0000 059F             c = spid_master_tx_rx(0x00);            // B15 - B08
	CALL SUBOPT_0x28
	MOV  R13,R30
; 0000 05A0             d = spid_master_tx_rx(0x00);            // B07 - B00  LSB
	CALL SUBOPT_0x28
	MOV  R12,R30
; 0000 05A1             LS7366_SS_L_H
	LDI  R30,LOW(16)
	STS  1636,R30
; 0000 05A2 
; 0000 05A3             sum = ( ((0x000000ffL & a) << 24) | ((0x000000ffL & b) << 16) | ((0x000000ffL & c) << 8) | (0x0000ffffL & d) );
	MOV  R30,R11
	CALL SUBOPT_0x29
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(24)
	CALL __LSLD12
	MOVW R26,R30
	MOVW R24,R22
	MOV  R30,R10
	CALL SUBOPT_0x29
	CALL __LSLD16
	CALL __ORD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOV  R30,R13
	CALL SUBOPT_0x29
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __LSLD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ORD12
	MOVW R26,R30
	MOVW R24,R22
	MOV  R30,R12
	CLR  R31
	CLR  R22
	CLR  R23
	__ANDD1N 0xFFFF
	CALL __ORD12
	STS  _sum,R30
	STS  _sum+1,R31
	STS  _sum+2,R22
	STS  _sum+3,R23
; 0000 05A4             sprintf(ch,"%4.3fM",sum*0.314/500);     // 1바퀴에 0.314m
	LDI  R30,LOW(_ch)
	LDI  R31,HIGH(_ch)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,280
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_sum
	LDS  R31,_sum+1
	LDS  R22,_sum+2
	LDS  R23,_sum+3
	CALL __CDF1
	__GETD2N 0x3EA0C49C
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x43FA0000
	CALL __DIVF21
	CALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
; 0000 05A5             delay_us(500);
	__DELAY_USW 250
; 0000 05A6             for(i=0;i<30;i++)
	LDI  R16,LOW(0)
_0xC5:
	CPI  R16,30
	BRSH _0xC6
; 0000 05A7             {
; 0000 05A8                 if(ch[i]==temp[i]) ttemp++;
	CALL SUBOPT_0x2A
	MOVW R0,R30
	SUBI R30,LOW(-_ch)
	SBCI R31,HIGH(-_ch)
	LD   R26,Z
	MOVW R30,R0
	SUBI R30,LOW(-_temp)
	SBCI R31,HIGH(-_temp)
	LD   R30,Z
	CP   R30,R26
	BRNE _0xC7
	SUBI R19,-1
; 0000 05A9             }
_0xC7:
	SUBI R16,-1
	RJMP _0xC5
_0xC6:
; 0000 05AA             if(ttemp != 30)   putstringc1(ch);       // 10ms간격 사이에 숫자변화가 있으면 화면에 출력
	CPI  R19,30
	BREQ _0xC8
	LDI  R30,LOW(_ch)
	LDI  R31,HIGH(_ch)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _putstringc1
; 0000 05AB             ttemp=0;
_0xC8:
	LDI  R19,LOW(0)
; 0000 05AC 
; 0000 05AD          }
; 0000 05AE       }
_0xC1:
	RJMP _0xB9
; 0000 05AF }
_0xC9:
	RJMP _0xC9

	.DSEG
_0xB8:
	.BYTE 0x12

	.CSEG
_puts:
	ST   -Y,R17
_0x2000003:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000005
	ST   -Y,R17
	RCALL _putchar
	RJMP _0x2000003
_0x2000005:
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _putchar
	LDD  R17,Y+0
	ADIW R28,3
	RET
_put_buff_G100:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x2B
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0x2B
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__ftoe_G100:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2000019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2000000,0
	CALL SUBOPT_0x2C
	RJMP _0x20A0005
_0x2000019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2000018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2000000,1
	CALL SUBOPT_0x2C
	RJMP _0x20A0005
_0x2000018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x200001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x200001B:
	LDD  R17,Y+11
_0x200001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200001E
	CALL SUBOPT_0x2D
	RJMP _0x200001C
_0x200001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x200001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x2D
	RJMP _0x2000020
_0x200001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x2E
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2000021
	CALL SUBOPT_0x2D
_0x2000022:
	CALL SUBOPT_0x2E
	BRLO _0x2000024
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	RJMP _0x2000022
_0x2000024:
	RJMP _0x2000025
_0x2000021:
_0x2000026:
	CALL SUBOPT_0x2E
	BRSH _0x2000028
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x31
	CALL SUBOPT_0x32
	SUBI R19,LOW(1)
	RJMP _0x2000026
_0x2000028:
	CALL SUBOPT_0x2D
_0x2000025:
	__GETD1S 12
	CALL SUBOPT_0x33
	CALL SUBOPT_0x32
	CALL SUBOPT_0x2E
	BRLO _0x2000029
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
_0x2000029:
_0x2000020:
	LDI  R17,LOW(0)
_0x200002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x200002C
	__GETD2S 4
	CALL SUBOPT_0x34
	CALL SUBOPT_0x33
	CALL __PUTPARD1
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0x2F
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x35
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x36
	CALL SUBOPT_0x32
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x200002A
	CALL SUBOPT_0x35
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x200002A
_0x200002C:
	CALL SUBOPT_0x37
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x200002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x200010E
_0x200002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x200010E:
	ST   X,R30
	CALL SUBOPT_0x37
	CALL SUBOPT_0x37
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x37
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0005:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
__print_G100:
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x2B
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2000036
	CPI  R18,37
	BRNE _0x2000037
	LDI  R17,LOW(1)
	RJMP _0x2000038
_0x2000037:
	CALL SUBOPT_0x38
_0x2000038:
	RJMP _0x2000035
_0x2000036:
	CPI  R30,LOW(0x1)
	BRNE _0x2000039
	CPI  R18,37
	BRNE _0x200003A
	CALL SUBOPT_0x38
	RJMP _0x200010F
_0x200003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x200003B
	LDI  R16,LOW(1)
	RJMP _0x2000035
_0x200003B:
	CPI  R18,43
	BRNE _0x200003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003C:
	CPI  R18,32
	BRNE _0x200003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003D:
	RJMP _0x200003E
_0x2000039:
	CPI  R30,LOW(0x2)
	BRNE _0x200003F
_0x200003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000040
	ORI  R16,LOW(128)
	RJMP _0x2000035
_0x2000040:
	RJMP _0x2000041
_0x200003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2000042
_0x2000041:
	CPI  R18,48
	BRLO _0x2000044
	CPI  R18,58
	BRLO _0x2000045
_0x2000044:
	RJMP _0x2000043
_0x2000045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2000035
_0x2000043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2000046
	LDI  R17,LOW(4)
	RJMP _0x2000035
_0x2000046:
	RJMP _0x2000047
_0x2000042:
	CPI  R30,LOW(0x4)
	BRNE _0x2000049
	CPI  R18,48
	BRLO _0x200004B
	CPI  R18,58
	BRLO _0x200004C
_0x200004B:
	RJMP _0x200004A
_0x200004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2000035
_0x200004A:
_0x2000047:
	CPI  R18,108
	BRNE _0x200004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2000035
_0x200004D:
	RJMP _0x200004E
_0x2000049:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x2000035
_0x200004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000053
	CALL SUBOPT_0x39
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x39
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x3B
	RJMP _0x2000054
_0x2000053:
	CPI  R30,LOW(0x45)
	BREQ _0x2000057
	CPI  R30,LOW(0x65)
	BRNE _0x2000058
_0x2000057:
	RJMP _0x2000059
_0x2000058:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x200005A
_0x2000059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x3C
	CALL __GETD1P
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3E
	LDD  R26,Y+13
	TST  R26
	BRMI _0x200005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x200005D
	RJMP _0x200005E
_0x200005B:
	CALL SUBOPT_0x3F
	CALL __ANEGF1
	CALL SUBOPT_0x3D
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x200005D:
	SBRS R16,7
	RJMP _0x200005F
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x3B
	RJMP _0x2000060
_0x200005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2000060:
_0x200005E:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2000062
	CALL SUBOPT_0x3F
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _ftoa
	RJMP _0x2000063
_0x2000062:
	CALL SUBOPT_0x3F
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL __ftoe_G100
_0x2000063:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x40
	RJMP _0x2000064
_0x200005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2000066
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x41
	CALL SUBOPT_0x40
	RJMP _0x2000067
_0x2000066:
	CPI  R30,LOW(0x70)
	BRNE _0x2000069
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x41
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000067:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x200006B
	CP   R20,R17
	BRLO _0x200006C
_0x200006B:
	RJMP _0x200006A
_0x200006C:
	MOV  R17,R20
_0x200006A:
_0x2000064:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x200006D
_0x2000069:
	CPI  R30,LOW(0x64)
	BREQ _0x2000070
	CPI  R30,LOW(0x69)
	BRNE _0x2000071
_0x2000070:
	ORI  R16,LOW(4)
	RJMP _0x2000072
_0x2000071:
	CPI  R30,LOW(0x75)
	BRNE _0x2000073
_0x2000072:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2000074
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x42
	LDI  R17,LOW(10)
	RJMP _0x2000075
_0x2000074:
	__GETD1N 0x2710
	CALL SUBOPT_0x42
	LDI  R17,LOW(5)
	RJMP _0x2000075
_0x2000073:
	CPI  R30,LOW(0x58)
	BRNE _0x2000077
	ORI  R16,LOW(8)
	RJMP _0x2000078
_0x2000077:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x20000B6
_0x2000078:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x200007A
	__GETD1N 0x10000000
	CALL SUBOPT_0x42
	LDI  R17,LOW(8)
	RJMP _0x2000075
_0x200007A:
	__GETD1N 0x1000
	CALL SUBOPT_0x42
	LDI  R17,LOW(4)
_0x2000075:
	CPI  R20,0
	BREQ _0x200007B
	ANDI R16,LOW(127)
	RJMP _0x200007C
_0x200007B:
	LDI  R20,LOW(1)
_0x200007C:
	SBRS R16,1
	RJMP _0x200007D
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x3C
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2000110
_0x200007D:
	SBRS R16,2
	RJMP _0x200007F
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x41
	CALL __CWD1
	RJMP _0x2000110
_0x200007F:
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x41
	CLR  R22
	CLR  R23
_0x2000110:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2000081
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2000082
	CALL SUBOPT_0x3F
	CALL __ANEGD1
	CALL SUBOPT_0x3D
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000082:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2000083
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2000084
_0x2000083:
	ANDI R16,LOW(251)
_0x2000084:
_0x2000081:
	MOV  R19,R20
_0x200006D:
	SBRC R16,0
	RJMP _0x2000085
_0x2000086:
	CP   R17,R21
	BRSH _0x2000089
	CP   R19,R21
	BRLO _0x200008A
_0x2000089:
	RJMP _0x2000088
_0x200008A:
	SBRS R16,7
	RJMP _0x200008B
	SBRS R16,2
	RJMP _0x200008C
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x200008D
_0x200008C:
	LDI  R18,LOW(48)
_0x200008D:
	RJMP _0x200008E
_0x200008B:
	LDI  R18,LOW(32)
_0x200008E:
	CALL SUBOPT_0x38
	SUBI R21,LOW(1)
	RJMP _0x2000086
_0x2000088:
_0x2000085:
_0x200008F:
	CP   R17,R20
	BRSH _0x2000091
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000092
	CALL SUBOPT_0x43
	BREQ _0x2000093
	SUBI R21,LOW(1)
_0x2000093:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2000092:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x3B
	CPI  R21,0
	BREQ _0x2000094
	SUBI R21,LOW(1)
_0x2000094:
	SUBI R20,LOW(1)
	RJMP _0x200008F
_0x2000091:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2000095
_0x2000096:
	CPI  R19,0
	BREQ _0x2000098
	SBRS R16,3
	RJMP _0x2000099
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x200009A
_0x2000099:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x200009A:
	CALL SUBOPT_0x38
	CPI  R21,0
	BREQ _0x200009B
	SUBI R21,LOW(1)
_0x200009B:
	SUBI R19,LOW(1)
	RJMP _0x2000096
_0x2000098:
	RJMP _0x200009C
_0x2000095:
_0x200009E:
	CALL SUBOPT_0x44
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20000A0
	SBRS R16,3
	RJMP _0x20000A1
	SUBI R18,-LOW(55)
	RJMP _0x20000A2
_0x20000A1:
	SUBI R18,-LOW(87)
_0x20000A2:
	RJMP _0x20000A3
_0x20000A0:
	SUBI R18,-LOW(48)
_0x20000A3:
	SBRC R16,4
	RJMP _0x20000A5
	CPI  R18,49
	BRSH _0x20000A7
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20000A6
_0x20000A7:
	RJMP _0x20000A9
_0x20000A6:
	CP   R20,R19
	BRSH _0x2000111
	CP   R21,R19
	BRLO _0x20000AC
	SBRS R16,0
	RJMP _0x20000AD
_0x20000AC:
	RJMP _0x20000AB
_0x20000AD:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20000AE
_0x2000111:
	LDI  R18,LOW(48)
_0x20000A9:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20000AF
	CALL SUBOPT_0x43
	BREQ _0x20000B0
	SUBI R21,LOW(1)
_0x20000B0:
_0x20000AF:
_0x20000AE:
_0x20000A5:
	CALL SUBOPT_0x38
	CPI  R21,0
	BREQ _0x20000B1
	SUBI R21,LOW(1)
_0x20000B1:
_0x20000AB:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x44
	CALL __MODD21U
	CALL SUBOPT_0x3D
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x42
	__GETD1S 16
	CALL __CPD10
	BREQ _0x200009F
	RJMP _0x200009E
_0x200009F:
_0x200009C:
	SBRS R16,0
	RJMP _0x20000B2
_0x20000B3:
	CPI  R21,0
	BREQ _0x20000B5
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x3B
	RJMP _0x20000B3
_0x20000B5:
_0x20000B2:
_0x20000B6:
_0x2000054:
_0x200010F:
	LDI  R17,LOW(0)
_0x2000035:
	RJMP _0x2000030
_0x2000032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x45
	SBIW R30,0
	BRNE _0x20000B7
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0004
_0x20000B7:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x45
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20A0004:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG
_strcpyf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
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

	.CSEG
_ftrunc:
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	CALL SUBOPT_0x20
	CALL __PUTPARD1
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL SUBOPT_0x20
	RJMP _0x20A0003
__floor1:
    brtc __floor0
	CALL SUBOPT_0x20
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x20A0003:
	ADIW R28,4
	RET

	.CSEG
_ftoa:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x208000D
	RCALL SUBOPT_0x46
	__POINTW1FN _0x2080000,0
	RCALL SUBOPT_0x2C
	RJMP _0x20A0002
_0x208000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x208000C
	RCALL SUBOPT_0x46
	__POINTW1FN _0x2080000,1
	RCALL SUBOPT_0x2C
	RJMP _0x20A0002
_0x208000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x208000F
	__GETD1S 9
	CALL __ANEGF1
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x48
	LDI  R30,LOW(45)
	ST   X,R30
_0x208000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2080010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2080010:
	LDD  R17,Y+8
_0x2080011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2080013
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x4A
	RJMP _0x2080011
_0x2080013:
	RCALL SUBOPT_0x4B
	CALL __ADDF12
	RCALL SUBOPT_0x47
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x4A
_0x2080014:
	RCALL SUBOPT_0x4B
	CALL __CMPF12
	BRLO _0x2080016
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x4A
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2080017
	RCALL SUBOPT_0x46
	__POINTW1FN _0x2080000,5
	RCALL SUBOPT_0x2C
	RJMP _0x20A0002
_0x2080017:
	RJMP _0x2080014
_0x2080016:
	CPI  R17,0
	BRNE _0x2080018
	RCALL SUBOPT_0x48
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2080019
_0x2080018:
_0x208001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x208001C
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x33
	CALL __PUTPARD1
	CALL _floor
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x4B
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x48
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x49
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	RCALL SUBOPT_0x4C
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x47
	RJMP _0x208001A
_0x208001C:
_0x2080019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20A0001
	RCALL SUBOPT_0x48
	LDI  R30,LOW(46)
	ST   X,R30
_0x208001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2080020
	RCALL SUBOPT_0x4C
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x47
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x48
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x4C
	CALL __CWD1
	CALL __CDF1
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x47
	RJMP _0x208001E
_0x2080020:
_0x20A0001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET

	.DSEG

	.CSEG

	.DSEG
_OSDchr:
	.BYTE 0x100
_ch:
	.BYTE 0x1E
_sum:
	.BYTE 0x4
_RTC_sec:
	.BYTE 0x4
_rx_buffer_usartd0:
	.BYTE 0x8
_rx_wr_index_usartd0:
	.BYTE 0x1
_rx_rd_index_usartd0:
	.BYTE 0x1
_rx_counter_usartd0:
	.BYTE 0x1
_command:
	.BYTE 0x1F
_command_size:
	.BYTE 0x1
_a_S0000018000:
	.BYTE 0x2
_encorder_pointer:
	.BYTE 0x2
_temp:
	.BYTE 0x1E
_timer_pointer:
	.BYTE 0x1
_hour:
	.BYTE 0x1
_minu:
	.BYTE 0x2
_date_pointer:
	.BYTE 0x2
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDS  R30,_command_size
	LDI  R31,0
	SUBI R30,LOW(-_command)
	SBCI R31,HIGH(-_command)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(16)
	STS  1606,R30
	__DELAY_USB 1
	LDD  R30,Y+2
	ST   -Y,R30
	JMP  _SPI1_Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	__DELAY_USB 1
	LDI  R30,LOW(16)
	STS  1605,R30
	__DELAY_USB 7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _MAX7456_SPI_WRITE

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _MAX7456_SPI_WRITE

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7:
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _MAX7456_Write
	MOVW R30,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_a_S0000018000
	LDS  R31,_a_S0000018000+1
	__ADDW1MN _OSDchr,48
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:97 WORDS
SUBOPT_0x9:
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	JMP  _MAX7456_Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xA:
	__GETB1MN _command,4
	LDI  R31,0
	SBIW R30,48
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0xB:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	MOVW R18,R16
	LDI  R26,LOW(_command)
	LDI  R27,HIGH(_command)
	ADD  R26,R18
	ADC  R27,R19
	LD   R26,X
	CPI  R26,LOW(0x3B)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(_command)
	LDI  R27,HIGH(_command)
	ADD  R26,R18
	ADC  R27,R19
	LD   R30,X
	LDI  R31,0
	SUBI R30,LOW(-_OSDchr)
	SBCI R31,HIGH(-_OSDchr)
	LD   R30,Z
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(16)
	STS  1636,R30
	LDI  R30,LOW(0)
	STS  1636,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	ST   -Y,R30
	CALL _spid_master_tx_rx
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _spid_master_tx_rx

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_encorder_pointer
	LDS  R31,_encorder_pointer+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x15:
	LDI  R31,0
	SUBI R30,LOW(-_OSDchr)
	SBCI R31,HIGH(-_OSDchr)
	LD   R30,Z
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	STS  _encorder_pointer,R30
	STS  _encorder_pointer+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	ST   -Y,R17
	ST   -Y,R16
	LDS  R26,_RTC_sec
	LDS  R27,_RTC_sec+1
	LDS  R24,_RTC_sec+2
	LDS  R25,_RTC_sec+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:74 WORDS
SUBOPT_0x18:
	STS  _timer_pointer,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_timer_pointer
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	LDS  R30,_timer_pointer
	SUBI R30,LOW(1)
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	__ADDW1MN _OSDchr,48
	LD   R30,Z
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	__ADDW1MN _OSDchr,48
	LD   R30,Z
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	LDS  R26,_minu
	LDS  R27,_minu+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	STS  _minu,R30
	STS  _minu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(0)
	STS  _RTC_sec,R30
	STS  _RTC_sec+1,R30
	STS  _RTC_sec+2,R30
	STS  _RTC_sec+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	__GETD2S 4
	__GETD1N 0xA
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x21:
	__GETB1MN _command,3
	LDI  R31,0
	SBIW R30,48
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	MOV  R26,R30
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDI  R31,0
	SBIW R30,48
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	SBIW R30,1
	ADD  R30,R26
	ADC  R31,R27
	RCALL SUBOPT_0x1D
	JMP  _ontime_min

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x24:
	STS  _date_pointer,R30
	STS  _date_pointer+1,R31
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x25:
	LDS  R30,_date_pointer
	LDS  R31,_date_pointer+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x26:
	RCALL SUBOPT_0x25
	SBIW R30,1
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x27:
	RCALL SUBOPT_0x25
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _spid_master_tx_rx

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x29:
	CLR  R31
	CLR  R22
	CLR  R23
	__ANDD1N 0xFF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2B:
	CALL __GETW1P
	ADIW R30,1
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2C:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _strcpyf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2D:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2E:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2F:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x30:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x31:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x33:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x34:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x37:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x38:
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x39:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3A:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3B:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x3C:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3E:
	RCALL SUBOPT_0x39
	RJMP SUBOPT_0x3A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3F:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x40:
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x41:
	RCALL SUBOPT_0x3C
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x42:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x43:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 91
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x44:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x46:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x47:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x48:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x49:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4A:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4B:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4C:
	__GETD2S 9
	RET


	.CSEG
__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ORD12:
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__LSLD16:
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
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

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
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

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
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

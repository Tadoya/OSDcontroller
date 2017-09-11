/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2014-01-27
Author  : NeVaDa
Company : 
Comments: 


Chip type               : ATxmega32A4
Program type            : Application
AVR Core Clock frequency: 2.000000 MHz
Memory model            : Small
Data Stack size         : 1024
*****************************************************/

// I/O Registers definitions
#include <io.h>

// Standard Input/Output functions
#include <stdio.h>
#include <delay.h>
#include <stdio.h>
#include <string.h>

// Declare your global variables here
// Array of character addresses in MAX7456
const char OSDchr[256]={  0xF2,  0xF1,  0xF0,  0xEF, 0xEE,  0xED, 0xF3,            // 0-6 progress bar
  0xFB,0xA9,0xAA,0xAB,0xAC,0xAD,0xAE,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,      // 7-33
  0x48, 0,0,0,0, 0x46,0x3F,0x40, 0,0, 0x45,0x49,0x41,0x47,                         // 34; 35-38; 39-41; 42-43; 44-47
  0x0A, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x44, 0x43, 0x4A,    // 48-60
  0, 0x4B, 0x42, 0x4C,                                                             // 61; 62-64
  0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,    // 65-77  A-M
  0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F, 0x20, 0x21, 0x22, 0x23, 0x24,    // 78-90  N-Z
  0, 0, 0, 0, 0, 0,                                                                // 91-96
  0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x2F, 0x30, 0x31,    // 97-109   a-m
  0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D, 0x3E     // 110-122  n-z
};
int col_pointer=1, row_pointer=1, title_pointer;
int ten_ms;

char ch[30]="";
unsigned char a,b,c,d;
long int sum;
bit flag_com=0;

//////////////////////////////////////////////////////////////encorder///////////////////////////////////////////////////////////////////
#define SELECT_MDR0 0b00001000     // Select MDR0
#define SELECT_MDR1 0b00010000     // Select MDR1
#define SELECT_DTR  0b00011000     // Select DTR
#define SELECT_CNTR 0b00100000     // Select CNTR
#define SELECT_OTR  0b00101000     // Select OTR
#define SELECT_STR  0b00110000     // Select STR

#define CLR_REG     0b00000000     // CLR  register
#define RD_REG      0b01000000     // RD   register
#define WR_REG      0b10000000     // WR   register
#define LOAD_REG    0b11000000     // LOAD register
#define NON_QUAD            0b00000000      // non-quadrature counter mode.
#define X1_QUAD             0b00000001      // x1 quadrature counter mode.
#define X2_QUAD             0b00000010      // x2 quadrature counter mode.
#define X4_QUAD             0b00000011      // x4 quadrature counter mode.
#define FREE_RUN            0b00000000      // free-running count mode.
#define SINGLE_CYCLE        0b00000100      // single-cycle count mode.
#define RANGE_LIMIT         0b00001000      // range-limit count mode.
#define MODULO_N            0b00001100      // modulo-n count mode.
#define DISABLE_INDEX       0b00000000      // disable index.
#define INDEX_AS_LOAD_CNTR  0b00010000      // configure index as the "load CNTR" input(clears CNTR to 0).
#define INDEX_AS_RESET_CNTR 0b00100000      // configure index as the "reset CNTR" input(clears CNTR to 0).
#define INDEX_AS_LOAD_OTR   0b00110000      // configure index as the "load OTR" input(transfer CNTR to OTR).
#define ASYCHRONOUS_INDEX   0b00000000      // Asynchronous index
#define SYNCHRONOUS_INDEX   0b01000000      // Synchoronous index
#define FILTER_CDF_1        0b00000000      // Filter clock division factor = 1
#define FILTER_CDF_2        0b10000000      // Filter clock division factor = 2
#define FOUR_BYTE_COUNT_MODE    0b00000000       // 4-byte counter mode
#define THREE_BYTE_COUNT_MODE   0b00000001       // 3-byte counter mode
#define TWO_BYTE_COUNT_MODE     0b00000010       // 2-byte counter mode
#define ENABLE_COUNTING         0b00000000       // Enable counting
#define DISABLE_COUNTING        0b00000100       // Disable counting
#define FLAG_ON_IDX             0b00010000       // FLAG on IDX (B4 of STR)
#define FLAG_ON_CMP             0b00100000       // FLAG on CMP (B5 of STR)
#define FLAG_ON_BW              0b01000000       // FLAG on BW (B6 of STR)
#define FLAG_ON_CY              0b10000000       // FLAG on CY (B7 of STR)
#define LS7366_SS_H_L  PORTD.OUT = 0x00;    // Device Select or Start
#define LS7366_SS_L_H  PORTD.OUT = 0x10;    // Device Unselect or End
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// System Clocks initialization


void system_clocks_init(void)
{
unsigned char n,s;

// Optimize for speed
#pragma optsize- 
// Save interrupts enabled/disabled state
s=SREG;
// Disable interrupts
#asm("cli")

// Internal 2 MHz RC oscillator initialization
// Enable the internal 2 MHz RC oscillator
OSC.CTRL|=OSC_RC2MEN_bm;

// System Clock prescaler A division factor: 1
// System Clock prescalers B & C division factors: B:1, C:1
// ClkPer4: 2000.000 kHz
// ClkPer2: 2000.000 kHz
// ClkPer:  2000.000 kHz
// ClkCPU:  2000.000 kHz
n=(CLK.PSCTRL & (~(CLK_PSADIV_gm | CLK_PSBCDIV1_bm | CLK_PSBCDIV0_bm))) |
	CLK_PSADIV_1_gc | CLK_PSBCDIV_1_1_gc;
CCP=CCP_IOREG_gc;
CLK.PSCTRL=n;

// Disable the autocalibration of the internal 2 MHz RC oscillator
DFLLRC2M.CTRL&= ~DFLL_ENABLE_bm;

// Wait for the internal 2 MHz RC oscillator to stabilize
while ((OSC.STATUS & OSC_RC2MRDY_bm)==0);

// Select the system clock source: 2 MHz Internal RC Osc.
n=(CLK.CTRL & (~CLK_SCLKSEL_gm)) | CLK_SCLKSEL_RC2M_gc;
CCP=CCP_IOREG_gc;
CLK.CTRL=n;

// Disable the unused oscillators: 32 MHz, 32 kHz, external clock/crystal oscillator, PLL
OSC.CTRL&= ~(OSC_RC32MEN_bm | OSC_RC32KEN_bm | OSC_XOSCEN_bm | OSC_PLLEN_bm);

// Peripheral Clock output: Disabled
PORTCFG.CLKEVOUT=(PORTCFG.CLKEVOUT & (~PORTCFG_CLKOUT_gm)) | PORTCFG_CLKOUT_OFF_gc;

// Restore interrupts enabled/disabled state
SREG=s;
// Restore optimization for size if needed
#pragma optsize_default
}

// Watchdog Timer initialization
void watchdog_init(void)
{
unsigned char s,n;

// Optimize for speed
#pragma optsize- 
// Save interrupts enabled/disabled state
s=SREG;
// Disable interrupts
#asm("cli")

// Watchdog Timer: Off
n=(WDT.CTRL & (~WDT_ENABLE_bm)) | WDT_CEN_bm;
CCP=CCP_IOREG_gc;
WDT.CTRL=n;
// Watchdog window mode: Off
n=(WDT.WINCTRL & (~WDT_WEN_bm)) | WDT_WCEN_bm;
CCP=CCP_IOREG_gc;
WDT.WINCTRL=n;

// Restore interrupts enabled/disabled state
SREG=s;
// Restore optimization for size if needed
#pragma optsize_default
}

// Event System initialization
void event_system_init(void)
{
// Event System Channel 0 source: None
EVSYS.CH0MUX=EVSYS_CHMUX_OFF_gc;
// Event System Channel 1 source: None
EVSYS.CH1MUX=EVSYS_CHMUX_OFF_gc;
// Event System Channel 2 source: None
EVSYS.CH2MUX=EVSYS_CHMUX_OFF_gc;
// Event System Channel 3 source: None
EVSYS.CH3MUX=EVSYS_CHMUX_OFF_gc;
// Event System Channel 4 source: None
EVSYS.CH4MUX=EVSYS_CHMUX_OFF_gc;
// Event System Channel 5 source: None
EVSYS.CH5MUX=EVSYS_CHMUX_OFF_gc;
// Event System Channel 6 source: None
EVSYS.CH6MUX=EVSYS_CHMUX_OFF_gc;
// Event System Channel 7 source: None
EVSYS.CH7MUX=EVSYS_CHMUX_OFF_gc;

// Event System Channel 0 Digital Filter Coefficient: 1 Sample
EVSYS.CH0CTRL=(EVSYS.CH0CTRL & (~(EVSYS_QDIRM_gm | EVSYS_QDIEN_bm | EVSYS_QDEN_bm | EVSYS_DIGFILT_gm))) |
	EVSYS_DIGFILT_1SAMPLE_gc;
// Event System Channel 1 Digital Filter Coefficient: 1 Sample
EVSYS.CH1CTRL=EVSYS_DIGFILT_1SAMPLE_gc;
// Event System Channel 2 Digital Filter Coefficient: 1 Sample
EVSYS.CH2CTRL=(EVSYS.CH2CTRL & (~(EVSYS_QDIRM_gm | EVSYS_QDIEN_bm | EVSYS_QDEN_bm | EVSYS_DIGFILT_gm))) |
	EVSYS_DIGFILT_1SAMPLE_gc;
// Event System Channel 3 Digital Filter Coefficient: 1 Sample
EVSYS.CH3CTRL=EVSYS_DIGFILT_1SAMPLE_gc;
// Event System Channel 4 Digital Filter Coefficient: 1 Sample
EVSYS.CH4CTRL=(EVSYS.CH4CTRL & (~(EVSYS_QDIRM_gm | EVSYS_QDIEN_bm | EVSYS_QDEN_bm | EVSYS_DIGFILT_gm))) |
	EVSYS_DIGFILT_1SAMPLE_gc;
// Event System Channel 5 Digital Filter Coefficient: 1 Sample
EVSYS.CH5CTRL=EVSYS_DIGFILT_1SAMPLE_gc;
// Event System Channel 6 Digital Filter Coefficient: 1 Sample
EVSYS.CH6CTRL=EVSYS_DIGFILT_1SAMPLE_gc;
// Event System Channel 7 Digital Filter Coefficient: 1 Sample
EVSYS.CH7CTRL=EVSYS_DIGFILT_1SAMPLE_gc;

// Event System Channel 0 output: Disabled
// Note: the correct direction for the Event System Channel 0 output
// is configured in the ports_init function
PORTCFG.CLKEVOUT=(PORTCFG.CLKEVOUT & (~PORTCFG_EVOUT_gm)) | PORTCFG_EVOUT_OFF_gc;
}

// Ports initialization
void ports_init(void)
{
// PORTA initialization
// OUT register
PORTA.OUT=0x00;
// Bit0: Input
// Bit1: Input
// Bit2: Input
// Bit3: Input
// Bit4: Input
// Bit5: Input
// Bit6: Input
// Bit7: Input
PORTA.DIR=0x00;
// Bit0 Output/Pull configuration: Totempole/No
// Bit0 Input/Sense configuration: Sense both edges
// Bit0 inverted: Off
// Bit0 slew rate limitation: Off
PORTA.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit1 Output/Pull configuration: Totempole/No
// Bit1 Input/Sense configuration: Sense both edges
// Bit1 inverted: Off
// Bit1 slew rate limitation: Off
PORTA.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit2 Output/Pull configuration: Totempole/No
// Bit2 Input/Sense configuration: Sense both edges
// Bit2 inverted: Off
// Bit2 slew rate limitation: Off
PORTA.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit3 Output/Pull configuration: Totempole/No
// Bit3 Input/Sense configuration: Sense both edges
// Bit3 inverted: Off
// Bit3 slew rate limitation: Off
PORTA.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit4 Output/Pull configuration: Totempole/No
// Bit4 Input/Sense configuration: Sense both edges
// Bit4 inverted: Off
// Bit4 slew rate limitation: Off
PORTA.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit5 Output/Pull configuration: Totempole/No
// Bit5 Input/Sense configuration: Sense both edges
// Bit5 inverted: Off
// Bit5 slew rate limitation: Off
PORTA.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit6 Output/Pull configuration: Totempole/No
// Bit6 Input/Sense configuration: Sense both edges
// Bit6 inverted: Off
// Bit6 slew rate limitation: Off
PORTA.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit7 Output/Pull configuration: Totempole/No
// Bit7 Input/Sense configuration: Sense both edges
// Bit7 inverted: Off
// Bit7 slew rate limitation: Off
PORTA.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Interrupt 0 level: Disabled
// Interrupt 1 level: Disabled
PORTA.INTCTRL=(PORTA.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
// Bit0 pin change interrupt 0: Off
// Bit1 pin change interrupt 0: Off
// Bit2 pin change interrupt 0: Off
// Bit3 pin change interrupt 0: Off
// Bit4 pin change interrupt 0: Off
// Bit5 pin change interrupt 0: Off
// Bit6 pin change interrupt 0: Off
// Bit7 pin change interrupt 0: Off
PORTA.INT0MASK=0x00;
// Bit0 pin change interrupt 1: Off
// Bit1 pin change interrupt 1: Off
// Bit2 pin change interrupt 1: Off
// Bit3 pin change interrupt 1: Off
// Bit4 pin change interrupt 1: Off
// Bit5 pin change interrupt 1: Off
// Bit6 pin change interrupt 1: Off
// Bit7 pin change interrupt 1: Off
PORTA.INT1MASK=0x00;

// PORTB initialization
// OUT register
PORTB.OUT=0x00;
// Bit0: Input
// Bit1: Input
// Bit2: Input
// Bit3: Input
PORTB.DIR=0x00;
// Bit0 Output/Pull configuration: Totempole/No
// Bit0 Input/Sense configuration: Sense both edges
// Bit0 inverted: Off
// Bit0 slew rate limitation: Off
PORTB.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit1 Output/Pull configuration: Totempole/No
// Bit1 Input/Sense configuration: Sense both edges
// Bit1 inverted: Off
// Bit1 slew rate limitation: Off
PORTB.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit2 Output/Pull configuration: Totempole/No
// Bit2 Input/Sense configuration: Sense both edges
// Bit2 inverted: Off
// Bit2 slew rate limitation: Off
PORTB.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit3 Output/Pull configuration: Totempole/No
// Bit3 Input/Sense configuration: Sense both edges
// Bit3 inverted: Off
// Bit3 slew rate limitation: Off
PORTB.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Interrupt 0 level: Disabled
// Interrupt 1 level: Disabled
PORTB.INTCTRL=(PORTB.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
// Bit0 pin change interrupt 0: Off
// Bit1 pin change interrupt 0: Off
// Bit2 pin change interrupt 0: Off
// Bit3 pin change interrupt 0: Off
PORTB.INT0MASK=0x00;
// Bit0 pin change interrupt 1: Off
// Bit1 pin change interrupt 1: Off
// Bit2 pin change interrupt 1: Off
// Bit3 pin change interrupt 1: Off
PORTB.INT1MASK=0x00;

// PORTC initialization
// OUT register
PORTC.OUT=0x10;
// Bit0: Input
// Bit1: Input
// Bit2: Input
// Bit3: Input
// Bit4: Output
// Bit5: Output
// Bit6: Input
// Bit7: Output
PORTC.DIR=0xB0;
// Bit0 Output/Pull configuration: Totempole/No
// Bit0 Input/Sense configuration: Sense both edges
// Bit0 inverted: Off
// Bit0 slew rate limitation: Off
PORTC.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit1 Output/Pull configuration: Totempole/No
// Bit1 Input/Sense configuration: Sense both edges
// Bit1 inverted: Off
// Bit1 slew rate limitation: Off
PORTC.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit2 Output/Pull configuration: Totempole/No
// Bit2 Input/Sense configuration: Sense both edges
// Bit2 inverted: Off
// Bit2 slew rate limitation: Off
PORTC.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit3 Output/Pull configuration: Totempole/No
// Bit3 Input/Sense configuration: Sense both edges
// Bit3 inverted: Off
// Bit3 slew rate limitation: Off
PORTC.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit4 Output/Pull configuration: Totempole/No
// Bit4 Input/Sense configuration: Sense both edges
// Bit4 inverted: Off
// Bit4 slew rate limitation: Off
PORTC.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit5 Output/Pull configuration: Totempole/No
// Bit5 Input/Sense configuration: Sense both edges
// Bit5 inverted: Off
// Bit5 slew rate limitation: Off
PORTC.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit6 Output/Pull configuration: Totempole/No
// Bit6 Input/Sense configuration: Sense both edges
// Bit6 inverted: Off
// Bit6 slew rate limitation: Off
//PORTC.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit6 Output/Pull configuration: Totempole/Pull-up (on input)
// Bit6 Input/Sense configuration: Sense both edges
// Bit6 inverted: Off
// Bit6 slew rate limitation: Off
PORTC.PIN6CTRL=PORT_OPC_PULLUP_gc | PORT_ISC_BOTHEDGES_gc; ///////////////////////////////////////////////////pull up!

// Bit7 Output/Pull configuration: Totempole/No
// Bit7 Input/Sense configuration: Sense both edges
// Bit7 inverted: Off
// Bit7 slew rate limitation: Off
PORTC.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Interrupt 0 level: Disabled
// Interrupt 1 level: Disabled
PORTC.INTCTRL=(PORTC.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
// Bit0 pin change interrupt 0: Off
// Bit1 pin change interrupt 0: Off
// Bit2 pin change interrupt 0: Off
// Bit3 pin change interrupt 0: Off
// Bit4 pin change interrupt 0: Off
// Bit5 pin change interrupt 0: Off
// Bit6 pin change interrupt 0: Off
// Bit7 pin change interrupt 0: Off
PORTC.INT0MASK=0x00;
// Bit0 pin change interrupt 1: Off
// Bit1 pin change interrupt 1: Off
// Bit2 pin change interrupt 1: Off
// Bit3 pin change interrupt 1: Off
// Bit4 pin change interrupt 1: Off
// Bit5 pin change interrupt 1: Off
// Bit6 pin change interrupt 1: Off
// Bit7 pin change interrupt 1: Off
PORTC.INT1MASK=0x00;

// PORTD initialization
// OUT register
PORTD.OUT=0x18;
// Bit0: Input
// Bit1: Input
// Bit2: Input
// Bit3: Output
// Bit4: Output
// Bit5: Output
// Bit6: Input
// Bit7: Output
PORTD.DIR=0xB8;
// Bit0 Output/Pull configuration: Totempole/No
// Bit0 Input/Sense configuration: Sense both edges
// Bit0 inverted: Off
// Bit0 slew rate limitation: Off
PORTD.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit1 Output/Pull configuration: Totempole/No
// Bit1 Input/Sense configuration: Sense both edges
// Bit1 inverted: Off
// Bit1 slew rate limitation: Off
PORTD.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit2 Output/Pull configuration: Totempole/No
// Bit2 Input/Sense configuration: Sense both edges
// Bit2 inverted: Off
// Bit2 slew rate limitation: Off
PORTD.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit3 Output/Pull configuration: Totempole/No
// Bit3 Input/Sense configuration: Sense both edges
// Bit3 inverted: Off
// Bit3 slew rate limitation: Off
PORTD.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit4 Output/Pull configuration: Totempole/No
// Bit4 Input/Sense configuration: Sense both edges
// Bit4 inverted: Off
// Bit4 slew rate limitation: Off
PORTD.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit5 Output/Pull configuration: Totempole/No
// Bit5 Input/Sense configuration: Sense both edges
// Bit5 inverted: Off
// Bit5 slew rate limitation: Off
PORTD.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit6 Output/Pull configuration: Totempole/No
// Bit6 Input/Sense configuration: Sense both edges
// Bit6 inverted: Off
// Bit6 slew rate limitation: Off
PORTD.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit7 Output/Pull configuration: Totempole/No
// Bit7 Input/Sense configuration: Sense both edges
// Bit7 inverted: Off
// Bit7 slew rate limitation: Off
PORTD.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Interrupt 0 level: Disabled
// Interrupt 1 level: Disabled
PORTD.INTCTRL=(PORTD.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
// Bit0 pin change interrupt 0: Off
// Bit1 pin change interrupt 0: Off
// Bit2 pin change interrupt 0: Off
// Bit3 pin change interrupt 0: Off
// Bit4 pin change interrupt 0: Off
// Bit5 pin change interrupt 0: Off
// Bit6 pin change interrupt 0: Off
// Bit7 pin change interrupt 0: Off
PORTD.INT0MASK=0x00;
// Bit0 pin change interrupt 1: Off
// Bit1 pin change interrupt 1: Off
// Bit2 pin change interrupt 1: Off
// Bit3 pin change interrupt 1: Off
// Bit4 pin change interrupt 1: Off
// Bit5 pin change interrupt 1: Off
// Bit6 pin change interrupt 1: Off
// Bit7 pin change interrupt 1: Off
PORTD.INT1MASK=0x00;

// PORTE initialization
// OUT register
PORTE.OUT=0x00;
// Bit0: Input
// Bit1: Input
// Bit2: Input
// Bit3: Input
PORTE.DIR=0x00;
// Bit0 Output/Pull configuration: Totempole/No
// Bit0 Input/Sense configuration: Sense both edges
// Bit0 inverted: Off
// Bit0 slew rate limitation: Off
PORTE.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit1 Output/Pull configuration: Totempole/No
// Bit1 Input/Sense configuration: Sense both edges
// Bit1 inverted: Off
// Bit1 slew rate limitation: Off
PORTE.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit2 Output/Pull configuration: Totempole/No
// Bit2 Input/Sense configuration: Sense both edges
// Bit2 inverted: Off
// Bit2 slew rate limitation: Off
PORTE.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit3 Output/Pull configuration: Totempole/No
// Bit3 Input/Sense configuration: Sense both edges
// Bit3 inverted: Off
// Bit3 slew rate limitation: Off
PORTE.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Interrupt 0 level: Disabled
// Interrupt 1 level: Disabled
PORTE.INTCTRL=(PORTE.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
// Bit0 pin change interrupt 0: Off
// Bit1 pin change interrupt 0: Off
// Bit2 pin change interrupt 0: Off
// Bit3 pin change interrupt 0: Off
PORTE.INT0MASK=0x00;
// Bit0 pin change interrupt 1: Off
// Bit1 pin change interrupt 1: Off
// Bit2 pin change interrupt 1: Off
// Bit3 pin change interrupt 1: Off
PORTE.INT1MASK=0x00;

// PORTR initialization
// OUT register
PORTR.OUT=0x00;
// Bit0: Input
// Bit1: Input
PORTR.DIR=0x00;
// Bit0 Output/Pull configuration: Totempole/No
// Bit0 Input/Sense configuration: Sense both edges
// Bit0 inverted: Off
// Bit0 slew rate limitation: Off
PORTR.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Bit1 Output/Pull configuration: Totempole/No
// Bit1 Input/Sense configuration: Sense both edges
// Bit1 inverted: Off
// Bit1 slew rate limitation: Off
PORTR.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Interrupt 0 level: Disabled
// Interrupt 1 level: Disabled
PORTR.INTCTRL=(PORTR.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
// Bit0 pin change interrupt 0: Off
// Bit1 pin change interrupt 0: Off
PORTR.INT0MASK=0x00;
// Bit0 pin change interrupt 1: Off
// Bit1 pin change interrupt 1: Off
PORTR.INT1MASK=0x00;
}

// Virtual Ports initialization
void vports_init(void)
{
// PORTA mapped to VPORT0
// PORTB mapped to VPORT1
PORTCFG.VPCTRLA=PORTCFG_VP1MAP_PORTB_gc | PORTCFG_VP0MAP_PORTA_gc;
// PORTC mapped to VPORT2
// PORTD mapped to VPORT3
PORTCFG.VPCTRLB=PORTCFG_VP3MAP_PORTD_gc | PORTCFG_VP2MAP_PORTC_gc;
}
// Disable a Timer/Counter type 0
void tc0_disable(TC0_t *ptc)
{
// Timer/Counter off
ptc->CTRLA=(ptc->CTRLA & (~TC0_CLKSEL_gm)) | TC_CLKSEL_OFF_gc;
// Issue a reset command
ptc->CTRLFSET=TC_CMD_RESET_gc;
}
// Timer/Counter TCC0 initialization
void tcc0_init(void)
{
unsigned char s;
unsigned char n;

// Note: the correct PORTC direction for the Compare Channels outputs
// is configured in the ports_init function

// Save interrupts enabled/disabled state
s=SREG;
// Disable interrupts
#asm("cli")

// Disable and reset the timer/counter just to be sure
tc0_disable(&TCC0);
// Clock source: Peripheral Clock/1
TCC0.CTRLA=(TCC0.CTRLA & (~TC0_CLKSEL_gm)) | TC_CLKSEL_DIV1_gc;
// Mode: Normal Operation, Overflow Int./Event on TOP
// Compare/Capture on channel A: Off
// Compare/Capture on channel B: Off
// Compare/Capture on channel C: Off
// Compare/Capture on channel D: Off
TCC0.CTRLB=(TCC0.CTRLB & (~(TC0_CCAEN_bm | TC0_CCBEN_bm | TC0_CCCEN_bm | TC0_CCDEN_bm | TC0_WGMODE_gm))) |
	TC_WGMODE_NORMAL_gc;

// Capture event source: None
// Capture event action: None
TCC0.CTRLD=(TCC0.CTRLD & (~(TC0_EVACT_gm | TC0_EVSEL_gm))) |
	TC_EVACT_OFF_gc | TC_EVSEL_OFF_gc;

// Overflow interrupt: Low Level
// Error interrupt: Disabled
TCC0.INTCTRLA=(TCC0.INTCTRLA & (~(TC0_ERRINTLVL_gm | TC0_OVFINTLVL_gm))) |
	TC_ERRINTLVL_OFF_gc | TC_OVFINTLVL_LO_gc;

// Compare/Capture channel A interrupt: Disabled
// Compare/Capture channel B interrupt: Disabled
// Compare/Capture channel C interrupt: Disabled
// Compare/Capture channel D interrupt: Disabled
TCC0.INTCTRLB=(TCC0.INTCTRLB & (~(TC0_CCDINTLVL_gm | TC0_CCCINTLVL_gm | TC0_CCBINTLVL_gm | TC0_CCAINTLVL_gm))) |
	TC_CCDINTLVL_OFF_gc | TC_CCCINTLVL_OFF_gc | TC_CCBINTLVL_OFF_gc | TC_CCAINTLVL_OFF_gc;

// High resolution extension: Off
HIRESC.CTRL&= ~HIRES_HREN0_bm;

// Advanced Waveform Extension initialization
// Optimize for speed
#pragma optsize- 
// Disable locking the AWEX configuration registers just to be sure
n=MCU.AWEXLOCK & (~MCU_AWEXCLOCK_bm);
CCP=CCP_IOREG_gc;
MCU.AWEXLOCK=n;
// Restore optimization for size if needed
#pragma optsize_default

// Pattern generation: Off
// Dead time insertion: Off
AWEXC.CTRL&= ~(AWEX_PGM_bm | AWEX_CWCM_bm | AWEX_DTICCDEN_bm | AWEX_DTICCCEN_bm | AWEX_DTICCBEN_bm | AWEX_DTICCAEN_bm);

// Fault protection initialization
// Fault detection on OCD Break detection: On
// Fault detection restart mode: Latched Mode
// Fault detection action: None (Fault protection disabled)
AWEXC.FDCTRL=(AWEXC.FDCTRL & (~(AWEX_FDDBD_bm | AWEX_FDMODE_bm | AWEX_FDACT_gm))) |
	AWEX_FDACT_NONE_gc;
// Fault detect events: 
// Event channel 0: Off
// Event channel 1: Off
// Event channel 2: Off
// Event channel 3: Off
// Event channel 4: Off
// Event channel 5: Off
// Event channel 6: Off
// Event channel 7: Off
AWEXC.FDEVMASK=0b00000000;
// Make sure the fault detect flag is cleared
AWEXC.STATUS|=AWEXC.STATUS & AWEX_FDF_bm;

// Clear the interrupt flags
TCC0.INTFLAGS=TCC0.INTFLAGS;
// Set counter register
TCC0.CNT=0x0000;
// Set period register
TCC0.PER=0x4E1F;
// Set channel A Compare/Capture register
TCC0.CCA=0x0000;
// Set channel B Compare/Capture register
TCC0.CCB=0x0000;
// Set channel C Compare/Capture register
TCC0.CCC=0x0000;
// Set channel D Compare/Capture register
TCC0.CCD=0x0000;

// Restore interrupts enabled/disabled state
SREG=s;
}

// Timer/counter TCC0 Overflow/Underflow interrupt service routine
interrupt [TCC0_OVF_vect] void tcc0_overflow_isr(void)
{
// write your code here
    ten_ms++;
    if(ten_ms>128) //128
    {                                
        ten_ms=0;
    }
}

// RTC initialization

unsigned long int RTC_sec=0;
bit RTC_flag=0;

void rtcxm_init(void)
{
unsigned char s;

// RTC clock source: 1024 Hz from internal 32 kHz RC Oscillator
// Internal 32 kHz RC oscillator initialization
// Enable the internal 32 kHz RC oscillator
OSC.CTRL|=OSC_RC32KEN_bm;
// Wait for the internal 32 kHz RC oscillator to stabilize
while ((OSC.STATUS & OSC_RC32KRDY_bm)==0);

// Select the clock source and enable the RTC clock
CLK.RTCCTRL=(CLK.RTCCTRL & (~CLK_RTCSRC_gm)) | CLK_RTCSRC_RCOSC_gc | CLK_RTCEN_bm;
// Make sure that the RTC is stopped before initializing it
RTC.CTRL=(RTC.CTRL & (~RTC_PRESCALER_gm)) | RTC_PRESCALER_OFF_gc;

// Optimize for speed
#pragma optsize- 
// Save interrupts enabled/disabled state
s=SREG;
// Disable interrupts
#asm("cli")

// Wait until the RTC is not busy
while (RTC.STATUS & RTC_SYNCBUSY_bm);
// Set the RTC period register
RTC.PER=0x0400;
// Set the RTC count register
RTC.CNT=0x0000;
// Set the RTC compare register
RTC.COMP=0x0000;

// Restore interrupts enabled/disabled state
SREG=s;
// Restore optimization for size if needed
#pragma optsize_default

// Set the clock prescaler: RTC Clock/1
// and start the RTC
RTC.CTRL=(RTC.CTRL & (~RTC_PRESCALER_gm)) | RTC_PRESCALER_DIV1_gc;

// RTC overflow interrupt: Low Level
// RTC compare interrupt: Disabled
RTC.INTCTRL=(RTC.INTCTRL & (~(RTC_OVFINTLVL_gm | RTC_COMPINTLVL_gm))) |
	RTC_OVFINTLVL_LO_gc | RTC_COMPINTLVL_OFF_gc;
}

// RTC overflow interrupt service routine
interrupt [RTC_OVF_vect] void rtcxm_overflow_isr(void)
{
// write your code here
    RTC_flag=1;
    RTC_sec++;    
}

// Disable an USART
void usart_disable(USART_t *pu)
{
// Rx and Tx are off
pu->CTRLB=0;
// Ensure that all interrupts generated by the USART are off
pu->CTRLA=0;
}

// USARTD0 initialization
void usartd0_init(void)
{
// Note: the correct PORTD direction for the RxD, TxD and XCK signals
// is configured in the ports_init function

// Transmitter is enabled
// Set TxD=1
PORTD.OUTSET=0x08;

// Communication mode: Asynchronous USART
// Data bits: 8
// Stop bits: 1
// Parity: Disabled
USARTD0.CTRLC=USART_CMODE_ASYNCHRONOUS_gc | USART_PMODE_DISABLED_gc | USART_CHSIZE_8BIT_gc;

// Receive complete interrupt: Low Level
// Transmit complete interrupt: Disabled
// Data register empty interrupt: Disabled
USARTD0.CTRLA=(USARTD0.CTRLA & (~(USART_RXCINTLVL_gm | USART_TXCINTLVL_gm | USART_DREINTLVL_gm))) |
	USART_RXCINTLVL_LO_gc | USART_TXCINTLVL_OFF_gc | USART_DREINTLVL_OFF_gc;

// Required Baud rate: 115200
// Real Baud Rate: 115107.9 (x1 Mode), Error: 0.1 %
USARTD0.BAUDCTRLA=0x0B;
USARTD0.BAUDCTRLB=((0x09 << USART_BSCALE_bp) & USART_BSCALE_gm) | 0x00;

// Receiver: On
// Transmitter: On
// Double transmission speed mode: Off
// Multi-processor communication mode: Off
USARTD0.CTRLB=(USARTD0.CTRLB & (~(USART_RXEN_bm | USART_TXEN_bm | USART_CLK2X_bm | USART_MPCM_bm | USART_TXB8_bm))) |
	USART_RXEN_bm | USART_TXEN_bm;
}

// USARTD0 Receiver buffer
#define RX_BUFFER_SIZE_USARTD0 8
char rx_buffer_usartd0[RX_BUFFER_SIZE_USARTD0];

#if RX_BUFFER_SIZE_USARTD0 <= 256
unsigned char rx_wr_index_usartd0=0,rx_rd_index_usartd0=0,rx_counter_usartd0=0;
#else
unsigned int rx_wr_index_usartd0=0,rx_rd_index_usartd0=0,rx_counter_usartd0=0;
#endif

// This flag is set on USARTD0 Receiver buffer overflow
bit rx_buffer_overflow_usartd0=0, command_flag=0;
unsigned char command[31];  // 명령어 버퍼
unsigned char command_size=0;         // 버퍼주소

// USARTD0 Receiver interrupt service routine
interrupt [USARTD0_RXC_vect] void usartd0_rx_isr(void)
{
unsigned char status;
char data;

status=USARTD0.STATUS;
data=USARTD0.DATA;
if ((status & (USART_FERR_bm | USART_PERR_bm | USART_BUFOVF_bm)) == 0)
   {
   rx_buffer_usartd0[rx_wr_index_usartd0++]=data;
#if RX_BUFFER_SIZE_USARTD0 == 256
   // special case for receiver buffer size=256
   if (++rx_counter_usartd0 == 0)
      {
#else
   if (rx_wr_index_usartd0 == RX_BUFFER_SIZE_USARTD0) rx_wr_index_usartd0=0;
   if (++rx_counter_usartd0 == RX_BUFFER_SIZE_USARTD0)
      {
      rx_counter_usartd0=0;
#endif
      rx_buffer_overflow_usartd0=1;
      }
   }
    command[command_size]=data;
    if(data=='>')
    {
        command_flag=1;
        command_size=0;
    }
    if(command_size>=30) command_size=0;
    else command_size++;
}

// Receive a character from USARTD0
// USARTD0 is used as the default input device by the 'getchar' function
#define _ALTERNATE_GETCHAR_

#pragma used+
char getchar(void)
{
char data;

while (rx_counter_usartd0==0);
data=rx_buffer_usartd0[rx_rd_index_usartd0++];
#if RX_BUFFER_SIZE_USARTD0 != 256
if (rx_rd_index_usartd0 == RX_BUFFER_SIZE_USARTD0) rx_rd_index_usartd0=0;
#endif
#asm("cli")
--rx_counter_usartd0;
#asm("sei")
return data;
}
#pragma used-

// Write a character to the USARTD0 Transmitter
// USARTD0 is used as the default output device by the 'putchar' function
#define _ALTERNATE_PUTCHAR_

#pragma used+
void putchar(char c)
{
while ((USARTD0.STATUS & USART_DREIF_bm) == 0);
USARTD0.DATA=c;
}
#pragma used-

// SPIC initialization
void spic_init(void)
{
// SPIC is enabled
// SPI mode: 0
// Operating as: Master
// Data order: MSB First
// SCK clock prescaler: 4
// SCK clock doubled: On
// SCK clock frequency: 1000.000 kHz
SPIC.CTRL=SPI_ENABLE_bm | SPI_MODE_0_gc | SPI_MASTER_bm |
	SPI_PRESCALER_DIV4_gc | SPI_CLK2X_bm;

// SPIC interrupt: Disabled
SPIC.INTCTRL=(SPIC.INTCTRL & (~SPI_INTLVL_gm)) | SPI_INTLVL_OFF_gc;

// Note: the MOSI (PORTC Bit 5), SCK (PORTC Bit 7) and
// /SS (PORTC Bit 4) signals are configured as outputs in the ports_init function
}

// Macro used to drive the SPIC /SS signal low in order to select the slave
#define SET_SPIC_SS_LOW {PORTC.OUTCLR=SPI_SS_bm;}
// Macro used to drive the SPIC /SS signal high in order to deselect the slave
#define SET_SPIC_SS_HIGH {PORTC.OUTSET=SPI_SS_bm;}

// SPIC transmit/receive function in Master mode
// c - data to be transmitted
// Returns the received data
#pragma used+
unsigned char SPI1_Write(unsigned char c)
{
// Transmit data in Master mode
SPIC.DATA=c;
// Wait for the data to be transmitted/received
while ((SPIC.STATUS & SPI_IF_bm)==0);
// Return the received data
return SPIC.DATA;
}
#pragma used-

// SPID initialization
void spid_init(void)
{
// SPID is enabled
// SPI mode: 0
// Operating as: Master
// Data order: MSB First
// SCK clock prescaler: 4
// SCK clock doubled: On
// SCK clock frequency: 1000.000 kHz
SPID.CTRL=SPI_ENABLE_bm | SPI_MODE_0_gc | SPI_MASTER_bm |
	SPI_PRESCALER_DIV4_gc | SPI_CLK2X_bm;

// SPID interrupt: Disabled
SPID.INTCTRL=(SPID.INTCTRL & (~SPI_INTLVL_gm)) | SPI_INTLVL_OFF_gc;

// Note: the MOSI (PORTD Bit 5), SCK (PORTD Bit 7) and
// /SS (PORTD Bit 4) signals are configured as outputs in the ports_init function
}

// Macro used to drive the SPID /SS signal low in order to select the slave
#define SET_SPID_SS_LOW {PORTD.OUTCLR=SPI_SS_bm;}
// Macro used to drive the SPID /SS signal high in order to deselect the slave
#define SET_SPID_SS_HIGH {PORTD.OUTSET=SPI_SS_bm;}

// SPID transmit/receive function in Master mode
// c - data to be transmitted
// Returns the received data
#pragma used+
unsigned char spid_master_tx_rx(unsigned char c)
{
// Transmit data in Master mode
SPID.DATA=c;
// Wait for the data to be transmitted/received
while ((SPID.STATUS & SPI_IF_bm)==0);
// Return the received data
return SPID.DATA;
}
#pragma used-
////////////////////////////////////////////////////////////////////OSD Driver//////////////////////////////////////////////////////////////////////////////
void MAX7456_SPI_WRITE(unsigned short ADDRESS, unsigned short DATA){
  SET_SPIC_SS_LOW            //OSD_CS = 0;                // Selecting the OSD click
  delay_us(1);               //
  SPI1_Write(ADDRESS);       // Send the ADDRESS of registe in which you wish to wite DATA
  SPI1_Write(DATA);          // Send the DATA which you wish to wite
  delay_us(1);               //
  SET_SPIC_SS_HIGH           //OSD_CS = 1;                // Deselecting the OSD click
  delay_us(10);
}
unsigned short MAX7456_SPI_READ(unsigned short ADDRESS){
unsigned short temp;
  SET_SPIC_SS_LOW            //OSD_CS = 0;                // Selecting the OSD click
  delay_us(1);               //
  SPI1_Write(ADDRESS);       // Send the ADDRESS of registe from which you wish to read DATA
  delay_us(1);               //
  temp  = SPI1_Write(0);     //SPI1_Read(0);      // Read the register DATA
  SET_SPIC_SS_HIGH           //OSD_CS = 1;                // Deselecting the OSD click
  delay_us(20);
} 

void MAX7456_init(){
unsigned short temp;
  MAX7456_SPI_WRITE(0x00, 0x0C);   // Setup Video Mode 0 register
  temp  = MAX7456_SPI_READ(0xEC);  // Read OSD Black Level register
  temp&= 0xEF;
  MAX7456_SPI_WRITE(0x6C, temp);  // Setup OSD Black Level register
  MAX7456_SPI_WRITE(0x04, 0x04);  // Setup Display Memory Mode register
  MAX7456_SPI_WRITE(0x02, 0x26);  // Horizotal offset for ~1/2 of character
}

void MAX7456_Write(unsigned short x, unsigned short y, unsigned short symbol)
  {
  SET_SPIC_SS_LOW                 //OSD_CS = 0;                     // Selecting the OSD click
  delay_us(1);                    //
  SPI1_Write(0x05);               // Address to Display Memory Address High
  if( ( x * 30 + y ) <= 255 )
    SPI1_Write(0);                // For first 255 matrix positions Write 0
  else
    SPI1_Write(1);                // For the rest of matrix positions Write 1
  delay_us(1);
  SET_SPIC_SS_HIGH                //OSD_CS = 1;                     // Deselecting the OSD click
  delay_us(10);

  MAX7456_SPI_WRITE(0x06, x * 30 + y );  // Set position in display matrix(16x30)
  MAX7456_SPI_WRITE(0x07, symbol);       // Set character on selected position
} 
////////////////////////////////////////////////function////////////////////////////////////////////////////////////////////////////////////////////////////
void com_reset(void)                        // 명령어버퍼 초기화
{
   for(command_size=30 ; command_size>0; command_size--) command[command_size]=NULL;
   command_flag=0;
}
void check(void)                             // 동작체크
{
    static int a=0;
    MAX7456_Write(row_pointer,  col_pointer, OSDchr['C']);
    MAX7456_Write(row_pointer+2,  col_pointer+2, OSDchr['K']);
    MAX7456_Write(row_pointer+1,  col_pointer+1, OSDchr['0'+a]);
    MAX7456_Write(row_pointer+3,  col_pointer+3, OSDchr['0'+a]);
    if(a>=9)
    a=0;
    else
    a++;
    puts("CHECK!\r");        
}
void clear(void)
{
    MAX7456_SPI_WRITE(0x04, 0x04);         // RAM초기화(화면초기화)
    puts("CLEAR!\r");
}
void on(void)
{
    MAX7456_SPI_WRITE(0x00, 0x0c);         // OSD ON
    puts("OSD ON!\r");
}
void off(void)
{
    MAX7456_SPI_WRITE(0x00, 0x04);         // OSD OFF
    puts("OSD OFF!\r");
}
void col(char value)                        // 가로 몇번째 칸에 쓸것인지 결정(1~27)
{                            
    if(value=='0')                                          // 1~9 칸 중
    {             
        col_pointer=(int)(command[4]-'0');                  // 포인터값에 왼쪽부터 몇번째칸인지 지정
    }
    else if(value=='1')                                     // 10~19 칸 중
    {
        col_pointer=(int)(command[4]-'0'+10);
    }                                                      
    else if(value=='2')                                     // 20~27 칸 중
    {                                                     
        if(command[4]>'7') puts("range of column is 1~27\r");
        else
        col_pointer=((int)command[4]-'0'+20);     
    }
    else puts("range of column is 1~27\r");
    puts("Col Pointer : ");
    putchar('0'+col_pointer/100);
    putchar('0'+col_pointer%100/10);
    putchar('0'+col_pointer%10);
    puts("\r");     
}
void row(char value)                                        // 세로 몇번째 줄에 쓸것인지 결정(1~12)
{                                        
    if(value=='0')
    {                                                       // 1~9 줄 중
        row_pointer=(int)(command[4]-'0');                  // 포인터값에 왼쪽부터 몇번째칸인지 지정 
    }
    else if(value=='1')                                     // 10~12 줄 중
    {
        if(command[4]>'2') puts("range of row is 1~12\r");
        else
        row_pointer=((int)command[4]-'0'+10);
    }
    else puts("range of row is 1~12\r");
    puts("Row Pointer : ");
    putchar('0'+row_pointer/100);
    putchar('0'+row_pointer%100/10);
    putchar('0'+row_pointer%10);
    puts("\r");
}
void chat()       // ->문자입력; 했을 시 OSD에 문자입력이 나오도록함
{
    int j,k;
    for(j=1;j<30;j++)                                       // ->(command[1])이후 ;가 나올때까지 uc의 총 길이는 0~29 
        {
            k=j;                                            // j값은 순차적으로 k로 저장하고 2,3,4,5,....28, 29
            if(command[k]==';' && command[k+1]==13)          // (command[2], command[3]... command[29]중에) command[k]에 ; 가 나오면 
            {
                col_pointer=col_pointer+(k-1);              // 포인터를 입력된 문자개수에 위치시킴 ex) >abcde;라면 >;를 제외하고 총 5개 글자만큼 포인터를 이동
                //command[k]=NULL;                          // 해당 ';'가 들어있는 명령어배열은 비움
                for(k=k-1 ; k>0; k--)                       // 입력된 문자개수만큼                 ex) abcde; 에서 ;를 뺀만큼
                {
                    col_pointer--;                          // 포인터를 역순으로
                    MAX7456_Write(row_pointer, col_pointer, OSDchr[command[k]]);    // 입력된 글자를 출력해야 화면엔 abcde로 보임      
                }       
                                                           //화면출력
                puts("CHAT!\r"); 
                com_reset();
            }
        }
}
void title()
{
    int j,k;
    for(j=3;j<30;j++)                                                           // ->(command[1])이후 ;가 나올때까지 uc의 총 길이는 0~29 
        {
            k=j;                                                                // j값은 순차적으로 k로 저장하고 2,3,4,5,....28, 29
            if(command[k]==';' && command[k+1]==13)                             // (command[2], command[3]... command[29]중에) command[k]에 ; 가 나오면 
            {
                title_pointer = title_pointer+(k-3);                            // 포인터를 입력된 문자개수에 위치시킴 ex) >abcde;라면 >;를 제외하고 총 5개 글자만큼 포인터를 이동
                if(title_pointer>=18) puts("Title is too long!(Max:15)\r");     // 최대 15글자까지 출력제한
                else
                {
                    for(k=k-1 ; k>2; k--)                                       // 입력된 문자개수만큼                 ex) abcde; 에서 ;를 뺀만큼
                    {
                      title_pointer--;                                          // 포인터를 역순으로         
                      MAX7456_Write(11, title_pointer, OSDchr[command[k]]);     // 입력된 글자를 출력해야 화면엔 abcde로 보임
                    }                                                            
                    puts("TITLE!\r");                                           //화면출력 
                }
                com_reset();
            }
        }
}
////////////////////////////////////////////////////////////encorder////////////////////////////////////////////////////////////////
void init_LS7366(void) {

 LS7366_SS_L_H                                 // Initialize SS
 
 LS7366_SS_H_L                                 // Set MDR0 X4 Count Mode
 spid_master_tx_rx(SELECT_MDR0 | WR_REG);
 spid_master_tx_rx(X1_QUAD | FREE_RUN | DISABLE_INDEX | SYNCHRONOUS_INDEX | FILTER_CDF_1 );
 LS7366_SS_L_H
 
 LS7366_SS_H_L                                 // Set MDR1 4 Bytes Counter Mode
 spid_master_tx_rx(SELECT_MDR1 | WR_REG);
 spid_master_tx_rx(FOUR_BYTE_COUNT_MODE | ENABLE_COUNTING);
 LS7366_SS_L_H
                                            
 LS7366_SS_H_L                               // Clear(0) CNTR Register   
 spid_master_tx_rx(SELECT_CNTR | CLR_REG);       
 LS7366_SS_L_H 
}

void reset_LS7366(void)
{
    LS7366_SS_H_L
    spid_master_tx_rx(SELECT_CNTR | CLR_REG);
    LS7366_SS_L_H
}


unsigned int encorder_pointer;
char temp[30]="";
void putstringc1(char *command)
{
    int i=0;
    while(*(command+i) !=0)
    {
        putchar(*(command+i)); 
        MAX7456_Write(1, encorder_pointer, OSDchr[*(command+i)]);
        encorder_pointer+=1;
        temp[i]=*(command+i);       //encorder의 출력 값이 다음타이밍(10ms)이후 들어온 값과 같은지 확인하기위한 용도의변수(중복된 값을 화면에 출력하는 낭비를 막기위해)
        temp[i+1]=NULL;
        i++;
    }
    MAX7456_Write(1, encorder_pointer, OSDchr[' ']);    //encorder값이 예를들어 1234였다가 123이되면 뒤에 4에 대한 잔상이 남는다 그것을 지우기위해 123뒤에 ' ' 을 넣어준다.
    encorder_pointer-=i;
    puts("\r");
}
////////////////////////////////////////////////////////////////RTC/////////////////////////////////////////////////////////////////
unsigned char timer_pointer=1;
unsigned char hour=0;
void ontime_hour(void)
{
    //hour=s%86400;
    int a=RTC_sec%86400;
    if(hour>=23 || a==0) hour=0;
    else hour++;
    timer_pointer+=2;
    MAX7456_Write(1, timer_pointer, OSDchr[':']);               // :
    timer_pointer--;
    MAX7456_Write(1, timer_pointer, OSDchr['0'+(hour%10)]);     // 1hour
    timer_pointer--; 
    MAX7456_Write(1, timer_pointer, OSDchr['0'+(hour/10)]);     // 10hour
}
int minu=0;
void ontime_min(void)
{
    //min=s%3600;
    int a=RTC_sec%3600;
    if(minu>=59 || a==0)
    {
        minu=0;
        ontime_hour();
    }
    else minu++;
    timer_pointer+=5;
    MAX7456_Write(1, timer_pointer, OSDchr[':']);                // :
    timer_pointer--; 
    MAX7456_Write(1, timer_pointer, OSDchr['0'+(minu%10)]);      // 1min
    timer_pointer--;     
    MAX7456_Write(1, timer_pointer, OSDchr['0'+(minu/10)]);      // 10min
    timer_pointer-=3;  
}
void ontime_sec(void)
{
    unsigned long int a;
    RTC_flag=0;
    if(hour>=24) RTC_sec=0;
    else{
    a=RTC_sec%60;
    timer_pointer+=7;                                        
    MAX7456_Write(1, timer_pointer, OSDchr['0'+(a%10)]);    // 1sec
    timer_pointer--; 
    MAX7456_Write(1, timer_pointer, OSDchr['0'+(a/10)]);    // 10sec
    timer_pointer-=6;
    if(a==0) ontime_min();
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bit ontime_flag=0;
int date_pointer;
void commands(void) //명령어 키조합
{    
    if(command[1]=='A' && command[2]=='T' && command[3]==13)          // 연결확인
    {
        delay_us(100);
        puts("OSD CONNECT : OK\r");
        com_reset();
    }
    else if(command[1]=='C' && command[2]=='K' && command[3]==13) // CHECK용
    {
        check();
        com_reset();   
    }
    else if(command[1]=='C' && command[2]=='R' && command[3]==13) // 화면 CLEAR
    {
        clear();
        com_reset();
    }
    else if(command[1]=='O' && command[2]=='N' && command[3]==13)     // OSD ON  
    {
        on();
        com_reset();   
    }
   else if(command[1]=='O' && command[2]=='F' && command[3]==13)   // OSD OFF
    {
        off();
        com_reset();   
    }
    else if(command[1]=='C' && command[2]=='L' && command[3]!= NULL && command[4]!= NULL && command[5] == 13)  //열
    {
        col(command[3]);     
        com_reset();
    }
    else if(command[1]=='R' && command[2]=='W'  && command[3]!= NULL && command[4] != NULL && command[5]==13) // 행
    {
        row(command[3]);     
        com_reset();
    }
    else if(command[1]=='T' && command[2]=='R' && command[3]==13)  
    {
        ontime_flag = ~ontime_flag;
        if(ontime_flag==1)
        {
            //t_pointer=pointer;
            timer_pointer=19;
            puts("ONTIMER ON\r");
        }
        else puts("ONTIMER OFF\r");
        com_reset();
    }
    else if(command[1]=='T' && command[2]=='S' && command[3]!= NULL && command[4] != NULL && command[5]!= NULL && command[6] != NULL && command[7]==13)  
    {
        timer_pointer=19;
        ontime_flag = 1;
        hour=(command[3]-'0')*10+(command[4]-'0'-1);
        minu=(command[5]-'0')*10+(command[6]-'0'-1); 
        ontime_min();
        ontime_hour();
        puts("ONTIMER SET\r");
        com_reset();    
    }
    else if(command[1]=='T' && command[2]=='H' && command[3]!= NULL && command[4] != NULL && command[5]==13)  
    {
        hour=(command[3]-'0')*10+(command[4]-'0'-1); 
        ontime_hour();
        com_reset();    
    }
    else if(command[1]=='T' && command[2]=='M' && command[3]!= NULL && command[4] != NULL && command[5]==13)  
    {
        minu=(command[3]-'0')*10+(command[4]-'0'-1); 
        ontime_min();
        com_reset();    
    }
    else if(command[1]=='D' && command[2]=='T'&& command[3] != NULL && command[4]!= NULL && command[5] != NULL && command[6]!= NULL && command[7] != NULL && command[8]!= NULL && command[9] == 13   )
    {
        date_pointer=26;
        MAX7456_Write(11, date_pointer, OSDchr[command[8]]);
        date_pointer--;
        MAX7456_Write(11, date_pointer, OSDchr[command[7]]);
        date_pointer--;
        MAX7456_Write(11, date_pointer, OSDchr['/']);
        date_pointer--;
        MAX7456_Write(11, date_pointer, OSDchr[command[6]]);
        date_pointer--;
        MAX7456_Write(11, date_pointer, OSDchr[command[5]]);
        date_pointer--;
        MAX7456_Write(11, date_pointer, OSDchr['/']);
        date_pointer--;
        MAX7456_Write(11, date_pointer, OSDchr[command[4]]);
        date_pointer--;
        MAX7456_Write(11, date_pointer, OSDchr[command[3]]);
        puts("DATE SET\r");
        com_reset();   
    }
    else if(command[1]=='T' && command[2]==':' && command[3]!=NULL)
    {
        title_pointer=2;
        title();
    }
    else if(command[1]=='T' && command[2]=='E' && command[3]==13)       
    {
        RTC_sec=0;
        puts("SECOND : 0");
        com_reset();   
    }
    else if(command[1]=='E' && command[2]=='N' && command[3]==13)
    {
        flag_com=~flag_com;
        if(flag_com==1)
        {
            //e_pointer=pointer;
            encorder_pointer=2;
            puts("ENCODER ON\r");
        }
        else puts("ENCODER OFF\r");
        com_reset();    
    }
    else if(command[1]=='E' && command[2]=='R'&& command[3]==13)
    {
        //init_LS7366();
        reset_LS7366();
        puts("ENCODER VALUE RESET!!\r");
        com_reset();
    }   
    else if(command[1] != NULL) //&& command[2] != NULL)   //문자입력
    {
         chat();
    }
}    
///////////////////////////////////////////////////////************************************************************************************************//////////////////    
void main(void)
{
// Declare your local variables here
unsigned char n, i, ttemp=0;

// Interrupt system initialization
// Optimize for speed
#pragma optsize- 
// Make sure the interrupts are disabled
#asm("cli")
// Low level interrupt: On
// Round-robin scheduling for low level interrupt: Off
// Medium level interrupt: Off
// High level interrupt: Off
// The interrupt vectors will be placed at the start of the Application FLASH section
n=(PMIC.CTRL & (~(PMIC_RREN_bm | PMIC_IVSEL_bm | PMIC_HILVLEN_bm | PMIC_MEDLVLEN_bm | PMIC_LOLVLEN_bm))) |
	PMIC_LOLVLEN_bm;
CCP=CCP_IOREG_gc;
PMIC.CTRL=n;
// Set the default priority for round-robin scheduling
PMIC.INTPRI=0x00;
// Restore optimization for size if needed
#pragma optsize_default

// Watchdog timer initialization
watchdog_init();

// System clocks initialization
system_clocks_init();

// Event system initialization
event_system_init();

// Ports initialization
ports_init();

// Virtual Ports initialization
vports_init();

// Timer/Counter TCC0 initialization
tcc0_init();

// RTC initialization
rtcxm_init();

// USARTD0 initialization
usartd0_init();

// USARTD1 is disabled
usart_disable(&USARTD1);

// USARTE0 is disabled
usart_disable(&USARTE0);

// SPIC initialization
spic_init();

// SPID initialization
spid_init();

// ENCORDER initialization
init_LS7366();

puts("OSD CONNECT : OK\r");
MAX7456_init();
// Globaly enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here
        if(command_flag==1)
         {
             if(command_size>1)commands();      
         }
        if(ontime_flag==1 && RTC_flag==1) ontime_sec();  
        if(flag_com==1 && (ten_ms%10)==0)
         {   
            LS7366_SS_H_L                     // Initialize SS 
            spid_master_tx_rx(SELECT_OTR | LOAD_REG);   // Transfer CNTR to OTR in "parallel"
            LS7366_SS_L_H
            LS7366_SS_H_L                           // 
            spid_master_tx_rx(SELECT_OTR | RD_REG);     // Read 4 Bytes OTR Register
            a = spid_master_tx_rx(0x00);            // B31 - B24  MSB
            b = spid_master_tx_rx(0x00);            // B23 - B16
            c = spid_master_tx_rx(0x00);            // B15 - B08
            d = spid_master_tx_rx(0x00);            // B07 - B00  LSB
            LS7366_SS_L_H
              
            sum = ( ((0x000000ffL & a) << 24) | ((0x000000ffL & b) << 16) | ((0x000000ffL & c) << 8) | (0x0000ffffL & d) );
            sprintf(ch,"%4.3fM",sum*0.314/500);     // 1바퀴에 0.314m
            delay_us(500);
            for(i=0;i<30;i++)
            {
                if(ch[i]==temp[i]) ttemp++;                
            }
            if(ttemp != 30)   putstringc1(ch);       // 10ms간격 사이에 숫자변화가 있으면 화면에 출력
            ttemp=0;
            
         }
      }
}

//------------------------------------------------------------------------------------------------- 
// 
// Initialaize the USART
//
//----------------------
#define FCLK 8000000
// Baud rate
#define BAUD 57600
// Calculate the UBRR setting
#define UBRR ((long) FCLK/(8*BAUD)-1)

// Bit definitions from the USART control registers
#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7
#define RXE	(1 << 4)
#define TXE	(1 << 3)

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
//------------------------------------------------------------------------------------------------- 
// 
// defines for Timer Counters
// 
//------------------------------------------------------------------------------------------------- 
#define TCCR_ICES_neg	0x40	//falling (negative) edge
#define TCCR_ICES_pos	0x00	//rising (positive) edge
//
#define TCCR_CS_stop	0x00
#define TCCR_CS_prescaler_1		0x01
#define TCCR_CS_prescaler_8		0x02
#define TCCR_CS_prescaler_64	0x03
#define TCCR_CS_prescaler_256	0x04
#define TCCR_CS_prescaler_1024	0x05
//------------------------------------------------------------------------------------------------- 
// 
// defines for Interrupts
// 
//------------------------------------------------------------------------------------------------- 
#define MCUCR_IVCE 	0X01	//Write the Interrupt Vector Change Enable (IVCE) bit to one.
//
#define EIMSK_noInterrupt	0x00
#define EIMSK_INT0	0x01
#define EIMSK_INT1	0x02
#define EIMSK_INT2	0x04
#define EIMSK_INT3	0x08
#define EIMSK_INT4	0x10
#define EIMSK_INT5	0x20
#define EIMSK_INT6	0x40
#define EIMSK_INT7	0x80
//------------------------------------------------------------------------------------------------- 
// 
// defines for Analog to digital converter.
// 
//------------------------------------------------------------------------------------------------- 
#define ADC_VREF_TYPE 	0XC0
//
#define ADCSRA_ADEN	0x80 	//Bit 7 – ADEN: ADC Enable
#define ADCSRA_ADSC	0x40	//Bit 6 – ADSC: ADC Start Conversion
#define ADCSRA_ADIF	0x10	//Bit 4 – ADIF: ADC Interrupt Flag
#define ADCSRA_ADPS_2	0x01
#define ADCSRA_ADPS_4	0x02
#define ADCSRA_ADPS_8	0x03
#define ADCSRA_ADPS_16	0x04
#define ADCSRA_ADPS_32	0x05
#define ADCSRA_ADPS_64	0x06
#define ADCSRA_ADPS_128	0x07
//------------------------------------------------------------------------------------------------- 
// 
// frequence of cpu in megahertz
// 
//------------------------------------------------------------------------------------------------- 
#define F_CPU	8
//------------------------------------------------------------------------------------------------- 
//
// from avr_compiler
//
//------------------------------------------------------------------------------------------------- 
#define _MEMATTR  flash
#define ISR(vec) interrupt[vec] void handler_##vec(void)
#define sei() #asm("sei")
#define cli() #asm("cli")
#define nop() #asm("nop")
#define watchdog_reset() #asm("wdr")
#define INLINE static inline
#define FLASH_DECLARE(x) _MEMATTR x
#define FLASH_STRING(x) ((_MEMATTR char *)(x))
#define FLASH_STRING_T  char _MEMATTR *
#define FLASH_BYTE_ARRAY_T unsigned char _MEMATTR *
#define PGM_READ_BYTE(x) *(x)
#define PGM_READ_WORD(x) *(x)
#define RESET()		#asm("JMP  __RESET")
//------------------------------------------------------------------------------------------------- 
//
// type declaration
//
//------------------------------------------------------------------------------------------------- 
extern int Icount;			// input pins count	
extern int Ocount;			// output pins count
extern int Is[];			// arrey of input pins
extern int Os[];			// arrey of output pins
//------------------------------------------------------------------------------------------------- 
//
// type declaration
//
//------------------------------------------------------------------------------------------------- 
typedef unsigned char byte;
typedef unsigned int word;
typedef enum { false, true } bool;
typedef enum { off, on } on_off;
//------------------------------------------------------------------------------------------------- 
//
// micro controller functions.
//
//----------------
void micro_init(void);

void LED_turn(int i, on_off b);
void LED_toggle(int i);
int Read();
void Write(int k, int imask);
int delayTime(int d);
void delay(int d);
void clock();
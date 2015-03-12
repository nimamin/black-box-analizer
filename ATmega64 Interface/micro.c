//------------------------------------------------------------------------------------------------- 
// micro modules with ATmega64 microcontroller
// By TAB Electric.
//-------------------------------------------------------------------------------------------------
#include <mega32.h>
#include <delay.h>
#include <stdio.h>
#include <stdlib.h>
#include "micro.h"

//------------------------------------------------------------------------------------------------- 
// 
// Initialaize the USART
//
//----------------------
void micro_USART_Init(void)
{
	// USART0 initialization
	// Communication Parameters: 8 Data, 1 Stop, No Parity
	// USART0 Receiver: Off
	// USART0 Transmitter: On
	// USART0 Mode: Asynchronous
	// USART0 Baud rate: 57600
	UCSRA = 0x02;
	UCSRB = 0x98;
	UCSRC = 0x06;
	UBRRH = (UBRR >> 8) & 0xFF;
	UBRRL = UBRR & 0xFF;
}

//------------------------------------------------------------------------------------------------- 
//
// Microcontroller's Initialization.
//
//--------------------------------
void micro_init(void)
{
	MCUCR = 0X01;	//Write the Interrupt Vector Change Enable (IVCE) bit to one.

	DDRA = 0XFF;
	DDRB = 0XFF;
	DDRC = 0X00;
	DDRD = 0XFC;
	PORTA = 0X00;
	PORTB = 0X00;
	PORTC = 0XFF;
	PORTD = 0X00;

	SFIOR = 0X00;	//Special Function IO Register.	Bit 3 – ACME: Analog Comparator Multiplexer Enable is off. Bit 2 – PUD: Pull-up disable

	micro_USART_Init(); 
	
	sei();
}

//------------------------------------------------------------------------------------------------- 
// 
// Turns LEDs on or off.
// 
//-----------------
void LED_turn(int i, on_off b)
{
	if (b) PORTD &= ~(1 << (5 + i));
	else PORTD |= 1 << (5 + i);
}

//------------------------------------------------------------------------------------------------- 
// 
// Toggles LEDs.
// 
//-----------------
void LED_toggle(int i)
{
	PORTD ^= 1 << (5 + i);
}

//------------------------------------------------------------------------------------------------- 
// 
// Read the ouput of the black box.
// 
//-----------------
int Read()
{
	return PINC;
}

//------------------------------------------------------------------------------------------------- 
// 
// Send the encoded parameter k with input mask imask to the black box.
// 
//-----------------
void Write(int k, int imask)
{
	int i;
	int data = 0;
	for(i = 0; i < 20; i++)
	{
		if (k & (1 << i)) data |= Is[i];
	}
	PORTA = data & 0xff;
	PORTB = (data >> 8) & 0x3;
	if(imask > 0x3ff) 
	{
		DDRC = (imask >> 10) & 0xff;
		PORTC = (data >> 10) & 0xff;
	}
}

//------------------------------------------------------------------------------------------------- 
// 
// Decoder of the delay code nomber.
// 
//-----------------
int delayTime(int d)
{
	switch (d)
	{
		case 1:
			return(1);
			break;
		case 2:
			return(5);
			break;
		case 3:
			return(25);
			break;
		case 4:
			return(125);
			break;
		case 5:
			return(625);
			break;
		case 6:
			return(5);
			break;
		case 7:
			return(25);
			break;
		case 8:
			return(125);
			break;
		case 9:
			return(625);
			break;
	}
}

//------------------------------------------------------------------------------------------------- 
// 
// Delay for the predetermined code nombers.
// 
//-----------------
void delay(int d)
{
	switch (d)
	{
		case 0:
			nop();
			break;
		case 1:
			delay_us(1);
			break;
		case 2:
			delay_us(5);
			break;
		case 3:
			delay_us(25);
			break;
		case 4:
			delay_us(125);
			break;
		case 5:
			delay_us(625);
			break;
		case 6:
			delay_ms(5);
			break;
		case 7:
			delay_ms(25);
			break;
		case 8:
			delay_ms(125);
			break;
		case 9:
			delay_ms(625);
			break;
		default:
			delay_ms(1000);
			break;
	}
}


//------------------------------------------------------------------------------------------------- 
// 
// Send the clock signal for the clock pin of the black box.
// 
//-----------------
void clock()
{
	PORTA ^= 1;
}
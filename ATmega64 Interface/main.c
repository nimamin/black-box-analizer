//------------------------------------------------------------------------------------------------- 
//
// Black box analizer microcontroller program.
// This program is coded for ATmega64 and connects the micro and PC with a UART.
// User with a simple terminal sets the parameters and gets the Scaned file.
// When the user sends the go command ('g'), micro starts to sends the properd data to the input of
// the black box and reads its outputs. Then it gathers the informations to the terminal.
// By this user can have a scanned file.
//
//------------------------------------------------------------------------------------------------- 
#include "micro.h"
#include <mega32.h>
#include <stdio.h>
#include <stdlib.h>
#include <delay.h>

int Imask = 0XFF;	// Input mask register
int Omask = 0XFF;	// Output mask register
int Icount;			// input pins count	
int Ocount;			// output pins count
int Is[20];			// arrey of input pins
int Os[20];			// arrey of output pins
int Lines;			// lines count of the file
int Columns = 8;	// columns count of the file
int D = 2;			// cycle delay code nomber
bool GoCommand = false;		// a public flag indicating the user's start request signal.

//------------------------------------------------------------------------------------------------- 
// 
// Calcute the parameters(Icount, Ocount, Is[], Os[], Lines) from Imask and Omask.
// 
//-----------------
void generatePrameters()
{
	int i;
	
	Icount = 0;
	for (i = 0; i < 20; i++)
	{
		if ((1 << i) & Imask)
		{
			Is[Icount++] = 1 << i;
		}
	}
	for (i = Icount; i < 20; i++) Is[i] = 0;
	
	Ocount = 0;
	for (i = 0; i < 8; i++)
	{
		if ((1 << i) & Omask)
		{
			Os[Ocount++] = 1 << i;
		}
	}
	for (i = Ocount; i < 20; i++) Os[i] = 0;

	Lines = 1 << (Icount - 1);
}


//------------------------------------------------------------------------------------------------- 
// 
// Interrup vactor for uart recieve interrupt.
// 
//-----------------
interrupt [USART_RXC] void uartRecieve(void)
{
	static int state = 0;
	static int data;
	char newchar;
	static int ec = 0;
	
	cli();	
	newchar = UDR;
	LED_turn(1, on);
	
	switch (state)
	{
		case 0:
			data = 0;
			ec = 0;
			switch (newchar)
			{
				case 'I':
				case 'i':
					state = 1;
					printf("\rInput Mask = 0X%03X\rEnter new Value:", Imask);
					break;
				case 'Q':
				case 'q':
				case 'o':
				case 'O':
					state = 2;
					printf("\rOutput Mask = 0X%03X\rEnter new Value:", Omask);
					break;
				case 'C':
				case 'c':
					state = 3;
					printf("\rColumns = %d\rEnter new Value:", Columns);
					break;
				case 'D':
				case 'd':
					state = 4;
					if (D < 6) printf("\rDelay Timer Mode = %d witch means %d micro secound.", D, delayTime(D));
					else printf("\rDelay Timer Mode = %d witch means %d mili secound.", D, delayTime(D));
					printf("\rEnter new Value:");
					break;
				case 'R':
				case 'r':
					Imask = 0XFF;
					Omask = 0XFF;
					Columns = 8;
					printf("\rReset\r");
					break;
				case '/':
				case '?':
					printf("\rInput Mask = 0X%03X,", Imask);
					printf("\tOutput Mask = 0X%03X,", Omask);
					printf("\tColumns = %d.", Columns);
					if (D < 6) printf("\rDelay Timer Mode = %d witch means %d micro secound.", D, delayTime(D));
					else printf("\rDelay Timer Mode = %d witch means %d mili secound.", D, delayTime(D));
					generatePrameters();
					printf("\rInput Pins Count = %d,", Icount);					
					printf("\tOutput Pins Count = %d,", Ocount);					
					printf("\tLines Count = %d.\r", Lines);
					
					printf("\rPress i for Input Mask,");
					printf(" q for output Mask,");
					printf("\rc for Columns,");
					printf(" d for Delay,");
					printf(" and g for Scan.");
					printf("\r\r>");
					break;
				case 'G':
				case 'g':
					GoCommand = true;
					break;
				default:
					printf("\b \b");
					break;
			}
			break;
		case 1:
			if ((newchar < '0') || (newchar > '9'))
			{
				if (data > 0xFFF) 
				{
					printf("\rValue must be less than 0xFFF.");
					break;
				}
				if ((data > 0x3ff) && ((data >> 10) & Omask))
				{
					Omask = ~(data >> 10);
					printf("\rOutput Mask = 0X%03X\r", Omask);
					Imask = data;					
				}
				else if (data > 0) Imask = data;
				printf("\rInput Mask = 0X%03X\r", Imask);
				printf("\r>");
				state = 0;
			}
			else
			{
				data = data * 10 + newchar - '0';
			}
			break;
		case 2:
			if ((newchar < '0') || (newchar > '9'))
			{
				if (data > 0) 
				{
					if ((Imask > 0x3ff) && ((Imask >> 10) & data))
					{
						Omask = ~(data >> 10);
						printf("\rError Input Output masks. Output Mask = 0X%03X\r", Omask);
					}
					Omask = data;
				}
				printf("\rOutput Mask = 0X%03X\r", Omask);
				printf("\r>");
				state = 0;
			}
			else
			{
				data = data * 10 + newchar - '0';
			}
			break;
		case 3:
			if ((newchar < '0') || (newchar > '9'))
			{
				if (data > 0) Columns = data;
				printf("Columns = %d\r", Columns);
				printf("\r>");
				state = 0;
			}
			else
			{
				data = data * 10 + newchar - '0';
			}
			break;		
		case 4:
			if ((newchar < '0') || (newchar > '9'))
			{
				if ((data > 0) && (data < 10)) D = data;
				if (D < 6) printf("Delay Timer Mode = %d witch means %d micro secound.\r", D, delayTime(D));
				else printf("Delay Timer Mode = %d witch means %d mili secound.\r", D, delayTime(D));
				printf("\r>");
				state = 0;
			}
			else
			{
				data = data * 10 + newchar - '0';
			}
			break;		
	}
	sei();
	LED_turn(1, off);
}

//------------------------------------------------------------------------------------------------- 
// 
// start scanning the black box.
// 
//-----------------
void start()
{
	int i, k, data, c;
	int columns, lines, imask, omask, icount, ocount;
	
	GoCommand = false;
	cli();
	LED_turn(0, on);
	
	// DDRA = imask & 0xff;
	// DDRB &= 0xfc;
	// DDRB |= (imask >> 8) & 0x3;
	// if(imask > 0x3ff) DDRC = (imask >> 10) & 0xff;
	
	generatePrameters();
	columns = Columns;	lines = Lines;
	imask = Imask;	omask = Omask; 
	icount = Icount;	ocount = Ocount;
	
	putchar('\r');
	printf("I:%d\tQ:%d\tC:%d\r", icount, ocount, columns);
	printf("In mask:%03X\tOut mask:%03X\r", imask, omask);
	
	for(k = 0; k < lines; k++)
	{
		i = k << 1;
		printf("%03X:\t", i);
		
		Write(i, imask);
		delay(D);
		data = Read() & omask;
		printf("%02X\t", data);
		
		for(c = 0; c < columns; c++)
		{
			clock();
			delay(D);
			data = Read() & omask;
			printf("%02X\t", data);
		}
		//putchar('\n');
		putchar('\r');
	}
	printf("\r\r>");
	LED_turn(0, off);
	sei();
}

//------------------------------------------------------------------------------------------------- 
// 
// main function.
// 
//-----------------
void main(void)
{
	micro_init();
	
	LED_turn(0, off);	// Go LED
	LED_turn(1, off);	// Recieve LED
	LED_turn(2, on);	// Power on LED
	printf("\r\rThe PEEL Scaner Program started.");
	printf("\rPress G for Scan the PEEL chip.\rPress ? for more help.\r\r>");

	while (1)
	{   
		if (GoCommand) 
			start();		
	}
}

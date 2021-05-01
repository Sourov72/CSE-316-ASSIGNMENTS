/*
 * GccApplication2.c
 *
 * Created: 4/9/2021 10:17:00 PM
 * Author : Saurav
 */ 

#include <avr/io.h>
#define F_CPU 1000000 // Clock Frequency
#include <util/delay.h>
#include <avr/interrupt.h>
 
volatile int rotate;

ISR(INT1_vect)//STEP2
{
	if(rotate)
		rotate = 0;
	else
		rotate = 1;
}


int main(void)
{
	MCUCSR = (1 << JTD);
	MCUCSR = (1 << JTD);
	unsigned char col = 1;
	unsigned char temp = 1;
	unsigned char row[8] = {0xFF, 0X00, 0X00, 0XE7, 0XE7, 0X00, 0X00, 0XFF};
	DDRA = 0xFF;
	DDRC = 0XFF;
	GICR = (1<<INT1); 
	MCUCR = 1 << ISC10;
	MCUCR |= 1 << ISC11;
	sei();
	rotate = 0;
	while(1)
	{
		
		for(int j = 0; j < 15; j++)
		{
			for(int i = 0; i < 8; i++)
			{
				
				PORTA = col;
				PORTC = row[i];
				_delay_ms(1);
				if(col == 1 << 7) col = 1;
				else
				col = col << 1;
				
				
				
				
			}
		}
		if(rotate == 1)
		{
			
			if(temp == 1 << 7) temp = 1;
			else
			temp = temp << 1;
			col = temp;
			_delay_ms(100);
		}
		
		
		
	}
}


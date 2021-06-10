
#ifndef F_CPU
#define F_CPU 1000000UL 
#endif


#define D4 eS_PORTD4
#define D5 eS_PORTD5
#define D6 eS_PORTD6
#define D7 eS_PORTD7
#define RS eS_PORTC6
#define EN eS_PORTC7

#include <avr/io.h>
#include "lcd.h"


int main(void)
{
	DDRD = 0xFF;
	DDRC = 0xFF;
	int i;
	unsigned int avoltage;
	float dvoltage;
	char voltage[10] = "Voltage:";
	char buf[10];
	char res[25] ;
	ADMUX = 0b00000111;
	
	ADCSRA = 0b10000011;
	Lcd4_Init();
	while(1)
	{
		Lcd4_Set_Cursor(1,1);
		ADCSRA |= (1 << ADSC);
		avoltage = 0b00000000;
		while(ADCSRA & (1 << ADSC))
		{
			;
		}
		
		
		
		avoltage = ADCL;
		avoltage |= (ADCH << 8);
		dvoltage = (avoltage * 4.0) / 1024.0;

		dtostrf(dvoltage, 6, 2, buf);
		
		strcpy(res, voltage);
		strcat(res, buf);
		Lcd4_Write_String(res);
		
	}
}
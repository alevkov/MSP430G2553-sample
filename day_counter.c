#include <msp430.h>

/*
 * Alex Levkovskyi
 * main.c
 */

// assuming we are using an internal clock, no xtal
#define TRIGGER 12000
#define DAYS_THRESH 3

static unsigned int seconds = 0, minutes = 0, hours = 0, days = 0;

void init()
{
	WDTCTL = WDTPW | WDTHOLD;
	BCSCTL3 |= LFXT1S_2; // enable VLO
	P1DIR |= BIT7 + BIT6; // count seconds by toggling port 1.7, count days by toggling 1.6
	P1OUT &= ~BIT7;
	P1OUT &= ~BIT6;
}

void initTimerA()
{
 	TACCTL0 |= CCIE;
  	TACCR0 = TRIGGER; // threshold to drop back to 0 in up mode
  	TACTL |= TASSEL_1; // ACLK is timer source (lowest clock speed)
  	TACTL |= MC_1; // up mode
}

int main(void)
{
	init();
	initTimerA();
  	for(;;) { _bis_SR_register(LPM3_bits + GIE); } // LPM3 with interrupt
	return 0;
}

#pragma vector=TIMER0_A0_VECTOR
 __interrupt void Timer_A0(void)
{
	seconds += 1;
	if(seconds >= 60) { minutes += 1; seconds = 0; }
	if(minutes >= 60) { hours += 1; minutes = 0; }
	if(hours >= 24) { days += 1; hours = 0; }
	if(days == DAYS_THRESH) P1OUT |= BIT6; // when we reach n number of days, activate 1.6
  P1OUT ^= BIT7;
}

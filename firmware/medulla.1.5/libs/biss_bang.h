// Kevin Kemper
#define F_CPU 32000000UL

#include <stdio.h>
#include <avr/io.h>
#include <util/delay.h>

#include "menial_io.h"


#define NBITS	32

#define BISS_ERROR_bp	7
#define BISS_ERROR_bm	(1<<7)

#define BISS_WARN_bp	6
#define BISS_WARN_bm	(1<<6)


// Notes:
//  - data changes state on rising clock edges
//	- sample when clk is low



#define BISS_SAMPLE	((PORT_BISS.IN & BISS_DAT_bm) >> BISS_DAT)

void initBiSS_bang() {

	PORT_BISS.OUTSET	= BISS_CLK_bm;				// clocks high...
	PORT_BISS.DIRSET	= BISS_CLK_bm;				// clocks -> output
	PORT_BISS.DIRCLR	= BISS_DAT_bm;				// data -> input

}


// Bang in the 32bit encoder values
//	data is a 32 bit container where the encoder values will be placed
uint8_t readBiSS_bang(uint8_t *data) {

	int8_t i,j;
	uint8_t tmp[4] = {0,0,0,0};
	uint8_t status = 0;

	if ((PORT_BISS.IN & BISS_DAT_bm) == 0) return status;								// the device isn't ready - bail
	
//	PORTH.OUTCLR = (1<<7);
	
	// knock twice...
	PORT_BISS.OUTTGL	= BISS_CLK_bm;	// down edge
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
	_delay_us(1);
	PORT_BISS.OUTTGL	= BISS_CLK_bm;	// up edge
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
	_delay_us(1);
	PORT_BISS.OUTTGL	= BISS_CLK_bm;	// down edge
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
	_delay_us(1);
	PORT_BISS.OUTTGL	= BISS_CLK_bm;	// up edge
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
	_delay_us(1);
	PORT_BISS.OUTTGL	= BISS_CLK_bm;	// down edge
	
	// Clock until we get the start bit
	while ((PORT_BISS.IN & BISS_DAT_bm) == 0) {
		//	__asm__ volatile ( "nop" );
		//	__asm__ volatile ( "nop" );
		//	__asm__ volatile ( "nop" );
		//	__asm__ volatile ( "nop" );
		_delay_us(1);
		PORT_BISS.OUTTGL	= BISS_CLK_bm;	// up edge
		//	__asm__ volatile ( "nop" );
		//	__asm__ volatile ( "nop" );
		//	__asm__ volatile ( "nop" );
		//	__asm__ volatile ( "nop" );
		_delay_us(1);
		PORT_BISS.OUTTGL	= BISS_CLK_bm;	// down edge
	}
//	PORTH.OUTTGL = (1<<7);
	
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
	_delay_us(1);
	PORT_BISS.OUTTGL	= BISS_CLK_bm;	// up edge
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
	_delay_us(1);
	PORT_BISS.OUTTGL	= BISS_CLK_bm;	// down edge
	
//	PORTH.OUTTGL = (1<<7);
	// now dat should be 0
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
	_delay_us(1);
	PORT_BISS.OUTTGL	= BISS_CLK_bm;	// up edge
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
	_delay_us(1);
	PORT_BISS.OUTTGL	= BISS_CLK_bm;	// down edge



	// next up is the actual data - sent MSb
//	PORTH.OUTTGL = (1<<7);
	for(i=7;i>=0;i--) {

		// sample the port
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
		tmp[3]	|= BISS_SAMPLE << i;
		
		
		PORT_BISS.OUTTGL	= BISS_CLK_bm;	// up edge
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
		_delay_us(1);
		PORT_BISS.OUTTGL	= BISS_CLK_bm;	// down edge
		
	}

//	PORTH.OUTTGL = (1<<7);
	for(i=7;i>=0;i--) {

		// sample the port
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
		tmp[2]	|= BISS_SAMPLE << i;
		
		PORT_BISS.OUTTGL	= BISS_CLK_bm;	// up edge
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
		_delay_us(1);
		PORT_BISS.OUTTGL	= BISS_CLK_bm;	// down edge
		
	}

//	PORTH.OUTTGL = (1<<7);
	for(i=7;i>=0;i--) {

		// sample the port
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
		tmp[1]	|= BISS_SAMPLE << i;
		
		PORT_BISS.OUTTGL	= BISS_CLK_bm;	// up edge
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
		_delay_us(1);
		PORT_BISS.OUTTGL	= BISS_CLK_bm;	// down edge
		
	}

//	PORTH.OUTTGL = (1<<7);
	for(i=7;i>=0;i--) {

		// sample the port
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
		tmp[0]	|= BISS_SAMPLE << i;
		
		PORT_BISS.OUTTGL	= BISS_CLK_bm;	// up edge
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
//			__asm__ volatile ( "nop" );
		_delay_us(1);
		PORT_BISS.OUTTGL	= BISS_CLK_bm;	// down edge
		
	}


	// sample the error bit...
	__asm__ volatile ( "nop" );
	__asm__ volatile ( "nop" );
	__asm__ volatile ( "nop" );
	status	|= BISS_SAMPLE << BISS_ERROR_bp;
//	PORTH.OUTTGL = (1<<7);
	
	PORT_BISS.OUTTGL	= BISS_CLK_bm;	// up edge
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
	_delay_us(1);
	PORT_BISS.OUTTGL	= BISS_CLK_bm;	// down edge


	// sample the warning bit...
	__asm__ volatile ( "nop" );
	__asm__ volatile ( "nop" );
	__asm__ volatile ( "nop" );
	status	|= BISS_SAMPLE << BISS_WARN_bp;
//	PORTH.OUTTGL = (1<<7);
	
	PORT_BISS.OUTTGL	= BISS_CLK_bm;	// up edge
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
//	__asm__ volatile ( "nop" );
	_delay_us(1);
	PORT_BISS.OUTTGL	= BISS_CLK_bm;	// down edge

//	PORTH.OUTTGL = (1<<7);
	// hammer out the CRC - 6 bits
	for(i=5;i>=0;i--) {

		// sample the port
//		__asm__ volatile ( "nop" );
//		__asm__ volatile ( "nop" );
//		__asm__ volatile ( "nop" );
		status	|= BISS_SAMPLE << i;
		
		PORT_BISS.OUTTGL	= BISS_CLK_bm;	// up edge
//		__asm__ volatile ( "nop" );
//		__asm__ volatile ( "nop" );
//		__asm__ volatile ( "nop" );
//		__asm__ volatile ( "nop" );
		_delay_us(1);
		PORT_BISS.OUTTGL	= BISS_CLK_bm;	// down edge
		
	}
	
//	PORTH.OUTSET = (1<<7);
	PORT_BISS.OUTSET	= BISS_CLK_bm;	// down edge
	
	// pack it up
	data[3] = tmp[3];
	data[2] = tmp[2];
	data[1] = tmp[1];
	data[0] = tmp[0];
	
	return status;
}

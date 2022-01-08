/*
-- inject a vga font (dos) (8 bit wide, not 9) on vga.pcf!
-- by freakpie@lix.intercom.es
*/

#include <stdio.h>

int main (void) {
	FILE *input, *output;
 	unsigned long i;
 	unsigned int tmp;
 	unsigned char tmp2;

	puts("dr.fontdumper -- inject font in X11R6's vga.pcf");

	if ((output = fopen ("fkp.pcf", "r+")) == NULL) {
		puts("-- error opening output file!");
		return 1;
	}
	if ((input = fopen("xfreakt.fnt","r")) == NULL) {
		puts("-- error opening input file!");
		fclose(output);
		return 2;
	}
	/* lets inject da font */
	
	fseek(output,14020-175*16*4,0);
	fseek(input,16,0);
	for(i=0;i<254*16;i++) {
		tmp = getc(input);
		if(i!=0) { putc(0,output); putc(0,output); putc(0,output); }
		/* aqui hay que darle la vuelta al bit */
		tmp2 = ((tmp&(1<<0))<<7) | ((tmp&(1<<1))<<5) | ((tmp&(1<<2))<<3) | ((tmp&(1<<3))<<1) \
		     | ((tmp&(1<<7))>>7) | ((tmp&(1<<6))>>5) | ((tmp&(1<<5))>>3) | ((tmp&(1<<4))>>1);
		putc(tmp2,output);
	}
	fclose(input);
	fclose(output);
  	puts("done!");
  	return 0;
}

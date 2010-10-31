#include <font_8x8.h>

#define WIDTH (15*10*10)
#define HEIGHT (100)

unsigned char image[WIDTH][HEIGHT];

void render(char *message,char *specialText){
	unsigned char c,sc,inner_font,outer_font;
	int specialTextLength=strlen(specialText);
	int specialTextIndex=0;
	int X=10;
	int outer_x,outer_y,inner_x,inner_y,i,j,outer_r;
	while(*message){
		c=message[0];
		message++;
		specialTextIndex=0;


		if(c==' '){
			X+=50;
			continue;
		}
		for(outer_y=10,outer_r=0;outer_y<10+(8*10);outer_y+=10,outer_r++){
			outer_font=fontdata_8x8[(c*8)+outer_r];
			for(outer_x=X;outer_x<(X+(8*10));outer_x+=10){
				if(outer_font&0x80){
					sc=specialText[specialTextIndex++];
					if(specialTextIndex==specialTextLength)specialTextIndex=0;
					for(inner_y=outer_y;inner_y<outer_y+8;inner_y++){
						inner_font=fontdata_8x8[sc*8+(inner_y-outer_y)];
						for(inner_x=outer_x;inner_x<outer_x+8;inner_x++){
							if(inner_font&0x80)image[inner_x][inner_y]=255;
							inner_font<<=1;
						}
					}
				}
				outer_font<<=1;
			}
		}
		X+=(8*10);
	}

	printf("P6\n");
	printf("# Comment\n");
	printf("%d %d\n",X,HEIGHT);
	printf("255\n");

	for ( i = 0; i < HEIGHT; i++ )
	{
		for ( j = 0; j < X; j++ ){
			c=255-image[j][i];
			if(c==0)
			printf("%c%c%c",255,50,50);
			else 
			printf("%c%c%c",255,255,255);
		}
	}


}



int main(int argc,char *argv[]){

	render(argv[1],argv[2]);

}

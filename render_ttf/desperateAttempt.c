#include <stdio.h>
#include <font_8x8.h>

#define WIDTH 6000
#define HEIGHT 4000

unsigned char image[WIDTH][HEIGHT][3];

#define LETTER_WIDTH 400
#define LETTER_HEIGHT 400




unsigned char template[600][200][200][3];

void loadImage(char *image){
	static int imageCounter;
	int i,j,x;

	char line[1000];
	int max_x,max_y;

	FILE *fp=fopen(image,"r");

	fgets(line,100,fp);
	fscanf(fp,"%d %d\n",&max_x,&max_y);
	fgets(line,100,fp);



	for(i=0;i<200;i++){
		for(j=0;j<200;j++){
			if(i<max_y && j < max_x) fscanf(fp,"%c%c%c",&(template[imageCounter][i][j][0]),&(template[imageCounter][i][j][1]),&(template[imageCounter][i][j][2]));
			else template[imageCounter][i][j][0]=template[imageCounter][i][j][1]=template[imageCounter][i][j][2]=127;
		}
		if (max_x > 200) {
			char r,g,b;
			for(j=0;j<(max_x-200);j++)fscanf(fp,"%c%c%c",&r,&g,&b);
		}
	}
	imageCounter++;
	fclose(fp);
}

void loadImages(){
	int i;
	char *list[]={

#include "imagelist.h"
		
	};

for(i=0;i<485;i++)loadImage(list[i]);


}

#include <math.h>

unsigned char enhance(unsigned char v){
	double f=v;
	f=ceil(f*1.2);
	if(f>255)f=255;
	v=f;
	return f;

}
unsigned char reduce(unsigned char v){
	double f=v;
	f=ceil(f*.8);
	if(f<0)f=0;
	v=f;
	return f;
}

void render(char *message){
	unsigned char c,sc,inner_font,outer_font,r,g,b;
	int specialTextIndex=0;
	int X=10;
	int ii,jj;
	int outer_x,outer_y,inner_x,inner_y,i,j,outer_r;
	while(*message){
		c=message[0];
		message++;

#define Y_OFFSET 200
#define X_OFFSET 20

		for(outer_y=Y_OFFSET,outer_r=0;outer_y<(Y_OFFSET+(8*LETTER_HEIGHT));outer_y+=(LETTER_HEIGHT),outer_r++){
			outer_font=fontdata_8x8[(c*8)+outer_r];
			for(outer_x=X;outer_x<(X+(8*LETTER_WIDTH));outer_x+=LETTER_WIDTH){
					specialTextIndex++;
					if(specialTextIndex>=485)specialTextIndex=0;
				if(outer_font&0x80){
					for(inner_y=outer_y,ii=0;inner_y<outer_y+(LETTER_HEIGHT/2);inner_y++,ii++){
						for(inner_x=outer_x,jj=0;inner_x<outer_x+(LETTER_WIDTH/2);inner_x++,jj++){
							image[inner_x][inner_y][0]=(reduce(template[specialTextIndex][ii][jj][0]));
							image[inner_x][inner_y][1]=(reduce(reduce(reduce(template[specialTextIndex][ii][jj][1]))));
							image[inner_x][inner_y][2]=enhance(template[specialTextIndex][ii][jj][2]);

						}
					}
					specialTextIndex++;
					if(specialTextIndex>=485)specialTextIndex=0;
					for(inner_y=outer_y+(LETTER_HEIGHT/2),ii=0;inner_y<outer_y+(LETTER_HEIGHT);inner_y++,ii++){
						for(inner_x=outer_x,jj=0;inner_x<outer_x+(LETTER_WIDTH/2);inner_x++,jj++){
							image[inner_x][inner_y][0]=(reduce(template[specialTextIndex][ii][jj][0]));
							image[inner_x][inner_y][1]=(reduce(reduce(reduce(template[specialTextIndex][ii][jj][1]))));
							image[inner_x][inner_y][2]=enhance(template[specialTextIndex][ii][jj][2]);
						}
					}
					specialTextIndex++;
					if(specialTextIndex>=485)specialTextIndex=0;
					for(inner_y=outer_y+(LETTER_HEIGHT/2),ii=0;inner_y<outer_y+(LETTER_HEIGHT);inner_y++,ii++){
						for(inner_x=outer_x+(LETTER_WIDTH/2),jj=0;inner_x<outer_x+(LETTER_WIDTH);inner_x++,jj++){
							image[inner_x][inner_y][0]=(reduce(template[specialTextIndex][ii][jj][0]));
							image[inner_x][inner_y][1]=(reduce(reduce(reduce(template[specialTextIndex][ii][jj][1]))));
							image[inner_x][inner_y][2]=enhance(template[specialTextIndex][ii][jj][2]);
						}
					}
					specialTextIndex++;
					if(specialTextIndex>=485)specialTextIndex=0;
					for(inner_y=outer_y,ii=0;inner_y<outer_y+(LETTER_HEIGHT/2);inner_y++,ii++){
						for(inner_x=outer_x+(LETTER_WIDTH/2),jj=0;inner_x<outer_x+(LETTER_WIDTH);inner_x++,jj++){
							image[inner_x][inner_y][0]=(reduce(template[specialTextIndex][ii][jj][0]));
							image[inner_x][inner_y][1]=(reduce(reduce(reduce(template[specialTextIndex][ii][jj][1]))));
							image[inner_x][inner_y][2]=enhance(template[specialTextIndex][ii][jj][2]);
						}
					}
				}else{
					for(inner_y=outer_y,ii=0;inner_y<outer_y+(LETTER_HEIGHT/2);inner_y++,ii++){
						//inner_font=fontdata_8x8[sc*8+(inner_y-outer_y)];
						for(inner_x=outer_x,jj=0;inner_x<outer_x+(LETTER_WIDTH/2);inner_x++,jj++){
							image[inner_x][inner_y][0]=enhance(template[specialTextIndex][ii][jj][0]);
							image[inner_x][inner_y][1]=enhance(template[specialTextIndex][ii][jj][1]);
							image[inner_x][inner_y][2]=enhance(template[specialTextIndex][ii][jj][2]);
						}
					}
					specialTextIndex++;
					if(specialTextIndex>=485)specialTextIndex=0;
					for(inner_y=outer_y+(LETTER_HEIGHT/2),ii=0;inner_y<outer_y+(LETTER_HEIGHT);inner_y++,ii++){
						for(inner_x=outer_x,jj=0;inner_x<outer_x+(LETTER_WIDTH/2);inner_x++,jj++){
							image[inner_x][inner_y][0]=enhance(template[specialTextIndex][ii][jj][0]);
							image[inner_x][inner_y][1]=enhance(template[specialTextIndex][ii][jj][1]);
							image[inner_x][inner_y][2]=enhance(template[specialTextIndex][ii][jj][2]);
						}
					}
					specialTextIndex++;
					if(specialTextIndex>=485)specialTextIndex=0;
					for(inner_y=outer_y+(LETTER_HEIGHT/2),ii=0;inner_y<outer_y+(LETTER_HEIGHT);inner_y++,ii++){
						for(inner_x=outer_x+(LETTER_WIDTH/2),jj=0;inner_x<outer_x+(LETTER_WIDTH);inner_x++,jj++){
							image[inner_x][inner_y][0]=enhance(template[specialTextIndex][ii][jj][0]);
							image[inner_x][inner_y][1]=enhance(template[specialTextIndex][ii][jj][1]);
							image[inner_x][inner_y][2]=enhance(template[specialTextIndex][ii][jj][2]);
						}
					}
					specialTextIndex++;
					if(specialTextIndex>=485)specialTextIndex=0;
					for(inner_y=outer_y,ii=0;inner_y<outer_y+(LETTER_HEIGHT/2);inner_y++,ii++){
						for(inner_x=outer_x+(LETTER_WIDTH/2),jj=0;inner_x<outer_x+(LETTER_WIDTH);inner_x++,jj++){
							image[inner_x][inner_y][0]=enhance(template[specialTextIndex][ii][jj][0]);
							image[inner_x][inner_y][1]=enhance(template[specialTextIndex][ii][jj][1]);
							image[inner_x][inner_y][2]=enhance(template[specialTextIndex][ii][jj][2]);
						}
					}

				}
				outer_font<<=1;
			}
		}
		X+=(8*LETTER_WIDTH);
	}

	
	printf("P6\n");
	printf("# Comment %d\n",specialTextIndex);
	printf("%d %d\n",X,HEIGHT);
	printf("255\n");

	for ( i = 0; i < HEIGHT; i++ )
	{
		for ( j = 0; j < X; j++ ){
			r=image[j][i][0];
			g=image[j][i][1];
			b=image[j][i][2];
			printf("%c%c%c",r,g,b);
		}
	}


}



int main(int argc,char *argv[]){

loadImages();
	//loadImage("sriguru.pnm");
	render(argv[1]);

}

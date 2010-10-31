%.exe:%.c
	gcc -I/Developer/SDKs/MacOSX10.6.sdk/usr/X11/include/freetype2 -I/opt/local/var/macports/software/freetype/2.4.2_0/opt/local/include/ -L/opt/local/var/macports/software/freetype/2.4.2_0/opt/local/lib/ -lfreetype $< -o $@

#gcc `pkg-config --cflags --libs freetype2` -lm example.c -o render

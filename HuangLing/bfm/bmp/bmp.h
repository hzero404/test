#include <stdio.h>
#include <stdlib.h>


typedef unsigned short WORD;

typedef unsigned long DWORD;
#pragma  pack(1)

//File header
typedef struct BMP_FILE_HEADER
{
	WORD bType;
	DWORD bSize;
	WORD bReserved1;
	WORD bReserved2;
	DWORD bOffset;
} BMPFILEHEADER;

//bitmap information
typedef struct BMP_INFO
{
	DWORD bInfoSize;
	DWORD bWidth;
	DWORD bHeight;
	WORD bPlanes;
	WORD bBitCount;
	DWORD bCompression;
	DWORD bmpImageSize;
	DWORD bXPelsPerMeter;
	DWORD bYPelsPerMeter;
	DWORD bClrUsed;
	DWORD bClrImportant;
} BMPINF;


typedef struct Rgb_Quad 
{  
	unsigned char rgbBlue;
	unsigned char rgbGreen;
	unsigned char rgbRed;
	unsigned char rgbReserved;
} RgbQuad;
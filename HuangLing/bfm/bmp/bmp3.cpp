#include <stdlib.h>
#include <stdio.h>
#include "bmp.h"

/////////////////////8-bit//////////////////////// 
int main()
{
	FILE *fp = fopen("test.bmp", "rb");
	if (fp == 0)
		return 0;
	BMPFILEHEADER fileHead;
	fread(&fileHead, sizeof(BMPFILEHEADER), 1, fp);
	BMPINF infoHead;
	fread(&infoHead, sizeof(BMPINF), 1, fp);
	int width = infoHead.bWidth;
	int height = infoHead.bHeight;
	int biCount = infoHead.bBitCount;
 
	RgbQuad *fpc; //color palette
 
	fpc = new RgbQuad[256];
	fread(fpc, sizeof(RgbQuad), 256, fp);
 
	unsigned char *fpb;//bitmap information
	int lineByte = (width*biCount / 8 + 3) / 4 * 4;//4 bytes per line
	fpb = new unsigned char[lineByte*height];
	fread(fpb, lineByte*height, 1, fp);
	fclose(fp);
 
	// Horizontal mirror
	unsigned char*fpb1;
	fpb1 = new unsigned char[lineByte*height];

	for (int i = 0; i < height; ++i)
	{
		for (int j = 0; j < width; ++j)
		{
			unsigned char *p1, *p2;
			p1 = fpb + i*lineByte + (width - 1 - j);//Mirror pixels
			p2 = fpb1 + i*lineByte + j;//Original pixel
			(*p2) = (*p1);//Exchange
		}
	}

	// write file
	FILE *fpo = fopen("mirror.bmp", "wb");
	if (fpo == 0)
		return 0;
	BMPFILEHEADER bmpFileHeader;

    bmpFileHeader.bType=0x4d42;
    bmpFileHeader.bSize=sizeof(BMPFILEHEADER) + sizeof(BMPINF) + 1024 + lineByte*height;
    bmpFileHeader.bReserved1=0;
    bmpFileHeader.bReserved2=0;
    bmpFileHeader.bOffset=1078;

	fwrite(&bmpFileHeader, sizeof(bmpFileHeader), 1, fpo);
 
	BMPINF bmpInfo;

    bmpInfo.bInfoSize=40;
    bmpInfo.bHeight=height;
    bmpInfo.bWidth=width;
    bmpInfo.bPlanes=1;
    bmpInfo.bBitCount=8;
    bmpInfo.bCompression=0;
    bmpInfo.bmpImageSize=lineByte*height;
    bmpInfo.bXPelsPerMeter=3780;
    bmpInfo.bYPelsPerMeter=3780;
    bmpInfo.bClrUsed=0;
    bmpInfo.bClrImportant=0;

	fwrite(&bmpInfo, sizeof(bmpInfo), 1, fpo);
 
	fwrite(fpc, sizeof(RgbQuad), 256, fpo);
	fwrite(fpb1, lineByte*height, 1, fp);
	fclose(fpo);
 
	return 0;
}

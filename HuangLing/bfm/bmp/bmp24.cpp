#include <stdlib.h>
#include <stdio.h>
#include "bmp.h"

/////////////////////24位图水平镜像////////////////////////
int main()
{
	FILE *fp = fopen("test2244.bmp", "rb");
	if (fp == 0)
		return 0;
	BMPFILEHEADER fileHead;
	fread(&fileHead, sizeof(BMPFILEHEADER), 1, fp);
	BMPINF infoHead;
	fread(&infoHead, sizeof(BMPINF), 1, fp);
	int width = infoHead.bWidth;
	int height = infoHead.bHeight;
	int biCount = infoHead.bBitCount;

	unsigned char *fpb;//位图数据
	int lineByte = (width*biCount / 8 + 3) / 4 * 4;//每行字节数4
	fpb = new unsigned char[lineByte*height];
	fread(fpb, lineByte*height, 1, fp);
	fclose(fp);
 
	// 水平镜像
	unsigned char*fpb1;
	fpb1 = new unsigned char[lineByte*height];

	for (int i = 0; i < height; ++i)
	{
		for (int j = 0; j < lineByte; j = j + 3)
		{
			unsigned char *p1,*p2;
			for(int k = 0; k < 3; ++k)
			{
				p1 = fpb + i*lineByte + (lineByte + k - 3 - j);//镜像像素，化简
			  //p1 = fpb + i*lineByte + (lineByte - 1 + k - 2 - j);化简前
				p2 = fpb1 + i*lineByte + j + k;//原本像素
			    (*p2) = (*p1);//交换
			}
		}
	}

	// 写入文件
	FILE *fpo = fopen("mirror24.bmp", "wb");
	if (fpo == 0)
		return 0;
	BMPFILEHEADER bmpFileHeader;

    bmpFileHeader.bType=0x4d42;
    bmpFileHeader.bSize=sizeof(BMPFILEHEADER) + sizeof(BMPINF) + lineByte*height;;
    bmpFileHeader.bReserved1=0;
    bmpFileHeader.bReserved2=0;
    bmpFileHeader.bOffset=54;

	fwrite(&bmpFileHeader, sizeof(bmpFileHeader), 1, fpo);
 
	BMPINF bmpInfo;

    bmpInfo.bInfoSize=40;
    bmpInfo.bHeight=height;
    bmpInfo.bWidth=width;
    bmpInfo.bPlanes=1;
    bmpInfo.bBitCount=24;
    bmpInfo.bCompression=0;
    bmpInfo.bmpImageSize=lineByte*height;
    bmpInfo.bXPelsPerMeter=0;
    bmpInfo.bYPelsPerMeter=0;
    bmpInfo.bClrUsed=0;
    bmpInfo.bClrImportant=0;

	fwrite(&bmpInfo, sizeof(bmpInfo), 1, fpo);
 
	fwrite(fpb1, lineByte*height, 1, fp);
	fclose(fpo);
 
	return 0;
}

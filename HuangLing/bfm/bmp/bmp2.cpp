#include <stdio.h>
#include <stdlib.h>
#include "bmp.h"

///////////////////读信息//////////////////////

typedef unsigned short WORD;

typedef unsigned long DWORD;

int main()
{

	BMPFILEHEADER bmpFileHeader;
	BMPINF bmpInfo;


    FILE *fp;
//读
	fp = fopen("test2244.bmp", "rb");
	if (fp == 0)
	{
		printf("错\n");
		while(1);
		return 0;
	}

	fread(&bmpFileHeader, sizeof(bmpFileHeader), 1, fp); 
	
	fread(&bmpInfo, sizeof(bmpInfo), 1, fp);


    //文件信息头
	printf("文件标识符 = 0X%X\n",                            bmpFileHeader.bType);
	printf("BMP 文件大小 = %d 字节\n",                       bmpFileHeader.bSize);
	printf("保留值1 = %d \n",                                bmpFileHeader.bReserved1);
	printf("保留值2 = %d \n",                                bmpFileHeader.bReserved2);
	printf("文件头的最后到图像数据位开始的偏移量 = %d 字节\n",  bmpFileHeader.bOffset);
    //位图信息头
	printf("信息头的大小 = %d 字节\n",                        bmpInfo.bInfoSize);
	printf("位图的高度 = %d \n",                             bmpInfo.bHeight);
	printf("位图的宽度 = %d \n",                             bmpInfo.bWidth);
	printf("图像的位面数 = %d \n",                           bmpInfo.bPlanes); 
	printf("每个像素的位数 = %d 位\n",                       bmpInfo.bBitCount);
	printf("压缩类型 = %d \n",                               bmpInfo.bCompression);
	printf("图像的大小 = %d 字节\n",                         bmpInfo.bmpImageSize);
	printf("水平分辨率 = %d \n",                             bmpInfo.bXPelsPerMeter);
	printf("垂直分辨率 = %d \n",                             bmpInfo.bYPelsPerMeter);
	printf("使用的色彩数 = %d \n",                           bmpInfo.bClrUsed);
	printf("重要的色彩数 = %d \n",                           bmpInfo.bClrImportant);



	while(1);

	return 0;


}

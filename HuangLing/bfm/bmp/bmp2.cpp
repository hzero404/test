#include <stdio.h>
#include <stdlib.h>
#include "bmp.h"

///////////////////����Ϣ//////////////////////

typedef unsigned short WORD;

typedef unsigned long DWORD;

int main()
{

	BMPFILEHEADER bmpFileHeader;
	BMPINF bmpInfo;


    FILE *fp;
//��
	fp = fopen("test2244.bmp", "rb");
	if (fp == 0)
	{
		printf("��\n");
		while(1);
		return 0;
	}

	fread(&bmpFileHeader, sizeof(bmpFileHeader), 1, fp); 
	
	fread(&bmpInfo, sizeof(bmpInfo), 1, fp);


    //�ļ���Ϣͷ
	printf("�ļ���ʶ�� = 0X%X\n",                            bmpFileHeader.bType);
	printf("BMP �ļ���С = %d �ֽ�\n",                       bmpFileHeader.bSize);
	printf("����ֵ1 = %d \n",                                bmpFileHeader.bReserved1);
	printf("����ֵ2 = %d \n",                                bmpFileHeader.bReserved2);
	printf("�ļ�ͷ�����ͼ������λ��ʼ��ƫ���� = %d �ֽ�\n",  bmpFileHeader.bOffset);
    //λͼ��Ϣͷ
	printf("��Ϣͷ�Ĵ�С = %d �ֽ�\n",                        bmpInfo.bInfoSize);
	printf("λͼ�ĸ߶� = %d \n",                             bmpInfo.bHeight);
	printf("λͼ�Ŀ�� = %d \n",                             bmpInfo.bWidth);
	printf("ͼ���λ���� = %d \n",                           bmpInfo.bPlanes); 
	printf("ÿ�����ص�λ�� = %d λ\n",                       bmpInfo.bBitCount);
	printf("ѹ������ = %d \n",                               bmpInfo.bCompression);
	printf("ͼ��Ĵ�С = %d �ֽ�\n",                         bmpInfo.bmpImageSize);
	printf("ˮƽ�ֱ��� = %d \n",                             bmpInfo.bXPelsPerMeter);
	printf("��ֱ�ֱ��� = %d \n",                             bmpInfo.bYPelsPerMeter);
	printf("ʹ�õ�ɫ���� = %d \n",                           bmpInfo.bClrUsed);
	printf("��Ҫ��ɫ���� = %d \n",                           bmpInfo.bClrImportant);



	while(1);

	return 0;


}

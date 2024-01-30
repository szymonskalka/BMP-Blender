#include "pch.h"
#include "Test.h"
#include <bitset>
#include <cstddef>
#include <iostream>




TestClass::TestClass(int x) {
	this->x = x;
}

int TestClass::Adding(int y) {
	return (this->x + y);
}

void  BlendImages2(std::byte *byteArray1First, std::byte* byteArray1Last,
				   std::byte* byteArray2First, std::byte* byteArray2Last,
				   int alpha) {
	while (byteArray1First != byteArray1Last) {
		*byteArray1First = (std::byte)(((int)*byteArray1First * (255 - alpha) + (int)*byteArray2First * alpha) / 255);
		byteArray1First++;
		byteArray2First++;
	}
	*byteArray1Last = (std::byte)(((int)*byteArray1Last * (255 - alpha) + (int)*byteArray2Last * alpha) / 255);
}




std::byte  BlendImages(std::byte byte1, std::byte byte2,  int alpha) {	

	return  (std::byte)(((int)byte1 * (255 - alpha) + (int)byte2 * alpha) / 255);
}


int TestDoubling(int x) {
	return (x * 2);
}

extern "C" __declspec(dllexport) std::byte BlendImagesInCpp(std::byte byte1, std::byte byte2, int alpha) {
	return BlendImages(byte1, byte2, alpha);
}
extern "C" __declspec(dllexport)  void BlendImagesInCpp2(std::byte *byteArray1First, std::byte* byteArray1Last,
														std::byte* byteArray2First, std::byte* byteArray2Last,
														int alpha) {
	return BlendImages2(byteArray1First, byteArray1Last, byteArray2First, byteArray2Last, alpha);
}



extern "C" __declspec(dllexport) int TestFunc(int x) {
	return TestDoubling(x);
}
extern "C" __declspec(dllexport) int TestFunc2(int x) {
	return TestDoubling(x);
}
// ------------------------------------------------------------------------ -
//
// Autor: Szymon Skalka
// Temat: Program laczacy dwa pliki graficzne.
// Opis: Program mnozy wartosci bajtowe dwoch obrazow przez zmienna i oblicza wartosc polaczona
// Data: 11.02.2024 Semestr 5 Rok II Skalka Szymon
// Wersja 1.0
//
// This is the C++ exported function
//
// ------------------------------------------------------------------------ -
#include "pch.h"
#include "framework.h"
#include "CppLib.h"

#include <bitset>
#include <cstddef>
#include <iostream>

#include <stdio.h>
#include <intrin.h>

#pragma intrinsic(__rdtsc)


/**
* Name: Ticks
* Output Parameters: Amount of cpu ticks.
*
*/
uint64_t Ticks() {
	uint64_t i;
	i = __rdtsc();
	return i;
}

/**
* Name: BlendImages
* Paramters: 4 pointers and the alpha blending value (0-255).
* Pointing to first and last byte in each imageArray.
* No output parameters - all operations done on the first array pointers
*
*/
void  BlendImages(std::byte* byteArray1First, std::byte* byteArray1Last,
	std::byte* byteArray2First, std::byte* byteArray2Last,
	int alpha) {
	while (byteArray1First <= byteArray1Last) {
		*byteArray1First = (std::byte)(((int)*byteArray1First * (255 - alpha) + (int)*byteArray2First * alpha) / 255);
		byteArray1First++;
		byteArray2First++;
	}
}

void  BlendImages2(std::byte* byteArray1First,	std::byte* byteArray2First, int length,	int alpha) {
	for (int i = 0; i < length; i++) {
		*byteArray1First = (std::byte)(((int)*byteArray1First * (255 - alpha) + (int)*byteArray2First * alpha) / 255);
		byteArray1First++;
		byteArray2First++;
	}
}


/**
* Export definition
*
*/
extern "C" __declspec(dllexport)  void BlendImagesInCpp2(std::byte * byteArray1First, std::byte * byteArray2First, int length, int alpha) {
	return BlendImages2(byteArray1First, byteArray2First, length, alpha);
}
/**
* Export definition
*  
*/
extern "C" __declspec(dllexport)  void BlendImagesInCpp(std::byte * byteArray1First, std::byte * byteArray1Last,
	std::byte * byteArray2First, std::byte * byteArray2Last,
	int alpha) {
	return BlendImages(byteArray1First, byteArray1Last, byteArray2First, byteArray2Last, alpha);
}

/**
* Export definition
*
*/
extern "C" __declspec(dllexport)  uint64_t GetTicks() {
	return Ticks();
}

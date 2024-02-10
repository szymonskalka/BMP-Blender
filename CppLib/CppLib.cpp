// -------------------------------------------------------------------------
//
// Autor: Szymon Ska?ka
// Temat: Program ??cz?cy dwa pliki graficzne.
// Opis: Program mno?y warto?ci bajtowe dwóch obrazów przez zmienn? i oblicza warto?? po??czon? 
// Data: 11.02.2024 Semestr 5 Rok II Ska?ka Szymon
// Wersja 1.0
//
// This is the C# Windows Forms main function
//
// -------------------------------------------------------------------------
#include "pch.h"
#include "framework.h"
#include "CppLib.h"

#include <bitset>
#include <cstddef>
#include <iostream>




void  BlendImages(std::byte* byteArray1First, std::byte* byteArray1Last,
	std::byte* byteArray2First, std::byte* byteArray2Last,
	int alpha) {
	while (byteArray1First != byteArray1Last) {
		*byteArray1First = (std::byte)(((int)*byteArray1First * (255 - alpha) + (int)*byteArray2First * alpha) / 255);
		byteArray1First++;
		byteArray2First++;
	}
	*byteArray1Last = (std::byte)(((int)*byteArray1Last * (255 - alpha) + (int)*byteArray2Last * alpha) / 255);
}

extern "C" __declspec(dllexport)  void BlendImagesInCpp(std::byte * byteArray1First, std::byte * byteArray1Last,
	std::byte * byteArray2First, std::byte * byteArray2Last,
	int alpha) {
	return BlendImages(byteArray1First, byteArray1Last, byteArray2First, byteArray2Last, alpha);
}

#pragma once
class TestClass {
	int x;
public:
	TestClass(int y);
	int Adding(int y);
};



extern "C" __declspec(dllexport) void* Create(int x) {
	return (void*) new TestClass(x);
}

extern "C" __declspec(dllexport) int TestAdd(TestClass * a, int y) {
	return a->Adding(y);
}
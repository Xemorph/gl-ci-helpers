// main.cpp : the application source code.
#include <iostream>
#include <GLFW/glfw3.h>

using namespace std;

int main() {
	if(!glfwInit()) {
		return 1;
	}
	glfwTerminate();
	return 0;
}
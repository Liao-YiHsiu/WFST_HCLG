#include <iostream>
#include <fstream>
#include <string>
#include <stdlib.h>     /* strtod */
using namespace std;

int main(int argc, char* argv[]){

	ifstream I(argv[1]);
	string name(argv[1]);
	double s = strtod(argv[2], NULL);;
	name = name + "_scale";
	ofstream O(name.c_str());
	double tmp;
	while(I>>tmp)
		O<<tmp*s<<endl;


	return 0;
}

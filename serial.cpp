#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <chrono>

using namespace std;

void printField(int **field, int row, int col) {
	for (int i = 0; i < row; i++) {
		for (int j = 0; j < col; j++) {
			if (field[i][j] == 0) {
				cout << '.';
			} else {
				cout << 'O';
			}
		}
		cout << endl;
	}
	cout << endl;
}

const int around[8][2] = {
	{-1, 0}, // Left
	{1, 0},  // Right
	{0, -1}, // Up
	{0, 1},  // Down
	{-1, -1}, // Up Left
	{-1, 1},  // Down Left
	{1, -1}, // Up Right
	{1, 1},  // Down Right
};

int countAround(int **field, int x, int y, int fieldSize) {
	int count = 0;
	for (int i = 0; i < 8; i++) {
		int aroundX = x + around[i][0];
		int aroundY = y + around[i][1];
		if (aroundX >= 0 && aroundY >= 0 && aroundX < fieldSize && aroundY < fieldSize) {
			if (field[aroundY][aroundX] == 1) {
				count++;
			}
		}		
	}
	return count;
}

void eval(int **prev, int fieldSize) {
	// Init new field
	int **field;
	field = (int**) malloc(sizeof(int*) * fieldSize);
	for (int i = 0; i < fieldSize; i++) {
			int *row = (int*) malloc(sizeof(int) * fieldSize);
			field[i] = row;
	}
	
	// Evaluate every cell
	for (int i = 0; i < fieldSize; i++) {
		for (int j = 0; j < fieldSize; j++) {
			// Count living cell
			int around = countAround(prev, j, i, fieldSize);
			
			// Evaluate cell
			if (prev[i][j] == 1 && around != 2 && around != 3) {
				field[i][j] = 0;				
			} else if (prev[i][j] == 0 && around == 3) {
				field[i][j] = 1;
			} else {
				field[i][j] = prev[i][j];
			}
		}
	}
	
	// Copy new field to previous field
	for (int i = 0; i < fieldSize; i++) {
		memcpy(prev[i], field[i], sizeof(int) * fieldSize);
	}
	free(field);
}

void initField(int *field, int fieldSize) {
  // Initialize field with pattern using file
  // File format:
  // x1 y1
  // x2 y2
  // x3 y3
  // etc
  
  // Cell (x, y) will become living cell
  ifstream fin("field-gosper.txt");

  if (fin) {
    string lineread;
    while (getline(fin, lineread)) {
        stringstream line(lineread);
        string coor;
        line >> coor;
        int x = stoi(coor);
        line >> coor;
        int y = stoi(coor);
        
        // // One
        // field[y][x] = 1;
        
        // Repeating pattern
        const int TEMPLATE_SIZE = 40; // Max size of pattern generated
        for (int i = 0; i < fieldSize / TEMPLATE_SIZE; i++) {  
          for (int j = 0; j < fieldSize / TEMPLATE_SIZE; j++) {  
            field[(i*TEMPLATE_SIZE + y)][(j*TEMPLATE_SIZE+ x)] = 1;
          }
        }
    }
    fin.close();
  }
}

int main() {
	int n;
	int iter = 1000;
	n = 512;
	
	int **field;
	
	field = (int**) malloc(sizeof(int*) * n);
	
	for (int i = 0; i < n; i++) {
		int *row;
		row = (int*) calloc(n, sizeof(int));
		field[i] = row;
	}
	
	initField(field, n);
	  
	ofstream fout;
  	fout.open("output-serial.txt", ofstream::out | ofstream::trunc);
	auto start = chrono::steady_clock::now();
  	for (int i = 0; i < iter; i++) {
		eval(field, n);
		//output the field to file
		for (int i = 0; i < n; i++) {
			for (int j = 0; j < n; j++) {
				if (field[i][j] == 0) {
					fout << '.';
				} else {
					fout << 'O';
				}
			}
			fout << endl;
		}
		fout << endl;
	}

	auto end = chrono::steady_clock::now();

	auto diff = end - start;
	cout << "Serial:" << endl;
	cout << "Field size: " << n << endl;
	cout << "Iteration: " << iter << endl;
	cout << "Time: " << chrono::duration <double, milli> (diff).count() / 1000 << " seconds" << endl;

	free(field);
	
	return 0;
}
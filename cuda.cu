%%cu
#include <iostream>
#include <fstream>
#include <cuda.h>
#include <string>
#include <sstream>
#include <cstring>
#include <chrono>

using namespace std;

#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort=true)
{
   if (code != cudaSuccess) 
   {
      fprintf(stderr,"GPU assert: %s %s line %d\n", cudaGetErrorString(code), file, line);
      if (abort) exit(code);
   }
}

void printArrAsField(int* field, int fieldSize) {
  for (int i = 0; i < fieldSize; i++) {
      for (int j = 0; j < fieldSize; j++) {
        if (field[i*fieldSize + j] == 0) {
          cout << '.';
        } else {
          cout << 'O';
        }
      }
    cout << endl;
  }
  cout << endl;
}

void printRaw(int* field, int fieldSize) {
  for (int i = 0; i < fieldSize; i++) {
      for (int j = 0; j < fieldSize; j++) {
        cout << field[i*fieldSize + j] << '\t';
      }
    cout << endl;
  }
  cout << endl;
}


__global__ void evalCell(int *prevField, int *newField, int fieldSize) {
  int idx = blockIdx.x * blockDim.x + threadIdx.x;
  
  if (idx < fieldSize*fieldSize) {
    const int around[8][2] = {
      {-1, 0}, // Left
      {1, 0},  // Right
      {0, -1}, // Up
      {0, 1},  // Down
      {-1, -1}, // Up Left
      {-1, 1},  // Down Left
      {1, -1}, // Up Right
      {1, 1},  // Up Down
    };

    // Count living neighbour
    int count = 0;
    for (int i = 0; i < 8; i++) {
      int aroundIdx = idx + around[i][0] + around[i][1] * fieldSize;
      if (aroundIdx > 0 && aroundIdx < fieldSize * fieldSize && (aroundIdx+1) % fieldSize != 0 && (aroundIdx-1) % fieldSize != 0) {
        if (prevField[aroundIdx] == 1) {
          count++;
        }
      }		
    }

    // Evaluate cell
    if (prevField[idx] == 1 && count != 2 && count != 3) {
      newField[idx] = 0;				
    } else if (newField[idx] == 0 && count == 3) {
      newField[idx] = 1;
    } else {
      newField[idx] = prevField[idx];
    }
  }
}

void evalField(int *field, int fieldSize) {
  // Declare grid size and block size
  const int BLOCK_SIZE = 512;
  const int GRID_SIZE = fieldSize * fieldSize / THREAD_SIZE + 1;

  // Declare GPU memory pointers
  size_t BYTES = fieldSize * fieldSize * sizeof(int);
  int *d_in, *d_out;

  // Allocate GPU memory
  gpuErrchk(cudaMalloc((void**) &d_in, BYTES));
  gpuErrchk(cudaMalloc((void**) &d_out, BYTES));

  // Transfer the array to the GPU
  gpuErrchk(cudaMemcpy(d_in, field, BYTES, cudaMemcpyHostToDevice));

  evalCell<<<GRID_SIZE, BLOCK_SIZE>>>(d_in, d_out, fieldSize);

  gpuErrchk( cudaPeekAtLastError() );
  gpuErrchk(cudaMemcpy(field, d_out, BYTES, cudaMemcpyDeviceToHost));

  cudaFree(d_in);
  cudaFree(d_out);
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
            field[i*TEMPLATE_SIZE*fieldSize + y*fieldSize + j*TEMPLATE_SIZE+ x] = 1;
          }
        }
    }
    fin.close();
  }
}

int main() {
  int iter = 1000;
  int n;
  n = 512;
  
  int *field;
  field = (int*) malloc(sizeof(int) * n*n);
  
  initField(field, n);

  ofstream fout;
  fout.open("output-cuda.txt", ofstream::out | ofstream::trunc);

  auto start = chrono::steady_clock::now();

  for (int i = 0; i < iter; i++) {
	evalField(field, n);

    //output the field to file
    for (int i = 0; i < n; i++) {
     for (int j = 0; j < n; j++) {
        if (field[i*n + j] == 0) {
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
  cout << "CUDA:" << endl;
  cout << "Field size: " << n << endl;
  cout << "Iteration: " << iter << endl;
  cout << "Time: " << chrono::duration <double, milli> (diff).count() / 1000 << " seconds" << endl;

  fout.close();
	
  free(field);
	
  return 0;
}
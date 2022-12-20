# CUDA_GameOfLife
Conway's Game of Life implementation with CUDA

## Team
| NIM            | Name                         |
| -------------- | -----------------------------|
| | |
| 24060120130059 | Liem, Roy Marcelino          |
| | |
| | |

## Colab Link
https://colab.research.google.com/drive/1FQyVgMeABPgA6Y005ZVVHpBjjBvvZMTJ#scrollTo=otxJgz8OfRsi&uniqifier=1

## Files
serial.cpp: Serial implementation of Conway's Game of Life
output-serial.txt: Output for serial.cpp

cuda.cu: CUDA implementation of Conway's Game of Life
output-cuda.txt: Output for cuda.cu

visualize.py: Visualize output-serial.txt or output-cuda.txt (specify in FILE_NAME constant) with Pygame
generate_field.py: Generate initial pattern to use. Output at field.txt (specify in FILE_NAME constant)
field-gosper.txt: Gosper's Glider Gun pattern. 40x40
field.txt: Default output file for generate_field.py

Note: field.txt and field-gosper.txt are used in serial.cpp and cuda.cu in initField() procedure

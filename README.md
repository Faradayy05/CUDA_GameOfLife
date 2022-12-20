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
serial.cpp: Serial implementation of Conway's Game of Life <br />
output-serial.txt: Output for serial.cpp <br /> <br />

cuda.cu: CUDA implementation of Conway's Game of Life <br />
output-cuda.txt: Output for cuda.cu <br /> <br />

visualize.py: Visualize output-serial.txt or output-cuda.txt (specify in FILE_NAME constant) with Pygame <br />
generate_field.py: Generate initial pattern to use. Output at field.txt (specify in FILE_NAME constant) <br />
field-gosper.txt: Gosper's Glider Gun pattern. 40x40 <br />
field.txt: Default output file for generate_field.py <br /> <br />
 
Note: field.txt and field-gosper.txt are used in serial.cpp and cuda.cu in initField() procedure. Change TEMPLATE_SIZE according to field_size in generate_field.py

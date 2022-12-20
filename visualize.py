import pygame
import time
if __name__ == "__main__":
    BLACK = (0, 0, 0)
    WHITE = (255, 255,  255)
    MAX_SCREEN_SIZE = 800
    FILE_NAME = "output-serial.txt"

    outputs = open(FILE_NAME, "r").read().split()
    field_size = len(outputs[0])
    cell_size = MAX_SCREEN_SIZE / field_size
    delay = 1000 // field_size 
    screen = pygame.display.set_mode((field_size*cell_size, field_size*cell_size))

    frame = 1
    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

        # Background color
        screen.fill(color=BLACK)

        # Fill living and dead cell
        for i in range(field_size*(frame-1), field_size*frame):
            line = outputs[i]
            y = (i - field_size*(frame-1))*cell_size
            for j, cell in enumerate(line):
                x = j*cell_size
                if (cell == '.'):
                    pygame.draw.rect(screen, BLACK, pygame.Rect(x, y, cell_size, cell_size))
                else:
                    pygame.draw.rect(screen, WHITE, pygame.Rect(x, y, cell_size, cell_size))

        # Redisplay
        pygame.display.flip()
        
        # Delay for a while
        pygame.time.wait(delay)

        # Next frame / iter
        frame += 1

        # Break if final frame / iter
        if (frame * field_size > len(outputs)):
            running = False
            break

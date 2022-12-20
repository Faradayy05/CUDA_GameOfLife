import pygame

# Control:
# Ctrl+S: Save current state
# Ctrl+L: Load previous state
# Ctrl+C: Clear field

if __name__ == "__main__":
    BLACK = (0, 0, 0)
    WHITE = (255, 255, 255)
    MAX_SCREEN_SIZE = 800
    FILE_NAME = "field.txt"
    FIELD_SIZE = 40
    
    cell_size = MAX_SCREEN_SIZE / FIELD_SIZE
    screen = pygame.display.set_mode((FIELD_SIZE*cell_size, FIELD_SIZE*cell_size))
    mouse_hold = False
    state = False
    current_field = [[False] * FIELD_SIZE for _ in range(FIELD_SIZE)] 

    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == pygame.MOUSEBUTTONDOWN:
                # Trigger mouse hold
                mouse_hold = True

                # Change state of cell
                mouse_pos = pygame.mouse.get_pos()
                x = int(mouse_pos[0] // cell_size)
                y = int(mouse_pos[1] // cell_size)
                state = not current_field[y][x]
                current_field[y][x] = state
            elif event.type == pygame.KEYDOWN:
                if (event.key == pygame.K_s and pygame.key.get_mods() & pygame.KMOD_CTRL):
                    # Save file
                    output_file = open(FILE_NAME, "w")
                    for i, line in enumerate(current_field):
                        for j, cell in enumerate(line):
                            if (cell == True):
                                output_file.write(f"{j} {i}\n")
                    print("Field saved")
                    output_file.close()
                elif (event.key == pygame.K_l and pygame.key.get_mods() & pygame.KMOD_CTRL):
                    # Load file
                    current_field = [[False] * FIELD_SIZE for _ in range(FIELD_SIZE)]
                    input_file = open(FILE_NAME, "r")
                    line = input_file.readline()
                    while (line):
                        coor = line.split()
                        x = int(coor[0])
                        y = int(coor[1])
                        current_field[y][x] = True
                        line = input_file.readline()
                    print("Field loaded")
                    input_file.close()
                elif (event.key == pygame.K_c and pygame.key.get_mods() & pygame.KMOD_CTRL):
                    # Clear field
                    current_field = [[False] * FIELD_SIZE for _ in range(FIELD_SIZE)]
            elif event.type == pygame.MOUSEBUTTONUP:
                mouse_hold = False

        if (mouse_hold):
            mouse_pos = pygame.mouse.get_pos()
            x = int(mouse_pos[0] // cell_size)
            y = int(mouse_pos[1] // cell_size)
            current_field[y][x] = state

        screen.fill(color=BLACK)
        for i in range(FIELD_SIZE):
            row = current_field[i]
            y = i*cell_size
            for j, cell in enumerate(row):
                x = j*cell_size
                if (cell == False):
                    pygame.draw.rect(screen, WHITE, pygame.Rect(x, y, cell_size-1, cell_size-1))
                else:
                    pygame.draw.rect(screen, BLACK, pygame.Rect(x, y, cell_size-1, cell_size-1))

        pygame.display.flip()

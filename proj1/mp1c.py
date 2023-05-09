from copy import deepcopy

### DONE ###
def is_equal_grids(gridOne, gridTwo):
    result = True
    for i in range(6 + 4):
        for j in range(6):
            result = result and (gridOne[i][j] == gridTwo[i][j])
    return result


# def print_grid(grid):
#     for row in grid:
#         print(''.join(row))

### DONE ###
def freeze_blocks(grid):
    for i in range(6 + 4):
        for j in range(6):
            if grid[i][j] == '#':
                grid[i][j] = 'X'
    return grid


### DONE ###
def get_max_x_of_piece(piece):
    max_x = -1
    for block in piece:
        max_x = max(max_x, block[1])
        # print(block)
        # print(max_x)
    return max_x


def drop_piece_in_grid(grid, piece, yOffset):
    gridCopy = [[grid[i][j] for j in range(6)] for i in range(4 + 6)]
    maxY = 9
    for block in piece:
        gridCopy[block[0]][block[1] + yOffset] = '#'  # put piece in grid
        print(block)
    #  only active blocks are '#'; frozen blocks are 'X'

    # for k in range(len(gridCopy)):
    #     print(gridCopy[k])
    # print()

    while True:
        canStillGoDown = True
        for i in range(4 + 6):
            for j in range(6):
                if gridCopy[i][j] == '#' and (i + 1 == 10 or gridCopy[i + 1][j] == 'X'):
                    canStillGoDown = False
                    break  # terminate inner loop as soon as we find a cell that cannot move down
            if not canStillGoDown:
                break  # terminate outer loop if we can't move any cells down

        if canStillGoDown:
            for i in range(8, -1, -1):  # move cells of piece down, starting from bottom cells
                for j in range(6):
                    if gridCopy[i][j] == '#':  # move cells down one space
                        gridCopy[i + 1][j] = '#'
                        gridCopy[i][j] = '.'
        else:
            break
    
    for i in range(4 + 6):
        for j in range(6):
            if gridCopy[i][j] == '#':
                maxY = min(maxY, i)

    if maxY <= 3:  # piece protrudes from top of 6x6 grid
        return grid, False
    else:
        return freeze_blocks(gridCopy), True


### DONE ###
def convert_piece_to_pairs(pieceGrid):  # get (row,col) coords of piece at top left of grid
    pieceCoords = []
    for i in range(4):
        for j in range(4):
            if pieceGrid[i][j] == '#':
                pieceCoords.append([i, j])
    return pieceCoords


def backtrack(currGrid, chosen, pieces):
    # print(chosen)
    # print_grid(currGrid)
    # print()
    if is_equal_grids(currGrid, final_grid):
        return True
    chosen_copy = chosen[:]
    for i in range(len(chosen)):
        if not chosen[i]:
            max_x_of_piece = get_max_x_of_piece(pieces[i])
            for offset in range(6 - max_x_of_piece):
                nextGrid, success = drop_piece_in_grid(currGrid, pieces[i], offset)
                print(len(nextGrid))
                for k in range(len(nextGrid)):
                    print(nextGrid[k])
                print()
                if success:
                    chosen_copy[i] = True
                    if backtrack(nextGrid, chosen_copy, pieces):
                        return True
                    chosen_copy[i] = False
    return False


# initialize grids to have 4 empty rows
### DONE ###
start_grid = [['.' for _ in range(6)] for _ in range(4)]
final_grid = [['.' for _ in range(6)] for _ in range(4)]

# grids will be 10 rows by 6 columns, so we can put the piece at the top,
# before letting it fall

for _ in range(6): ### DONE ###
    line = input()
    row = [character for character in line]
    for j in range(len(row)):
        if row[j] == '#':
            row[j] = 'X'  # mark frozen blocks as 'X'
    start_grid.append(row)

for _ in range(6): ### DONE ###
    line = input()
    row = [character for character in line]
    for j in range(len(row)):
        if row[j] == '#':
            row[j] = 'X'   # mark frozen blocks as 'X'
    final_grid.append(row)

numPieces = int(input()) ### DONE ###
chosen = [False for _ in range(numPieces)] ### DONE ### # tracks which piece has been used
converted_pieces = [] ### DONE ###
for _ in range(numPieces):### DONE ###
    pieceAscii = []
    for _ in range(4):
        line = input()
        row = [character for character in line]
        pieceAscii.append(row)
    piecePairs = convert_piece_to_pairs(pieceAscii)
    # print(piecePairs)
    converted_pieces.append(piecePairs)


answer = backtrack(start_grid, chosen, converted_pieces)
if answer:
    print('YES')
else:
    print('NO')

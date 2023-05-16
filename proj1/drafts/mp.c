int is_equal_grids(int gridOne[10][6], int gridTwo[10][6]){
    int result = 1;
    for(int i = 0; i < 6 + 4; i++){
        for(int j = 0; j < 6; j++){
            result = result && (gridOne[i][j] == gridTwo[i][j]);
        }
    }
    return result;
}

// void print_grid(char grid[][]){
//     for(int i=0;i<grid.length;i++){
//         for(int j=0;j<grid[i].length;j++){
//             printf("%c",grid[i][j]);
//         }
//         printf("\n");
//     }
// }

void freeze_blocks(char grid[10][6]){
    int i,j;
    for(i=0;i<10;i++){
        for(j=0;j<6;j++){
            if(grid[i][j]=='#'){
                grid[i][j]='X';
            }
        }
    }
}

int get_max_x_of_piece(int piece[][2], int piece_size) {
    int max_x = -1;
    for (int i = 0; i < piece_size; i++) {
        max_x = (max_x > piece[i][1]) ? max_x : piece[i][1];
    }
    return max_x;
}


// drop_piece_in_grid

void convert_piece_to_pairs(char pieceGrid[4][4], int pieceCoords[4][2]) {
  int i, j;
  for (i = 0; i < 4; i++) {
    for (j = 0; j < 4; j++) {
      if (pieceGrid[i][j] == '#') {
        pieceCoords[i][j] = 1;
      }
    }
  }
}

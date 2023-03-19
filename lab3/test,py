def main() :
    matrix = [  [0, 3, float('inf'), 5],
                [2, 0, float('inf'), 4],
                [float('inf'), 1, 0, float('inf')],
                [float('inf'), float('inf'), 2, 0]]

    for k in range(0, 4):
        for i in range(0, 4):
            for j in range(0, 4):
                matrix[i][j] = min(matrix[i][j], matrix[i][k] + matrix[k][j])

    for row in matrix:
        for data in row:
            print(f" {data} ", end="")
        print("\n")


if __name__ == "__main__":
    main()
    print(float('inf') + 8)
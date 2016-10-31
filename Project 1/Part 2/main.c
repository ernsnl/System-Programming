#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define clear() printf("\033[H\033[J")

int** NextGen(int**,int,int,int**,unsigned long long int);
int convertToInt(char* number);
unsigned long long int convertBinaryToUInteger(char* binary);
int convertToInt(char* number);
char* removeWhiteSpace(char* initial);

int main(int argc, char const *argv[]){
        if(argc < 3) {
                printf("%s\n", "Number of arguments are less than desired");
                return 0;
        }
        FILE *fp;
        char buff[256];
        char *rule;
        unsigned long long int rule_number;
        char **temp_matrix;
        int rows, columns;
        fp = fopen(argv[1], "r+");
        if(fp) {
                // Getting the Matrix
                size_t line = 0;
                size_t row_iter = 0;
                while(fgets(buff, sizeof(buff), fp)) {
                        if (line == 0) {
                                char *tokens;
                                tokens = strtok(buff, " ");
                                int matrix_pos[2];
                                size_t iter = 0;
                                while (tokens) {
                                        matrix_pos[iter] = convertToInt(removeWhiteSpace(tokens));
                                        iter++;
                                        tokens = strtok(NULL, "");
                                }
                                iter = 0;
                                rows = matrix_pos[0];
                                //printf("Rows: %d\n", rows);
                                columns = matrix_pos[1];
                                //printf("Columns: %d\n", columns);
                                temp_matrix = (char**) malloc(sizeof(char*) * rows);
                                for (; iter < rows; iter++) {
                                        temp_matrix[iter] = (char *) malloc(sizeof(char) * columns);
                                }
                                free(tokens);
                        } else {
                                char *temp;
                                temp = removeWhiteSpace(buff);
                                size_t iter = 0;
                                for(; iter < columns; iter++) {
                                        temp_matrix[row_iter][iter] = temp[iter];
                                }
                                row_iter++;
                                free(temp);
                        }
                        line++;
                }
                int k = 0, l = 0;

                fclose(fp);
                fp = fopen(argv[2], "r+");
                if (fp) {
                        while(fgets(buff, sizeof(buff), fp)) {
                                rule = removeWhiteSpace(buff);
                                rule_number = convertBinaryToUInteger(rule);
                                //printf("Rule: %llu \n --- \n", rule_number);
                        }
                }
                else{
                    printf("Rule file not found\n");
                    return -1;
                }
                fclose(fp);

        }
        else{
          printf("Input file not found\n");
          return -1;
        }


        int **matrix,**newMatrix;
        matrix=malloc(sizeof(int*)*rows);
        newMatrix=malloc(sizeof(int*)*rows);

        int i=0;
        for(; i<rows; i++)
        {
                matrix[i]=malloc(sizeof(int)*columns);
                newMatrix[i]=malloc(sizeof(int)*columns);
                int j=0;
                for(; j<columns; j++)
                {
                        matrix[i][j]=temp_matrix[i][j]-'0';
                        newMatrix[i][j]=0;
                }
        }
        i=0;
        for(; i<rows; i++)
        {
                int j=0;
                for(; j<columns; j++)
                {
                        printf("%d \t",matrix[i][j]);
                }
                printf("\n");
        }

        printf("\n");
        printf("\n");
        printf("\n");
        int f=0;

        while(1)
        {
                printf("Generating Next Generation...\n");
                matrix=NextGen(matrix,rows,columns,newMatrix,rule_number);
                i=0;
                clear();
                for(; i<rows; i++)
                {
                        int j=0;
                        for(; j<columns; j++)
                        {
                                printf("%d \t",matrix[i][j]);
                        }
                        printf("\n");
                }

                printf("\n");
                printf("\n");
                sleep(5);


        }

}
unsigned long long int convertBinaryToUInteger(char* binary){
        int return_number = 0;
        int number_len = strlen(binary);
        int i = 0;
        while(binary[i]) {
                return_number = return_number * 2 + (binary[i] - '0');
                i++;
        }
        return return_number;
}
char* removeWhiteSpace(char* initial){
        int i = 0, j = 0;
        char *temp;
        temp = malloc(sizeof(char) * strlen(initial));
        while(initial[i]) {
                if (isspace(initial[i])) {
                        /* Do Nothing */
                }
                else{
                        temp[j] = initial[i];
                        j++;
                }
                i++;
        }
        return temp;
}

int convertToInt(char* number){
        int return_number = 0;
        int number_len = strlen(number);
        int i = 0;
        while(number[i]) {
                return_number = return_number * 10 + (number[i] - '0');
                i++;
        }
        return return_number;
}

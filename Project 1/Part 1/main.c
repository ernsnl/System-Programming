#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Removing Unnecessary WhiteSpace so Job Becomes Easier
char* removeWhiteSpace(char* initial);
int convertToInt(char* number);
int convertBinaryToUInteger(char* binary);
char* convert_int_to_binary(unsigned long long int number, int gen_length);
char* sendToTheASM(char* initial, int rule, int number_of_generation);
// Old One int ASM(int ruleID, int past_gen,int length);
char* ASM(int ruleID, int length, char* temp);

int main(int argc, char const *argv[]) {
        if(argc < 1) {
                printf("%s\n", "Number of arguments are less than desired");
                return 0;
        }
        FILE *fp;
        char buff[256];

        char rule_ID[20];
        int rule;

        char generations[20];
        int gen;

        int gen_length;

        fp = fopen(argv[1], "r+");
        if(fp) {
                int i = 0;
                while(fgets(buff, sizeof(buff), fp)) {
                        //printf("First Generation is: %s \n", buff);

                        if(i != 0) {
                                printf("Please enter the rule: ");
                                scanf("%s", rule_ID);
                                rule =  convertToInt(rule_ID);
                                //printf("%d\n", rule);
                                printf("Please enter the number of generations: ");
                                scanf("%s", generations);
                                gen = convertToInt(generations);
                                //printf("%d\n", gen);
                                printf("Rule: %s, Generation: %s \n", rule_ID, generations);
                                sendToTheASM(buff, rule, gen);
                        }
                        else{
                                gen_length = convertToInt(removeWhiteSpace(buff));
                                printf("Receving a length of %d \n", gen_length);
                        }
                        i++;
                }
                fclose(fp);


        }
        else
                printf("%s\n","File cannot be found");

        return 0;
}

char* sendToTheASM(char* initial, int rule, int number_of_generation){
        int i = 0, j = 0;
        int size_in;
        char *temp;
        temp = removeWhiteSpace(initial);
        size_in = strlen(temp);
        printf("%s", temp);
        printf("\n");
        while(j < number_of_generation) {
                int temp_gen = convertBinaryToUInteger(temp);
                // ASM Function Goes Here
                //unsigned long long int ret_asm = ASM(rule, size_in,temp_gen);
                char* ret_char = ASM (rule, size_in, temp);
                //char* ret_char = convert_int_to_binary(ret_asm,size_in);
                for(; i < size_in; i++) {
                        temp[i] = ret_char[i];
                }
                i = 0;
                printf("%s", ret_char);
                printf("\n");
                j++;
        }
}


char* convert_int_to_binary( unsigned long long int number, int gen_length){
        char* temp;
        temp = malloc(sizeof(char) * gen_length);
        int i = 0;
        for (; i < gen_length; i++) {
                temp[i] = '0';
        }

        int remainder;
        while(number != 0 )
        {
                i--;
                temp[i] = number % 2 + '0';
                number = number / 2;
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
int convertBinaryToUInteger(char* binary){
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

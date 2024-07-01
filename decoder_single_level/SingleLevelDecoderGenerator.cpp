/*
 * Author: Maxwell Phillips
 * Acknowledgement: Nathan Hagerdorn, for the original version of the multiplier component generator used in 2LMR (ref. [2] in MLD paper).
 * Copyright: Ohio Northern University, 2024.
 * License: GPL v3
 * Usage: Change the size parameter n below to the desired output width of the decoder. Build and run the program.
 */ 

#include <cmath>
#include <fstream>
#include <iostream>
#include <string>
#include <bitset>
#include <vector>

#define FILE_ENDING "_sld.vhd"

// Prototypes
void genDecoder();
void printLibraries(std::ofstream &output);
std::string intToBinaryString(int i);
void printParametersToTerminal();
void printBitVectorToTerminal(std::vector<bool> bv);
void increment(std::vector<bool> &bv);
void decrement(std::vector<bool> &bv);
bool isEmpty(std::vector<bool> bv);


// Size Parameters

/* 
Output Length n
Must be a power of 2
*/
const int n = 512;

/*
Base 2 Logarithm of output length n, i.e., input length
*/
const int log2n = log2(n);

void printParametersToTerminal() {
  std::cout << "Parameters: \n" 
            << "n = ...... " << n << std::endl
            << "log_2(n) = " << log2n << std::endl;
}

void printBitVectorToTerminal(std::vector<bool> bv) {
  std::cout << "[ ";
  for (int i = bv.size() - 1; i >= 0; i--) {
    std::cout << bv[i] << " ";
  }
  std::cout << "]\n";
}

// Print libraries common to all files
void printLibraries(std::ofstream &output) {
  output
  << "library IEEE;\n"
  << "use IEEE.std_logic_1164.all;\n"
  << "use IEEE.numeric_std.all;\n"
  << "use IEEE.std_logic_unsigned.all;\n\n";
}

int main(void) {
  genDecoder();
  return 0;
}

void genDecoder() {
  std::ofstream output;
  std::string entityName = "decoder_" + std::to_string(n);
	std::string filename = entityName + FILE_ENDING;
  std::cout << "Creating " << filename << std::endl;
	output.open(filename);

  printLibraries(output);

  //
  // Entity
  //

  // Begin Entity
  output << "entity " << entityName << " is" << std::endl;

  // Generics
  output
  << "generic(\n"
  << "  g_n:      integer := " << n << ";  -- Output length is n\n"
  << "  g_log2n:  integer := " << log2n << "   -- Base 2 Logarithm of output length n; i.e., input length\n"
  << ");\n";

  output
  << "port(\n"
  << "  input: in std_logic_vector(g_log2n - 1 downto 0); -- value to decode\n"
  << "  output: out std_logic_vector(g_n - 1 downto 0) -- decoded result\n"
  << ");\n";

  // End Entity
  output << "end " << entityName << ";\n\n";

  //
  // Architecture
  //

  output << "architecture behavioral of " << entityName << " is\n\n";

  output << "begin\n";
  output << "-- Decoding corresponds to binary representation of given portions of shift\n\n";

  int upper_range = log2n - 1;
  int lower_range = 0;

    // create full bit vector which can hold n - 1
  std::vector<bool> bv(log2(n), 1); 
  
  // generate n:log2(n) decoder
  for (int i = n - 1; i >= 0; i--) {
    // add padding if necessary
    std::string padding = "";
    int digit_diff = (floor(log10(n - 1)) + 1) - (floor(log10(i)) + 1);
    if (digit_diff > 0) 
      for (int k = 0; k < digit_diff; k++)
        padding += " ";
    if (i == 0) padding += " ";

    output << "output" << "(" << i << ")" << padding << " <= ";
    // convert binary representation of 'i' to decoder row
    for (int j = upper_range; j >= lower_range; j--) {
      if (bv[j - lower_range] == 0) output << "not ";
      output << "input(" << j << ")";
      if (j > lower_range) output << " and ";
      else output << ";\n";
    }
    decrement(bv);
    // printBitVectorToTerminal(bv);
  }

  output << "\n\n";

  // End Component Logic
  output << "end;";
  output.close();
  std::cout << "Created " << filename << std::endl;
}

bool isEmpty(std::vector<bool> bv) {
  for (int i = 0; i < bv.size(); i++) {
    if (bv[i] == 1) return false;
  }
  return true;
}

void increment(std::vector<bool> &bv) {
    // add 1 to each value, and if it was 1 already, carry the 1 to the next.
  for (int i = 0; i < bv.size(); i++) {
    if (bv[i] == 0) { // there will be no carry
      bv[i] = 1;
      break;
    }
    bv[i] = 0; // this entry was 1; set to zero and carry the 1
  }
}

void decrement(std::vector<bool> &bv) {
  if (isEmpty(bv)) { // if empty, bv value == 0, so don't decrement
    return;
  } else if (bv[0] == 1) { // subtract 1 if possible...
    bv[0] = 0;
  } else { // otherwise borrow
    for (int i = 1; i < bv.size(); i++) {
      if (bv[i] == 1) {
        bv[i] = 0;
        while (i > 0) {
          i--;
          bv[i] = 1;
        }
        break;
      }
    }
  }
}

std::string intToBinaryString(int i) {
  int size = floor(log2(i)) + 1;
  // std::cout << "size = " << size << std::endl;
  char str[size + 1];
  for (int j = 0; j < size; j++) {
    str[j] = '0';
  }
  int j; // value to subtract from i
  while (i > 0) {
    j = floor(log2(i));
    // std::cout << "j is " << j << ", i is " << i << std::endl;
    i -= pow(2, j);
    // std::cout << "i is now " << i << std::endl;
    str[size - j - 1] = '1';
    // std::cout << "str = ";
    // for (int k = 0; k < size; k++) {
      // std::cout << str[k];
    // }
    // std::cout << std::endl;
  }
  str[size] = '\0';
  std::string s(str);
  // std::cout << "Final Result: " << s << std::endl;
  return s;
}
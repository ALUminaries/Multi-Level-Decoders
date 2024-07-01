# Multi-Level-Decoder
This repository contains source code for a VHDL implementation of the multi-level decoders described in the paper "A Generalized Multi-Level Structure for
High-Precision Binary Decoders."

### Files
The files in this repository are organized as follows:

- `/data/` contains the numerical results from our complexity (FPGA/ASIC) and critical path (ASIC) analyses described in the paper.
  - You can view the FPGA complexity and ASIC critical path results as a Google spreadsheet [here](https://docs.google.com/spreadsheets/d/1_iUDO7c7XtIs3deEhkv4fIAmkZvYwqlGhxpSMQIz-KM/edit?usp=sharing) (or from results-link.txt).
    - These results are also formatted as a series of PDFs (`./results-pdf-x#.pdf`) where `x` may be `c` for complexity or `d` for delay/critical path. 
  - `./transistor-level.png` shows the compiled ASIC complexity results from our Desmos calculator [here](https://www.desmos.com/calculator/jizpovsmee).
    - See `./transistor-level-color-key.txt` for details on the categorization in the image.
- The remainder of the relevant source files are organized as follows:
  - `/decoder_multi_level/` contains the VHDL descriptions of the multi-level decoders. In particular, `./mld_v1.vhd` is essentially an all-in-one description capable of generating a composed or cascaded multi-level decoder of any number of levels (including two-level and single-level).
    - However, `./mld_v1_top.vhd` is necessary as a wrapper if working in Vivado since it will flag "illegal recursive instantiation" if a top-level file instantiates itself.
    - All files in this directory require usage of the VHDL-2008 standard.
  - `/decoder_two_level/` contains the VHDL descriptions of the original two-level decoders used in [2LMR](https://github.com/ALUminaries/Two-Level-Multiplier), along with a customized version of the script used to generate the components for that paper, which only generates the 2LDs.
  - `/decoder_single_level/` contains the relevant code for all types of single-level decoders tested.
    - For gate-level SLDs, the generation script `./SingleLevelDecoderGenerator.cpp` will generate VHDL descriptions of a single level decoder with a specified output width.
      - Simply compile this with your preferred C++ compiler and run.
    - `./sld_v1.vhd` and `./sld_alt_v1.vhd` are the VHDL descriptions of the function-based and loop-based SLD types described in Section IV of this paper, respectively.
    - `./sld_en_v1.vhd`, the SLD with enable input, is provided both here and in `/tree` for usage with tree decoders.
  - `/decoder_tree/` contains all code relevant to tree decoders.
    - `./tree_calc.kt` is the Kotlin script provided in the paper for determining ASIC/transistor-level tree decoder complexity. It is capable of generating CSV-type output for easy data analysis.
    - `./tree_dec_v3.vhd` is the primary VHDL description for the tree decoders. It depends on `./sld_en_v1.vhd` which is also in this folder.
      - Like the MLD, `./tree_dec_v3_top.vhd` is required as a wrapper for `./tree_dec_v3.vhd`.
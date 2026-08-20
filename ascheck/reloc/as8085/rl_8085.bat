as8085 -loxff rl_8085
as8085 -lox xtrnab
aslink -nmxu -a RELOC=0x1000 rl_8085 xtrnab


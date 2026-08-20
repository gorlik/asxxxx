ascheck -loxbbff reloc
ascheck -lox xtrnab
aslink -nmxu -a RELOC=0x1000 reloc xtrnab


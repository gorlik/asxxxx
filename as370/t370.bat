as370 -ploxff t370
aslink -nmux -g xa=0x00 t370
asxscn t370.rst
as370 -ploxff -o+t370x -i ".define XTRNL" t370
aslink -nmux -g xa=0x00 t370x
asxscn t370x.rst

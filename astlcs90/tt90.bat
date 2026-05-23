astlcs90 -lffpo tt90
asxscn -i tt90.lst
aslink -nf tt90_l.lnk
asxscn -i tt90.rst
astlcs90 -lffpo -i ".list" -i "EXTERNAL=1" tt90
astlcs90 -lffpo tt90dp
aslink -nf tt90_e.lnk
asxscn -i tt90.rst

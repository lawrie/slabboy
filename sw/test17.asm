SECTION "ROM0", ROM0

and $0
jp  nz, test
jp  z, test
jp test
halt

test:
halt


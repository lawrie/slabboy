SECTION "ROM0", ROM0

call test
halt

test:
and $0
ret nz
ret z
ret
halt


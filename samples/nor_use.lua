#!/usr/bin/env luma

require_for_syntax[[nor]]

a, b, c, d = false, true, false, true

print(nor[[a == b, b == a and c == d, c]])
print(nor[[a, b, c, d]])


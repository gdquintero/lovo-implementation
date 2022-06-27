set yrange [-1.2:1.2]
set key noautotitle
unset xtics
unset ytics
# set terminal epslatex color solid 8 size 27cm, 20cm
# set border 15 back lw 4

plot \
"scenarios.txt" u 1:2 with lines lw 2,\
"scenarios.txt" u 1:3 with lines lw 2,\
"scenarios.txt" u 1:4 with lines lw 2,\
"scenarios.txt" u 1:5 with lines lw 2,\
"scenarios.txt" u 1:6 with lines lw 2,\
"ordervalues.txt" u 1:2 with lines lc "black" lw 4;


# plot \
# "scenarios.txt" u 1:2 with lines lw 2,\
# "scenarios.txt" u 1:3 with lines lw 2,\
# "scenarios.txt" u 1:4 with lines lw 2,\
# "scenarios.txt" u 1:5 with lines lw 2,\
# "scenarios.txt" u 1:6 with lines lw 2,\
# "ordervalues.txt" u 1:3 with lines lc "black" lw 4,\

# pause -1

# plot \
# "scenarios.txt" u 1:2 with lines lw 2,\
# "scenarios.txt" u 1:3 with lines lw 2,\
# "scenarios.txt" u 1:4 with lines lw 2,\
# "scenarios.txt" u 1:5 with lines lw 2,\
# "scenarios.txt" u 1:6 with lines lw 2,\
# "ordervalues.txt" u 1:4 with lines lc "black" lw 4,\

# pause -1

# plot \
# "scenarios.txt" u 1:2 with lines lw 2,\
# "scenarios.txt" u 1:3 with lines lw 2,\
# "scenarios.txt" u 1:4 with lines lw 2,\
# "scenarios.txt" u 1:5 with lines lw 2,\
# "scenarios.txt" u 1:6 with lines lw 2,\
# "ordervalues.txt" u 1:5 with lines lc "black" lw 4,\

# pause -1

# plot \
# "scenarios.txt" u 1:2 with lines lw 2,\
# "scenarios.txt" u 1:3 with lines lw 2,\
# "scenarios.txt" u 1:4 with lines lw 2,\
# "scenarios.txt" u 1:5 with lines lw 2,\
# "scenarios.txt" u 1:6 with lines lw 2,\
# "ordervalues.txt" u 1:6 with lines lc "black" lw 4,\

# pause -1


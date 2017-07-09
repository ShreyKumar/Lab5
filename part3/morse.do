# Set the working dir, where all compiled Verilog goes.

vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)


vlog -timescale 1ns/1ns morse.v

# Load simulation using mux as the top level simulation module.
vsim morse

# Log all signals and add some signals to waveform window.
log {/*}

# add wave {/*}would add all items in top level simulation module.
add wave {/*}

# reset, set initial values
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 1

force {KEY[0]} 0
force {KEY[1]} 0
run 1ns

# cycle clock
force {CLOCK_50} 0
run 1ns
force {CLOCK_50} 1
run 1ns

# reset
force {KEY[0]} 1
run 1ns

force {CLOCK_50} 0
run 1ns
force {CLOCK_50} 1
run 1ns

# turn off reset
force {KEY[0]} 0
run 1ns

force {CLOCK_50} 0
run 1ns
force {CLOCK_50} 1
run 1ns

# load
force {KEY[1]} 1
run 1ns

force {CLOCK_50} 0
run 1ns
force {CLOCK_50} 1
run 1ns

# turn off load
force {KEY[1]} 0
run 1ns


# just run
force {CLOCK_50} 0 0, 1 1 -repeat 2
run 100ns

force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0

# load
force {KEY[1]} 1
run 1ns


# turn off load
force {KEY[1]} 0


force {CLOCK_50} 0 0, 1 1 -repeat 2
run 100ns




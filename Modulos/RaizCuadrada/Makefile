TARGET = RaizCuadrada
TOP = RaizCuadrada

OBJS+=RaizCuadrada.v
OBJS+=contador/contador.v
OBJS+=fsm/fsm.v
OBJS+=comparador/comparador.v
OBJS+=RegistroAext2/RegistroAext2.v
OBJS+=RegistroC/RegistroC.v
OBJS+=SumadorRestador17_C2/SumadorRestador17_C2.v
PER_OBJS = perip_mult.v $(OBJS)

BUILD_DIR = build

all: sim

sim:
	rm -f a.out *.vcd
	iverilog -DBENCH -DSIM -DPASSTHROUGH_PLL -DBOARD_FREQ=27 -DCPU_FREQ=27  $(TARGET)_TB.v $(OBJS)
	vvp a.out
	gtkwave Raiz_Top_TB.vcd

sim_per:
	rm -f a.out *.vcd
	iverilog -DBENCH -DSIM -DPASSTHROUGH_PLL -DBOARD_FREQ=27 -DCPU_FREQ=27  perip_$(TARGET)_TB.v $(PER_OBJS)
	vvp a.out
	gtkwave perip_$(TARGET)_TB.vcd


svg: $(OBJS)
	yosys -p "prep -top ${TARGET}; write_json ${TARGET}.json" ${OBJS}
	netlistsvg ${TARGET}.json -o ${TARGET}.svg  #--skin default.svg
	yosys -p "prep -top ${TARGET} -flatten; write_json ${TARGET}_flat.json" ${OBJS}
	netlistsvg ${TARGET}_flat.json -o ${TARGET}_flat.svg  #--skin default.svg

clean:
	rm -rf *.out *.vcd *.svg *.json

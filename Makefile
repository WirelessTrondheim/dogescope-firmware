CC:=${HOME}/.arduino15/packages/Digilent/tools/xc32-tools/xc32-1.43/bin/xc32-gcc
CXX:=${HOME}/.arduino15/packages/Digilent/tools/xc32-tools/xc32-1.43/bin/xc32-g++
AR:=${HOME}/.arduino15/packages/Digilent/tools/xc32-tools/xc32-1.43/bin/xc32-ar
OBJCPY:=${HOME}/.arduino15/packages/Digilent/tools/xc32-tools/xc32-1.43/bin/xc32-objcopy
BIN2HEX:=${HOME}/.arduino15/packages/Digilent/tools/xc32-tools/xc32-1.43/bin/xc32-bin2hex

CFLAGS:=-g -O0 -w -mno-smart-io -ffunction-sections -fdata-sections -mdebugger\
        -Wcast-align -fno-short-double -ftoplevel-reorder -MMD  -mnewlib-libc\
        -mprocessor=32MZ2048EFG124 -DF_CPU=200000000UL  -DARDUINO=10609\
        -D_BOARD_OPENSCOPE_ -DMPIDEVER=16777998 -DMPIDE=150 -DIDE=Arduino\
         -I.\
        -I${HOME}/.arduino15/packages/Digilent/hardware/pic32/1.0.3/cores/pic32\
        -I${HOME}/.arduino15/packages/Digilent/hardware/pic32/1.0.3/variants/OpenScope

CXXFLAGS:=-g -O0 -w -mno-smart-io -fno-exceptions -ffunction-sections -fdata-sections\
          -mdebugger -Wcast-align -fno-short-double -ftoplevel-reorder -MMD\
          -mnewlib-libc -std=gnu++11 -mprocessor=32MZ2048EFG124 -DF_CPU=200000000UL\
          -DARDUINO=10609 -D_BOARD_OPENSCOPE_ -DMPIDEVER=16777998 -DMPIDE=150 -DIDE=Arduino\
          -I.\
          -I${HOME}/.arduino15/packages/Digilent/hardware/pic32/1.0.3/cores/pic32\
          -I${HOME}/.arduino15/packages/Digilent/hardware/pic32/1.0.3/variants/OpenScope

CXXARFLAGS:=-g1 -O0 -Wa,--gdwarf-2 -mprocessor=32MZ2048EFG124 -DF_CPU=200000000UL\
            -DARDUINO=10609 -D_BOARD_OPENSCOPE_ -DMPIDEVER=16777998 -DMPIDE=150 -DIDE=Arduino\
            -I.\
            -I${HOME}/.arduino15/packages/Digilent/hardware/pic32/1.0.3/cores/pic32\
            -I${HOME}/.arduino15/packages/Digilent/hardware/pic32/1.0.3/variants/OpenScope

OBJFILES_:= AWG.c.o AnalogIn.c.o DCInstruments.c.o FeedBack.c.o LA.c.o\
           OSMath.c.o TimeOutTmr9.c.o Trigger.c.o Version.c.o\
					 System.c.o ccsbcs.c.o fs_ff.c.o flash.c.o\
           Config.cpp.o GlobalData.cpp.o\
           Helper.cpp.o IO.cpp.o Initialize.cpp.o LEDs.cpp.o LexJSON.cpp.o\
           LoopStats.cpp.o MfgTest.cpp.o OSSerial.cpp.o OpenScope.cpp.o\
           ParseOpenScope.cpp.o ProcessJSONCmd.cpp.o main.cpp.o\
           DFATFS.cpp.o fs_diskio.cpp.o\
           DMASerial.cpp.o DSDVOL.cpp.o DSPI.cpp.o FLASHVOL.cpp.o\
           HTMLDefaultPage.cpp.o HTMLOptions.cpp.o HTMLPostCmd.cpp.o\
           HTMLReboot.cpp.o HTMLSDPage.cpp.o HTTPHelpers.cpp.o\
           Board_Data.c.o EFADC.c.o

OBJFILES:= $(addprefix build/,${OBJFILES_})

DEPOBJFILES:=$(OBJFILES:.o=.d)

COREOBJFILES_:= cpp-startup.S.o crti.S.o crtn.S.o pic32_software_reset.S.o\
                vector_table.S.o HardwareSerial_cdcacm.c.o\
                HardwareSerial_usb.c.o WInterrupts.c.o WSystem.c.o\
                exceptions.c.o pins_arduino.c.o task_manager.c.o\
                wiring.c.o wiring_analog.c.o wiring_digital.c.o\
                wiring_pulse.c.o wiring_shift.c.o HardwareSerial.cpp.o\
                IPAddress.cpp.o Print.cpp.o Stream.cpp.o Tone.cpp.o\
                WMath.cpp.o WString.cpp.o doprnt.cpp.o main.cpp.o

COREOBJFILES:= $(addprefix build/core/,${COREOBJFILES_})

DEPCOREOBJFILES:=$(OBJFILES:.o=.d) $(COREOBJFILES:.o=.d)

all: OpenScope.ino.hex


clean:
	${RM} ${COREOBJFILES} ${OBJFILES} ${DEPFILES} build/core/core.a OpenScope.ino.elf OpenScope.ino.eep OpenScope.ino.hex


OpenScope.cpp: OpenScope.ino
	echo "#include <Arduino.h>" > $@
	echo "#line 1 \"$(PWD)/$<\"" >> $@
	echo "#line 1 \"$(PWD)/$<\"" >> $@
	cat $< >> $@


build/core/core.a: ${COREOBJFILES}
	${RM} $@
	$(foreach COREOBJFILE, $^, ${AR} rcs $@ $(COREOBJFILE);)


OpenScope.ino.elf: ${OBJFILES} build/core/core.a
	$(CXX) -w -Wl,--save-gld=sketch.ld,-Map=sketch.map,--gc-sections\
        -mdebugger -mno-peripheral-libs -nostartfiles -mnewlib-libc\
        -mprocessor=32MZ2048EFG124 -o $@\
        ${HOME}/.arduino15/packages/Digilent/hardware/pic32/1.0.3/cores/pic32/cpp-startup.S ${OBJFILES} build/core/core.a -L.\
        -T ${HOME}/.arduino15/packages/Digilent/hardware/pic32/1.0.3/variants/OpenScope/OpenScope.ld\
        -T ${HOME}/.arduino15/packages/Digilent/hardware/pic32/1.0.3/cores/pic32/chipKIT-application-COMMON-MZ.ld


OpenScope.ino.eep: OpenScope.ino.elf
	${OBJCPY} -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load\
        --no-change-warnings --change-section-lma .eeprom=0  $< $@


OpenScope.ino.hex: OpenScope.ino.elf
	${BIN2HEX} -a  $<

build/core/%.S.o: ${HOME}/.arduino15/packages/Digilent/hardware/pic32/1.0.3/cores/pic32/%.S
	$(CXX) $(CXXARFLAGS) -c $< -o $@

build/core/%.c.o: ${HOME}/.arduino15/packages/Digilent/hardware/pic32/1.0.3/cores/pic32/%.c
	$(CC) $(CFLAGS) -c $< -o $@

build/core/%.cpp.o: ${HOME}/.arduino15/packages/Digilent/hardware/pic32/1.0.3/cores/pic32/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/core/%.c.o: ${HOME}/.arduino15/packages/Digilent/hardware/pic32/1.0.3/variants/OpenScope/%.c
	$(CC) $(CFLAGS) -c $< -o $@

build/%.c.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

build/%.cpp.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.cpp.o: libraries/DEWFcK/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.cpp.o: libraries/DFATFS/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.cpp.o: libraries/DMASerial/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.cpp.o: libraries/MRF24G/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.cpp.o: libraries/HTTPServer/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.cpp.o: libraries/FLASHVOL/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.cpp.o: libraries/DSPI/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.cpp.o: libraries/DSDVOL/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.c.o: libraries/MRF24G/%.c
	$(CC) $(CFLAGS) -c $< -o $@

build/%.c.o: libraries/FLASHVOL/%.c
	$(CC) $(CFLAGS) -c $< -o $@

build/%.cpp.o: libraries/DEIPcK/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.cpp.o: libraries/MRF24G/utility/%.c
	$(CC) $(CFLAGS) -c $< -o $@

build/%.c.o: libraries/DFATFS/utility/%.c
	$(CC) $(CFLAGS) -c $< -o $@

build/%.c.o: libraries/DEIPcK/utility/%.c
	$(CC) $(CFLAGS) -c $< -o $@

build/%.c.o: ${HOME}/.arduino15/packages/Digilent/hardware/pic32/1.0.3/variants/OpenScope/%.c
	$(CC) $(CFLAGS) -c $< -o $@

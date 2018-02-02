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
           OSMath.c.o TimeOutTmr9.c.o Trigger.c.o Version.c.o DHCP.c.o\
           DNS.c.o HeapMgr.c.o ICMP.c.o IPStack.c.o InternetLayer.c.o\
           LinkLayer.c.o SNTPv4.c.o System.c.o TCP.c.o TCPRFC793.c.o\
           TCPStateMachine.c.o UDP.c.o ccsbcs.c.o fs_ff.c.o flash.c.o\
           MRF24GAdaptor.c.o wf_connection_algorithm.cpp.o\
           wf_connection_profile.cpp.o wf_data_msg.cpp.o\
           wf_eint.cpp.o wf_eint_stub.cpp.o wf_event_queue.cpp.o\
           wf_event_stub.cpp.o wf_gpio_stub.cpp.o wf_init.cpp.o\
           wf_mgmt_msg.cpp.o wf_param_msg.cpp.o wf_pbkdf2.cpp.o\
           wf_pll.cpp.o wf_power.cpp.o wf_raw.cpp.o wf_registers.cpp.o\
           wf_scan.cpp.o wf_spi_stub.cpp.o wf_task.cpp.o wf_timer.cpp.o\
           wf_timer_stub.cpp.o wf_ud_state.cpp.o Config.cpp.o GlobalData.cpp.o\
           Helper.cpp.o IO.cpp.o Initialize.cpp.o LEDs.cpp.o LexJSON.cpp.o\
           LoopStats.cpp.o MfgTest.cpp.o OSSerial.cpp.o OpenScope.cpp.o\
           ParseOpenScope.cpp.o ProcessJSONCmd.cpp.o WiFi.cpp.o main.cpp.o\
           DEIPcK.cpp.o TCPServer.cpp.o TCPSocket.cpp.o UDPServer.cpp.o\
           UDPSocket.cpp.o DEWFcK.cpp.o DFATFS.cpp.o fs_diskio.cpp.o\
           DMASerial.cpp.o DSDVOL.cpp.o DSPI.cpp.o FLASHVOL.cpp.o\
           HTMLDefaultPage.cpp.o HTMLOptions.cpp.o HTMLPostCmd.cpp.o\
           HTMLReboot.cpp.o HTMLSDPage.cpp.o HTTPHelpers.cpp.o\
           ProcessClient.cpp.o ProcessServer.cpp.o deOpenScopeWebServer.cpp.o\
           DEMRF24G.cpp.o Board_Data.c.o EFADC.c.o

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
	@mkdir -p $(@D)
	$(CXX) $(CXXARFLAGS) -c $< -o $@

build/core/%.c.o: ${HOME}/.arduino15/packages/Digilent/hardware/pic32/1.0.3/cores/pic32/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

build/core/%.cpp.o: ${HOME}/.arduino15/packages/Digilent/hardware/pic32/1.0.3/cores/pic32/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/core/%.c.o: ${HOME}/.arduino15/packages/Digilent/hardware/pic32/1.0.3/variants/OpenScope/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

build/%.c.o: %.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

build/%.cpp.o: %.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.cpp.o: libraries/DEWFcK/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.cpp.o: libraries/DFATFS/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.cpp.o: libraries/DMASerial/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.cpp.o: libraries/MRF24G/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.cpp.o: libraries/HTTPServer/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.cpp.o: libraries/FLASHVOL/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.cpp.o: libraries/DSPI/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.cpp.o: libraries/DSDVOL/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.c.o: libraries/MRF24G/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

build/%.c.o: libraries/FLASHVOL/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

build/%.cpp.o: libraries/DEIPcK/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.cpp.o: libraries/MRF24G/utility/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

build/%.c.o: libraries/DFATFS/utility/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

build/%.c.o: libraries/DEIPcK/utility/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

build/%.c.o: ${HOME}/.arduino15/packages/Digilent/hardware/pic32/1.0.3/variants/OpenScope/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@


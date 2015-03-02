#
# embedXcode
# ----------------------------------
# Embedded Computing on Xcode
#
# Copyright © Rei VILO, 2010-2015
# http://embedxcode.weebly.com
# All rights reserved
#
#
# Last update: Dec 06, 2014 release 240



# Debug rules
# ----------------------------------
#
# ~
debug: 		make message_debug reset raw_upload serial launch_debug end_debug
# ~~

# ~
launch_debug:

ifneq ($(GDB),)
		@if [ -f $(UTILITIES_PATH)/embedXcode_debug ]; then $(UTILITIES_PATH)/embedXcode_debug; fi;

  ifeq ($(UPLOADER),mspdebug)
    ifeq ($(UPLOADER_PROTOCOL),tilib)
# Debug 1: Launch the server
		@echo "---- Launch server ----"
		$(call SHOW,"11.1-DEBUG",$(UPLOADER))
		$(call TRACE,"11-DEBUG",$(UPLOADER))
		osascript -e 'tell application "Terminal" to do script "cd $(UPLOADER_PATH); ./mspdebug $(UPLOADER_PROTOCOL) gdb"'

    else
		@echo "---- Launch server ----"
		$(call SHOW,"11.2-DEBUG",$(UPLOADER))
		$(call TRACE,"11-DEBUG",$(UPLOADER))
		@osascript -e 'tell application "Terminal" to do script "$(UPLOADER_EXEC) $(UPLOADER_PROTOCOL) gdb"'
    endif

# Debug 2: Launch the client
		@echo "---- Launch client ----"
		$(call SHOW,"11.3-DEBUG",$(UPLOADER))
		$(call TRACE,"11-DEBUG",$(UPLOADER))
		@sleep 5
		@osascript -e 'tell application "Terminal" to do script "cd $(CURRENT_DIR_SPACE); $(GDB) -x \"$(UTILITIES_PATH_SPACE)/gdb.txt\""'

# Debug 3: Garbage collector
		@if [ -f libmsp430.so ]; then rm libmsp430.so; fi
		@if [ -f comm.log ]; then rm comm.log; fi

  else ifeq ($(UPLOADER),lm4flash)
# Debug 1: Launch the server
		@echo "---- Launch server ----"
		$(call SHOW,"11.4-DEBUG",$(UPLOADER))
		$(call TRACE,"11-DEBUG",$(UPLOADER))
		-killall openocd
		@osascript -e 'tell application "Terminal" to do script "openocd --file \"$(UTILITIES_PATH_SPACE)/debug_LM4F120XL.cfg\""'

# Debug 2: Launch the client
		@echo "---- Launch client ----"
		$(call SHOW,"11.5-DEBUG",$(UPLOADER))
		$(call TRACE,"11-DEBUG",$(UPLOADER))
		@sleep 5
		@osascript -e 'tell application "Terminal" to do script "cd $(CURRENT_DIR_SPACE); $(GDB) -x \"$(UTILITIES_PATH_SPACE)/gdb.txt\""'

  else ifeq ($(UPLOADER),cc3200serial)
# Debug 1: Launch the server
		@echo "---- Launch server ----"
		$(call SHOW,"11.6-DEBUG",$(UPLOADER))
		$(call TRACE,"11-DEBUG",$(UPLOADER))
		-killall openocd
		@osascript -e 'tell application "Terminal" to do script "openocd --file \"$(UTILITIES_PATH_SPACE)/debug_CC3200.cfg\""'

# Debug 2: Launch the client
		@echo "---- Launch client ----"
		$(call SHOW,"11.7-DEBUG",$(UPLOADER))
		$(call TRACE,"11-DEBUG",$(UPLOADER))
		@sleep 5
		@osascript -e 'tell application "Terminal" to do script "cd $(CURRENT_DIR_SPACE); $(GDB) -x \"$(UTILITIES_PATH_SPACE)/gdb.txt\""'

  else ifeq ($(PLATFORM),mbed)
# Debug 1: Launch the server
    ifeq ($(DEBUG_SERVER),stlink)
		@echo "---- Launch server ----"
		$(call SHOW,"11.8-DEBUG",$(UPLOADER))
		-killall st-util
		$(call TRACE,"11-DEBUG",$(UPLOADER))
		@osascript -e 'tell application "Terminal" to do script "st-util -p 3333"'
    else
		@echo "---- Launch server ----"
		$(call SHOW,"11.9-DEBUG",$(UPLOADER))
		-killall openocd
		$(call TRACE,"11-DEBUG",$(UPLOADER))
		@osascript -e 'tell application "Terminal" to do script "openocd --file \"$(UTILITIES_PATH_SPACE)/debug_$(BOARD_TAG).cfg\""'
    endif
# Debug 2: Launch the client
		@echo "---- Launch client ----"
		$(call SHOW,"11.10-DEBUG",$(UPLOADER))
		$(call TRACE,"11-DEBUG",$(UPLOADER))
		-killall $(GDB)
		@sleep 5
		@osascript -e 'tell application "Terminal" to do script "cd $(CURRENT_DIR_SPACE); $(GDB) -x \"$(UTILITIES_PATH_SPACE)/gdb.txt\""'

  else
		@echo "Board not supported"
  endif

else ifneq ($(MDB),)
		@if [ -f $(UTILITIES_PATH)/embedXcode_debug ]; then $(UTILITIES_PATH)/embedXcode_debug; fi;

		@echo "---- Launch programmer-debugger ----"
		$(call SHOW,"11.10-DEBUG",$(UPLOADER))
		$(call TRACE,"11-DEBUG",$(UPLOADER))
		@osascript -e 'tell application "Terminal" to do script "$(MDB) \"$(UTILITIES_PATH_SPACE)/mdb.txt\""'

endif

message_debug:
		@echo "==== Debug ===="

end_debug:
		@echo "==== Debug done ==== "
# ~~


.PHONY:	debug launch_debug message_debug end_debug


include Makefile.config

APP_LIB_DIR = lib
APP_LIBS = \
  $(APP_LIB_DIR)/config.sld \
  $(APP_LIB_DIR)/database.sld \
  $(APP_LIB_DIR)/dirent.sld \
  $(APP_LIB_DIR)/fcgi.sld \
  $(APP_LIB_DIR)/http.sld \
  $(APP_LIB_DIR)/json.sld \
  $(APP_LIB_DIR)/request.sld \
  $(APP_LIB_DIR)/uri.sld \

APP_LIBS_COBJECTS = $(APP_LIBS:.sld=.o)
APP_LIBS_CFILES = $(APP_LIBS:.sld=.c)

CONTROLLERS=$(wildcard app/controllers/*.sld)
CONTROLLER_OBJS=$(CONTROLLERS:.sld=.o)

MODELS=$(wildcard app/models/*.sld)
MODEL_OBJS=$(MODELS:.sld=.o)

VIEWS=$(wildcard app/views/*)

all: $(APP) $(APP_LIBS_COBJECTS) cloudburst

cloudburst: cloudburst.scm $(APP_LIBS_COBJECTS)
	cyclone cloudburst.scm

$(CONTROLLER_OBJS) : %.o: %.sld
	$(CYCLONE) $<

$(MODEL_OBJS) : %.o: %.sld
	$(CYCLONE) $<

$(APP_LIBS_COBJECTS) : %.o: %.sld
	$(CYCLONE) $<

$(APP): $(APP).scm lib/router.scm $(APP_LIBS_COBJECTS) $(CONTROLLER_OBJS) $(MODEL_OBJS) $(VIEWS)
	$(CYCLONE) -CLNK -lfcgi $(APP).scm

.PHONY: clean test run run-server copy-html
clean:
	git clean -fdx -e config/database.scm

TEST_DIR = tests
TEST_SRC = \
 $(TEST_DIR)/http-test.scm \
 $(TEST_DIR)/json-test.scm \
 $(TEST_DIR)/uri-test.scm \

TESTS = $(basename $(TEST_SRC))

$(TESTS) : %: %.scm
	$(CYCLONE) $< && ./$@

# This one is a bit special so we break it out
tests/router-test: tests/router-test.scm
	$(CYCLONE) -CLNK -lfcgi tests/router-test.scm
	tests/router-test

test: $(APP) $(APP_LIBS_COBJECTS) $(TESTS) $(TEST_OBJS) tests/router-test

copy-html:
	sudo rm -rf $(WEB_DIR)/$(APP_WEB_SUBDIR)
	sudo cp -r html $(WEB_DIR)/$(APP_WEB_SUBDIR)

run: $(APP)
	spawn-fcgi -p 8000 -n $(APP)

# FUTURE? Serve local content via this method:
# https://stackoverflow.com/a/25486871/101258
run-server:
	sudo nginx -c `pwd`/config/nginx.conf -p "`pwd`"

stop-server:
	sudo nginx -s quit

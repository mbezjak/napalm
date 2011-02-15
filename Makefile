prefix=/usr/local

SRC_DIR=$(CURDIR)/src
SRC_SHELL_DIR=$(SRC_DIR)/shell
SRC_PLUGINS_DIR=$(SRC_DIR)/plugins
SRC_TEST_DIR=$(SRC_DIR)/test
LIB_DIR=$(CURDIR)/lib

BUILD_DIR=$(CURDIR)/build
TEST_DIR=$(BUILD_DIR)/test
DIST_DIR=$(BUILD_DIR)/dist

all: test

clean:
	rm -rf $(BUILD_DIR)


test: dist test-prep
	@echo "integration tests..."
	( cd $(TEST_DIR); $(TEST_DIR)/integration_tests.sh )
	@echo "unit tests..."
	( cd $(TEST_DIR); $(TEST_DIR)/unit_test_configure_environment.sh )
	( cd $(TEST_DIR); $(TEST_DIR)/unit_test_utilities.sh )
	( cd $(TEST_DIR); $(TEST_DIR)/unit_test_list_plugins.sh )
	( cd $(TEST_DIR); $(TEST_DIR)/unit_test_show_program.sh )
	( cd $(TEST_DIR); $(TEST_DIR)/unit_test_use_program.sh )
	( cd $(TEST_DIR); $(TEST_DIR)/unit_test_install_program.sh )

test-prep: test-clean
	@mkdir -p $(TEST_DIR)
	cp -p $(LIB_DIR)/shunit2/shunit2 $(TEST_DIR)
	cp -p $(SRC_TEST_DIR)/* $(TEST_DIR)

test-clean:
	rm -rf $(TEST_DIR)


dist: dist-prep

dist-prep: dist-clean
	@mkdir -p $(DIST_DIR)/bin
	@mkdir -p $(DIST_DIR)/plugins

	cp -p $(SRC_SHELL_DIR)/* $(DIST_DIR)/bin
	cp -p $(SRC_PLUGINS_DIR)/* $(DIST_DIR)/plugins

dist-clean:
	rm -rf $(DIST_DIR)


install: uninstall dist
	install -m 0755 -d $(prefix)/lib/napalm/bin
	install -m 0755 -d $(prefix)/lib/napalm/plugins
	install -m 0644 $(DIST_DIR)/bin/libnapalm $(prefix)/lib/napalm/bin
	install -m 0755 $(DIST_DIR)/bin/napalm $(prefix)/lib/napalm/bin
	install -m 0644 $(DIST_DIR)/plugins/* $(prefix)/lib/napalm/plugins
	ln -s $(prefix)/lib/napalm/bin/napalm $(prefix)/bin/napalm

uninstall:
	rm -f $(prefix)/bin/napalm
	rm -rf $(prefix)/lib/napalm

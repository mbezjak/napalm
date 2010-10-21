SRC_DIR=$(PWD)/src
SRC_SHELL_DIR=$(SRC_DIR)/shell
SRC_TEST_DIR=$(SRC_DIR)/test
LIB_DIR=$(PWD)/lib
PLUGINS_DIR=$(PWD)/plugins

BUILD_DIR=$(PWD)/build
TEST_DIR=$(BUILD_DIR)/test
DIST_DIR=$(BUILD_DIR)/dist

all: test

clean:
	rm -rf $(BUILD_DIR)


test: dist test-prep
	@echo "integration tests..."
	( cd $(TEST_DIR); $(TEST_DIR)/integration_tests.sh )
	@echo "unit tests..."
	( cd $(TEST_DIR); $(TEST_DIR)/unit_tests.sh )

test-prep: test-clean
	@mkdir -p $(TEST_DIR)
	cp -p $(LIB_DIR)/shunit2/shunit2 $(TEST_DIR)
	cp -p $(SRC_TEST_DIR)/* $(TEST_DIR)

test-clean:
	rm -rf $(TEST_DIR)


dist: dist-prep

dist-prep: dist-clean
	@mkdir -p $(DIST_DIR)
	@mkdir -p $(DIST_DIR)/bin
	@mkdir -p $(DIST_DIR)/lib
	@mkdir -p $(DIST_DIR)/plugins

	cp -p $(SRC_SHELL_DIR)/napalm $(DIST_DIR)/bin
	cp -p $(SRC_SHELL_DIR)/libnapalm $(DIST_DIR)/lib
#	cp -p $(PLUGINS_DIR)/* $(DIST_DIR)/plugins

dist-clean:
	rm -rf $(DIST_DIR)

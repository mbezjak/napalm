SRC_DIR=$(PWD)/src
SRC_SHELL_DIR=$(SRC_DIR)/shell
SRC_TEST_DIR=$(SRC_DIR)/test
LIB_DIR=$(PWD)/lib

BUILD_DIR=$(PWD)/build
TEST_DIR=$(BUILD_DIR)/test

all: test

clean:
	rm -rf $(BUILD_DIR)

test: test-prep
	( cd $(TEST_DIR); $(TEST_DIR)/integration_test.sh )

test-prep: test-clean
	@mkdir -p $(TEST_DIR)
	cp -p $(SRC_SHELL_DIR)/napalm $(TEST_DIR)
	cp -p $(LIB_DIR)/log4sh/log4sh $(TEST_DIR)
	cp -p $(LIB_DIR)/shunit2/shunit2 $(TEST_DIR)
	cp -p $(SRC_TEST_DIR)/* $(TEST_DIR)

test-clean:
	rm -rf $(TEST_DIR)

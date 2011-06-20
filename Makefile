prefix=/usr/local

TEST_DIR=$(CURDIR)/test

.PHONY: test install uninstall

test:
	@echo "integration tests..."
	( cd $(TEST_DIR); $(TEST_DIR)/integration_tests.sh )
	@echo "unit tests..."
	( cd $(TEST_DIR); $(TEST_DIR)/unit_test_configure_environment.sh )
	( cd $(TEST_DIR); $(TEST_DIR)/unit_test_utilities.sh )
	( cd $(TEST_DIR); $(TEST_DIR)/unit_test_list_plugins.sh )
	( cd $(TEST_DIR); $(TEST_DIR)/unit_test_show_program.sh )
	( cd $(TEST_DIR); $(TEST_DIR)/unit_test_use_program.sh )
	( cd $(TEST_DIR); $(TEST_DIR)/unit_test_install_program.sh )

install: uninstall
	install -m 0755 -d $(prefix)/lib/napalm/bin
	install -m 0755 -d $(prefix)/lib/napalm/plugins
	install -m 0644 $(CURDIR)/bin/libnapalm $(prefix)/lib/napalm/bin
	install -m 0755 $(CURDIR)/bin/napalm $(prefix)/lib/napalm/bin
	install -m 0644 $(CURDIR)/plugins/* $(prefix)/lib/napalm/plugins
	install -m 0644 $(CURDIR)/README.md $(prefix)/lib/napalm
	install -m 0644 $(CURDIR)/Changelog.md $(prefix)/lib/napalm
	install -m 0644 $(CURDIR)/LICENSE $(prefix)/lib/napalm
	ln -s $(prefix)/lib/napalm/bin/napalm $(prefix)/bin/napalm

uninstall:
	rm -f $(prefix)/bin/napalm
	rm -rf $(prefix)/lib/napalm

Napalm release steps:

1. Update `NAPALM_VERSION` in `bin/napalm`
2. Update version in `install/web-based-install.sh`
3. Git work:

        $ git tag --annotate $version
        $ git push
        $ git push --tags

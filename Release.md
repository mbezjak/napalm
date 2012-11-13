Release steps:

1. Add `Changelog.md` entry
2. Update `NAPALM_VERSION` in `bin/napalm`
3. Update version in `install/web-based-install.sh`
4. Update (upgrade) version in `README.md`
5. Git work:

        $ git tag --annotate $version
        $ git push
        $ git push --tags

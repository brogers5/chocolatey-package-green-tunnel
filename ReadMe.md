# <img src="https://cdn.jsdelivr.net/gh/brogers5/chocolatey-package-green-tunnel-gui@67d7a8d1b514780a1fe57127867a8567d1efbaba/green-tunnel-gui.png" width="48" height="48"/> Chocolatey Package: [Green Tunnel (GUI)](https://community.chocolatey.org/packages/green-tunnel-gui)
[![Chocolatey package version](https://img.shields.io/chocolatey/v/green-tunnel-gui.svg)](https://community.chocolatey.org/packages/green-tunnel-gui)
[![Chocolatey package download count](https://img.shields.io/chocolatey/dt/green-tunnel-gui.svg)](https://community.chocolatey.org/packages/green-tunnel-gui)

## Install
[Install Chocolatey](https://chocolatey.org/install), and run the following command to install the latest approved version on the Chocolatey Community Repository:
```shell
choco install green-tunnel-gui
```

Alternatively, the packages as published on the Chocolatey Community Repository will also be mirrored on this repository's [Releases page](https://github.com/brogers5/chocolatey-package-green-tunnel-gui/releases). The `nupkg` can be installed from the current directory as follows:

```shell
choco install green-tunnel-gui -s .
```

## Build
[Install Chocolatey](https://chocolatey.org/install) and the [Chocolatey Automatic Package Updater Module](https://github.com/majkinetor/au), then clone this repository.

Once cloned, simply run `build.ps1`. The script will download the Green Tunnel installer ZIP archive from the official distribution point (as the ZIP archive is intentionally untracked to avoid bloating the repository), then packs everything together.

A successful build will create `green-tunnel-gui.x.y.z.nupkg`, where `x.y.z` should be the Nuspec's `version` value at build time.

Note that Chocolatey package builds are non-deterministic. Consequently, an independently built package will fail a checksum validation against officially published packages.

## Update
This package should be automatically updated by the [Chocolatey Automatic Package Updater Module](https://github.com/majkinetor/au). If it is outdated by more than a few days, please [open an issue](https://github.com/brogers5/chocolatey-package-green-tunnel-gui/issues).

AU expects the parent directory that contains this repository to share a name with the Nuspec (`green-tunnel-gui`). Your local repository should therefore be cloned accordingly:
```shell
git clone git@github.com:brogers5/chocolatey-package-green-tunnel-gui.git green-tunnel-gui
```

Alternatively, a junction point can be created that points to the local repository (preferably within a repository adopting the [AU packages template](https://github.com/majkinetor/au-packages-template)):
```shell
mklink /J green-tunnel-gui ..\chocolatey-package-green-tunnel-gui
```

Once created, simply run `update.ps1` from within the created directory/junction point. Assuming all goes well, all relevant files should change to reflect the latest version available. This will also build a new package version using the modified files.

Before submitting a pull request, please [test the package](https://docs.chocolatey.org/en-us/community-repository/moderation/package-verifier#steps-for-each-package) using the [Chocolatey Testing Environment](https://github.com/chocolatey-community/chocolatey-test-environment) first.

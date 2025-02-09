# NixOS Configuration
This repository contains my NixOS configuration files.


## Installation 
> **_Note:_**
> It is highly recommended to review the configuration contents and make necessary modifications to customize it to your needs before attempting the installation.

#### 1. **Install NixOS**

First install NixOS using any [graphical ISO image](https://nixos.org/download.html#nixos-iso). 
> **_Note:_**
> Only been tested by choosing the ```No desktop``` option during installation.

#### 2. **Clone the repo**

```bash
nix-shell -p git
git clone https://github.com/d4ve10/nixos-config
cd nixos-config
```
#### 3. **Configure variables**
Change the `vars` variables in `flake.nix` to your desired values.
#### 4. **Install flake**
Execute and follow commands (replace `<hostname>` with the hostname that you want to use):
```bash
cp /etc/nixos/hardware-configuration.nix hosts/<hostname>/hardware-configuration.nix
sudo nixos-rebuild switch --flake .#<hostname>
```
#### 4. **Reboot**
After rebooting you should have a working NixOS system with the configuration from this repository.
## Configuration
The configuration is structured as follows:
- `hosts`: Contains the configuration for each host.
- `hosts/<hostname>`: Contains the configuration for a specific host.
- `modules`: Contains the configuration for each module.
- `modules/options.nix`: Setting these options will enable or disable certain features.
### Commands to use
- `nh os switch -a -H <hostname> .`: Build and switch to the configuration of a specific host.
- `nh clean -a -K 4d`: Clean up old generations.
# Credits
Other dotfiles that I have used as inspiration:
- [MatthiasBenaets/nix-config](https://github.com/MatthiasBenaets/nix-config): Initial flake / file structure
- [TLATER/dotfiles](https://github.com/TLATER/dotfiles): PipeWire Noise Cancelling configuration
- [Frost-Phoenix/nixos-config](https://github.com/Frost-Phoenix/nixos-config): README.md structure and miscellaneous configurations
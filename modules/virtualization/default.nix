#
#  Virtualisation Modules
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./virtualisation
#           ├─ default.nix *
#           └─ ...
#

[
  ./docker.nix
  ./podman.nix
  ./qemu.nix
]

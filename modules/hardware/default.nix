#
#  Hardware
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ default.nix
#   └─ ./modules
#       └─ ./hardware
#           ├─ default.nix *
#           └─ ...
#

[
  ./bluetooth.nix
  ./dslr.nix
  ./framework-laptop.nix
  ./power.nix
  ./suspend-then-hibernate.nix
]

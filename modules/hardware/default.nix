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
  ./power.nix
  ./suspend-then-hibernate.nix
]

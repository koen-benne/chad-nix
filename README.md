Install:
```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
nix run nix-darwin -- switch --flake github:koen-benne/chad-nix
```


Todo:
- move modules to modules folder
- add secret management?

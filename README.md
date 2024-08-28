Install:
```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
nix run nix-darwin -- switch --flake github:koen-benne/chad-nix
```


Todo:
- add secret management?
- manage certificates
- when an app has a home manager and non-home manager module, the enable option should only be in home manager, rather than having to enable the home manager module from within the non-home manager module
- should we even have standalone home manager support?

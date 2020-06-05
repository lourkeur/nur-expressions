self: super:
let
  branch = self.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "66715b5007807ceda476f4ef300745a9aad8b69f";
    sha256 = "0lvb3cjik9q524rhdb3bhdk67kcwsncqbmhi4146m5ssfg4kg9bi";
  };
in {
  xpra = self.callPackage "${branch}/pkgs/tools/X11/xpra" { };
}

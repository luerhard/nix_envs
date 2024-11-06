{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/7ffd9ae656aec493492b44d0ddfb28e79a1ea25d";
    flake-utils.url = "github:numtide/flake-utils";
    # does not work although this version has MacOS support according to nixhub.io
    # failing on dm-tree 0.1.8 / tensorflow-2.13.0 : marked as broken
    # spacypkgs.url = "github:NixOS/nixpkgs/1839883cd0068572aed75fb9442b508bbd9ef09c"; # v 3.7.6
    # spacypkgs.url = "github:NixOS/nixpkgs/fcb54ddcc974cff59bdfb7c1ac9e080299763d2d"; # v 3.7.5
    # spacypkgs.url = "github:NixOS/nixpkgs/61684d356e41c97f80087e89659283d00fe032ab"; # v 3.7.4
    spacypkgs.url = "github:NixOS/nixpkgs/458b097d81f90275b3fdf03796f0563844926708"; # v 3.7.3
    # 2.5.1 + 2.5.0 is broken in linux due to triton 3.1.0 build fail
    # torchpkgs.url = "github:NixOS/nixpkgs/ca30f584e18024baf39c395001262ed936f27ebd"; # v 2.4.1
    torchpkgs.url = "github:NixOS/nixpkgs/5ed627539ac84809c78b2dd6d26a5cebeb5ae269"; # v 2.4.0
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      spacypkgs,
      torchpkgs,
      ...
    }:
    flake-utils.lib.eachSystem [ "aarch64-darwin" "x86_64-linux" ] (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        spacy = import spacypkgs { inherit system; };
        torch = import torchpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };

        system_deps = with pkgs; [
          # trying to get rid of error msgs "unable to set locale -- default to 'C'"
          glibcLocales
          python311
          R
        ];

        r_env = with pkgs.rPackages; [
          box
          here
          irr
          jsonlite
          tidyverse
        ];

        python_env = with pkgs.python311Packages; [
          ibis-framework
          levenshtein
          openai
          pandas
          rpy2
          tqdm
        ];
      in
      {
        defaultPackage = pkgs.mkShell {
          buildInputs = [
            system_deps
            r_env
            python_env
            # spacy needs to be installed from another commit to use a version that works on darwin..
            spacy.python311Packages.spacy
            # torch needs to be installed from another commit to use a version that work in linux
            torch.python311Packages.torch-bin
          ];

          shellHook = ''
            echo "THIS RUNS?"
          '';
        };
      }
    );
}

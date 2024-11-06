# nix_envs

In this repo, i am trying to create enviroments for reproducible data science that fit my needs

## Requirements

Most development happens on MacOS `aarch64-darwin`, the actual runs usually happen on `x86_64-linux`.

- Working CUDA environment with pytorch (and transformers) (whereas cuda on linux and CPU version on Mac)
- R environment with MASS, dplyr and box (at minimum)

## Problems

- spacy package: spacy on nix only works on MacOS until 3.7.4 
- ibis-framework: is randomly broken because of its dependencies
    - dm-tree
    - wandb

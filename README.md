# Fantastic Kit 🔥🔥🔥

Shameless cheap knock off version of Shopify internal developer tool `dev`.

Command line utility `fk` (stands for **F**antastic **K**it)

`fk` provides few useful commands that increase developers productivity. `fk` assumes all git source directory locate at `$HOME/src/github.com/`.


### fk cd

`cd` into a project locate in `$HOME/src/github.com`, also supports zsh-autosuggest prompt. 

### fk clone

`git clone` a repository from github into `$HOME/src/github.com/` and `cd` into the project directory. It reads from `.gitconfig` for username for github. 

Cloning your own repository

``` bash
fk clone <my-own-repo>
```

Cloning public repo of other users:

``` bash
fk clone <git-username>/<repo-name>
```

### fk pr

Open github PRs if opened inside a git directory if the current branch is not master branch.

``` bash
fk pr
```

### fk `<custom-cmd>`

Create `kit.yml` file at the root of the project. Add custom commands to `commands` section.

Example `kit.yml`: it compiles latex to pdf based on name of the subdirectory: 

``` yaml
commands:
  latex:
    run:  latexmk -pdf -pvc $(pwd | xargs basename).tex
    desc: compiling latex file to pdf on change
```

Then you can just run `fk latex` anywhere inside the root directory where `kit.yml` is located.



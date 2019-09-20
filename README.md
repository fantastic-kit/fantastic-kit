# Fantastic Kit 🔥🔥🔥

Welcome!

**What is fantastic-kit?**

Fantastic Kit is a command line utility inspired from Shopify's internal developer tool `dev`.

All commands are based off `fk` (stands for **F**antastic **K**it)

**Why give a fk (fantastic-kit)?**

The `fk` command wants to make you *- the developer -* more productive! 

**What else do I need to know?**

`fk` assumes all git source directories are located at `$HOME/src/github.com/`.



## Installation

### Zsh Users

Run `curl https://raw.githubusercontent.com/fantastic-kit/fantastic-kit/master/bin/install.sh | bash`

### Fish Users

Install fantastic kit using fisher. 

Run `fisher add fantastic-kit/fantastic-kit`

Currently, only the following features are supported for the fish flavour. 

- `fk cd`
- `fk clone`

We are working on implementing the rest of the features soon.

## Built-in commands

### fk cd

`cd` into a project located in `$HOME/src/github.com`. Also supports zsh-autosuggest prompt.

### fk clone

`git clone` a repository from github into `$HOME/src/github.com/` and `cd` into the project directory. It retrieves github username from the `.gitconfig` 

Cloning your own repository

```bash
fk clone <my-own-repo>
```

Cloning someone else's public repo:

```bash
fk clone <git-username>/<repo-name>
```

### fk pr

Opens a github PR if user is

1. inside a git repository **and**
2. not on the master branch

```bash
fk pr
```

### fk repo

Open current repo on github

``` bash
fk repo
```

### fk `<custom-cmd>`

Using `kit.yml` file at the root of the project. Add custom commands to `commands` section.

Example `kit.yml`: it compiles latex to pdf based on name of the subdirectory:

```yaml
commands:
  latex:
    run:  latexmk -pdf -pvc $(pwd | xargs basename).tex
    desc: compiling latex file to pdf on change
```

Then you can just run `fk latex` anywhere inside the root directory where `kit.yml` is located.

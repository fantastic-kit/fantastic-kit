module FKit
  HELP_MSG = <<-EOF
Usage: fk [cmd] (subcmd|options)
  fk \e[94mup\e[39m           -- Create a new repository on github that is tracked by fantastic-kit
  fk \e[94mcd\e[39m           -- cd into a project tracked by fantastic-kit
  fk \e[94mclone\e[39m        -- clone a repository from GitHub
  fk \e[94mpr\e[39m           -- create a GitHub pull request for current repo
  fk \e[94mconfig\e[39m       -- fantastic-kit configuration
  fk \e[94mrepo\e[39m         -- open current repo on GitHub
  fk \e[94m<custom cmd>\e[39m -- run custom command defined in kit.yml
  EOF
end

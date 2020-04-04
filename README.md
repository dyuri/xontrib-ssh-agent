# Xontrib-ssh-agent

Ssh-agent xonsh integration.

## Install

Install using pip

```
pip install xontrib-ssh-agent
```

Add to your `.xonshrc`:

```
xontrib load ssh_agent
```

## Usage

This xontrib launches `ssh-agent` when `xonsh` is started if it isn't already running, and sets the required environment variables.

By issuing the `ssh` command it checks for added identities, and if there's none it adds them via the `ssh-add` command.

### `git` support

To handle ssh identities, [repassh](https://github.com/dyuri/repassh) is used under the hood. If it's on the `$PATH`, `xontrib-ssh-agent` sets `$GIT_SSH` to it by default. If your `repassh` command is not on the `$PATH` by default, but you still want to use it for git, then set `$GIT_SSH` to it manually, or set `$REPASSH_COMMAND` before you load this xontrib. 

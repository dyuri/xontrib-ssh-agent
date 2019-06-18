# Xontrib-ssh-agent

Ssh-agent xonsh integration.

## Install

Install using pip

```
pip install hg+https://bitbucket.org/dyuri/xontrib-ssh-agent
```

Add to your `.xonshrc`:

```
xontrib load ssh_agent
```

## Usage

This xontrib launches `ssh-agent` when `xonsh` is started if it isn't already running, and sets the required environment variables.

By issuing the `ssh` command it checks for added identities, and if there's none it adds them via the `ssh-add` command.

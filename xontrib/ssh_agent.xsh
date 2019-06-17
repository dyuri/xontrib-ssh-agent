"""Helper function to start SSH agent and add keys using ssh-add
"""
import builtins
import os
import stat

__all__ = ()

SSH = $(which 'ssh')
SSH_AGENT = $(which 'ssh-agent')
SSH_ADD = $(which 'ssh-add')
SSH_DIR = os.path.join($HOME, '.ssh')
TMPDIR = builtins.__xonsh__.env.get('TMPDIR', '/tmp')
SSH_AGENT_ENV = os.path.join(TMPDIR, 'ssh-agent.env')
SSH_AGENT_SOCK = os.path.join(TMPDIR, 'ssh-agent.sock')

_FROM_ZSH = """
  # Set the path to the SSH directory.
  _ssh_dir="$HOME/.ssh"

  # Set the path to the environment file if not set by another module.
  _ssh_agent_env="${_ssh_agent_env:-${TMPDIR:-/tmp}/ssh-agent.env}"

  # Set the path to the persistent authentication socket.
  _ssh_agent_sock="${TMPDIR:-/tmp}/ssh-agent.sock"

  # Start ssh-agent if not started.
  if [[ ! -S "$SSH_AUTH_SOCK" ]]; then
    # Export environment variables.
    source "$_ssh_agent_env" 2> /dev/null

    # Start ssh-agent if not started.
    if ! ps -U "$LOGNAME" -o pid,ucomm | grep -q -- "${SSH_AGENT_PID:--1} ssh-agent"; then
      eval "$(ssh-agent | sed '/^echo /d' | tee "$_ssh_agent_env")"
    fi
  fi

  # Create a persistent SSH authentication socket.
  if [[ -S "$SSH_AUTH_SOCK" && "$SSH_AUTH_SOCK" != "$_ssh_agent_sock" ]]; then
    ln -sf "$SSH_AUTH_SOCK" "$_ssh_agent_sock"
    export SSH_AUTH_SOCK="$_ssh_agent_sock"
  fi

  # Load identities.
  if ssh-add -l 2>&1 | grep -q 'The agent has no identities'; then
    zstyle -a ':prezto:module:ssh:load' identities '_ssh_identities'
    if (( ${#_ssh_identities} > 0 )); then
      ssh-add "$_ssh_dir/${^_ssh_identities[@]}" 2> /dev/null
    else
      ssh-add 2> /dev/null
    fi
  fi

  # Clean up.
  unset _ssh_{dir,identities} _ssh_agent_{env,sock}

  # Execute ssh
  /usr/bin/ssh $*
"""


def init_ssh_agent():
    ssh_auth_sock = builtins.__xonsh__.env.get('SSH_AUTH_SOCK', None)
    if ssh_auth_sock and os.path.exists(ssh_auth_sock):
        is_socket = stat.S_ISSOCK(os.stat(ssh_auth_sock).st_mode)
    else:
        is_socket = False

    # ssh-agent not running?
    if not is_socket:
        # load env variables if available
        source-bash @(SSH_AGENT_ENV) e>/dev/null

        # TODO eval output of SSH_AGENT
        ![ps -U "$LOGNAME" -o pid,ucomm | grep -q -- "$SSH_AGENT_PID ssh-agent"] or $(@(SSH_AGENT) | sed '/^echo /d' | tee @(SSH_AGENT_ENV))


def ssh(args):
    print(args)
    print([SSH, SSH_AGENT, SSH_ADD])

    @(SSH) @(args)


builtins.aliases['ssh'] = ssh
init_ssh_agent()

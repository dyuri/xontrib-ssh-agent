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


# checks if SSH_AUTH_SOCK is a socket
def is_auth_socket():
    ssh_auth_sock = builtins.__xonsh__.env.get('SSH_AUTH_SOCK', None)
    if ssh_auth_sock and os.path.exists(ssh_auth_sock):
        return stat.S_ISSOCK(os.stat(ssh_auth_sock).st_mode)

    return False


# start ssh-agent if not yet running
# set environment variables
def init_ssh_agent():
    # ssh-agent not running?
    if not is_auth_socket():
        # load env variables if available
        source-bash @(SSH_AGENT_ENV) e>/dev/null

        if not ![ps -U "$LOGNAME" -o pid,ucomm | grep -q -- "$SSH_AGENT_PID ssh-agent"]:
            # execute ssh-agent
            $(@(SSH_AGENT) | sed '/^echo /d' | tee @(SSH_AGENT_ENV))
            # set environment variables
            source-bash @(SSH_AGENT_ENV) e>/dev/null

    if is_auth_socket() and builtins.__xonsh__.env.get('SSH_AUTH_SOCK', None) != SSH_AGENT_SOCK:
        ln -sf $SSH_AUTH_SOCK @(SSH_AGENT_SOCK)
        builtins.__xonsh__.env['SSH_AUTH_SOCK'] = SSH_AGENT_SOCK


def ssh(args):
    """Load the identities if not yet loaded then launch the ssh command
    """
    if 'The agent has no identities.' in $(@(SSH_ADD) -l):
        @(SSH_ADD) e> /dev/null

    @(SSH) @(args)


builtins.aliases['ssh'] = ssh
init_ssh_agent()

"""Helper function to start SSH agent and add keys using ssh-add
"""
import builtins
from repassh import ssh

__all__ = ()


def sshc(binary="/bin/ssh", options={}):
    def command(args, stdin=None, stdout=None, stderr=None):
        """Launch `repassh` with '[binary]' and the provided arguments
        """
        opts = {}
        opts.update(options)
        opts.update({
            "BINARY_SSH": binary,
            "stdin": stdin,
            "stdout": stdout,
            "stderr": stderr
        })
        return ssh.main([''] + args, opts)

    return command


builtins.aliases['ssh'] = sshc()
builtins.aliases['scp'] = sshc("scp")
builtins.aliases['sftp'] = sshc("sftp")
builtins.aliases['rsync'] = sshc("rsync", {"SSH_DEFAULT_OPTIONS": ""})
$GIT_SSH="repassh"

trap '
    [[ -n "$SSH_AGENT_PID" ]] && eval `ssh-agent -k`
    [[ -n "$SSH2_AGENT_PID" ]] && kill $SSH2_AGENT_PID
' 0

function emoji-fish
    set -l buffer (commandline)
    set -l buffer_len (string length $buffer)
    set -l token (commandline -t)
    set -l token_len (string length $token)
    set -l trim_token_buf (string sub -l (expr $buffer_len - $token_len) $buffer)

    set -l function_file (type emoji-fish | head -n 2 | tail -n 1 | awk '{print $4}')
    set -l installed_path (dirname (realpath $function_file))

    set -l emoji (python3 $installed_path/suggest.py $installed_path $token | fzf-tmux -d $FZF_TMUX_HEIGHT)
    if test $status -ne 0
        false
    end

    set -l alias (echo $emoji | awk '{print $2}')
    if test $alias != ""
        commandline -P -S
        commandline -r $trim_token_buf$alias
    end
end

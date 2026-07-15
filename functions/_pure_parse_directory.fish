function _pure_parse_directory \
    --description "Replace '$HOME' with '~'" \
    --argument-names max_path_length

    set --local directory $PWD

    if test "$pure_truncate_prompt_current_directory_to_git_root" = true
        and type -q --no-functions git  # skip when `git` is not available

        set --local git_root (command git rev-parse --show-toplevel 2>/dev/null)

        if test -n "$git_root"
            set --local git_subpath (command git rev-parse --show-prefix 2>/dev/null)
            set directory (string trim --right --chars=/ -- (basename $git_root)/$git_subpath)
        end
    end

    set --local folder (fish_prompt_pwd_dir_length=$pure_shorten_prompt_current_directory_length prompt_pwd $directory)

    if test -n "$max_path_length"
        if test (string length $folder) -gt $max_path_length
            # If path exceeds maximum symbol limit, force fish path formating function to use 1 character
            set folder (fish_prompt_pwd_dir_length=1 prompt_pwd $directory)
        end
    end

    if test "$pure_truncate_prompt_current_directory_keeps" -ge 1
        set folder (
            string split '/' $folder \
                | tail -n $pure_truncate_prompt_current_directory_keeps \
                | string join '/'
        )
    end

    echo $folder
end

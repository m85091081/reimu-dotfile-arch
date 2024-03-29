# name: scorphish

function _prompt_rubies -a sep_color -a ruby_color -d 'Display current Ruby (rvm/rbenv)'
  [ "$theme_display_ruby" = 'no' ]; and return
  set -l ruby_version
  if type rvm-prompt >/dev/null 2>&1
    set ruby_version (rvm-prompt i v g)
  else if type rbenv >/dev/null 2>&1
    set ruby_version (rbenv version-name)
  end
  [ -z "$ruby_version" ]; and return

  echo -n -s $sep_color '|' $ruby_color (echo -n -s $ruby_version | cut -d- -f2-)
end

function _prompt_rust -a sep_color -a rust_color -d "Display current activated Rust"
  [ "$theme_display_rust" != 'yes' ]; and return
  echo -n -s $sep_color '|' $rust_color (rustc --version | cut -d\  -f2)
end

function _prompt_nvm -a sep_color -a nvm_color -d "Display current activated Node"
  [ "$theme_display_nvm" != 'yes' -o -z "$NVM_RC_VERSION" ]; and return
  echo -n -s $sep_color '|' $nvm_color $NVM_RC_VERSION
end

function _prompt_whoami -a sep_color -a whoami_color -d "Display user@host if on a SSH session"
  if set -q SSH_TTY
    echo -n -s $whoami_color (whoami)@(hostname) $sep_color '|'
  end
end

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function _git_ahead_count -a remote -a branch_name
  echo (command git log $remote/$branch_name..HEAD ^/dev/null | \
    grep '^commit' | wc -l | tr -d ' ')
end

function _git_dirty_remotes -a remote_color -a ahead_color
  set current_branch (command git rev-parse --abbrev-ref HEAD ^/dev/null)
  set current_ref (command git rev-parse HEAD ^/dev/null)

  for remote in (git remote | grep 'origin\|upstream')

    set -l git_ahead_count (_git_ahead_count $remote $current_branch)

    set remote_branch "refs/remotes/$remote/$current_branch"
    set remote_ref (git for-each-ref --format='%(objectname)' $remote_branch)
    if test "$remote_ref" != ''
      if test "$remote_ref" != $current_ref
        if [ $git_ahead_count != 0 ]
          echo -n " $ahead_color+$git_ahead_count$normal"
        end
      end
    end
  end
end

function fish_prompt
  set -l exit_code $status

  set -l gray (set_color 666)
  set -l blue (set_color blue)
  set -l red (set_color red)
  set -l normal (set_color normal)
  set -l yellow (set_color ffcc00)
  set -l orange (set_color ffb300)
  set -l green (set_color green)


  set_color -o 666
  printf '┌['
  set_color -o normal
  printf '%s' (whoami)
  set_color -o cyan
  printf '@'
  set_color -o normal
  printf '%s' (hostname)
  set_color -o 666
  printf ']-'
  set_color -o 666
  printf '('

  _prompt_whoami $gray $green

  set_color -o cyan
  printf '%s' (prompt_pwd)

  _prompt_rubies $gray $red

  if [ "$VIRTUAL_ENV" != "$LAST_VIRTUAL_ENV" -o -z "$PYTHON_VERSION" ]
    set -gx PYTHON_VERSION (python --version 2>&1 | cut -d\  -f2)
    set -gx LAST_VIRTUAL_ENV $VIRTUAL_ENV
  end

  set_color -o 666
  if set -q SCORPHISH_GIT_INFO_ON_FIRST_LINE
    printf ')'
  else
    printf ')'
  end

  # Show git branch and dirty state
  if [ (_git_branch_name) ]
    set -l git_branch (_git_branch_name)

    set dirty_remotes (_git_dirty_remotes $orange $orange)

    if [ (_is_git_dirty) ]
      echo -n -s $gray '-[' $yellow $git_branch $red '✘' $dirty_remotes $gray ']-' $normal
    else
      echo -n -s $gray '-[' $yellow $git_branch $green '✔' $orange $dirty_remotes $gray ']-' $normal
    end
  end

  if test $exit_code -ne 0
    set arrow_colors 666 c00 
  else
    set arrow_colors 666 0c0 
  end

  if set -q SCORPHISH_GIT_INFO_ON_FIRST_LINE
    printf ' '
  else
    printf ' \n'
  end
  set_color -o 666
   printf '└'
  for arrow_color in $arrow_colors
    set_color $arrow_color
    printf '»'
  end

  printf ' '

  set_color normal
end

function fish_right_prompt
  set -l exit_code $status
  if test $exit_code -ne 0
    set_color red
  else
    set_color green
  end
  printf '%d' $exit_code
  set_color -o 666
  echo '|'
  set_color -o 777
  printf '%s' (date +%H:%M:%S)
  set_color normal
end


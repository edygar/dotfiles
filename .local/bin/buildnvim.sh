#!/usr/bin/env bash
set -x
set -eo pipefail

function buildnvim() {
    # Make sure I cloned the thing.
    local nvim_dir="$HOME/Code/personal/neovim"
    [ ! -d "$nvim_dir" ] && echo "You haven't cloned neovim..." && return

    printf '\n========== NEOVIM DIRECTORY: %s ==========\n' "$nvim_dir"

    # Go to the neovim directory.
    cd "$nvim_dir" || { printf '\n========== COULD NOT CD TO NEOVIM DIRECTORY ==========\n' && return; }

    if ! git diff --exit-code; then
        printf '\n========== LOCAL NEOVIM CHANGES! ==========\n'
        return
    fi

    remote="upstream"

    if ! git remote get-url "$remote" >/dev/null 2>&1; then
	    remote="origin"
    fi

    git fetch "$remote" master
    git --no-pager log --decorate=short --pretty=short master.."$remote/master"
    git merge "$remote/master"

    # Clear the previous build.
    sudo rm -rf /usr/local/share/nvim
    sudo make distclean

    # Go back to the given commit or HEAD.
    local commit="${1:-HEAD}"
    printf '\n========== CHECKING OUT COMMIT %s... ==========\n' "$commit"
    git reset --hard "$commit"

    # Build.
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    make install

    # Remove the patched changes.
    git checkout .
}

buildnvim "$@"

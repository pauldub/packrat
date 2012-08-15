#!/bin/bash

mod_dotfiles() {
    verbose "[DOTFILES] running...."
    verbose "[DOTFILES] cd /home/$DOTFILES_USER/"
    cd /home/$DOTFILES_USER/
    if [ ! -e "/home/$DOTFILES_USER/.dotfiles" ]; then 
        verbose "[DOTFILES] mkdir .dotfiles"
        mkdir .dotfiles;
    fi;
    cd .dotfiles
    if [ ! -e "/home/$DOTFILES_USER/.dotfiles/.git" ]; then 
        verbose "[DOTFILES] git init && remote add origin $DOTFILES_REMOTE"
        git init && git remote add origin $DOTFILES_REMOTE;
    fi;

    verbose "[DOTFILES] git checkout $DOTFILES_BRANCH && git pull origin $DOTFILES_BRANCH"
    git checkout $DOTFILES_BRANCH &&
    git pull origin $DOTFILES_BRANCH &&
    verbose "[DOTFILES] Deleting & creating symlinks"
    for f in ${DOTFILES[@]}; do
        if [ ! -e "$f" ]; then
            verbose "[DOTFILES] Target does not exist: $f"
            verbose "[DOTFILES] ln -s ./.dotfiles/$f "
            ln -s .dotfiles/$f
            continue
        fi
        verbose "[DOTFILES] cd /home/$DOTFILES_USER &&"
        cd /home/$DOTFILES_USER &&
        verbose "[DOTFILES] rm ./$f"
        rm ./$f &&
        verbose "[DOTFILES] ln -s ./.dotfiles/$f "
        ln -s .dotfiles/$f
    done
    cd /home/$DOTFILES_USER/.dotfiles &&
    verbose "[DOTFILES] Adding changes to dotfiles"
    for f in ${DOTFILES[@]}; do
        if [ ! -e "$f" ]; then
            verbose "[DOTFILES] Target does not exist: $f"
            continue
        fi
        git add $f
    done
    verbose "[DOTFILES] Commiting changes: git commit -m \"${HOSTNAME} - ${TODAY}\""
    git commit -m "${HOSTNAME} - ${TODAY}" &&
    verbose "[DOTFILES] git push origin $DOTFILES_BRANCH"
    git push origin $DOTFILES_BRANCH
}

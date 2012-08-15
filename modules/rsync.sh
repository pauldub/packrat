#!/bin/bash

purge_rsync() {
	verbose "[SSH] cmd: ssh -i ${SSH_KEY} ${SSH_USER}@${SSH_HOST} rm -f ${SSH_DIR}/${1}"
	ssh -i ${SSH_KEY} ${SSH_USER}@${SSH_HOST} rm -f ${SSH_DIR}/${1}
}

mod_rsync() {
    verbose "[RSYNC] cmd: rsync -ave 'ssh -i ${SSH_KEY}' ${BACKUP_DIR}/ ${SSH_USER}@${SSH_HOST}:${SSH_DIR}"
		[ "$SSH_BWLIMIT" ] && lim="-l $SSH_BWLIMIT"
        rsync -chavzPe "ssh -i ${SSH_KEY} $lim" ${BACKUP_DIR}/ ${SSH_USER}@${SSH_HOST}:${SSH_DIR}
		[ $? -eq 0 ] || die "ERROR: command did not complete successfully"
}

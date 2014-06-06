#!/bin/sh
case "$SSH_ORIGINAL_COMMAND" in
*\&*)
  echo "Rejected"
;;
*\(*)
  echo "Rejected"
;;
*\{*)
  echo "Rejected"
;;
*\;*)
  echo "Rejected"
;;
*\<*)
  echo "Rejected"
;;
*\`*)
  echo "Rejected"
;;
rsync*)
  bash -c "$SSH_ORIGINAL_COMMAND"
  ;;
mysqldump*)
  bash -c "sudo $SSH_ORIGINAL_COMMAND"
  ;;
pg_dumpall*)
  bash -c "sudo $SSH_ORIGINAL_COMMAND"
  ;;
pg_dump*)
  bash -c "sudo $SSH_ORIGINAL_COMMAND"
  ;;
slapcat*)
  bash -c "sudo $SSH_ORIGINAL_COMMAND"
  ;;
virsh\ dumpxml*)
  bash -c "sudo $SSH_ORIGINAL_COMMAND"
  ;;
*true*)
  echo "$SSH_ORIGINAL_COMMAND"
  ;;
*)
  echo "Rejected"
  ;;
esac

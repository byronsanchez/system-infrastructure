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
  $SSH_ORIGINAL_COMMAND
  ;;
mysqldump*)
  bash -c "$SSH_ORIGINAL_COMMAND"
  ;;
pg_dumpall*)
  bash -c "$SSH_ORIGINAL_COMMAND"
  ;;
pg_dump*)
  bash -c "$SSH_ORIGINAL_COMMAND"
  ;;
slapcat*)
  bash -c "$SSH_ORIGINAL_COMMAND"
  ;;
*true*)
  echo "$SSH_ORIGINAL_COMMAND"
  ;;
*)
  echo "Rejected"
  ;;
esac

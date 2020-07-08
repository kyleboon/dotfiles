export ZSHDIR=/Users/z002nd2/Documents/workspace/shared-zshrc

export HOSTNAME=$(hostname)

source $ZSHDIR/zshrc_base

source $ZSHDIR/zshrc_options

# echo "sourcing general nonshared-zshrc/zshrc"
source $ZSHDIR/nonshared-zshrc/zshrc


HOST_SPECIFIC_FILE=$ZSHDIR/nonshared-zshrc/f40f24347ffa
if [ -e $HOST_SPECIFIC_FILE ]
then
  echo "Loading zshrc for host f40f24347ffa"
  source $ZSHDIR/nonshared-zshrc/f40f24347ffa
else 
  echo "creating file for host-specific overrides f40f24347ffa"
  touch $ZSHDIR/nonshared-zshrc/f40f24347ffa
fi


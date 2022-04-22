#!/bin/zsh
#Use fzf to pick subproject and test name in gradle
gt() {
  local out file key
  IFS=$'\n' out=("$(fd .gradle.kts | sed s,[A-Za-z0-9-]*.gradle.kts,, | fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    fzf_testname $file
  fi
}

fzf_testname() {
  local out2 file2 key2
  libdir=$1
  IFS=$'\n' out2=("$(fd Test $libdir | fzf-tmux --query="" --exit-0 --expect=ctrl-o,ctrl-e)")
  key2=$(head -1 <<< "$out2")
  file2=$(head -2 <<< "$out2" | tail -1)
  if [ -n "$file2" ]; then
    subst=$libdir"src/test/kotlin/"
    testName=`echo $file2 | sed s,$subst,,g | sed s,/,.,g | sed s,.kt,,`
    command=(./gradlew -p $libdir test --tests $testName)
  else
    command=(./gradlew -p $libdir test)
  fi
  #zshrc specific
  print -s $command
  echo $command
  "${command[@]}"
}
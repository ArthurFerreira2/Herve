#!/bin/bash

rm ./testsResults ./*.traces

for test in `cat ./testsList`
do
  echo -n "$test : " >> ./testsResults
  ../herve -i ./$test -o ./$test.traces 2>> ./testsResults
done


TARGET=`wc -l ./testsList | cut -d " " -f 1`
REACHED=`grep 'All tests passed' ./testsResults | wc -l`

if [[ $REACHED -eq $TARGET ]]
then
  echo "All tests passed"
  exit 0
else
  echo "Some test failled"
  exit 1
fi

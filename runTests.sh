#!/bin/sh

for test in `ls tests/ | grep -v dump | grep -v traces`
do
  echo -n "$test : "
  ./herve ./tests/$test 2> tests/$test.traces
done

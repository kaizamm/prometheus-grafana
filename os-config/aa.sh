#!/bin/bash
for i in `find . -type f -name "*.sh"`
do
echo $i
echo `basename $i`
echo `dirname $i`
done

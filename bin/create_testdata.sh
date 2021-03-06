#!/usr/bin/env bash
# Copyright (c) 2012 Cloudera, Inc. All rights reserved.

bin=`dirname "$0"`
bin=`cd "$bin"; pwd`
. "$bin"/impala-config.sh

set -e

# location of the generated data
DATALOC=$IMPALA_HOME/testdata/target

# regenerate the test data generator
cd $IMPALA_HOME/testdata
mvn clean package

# find jars
CP=""
JARS=`find target/*.jar 2> /dev/null || true`
for i in $JARS; do
    if [ -n "$CP" ]; then
        CP=${CP}:${i}
    else
        CP=${i}
    fi
done

# run test data generator
echo $DATALOC
mkdir -p $DATALOC
java -cp $CP com.cloudera.impala.datagenerator.TestDataGenerator $DATALOC
java -cp $CP com.cloudera.impala.datagenerator.CsvToHBaseConverter
echo "SUCCESS, data generated into $DATALOC"

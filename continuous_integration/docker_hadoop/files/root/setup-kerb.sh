#! /bin/bash

create_keytabs() {
    HOST="$1.example.com"
    KEYTABS="/etc/hadoop/conf.kerb/$1-keytabs"
    return kadmin.local -q "addprinc -randkey hdfs/$HOST@EXAMPLE.COM" \
    && kadmin.local -q "addprinc -randkey mapred/$HOST@EXAMPLE.COM" \
    && kadmin.local -q "addprinc -randkey yarn/$HOST@EXAMPLE.COM" \
    && kadmin.local -q "addprinc -randkey HTTP/$HOST@EXAMPLE.COM" \
    && kadmin.local -q "xst -norandkey -k $KEYTABS/hdfs.keytab hdfs/$HOST HTTP/$HOST" \
    && kadmin.local -q "xst -norandkey -k $KEYTABS/mapred.keytab mapred/$HOST HTTP/$HOST" \
    && kadmin.local -q "xst -norandkey -k $KEYTABS/yarn.keytab yarn/$HOST HTTP/$HOST" \
    && kadmin.local -q "xst -norandkey -k $KEYTABS/HTTP.keytab HTTP/$HOST" \
    && chown hdfs:mapred $KEYTABS/hdfs.keytab \
    && chown mapred:mapred $KEYTABS/mapred.keytab \
    && chown yarn:mapred $KEYTABS/yarn.keytab \
    && chown hdfs:mapred $KEYTABS/HTTP.keytab \
    && chmod 400 $KEYTABS/*.keytab
}

mkdir $KEYTABS \
&& kdb5_util create -s -P testpass \
&& create_keytabs nn \
&& create_keytabs dn \
&& create_keytabs edge

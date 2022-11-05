#!/bin/bash
mysql -utest -ptest1234 -hterraform-20221105075842098700000001.cefopgqo9xzy.us-east-1.rds.amazonaws.com <<CREATE_TEST_DB
CREATE DATABASE IF NOT EXISTS test;
CREATE_TEST_DB


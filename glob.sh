#!/bin/bash

e=2

function test1() {
  e=4
  echo "hello"
}

test1 
echo "$e"


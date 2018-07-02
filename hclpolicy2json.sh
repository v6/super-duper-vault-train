#!/usr/bin/env bash
  ##  tr -d '\n' | 
  ##
  ##  Behold.
  ##  
  ##  ______ _____ _   _ _____ _    ______ 
  ##  | ___ \  ___| | | |  _  | |   |  _  \
  ##  | |_/ / |__ | |_| | | | | |   | | | |
  ##  | ___ \  __||  _  | | | | |   | | | |
  ##  | |_/ / |___| | | \ \_/ / |___| |/ /  
  ##  \____/\____/\_| |_/\___/\_____/___/  (_)
  ##                                       
  ##                                       
  ##  
  ##   
  ##  It is hcl2json, Policy Weirdness Edition™
  ##  This removes comments from a .hcl file, serializes
  ##  its contents into a string compatible with JSON, and
  ##  outputs JSON with that string assigned to the 
  ##  key "policy".
printf "{
    \"policy\": \""
cat $1 | sed '/^[[:blank:]]*#/d;s/#.*//' | sed 's/\"/\\\"/g' | tr -d '\n'  ##  Remove comments and serialize string
printf "\"
}"

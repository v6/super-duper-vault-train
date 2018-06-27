#!/usr/bin/env bash
  ##  BEHOLD. 
  ##  It is hcl2json, Policy Weirdness Edition™
REPLACED=$(cat $1 | tr -d '\n' | sed 's/\"/\\\"/g')
printf "{
    \"policy\": \"${REPLACED}\"
}"

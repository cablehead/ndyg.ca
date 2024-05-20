#!/usr/bin/env -S nu --stdin

open plantings.yaml | to json | minijinja-cli -f json ./index.html -

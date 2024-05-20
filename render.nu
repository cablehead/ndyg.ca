#!/usr/bin/env -S nu --stdin

open plantings/* | { plantings: $in } | to json | minijinja-cli -f json ./index.html -

#!/usr/bin/env -S nu

def main [md: string] {
	open $md | md2html | {content: $in} | to json -r |
		minijinja-cli -f json apage.html -
}

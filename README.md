# Lucee ULID Extension

[![Java CI](https://github.com/zspitzer/extension-ulid/actions/workflows/main.yml/badge.svg)](https://github.com/zspitzer/extension-ulid/actions/workflows/main.yml)

Universally Unique Lexicographically Sortable Identifier https://github.com/ulid/spec

Uses the Java implementation https://github.com/f4b6a3/ulid-creator

Why are these interesting? TL;DR
- they are sorted by time
- BTREE indexes work way better with less random data
- smaller index size due to similair keys

Mailing list post https://dev.lucee.org/t/add-support-for-ulids-createulid/12602

https://luceeserver.atlassian.net/browse/LDEV-4481

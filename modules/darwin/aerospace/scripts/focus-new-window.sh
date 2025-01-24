#!/usr/bin/env bash

aerospace focus --window-id "$(aerospace list-windows --all | awk "{print \$1}" | sort -n | tail -n 1)"

#!/usr/bin/env bash

set -euo pipefail

# A script to convert any text file into a C++ header
# defining raw string literal variable.
#
# Usage:
#   ./embed-in-cpp.sh <input_file> <output_file>

# Exit if the wrong number of arguments are provided.
if [ "$#" -ne 2 ]; then
	echo "Usage: $0 <input_file> <output_file>"
	exit 1
fi

INPUT_FILE=$1
OUTPUT_FILE=$2

# Derive a C++-friendly variable name from the input file name.
# e.g., "kernel1.cl" becomes "kernel1_cl_src"
VAR_NAME=$(basename "${INPUT_FILE}" | sed 's/[^a-zA-Z0-9]/_/g')_src

# Write the C++ header file content.
{
	echo "#pragma once"
	echo ""
	echo "static const char *${VAR_NAME} = R\"CLC("
	cat "${INPUT_FILE}"
	echo ")CLC\";"
} >"${OUTPUT_FILE}"

#!/usr/bin/env python3
import os
import sys
import tiktoken

def count_gpt5_tokens(text: str) -> int:
    # GPT-5.5 uses the o200k_base vocabulary line
    encoding = tiktoken.get_encoding("o200k_base")
    num_tokens = len(encoding.encode(text))
    return num_tokens

GREEN_MAX = 499
ORANGE_MAX = 700
YELLOW_MAX = 900

def calculate_token_usage(file_path):
    # Platform agnostic approximation: 1 token ~= 4 characters in standard text
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        approx_tokens = count_gpt5_tokens(content)

        print(f"File: {os.path.basename(file_path)}")
        print(f"Approximate Token Usage: {approx_tokens}")

        if approx_tokens <= GREEN_MAX:
            print("STATUS: GREEN - token count is within the preferred runtime target.")
            sys.exit(0)
        elif approx_tokens <= ORANGE_MAX:
            print("STATUS: ORANGE - acceptable only when the extra rules materially improve determinism.")
            sys.exit(0)
        elif approx_tokens <= YELLOW_MAX:
            print("STATUS: YELLOW - needs reviewer justification and a follow-up compression pass.")
            sys.exit(0)
        else:
            print("STATUS: RED - rewrite priority; do not accept unless no safe compression remains.")
            sys.exit(1)

    except Exception as e:
        print(f"Error reading file: {e}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 measure_tokens.py <path_to_definition_file>")
        sys.exit(1)
    calculate_token_usage(sys.argv[1])

#!/usr/bin/env python3
"""
PreToolUse hook: block em dashes and en dashes in deliverable files.

Fires before Write, Edit, or MultiEdit tool calls. If the target file is a
deliverable (*.docx, *.md, *.txt, or any path containing "deliverable",
"draft", or "output") and the content contains an em dash or en dash used
as sentence punctuation, blocks the operation.

Always exits 0, even on error, to avoid blocking unrelated operations.
"""
import sys
import json
import re
from pathlib import Path

EM_DASH = "\u2014"
EN_DASH = "\u2013"

# Match deliverable files by extension or path keyword
DELIVERABLE_EXTENSIONS = {".docx", ".md", ".txt"}
DELIVERABLE_PATH_KEYWORDS = {"deliverable", "draft", "output"}


def is_deliverable(file_path: str) -> bool:
    if not file_path:
        return False
    p = Path(file_path)
    if p.suffix.lower() in DELIVERABLE_EXTENSIONS:
        return True
    parts = set(part.lower() for part in p.parts)
    return bool(parts & DELIVERABLE_PATH_KEYWORDS)


def extract_content(tool_name: str, tool_input: dict) -> tuple:
    """Extract file_path and writable content from tool input.

    Returns (file_path, content_to_check) or (None, None) if not applicable.
    """
    file_path = tool_input.get("file_path", "")

    if tool_name == "Write":
        return file_path, tool_input.get("content", "")
    elif tool_name == "Edit":
        return file_path, tool_input.get("new_string", "")
    elif tool_name == "MultiEdit":
        edits = tool_input.get("edits", [])
        combined = " ".join(e.get("new_string", "") for e in edits)
        return file_path, combined

    return None, None


def main():
    try:
        data = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        sys.exit(0)

    tool_name = data.get("tool_name", "")

    if tool_name not in ("Write", "Edit", "MultiEdit"):
        sys.exit(0)

    tool_input = data.get("tool_input", {})
    file_path, content = extract_content(tool_name, tool_input)

    if not file_path or not content:
        sys.exit(0)

    if not is_deliverable(file_path):
        sys.exit(0)

    found = []
    if EM_DASH in content:
        found.append("em dash (—)")
    if EN_DASH in content:
        found.append("en dash (–)")

    if not found:
        sys.exit(0)

    # Dash found in a deliverable file: block
    result = {
        "decision": "block",
        "reason": (
            f"{' and '.join(found).capitalize()} detected in deliverable: {file_path}. "
            "Restructure the sentence to use periods, commas, colons, or semicolons. "
            "Em dashes and en dashes are only allowed in plan files, conversational responses, "
            "and internal working notes."
        ),
    }
    print(json.dumps(result))
    sys.exit(0)


if __name__ == "__main__":
    try:
        main()
    except Exception:
        # Never block operations due to hook errors
        sys.exit(0)

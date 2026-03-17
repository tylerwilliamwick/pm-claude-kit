#!/usr/bin/env python3
"""
PreToolUse hook: Enforces model routing for Agent tool calls.

Intercepts all Agent spawns and warns when the explicit model doesn't match
the routing table in CLAUDE.md. Since PreToolUse hooks can't modify tool
inputs, this acts as a visibility mechanism that surfaces violations in
the conversation, reinforcing the CLAUDE.md directive.

Registered on matcher: Agent

B3 optimization: fast-path exit for OMC agents via raw string check
before JSON parsing (avoids ~80% of parse overhead).
"""
import sys; sys.path.insert(0, str(__import__('pathlib').Path(__file__).parent / "lib"))
from profiler import HookProfiler
import json

_p = HookProfiler("model-routing-enforcer")

# Routing table: subagent_type -> required model
# OMC agents are handled by the OMC delegation-enforcer; skip them.
ROUTING_TABLE = {
    "Explore": "haiku",
    "general-purpose": "sonnet",
    "Plan": "opus",
}


def main():
    raw = sys.stdin.read()

    # Fast-path: skip OMC agents before JSON parsing (B3 optimization)
    # ~80% of Agent spawns are oh-my-claudecode: agents — exit immediately
    if '"oh-my-claudecode:' in raw:
        sys.exit(0)

    try:
        data = json.loads(raw)
    except (json.JSONDecodeError, EOFError):
        sys.exit(0)

    tool_name = data.get("tool_name", "")
    _p.tool = tool_name

    if tool_name != "Agent":
        sys.exit(0)

    tool_input = data.get("tool_input", {})
    subagent_type = tool_input.get("subagent_type", "")

    # Skip agent types not in our routing table
    expected_model = ROUTING_TABLE.get(subagent_type)
    if not expected_model:
        sys.exit(0)

    explicit_model = tool_input.get("model")

    if explicit_model == expected_model:
        sys.exit(0)

    # Violation: model missing or wrong
    _p.matched = True
    actual = explicit_model or "inherited (Opus)"
    msg = (
        f"MODEL ROUTING VIOLATION: {subagent_type} agent MUST use "
        f'model: "{expected_model}". Got: {actual}. '
        f'Fix: add model: "{expected_model}" to this Agent call. '
        f"This wastes company budget."
    )
    print(json.dumps({"decision": "allow", "message": msg}))


if __name__ == "__main__":
    main()

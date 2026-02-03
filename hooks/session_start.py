#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = []
# ///

"""
Run on every session start

Hook type: SessionStart
"""
import json
import logging
import sys
from pathlib import Path
import os

SCRIPT_DIR = Path(os.environ.get('CLAUDE_PLUGIN_ROOT'))
LOG_FILE = SCRIPT_DIR / "logs" / "session_start.log"

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
    handlers=[logging.FileHandler(LOG_FILE, mode='a')]
)
logger = logging.getLogger(__name__)

def main():
    """Main entry point for the validator."""
    logger.info("=" * 60)
    logger.info("Hook started: session_start")

    try:
        # Read hook input from stdin (if provided)
        try:
            input_data = json.load(sys.stdin)
            logger.info(f"Stdin input received: {json.dumps(input_data)} bytes")
        except (json.JSONDecodeError, EOFError):
            input_data = {}
            logger.info("No stdin input or invalid JSON")

        result = {
          "hookSpecificOutput": {
            "hookEventName": "SessionStart",
            "additionalContext": ""
          }
        }
        logger.info(f"Result: CONTINUE")
        logger.info(json.dumps(result))
        print(json.dumps(result))
        sys.exit(0)
    except Exception as e:
        # On error, allow through but log
        logger.exception(f"Validation error: {e}")
        print(json.dumps({
            "result": "continue",
            "message": f"Validation error (allowing through): {str(e)}"
        }))
        sys.exit(0)


if __name__ == "__main__":
    main()
import os
import subprocess
import json
from datetime import datetime
from typing import Optional

errors_file = os.path.join(os.path.dirname(__file__), "errors.txt")
node_version = os.path.join(os.path.dirname(__file__), "node-version.json")  # Path to your JSON file
timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def run_command(command: str) -> Optional[str]:
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    output, error = process.communicate()
    # Determining what constitutes an "actual error" is hard - depends on the specific command being run and the context
    # In this case, we'll consider any non-empty stderr output to be an error so nothing is missed
    if error:
        with open(errors_file, "a") as f:
            f.write(f"{timestamp} - Error occurred: {error.decode().strip()}\n")
        return None
    return output.decode().strip()

# Fetch all the tags from the remote repository
run_command("git fetch origin --tags")

# Get the latest tag
latest_tag = run_command("git describe --tags $(git rev-list --tags --max-count=1)")

# Load the existing data from the JSON file
with open(node_version, "r") as f:
    data = json.load(f)

# Update the fields in the JSON file
data["lastUpdated"] = timestamp

if latest_tag and latest_tag != data["currentVersion"]:
    checkout_command = f"git checkout {latest_tag}"
    run_command(checkout_command)  # checkout the latest tag
    data["currentVersion"] = latest_tag

# Write the updated data back to the JSON file
with open(node_version, "w") as f:
    json.dump(data, f, indent=4)  # Use indent=4 for pretty-printing

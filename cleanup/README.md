
# dbt Cloud User Management Script

This Python script is designed to interact with the dbt Cloud API to retrieve a list of users associated with an account and deactivate users whose email addresses do not contain '@dbtlabs.com'.

## Features

- **Retrieve Users**: Fetches users from a specified dbt Cloud account and filters out those with emails that do not contain '@dbtlabs.com' and '@fishtownanalytics.com'.
- **Deactivate Users**: Automatically deactivates filtered users in the dbt Cloud account.

## Prerequisites

Before using this script, ensure you have:

- **Python 3.7+** installed on your machine.
- An **API Key** for your dbt Cloud account, which can be a User key or Service token.
- Your **dbt Cloud Account ID**.

## Installation

1. Clone this repository or download the script file.

2. Install the required Python packages:
    ```bash
    pip install requests
    ```

## Usage

Run the script by executing:

```bash
python clean_users.py --host "your-dbt-cloud-host.com" --api-key "your_api_key" --account-id 123456
```

Replace the following with your own values:

- `your-dbt-cloud-host.com`: Your dbt Cloud host (e.g., `cloud.getdbt.com` or `emea.dbt.com`).
- `your_api_key`: Your dbt Cloud API key.
- `123456`: Your dbt Cloud account ID.

## Logging

The script uses Python's built-in logging module to log actions and errors. Logs are printed to the console with timestamps and log levels (INFO, ERROR).

## Error Handling

The script includes error handling for network requests to the dbt Cloud API. In case of a failure (e.g., network issues, incorrect API credentials), an error message will be logged, and the script will continue to execute.

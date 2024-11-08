import requests
import logging
import argparse

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def run_dbt_job(host: str, account_id: int, job_id: int, api_key: str, cause: str = "Triggered via API") -> dict:
    """
    Trigger a dbt Cloud job run via API.

    Args:
        host (str): The dbt Cloud Host, e.g., cloud.getdbt.com or emea.dbt.com
        account_id (int): The dbt Cloud Account ID
        job_id (int): The Job ID to run
        api_key (str): The API Key for the dbt Cloud Account, can be a User key or Service token
        cause (str): The cause of the job run (optional, default is "Triggered via API")

    Returns:
        dict: The response from the API call to run the job
    """
    headers = {"Authorization": f"Token {api_key}"}
    url = f"https://{host}/api/v2/accounts/{account_id}/jobs/{job_id}/run/"

    payload = {"cause": cause}

    try:
        response = requests.post(url, headers=headers, json=payload)
        response.raise_for_status()
        logging.info(f"Successfully triggered job {job_id} on account {account_id}")
        return response.json()
    except requests.RequestException as e:
        logging.error(f"Failed to trigger job {job_id} on account {account_id}: {e}")
        return {}

def main():
    # Set up argument parsing
    parser = argparse.ArgumentParser(description='Run a dbt Cloud job via API.')
    parser.add_argument('--host', required=True, help='The dbt Cloud Host (e.g., cloud.getdbt.com)')
    parser.add_argument('--api-key', required=True, help='The API Key for the dbt Cloud Account')
    parser.add_argument('--account-id', type=int, required=True, help='The dbt Cloud Account ID')
    parser.add_argument('--job-id', type=int, required=True, help='The Job ID to run')
    parser.add_argument('--cause', default="Triggered via API", help='The cause of the job run (optional)')
    args = parser.parse_args()

    # Run the dbt Cloud job
    response = run_dbt_job(
        host=args.host,
        account_id=args.account_id,
        job_id=args.job_id,
        api_key=args.api_key,
        cause=args.cause
    )

    logging.info(f"API Response: {response}")

if __name__ == "__main__":
    main()
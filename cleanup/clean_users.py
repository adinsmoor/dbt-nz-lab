from datetime import datetime
import requests
import logging
import argparse

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def get_nondbt_users(host: str, account_id: int, api_key: str) -> list[dict]:
    """
    Query the dbt Cloud API and return the users without '@dbtlabs.com' in their email.
    
    Args:
        host (str): The dbt Cloud Host, e.g., cloud.getdbt.com or emea.dbt.com
        account_id (int): The dbt Cloud Account ID
        api_key (str): The API Key for the dbt Cloud Account, can be a User key or Service token
    
    Returns:
        list[dict]: The list of users whose emails do not contain '@dbtlabs.com'
    """
    headers = {"Authorization": f"Bearer {api_key}"}
    url = f"https://{host}/api/v3/accounts/{account_id}/users/?limit=100&order_by=last_login"
    
    try:
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        users = response.json()
    except requests.RequestException as e:
        logging.error(f"Failed to fetch users from {url}: {e}")
        return []
    
    filtered_users = [
        {
            'account_id': permission['account_id'],
            'id': permission['id'],
            'user_id': permission['user_id'],
            'email': user['email']
        }
        for user in users.get('data', [])
        if '@dbtlabs.com' not in user.get('email', '')
        for permission in user.get('permissions', [])
    ]
    
    logging.info(f"Number of users retrieved without '@dbtlabs.com' in their email: {len(filtered_users)}")
    return filtered_users

def deactivate_user(user_id: int, permission_id: int, account_id: int, api_key: str, host: str) -> dict:
    """
    Deactivate a user in dbt Cloud with state 2.
    
    Args:
        user_id (int): The internal User ID in dbt Cloud
        permission_id (int): The internal Permission ID in dbt Cloud
        account_id (int): The dbt Cloud Account ID
        api_key (str): The API Key for the dbt Cloud Account, can be a User key or Service token
        host (str): The dbt Cloud Host, e.g., cloud.getdbt.com or emea.dbt.com
    
    Returns:
        dict: The response from the API call to deactivate the user
    """
    headers = {"Authorization": f"Bearer {api_key}"}
    deactivate_url = f"https://{host}/api/v2/accounts/{account_id}/permissions/{permission_id}/"
    payload = {
        "account_id": account_id,
        "id": permission_id,
        "user_id": user_id,
        "state": 2,
    }
    
    try:
        response = requests.post(deactivate_url, headers=headers, json=payload)
        response.raise_for_status()
        logging.info(f"Successfully deactivated user id: {user_id}, account_id: {account_id}, permission_id: {permission_id}")
        return response.json()
    except requests.RequestException as e:
        logging.error(f"Failed to deactivate user id: {user_id}, account_id: {account_id}, permission_id: {permission_id}: {e}")
        return {}

def main():
    # Set up argument parsing
    parser = argparse.ArgumentParser(description='Manage dbt Cloud users.')
    parser.add_argument('--host', required=True, help='The dbt Cloud Host (e.g., cloud.getdbt.com)')
    parser.add_argument('--api-key', required=True, help='The API Key for the dbt Cloud Account')
    parser.add_argument('--account-id', type=int, required=True, help='The dbt Cloud Account ID')
    args = parser.parse_args()

    # Retrieve users without '@dbtlabs.com' in their email
    non_dbt_users = get_nondbt_users(args.host, args.account_id, args.api_key)

    # Deactivate each user
    for user in non_dbt_users:
        logging.info(f"Deactivating user {user['user_id']} ({user['email']}) with permission {user['id']}")
        response = deactivate_user(
            user_id=user['user_id'],
            permission_id=user['id'],
            account_id=user['account_id'],
            api_key=args.api_key,
            host=args.host
        )
        logging.info(f"API Response: {response}")

if __name__ == "__main__":
    main()
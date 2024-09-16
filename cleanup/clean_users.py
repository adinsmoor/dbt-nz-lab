from datetime import datetime
import requests
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')


def get_nondbt_users(host: str,account_id: int , api_key:str):
    """Query a page of the dbt Cloud API and return the users with last login more 
    than a certain number of days ago as well as the total number of users and the last login date for
    all the users in the list.

    Args:
        url (str): The URL to query the dbt Cloud API for users
        headers (dict): Headers for the API Call with the Authorization token

    Returns:
        (list[dict]: The list of users with last login more than a certain number of days ago
        (int): The total number of users in the account, used to know when to stop querying
        (datetime): The last login date for all the users in the list, used to know when to stop querying
    """
    headers = {"Authorization": "Bearer " + api_key}
    url = f"https://{host}/api/v3/accounts/{account_id}/users/?limit=100&order_by=last_login"
    users = requests.get(url, headers=headers).json()
    participant_ids = [
    {
        'account_id': permission['account_id'],
        'id': permission['id'],
        'user_id': permission['user_id'],
        'email' : user['email']
    }
    for user in users['data'] 
    if '@dbtlabs.com' not in user['email']
    for permission in user.get('permissions', [])
]
    return participant_ids


def deactivate_user_with_state(
    user_id: int, permission_id: int, account_id: int, api_key: str, host: str
):
    """Deactivate a user in dbt Cloud with state 2

    Args:
        user_id (int): The internal User ID in dbt Cloud
        permission_id (int): The internal Permission ID in dbt Cloud
        account_id (int): The dbt Cloud Account ID
        api_key (str): The API Key for the dbt Cloud Account, can be a User key or Service token
        host (str): The dbt Cloud Host, e.g. cloud.getdbt.com or emea.dbt.com

    Returns:
        dict: The response from the API call to deactivate the user
    """
    headers = {
        "Authorization": "Bearer " + api_key,
        "state": "2"  # Adding state 2 as a header
    }

    data_deactivate = {
        "account_id": account_id,
        "id": permission_id,
        "user_id": user_id,
        "state": 2,
    }

    response = requests.post(
        f"https://{host}/api/v2/accounts/{account_id}/permissions/{permission_id}/",
        headers=headers,
        json=data_deactivate,
    )
    logging.info(
        f"Deleting user id: {user_id}, account_id: {account_id}, permission_id: {permission_id}"
    )

    return response.json()



HOST = "au.dbt.com"
API_KEY = "dbtc_FuwM9L4-VBx8wQ6bGdrOC9j-jwys17gO6V6jaW2STFaPH8lI34"
ACCOUNT_ID = 146

nondbt_users= get_nondbt_users(HOST,ACCOUNT_ID,API_KEY)

# deactivate_user_with_state(account_id=146,user_id=1758,permission_id=2104,api_key=api_key,host=host)
for user in nondbt_users:
    logging.info(
        f"Deactivating user {user['user_id']} ({user['email']}) with permission {user['id']}"
    )
    response = deactivate_user_with_state(
        user_id=user['user_id'],
        permission_id=user['id'],
        account_id=user['account_id'],
        api_key=API_KEY,
        host=HOST
    )
    logging.info(f"API Response: {response}")
from ditlep import Ditlep
import json
import sys
import argparse

def fetch_dragon_data(search_term):
    try:
        ditlep = Ditlep()
        all_dragons = []
        page_number = 0
        page_size = 20
        total_pages = 107  # Adjust if needed based on API response

        while page_number < total_pages:
            data = ditlep.get_dragons(
                name_or_id=search_term,
                page_number=page_number,
                page_size=page_size
            )
            dragons = data.get("items", [])
            for dragon in dragons:
                print(f"{dragon['id']} - {dragon['name']}")
            all_dragons.extend(dragons)
            page_number += 1
            # Check if there are more pages
            if len(dragons) < page_size:
                break

        # Save results to JSON
        with open('dragon_data.json', 'w') as f:
            json.dump(all_dragons, f, indent=4)
        print("Data saved to dragon_data.json")
        return True
    except Exception as e:
        print(f"Error fetching data: {e}")
        return False

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Fetch dragon data from Ditlep API")
    parser.add_argument("search_term", help="Dragon name or ID to search for")
    args = parser.parse_args()

    if not fetch_dragon_data(args.search_term):
        sys.exit(1)

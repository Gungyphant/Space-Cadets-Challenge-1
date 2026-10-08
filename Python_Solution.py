import selenium.common.exceptions
from selenium import webdriver
from selenium.webdriver.common.by import By
import json
import requests
from PIL import Image
from io import BytesIO


options = webdriver.ChromeOptions()
options.add_argument('--headless')
driver = webdriver.Chrome(options=options)
driver.implicitly_wait(2)


def get_id_data(id: str) -> dict[str, str]:
    """:returns a dict of data for the person with the id"""
    results = {}
    driver.get(f"https://www.ecs.soton.ac.uk/people/{id}")
    try:
        driver.find_element(By.XPATH, r"/html/body/div[3]/div[1]/header/div[2]/div/div[1]/a/img")  # Selenium doesn't tell you what the last error code was; if the ID is invalid, the server returns HTTP 500, so the Chrome error page appears. Any valid page will have this XPATH (the UoS logo), so if it doesn't exist, the ID is invalid
    except selenium.common.exceptions.NoSuchElementException:
        return {}
    results["Name"] = driver.find_element(By.XPATH, r"/html/body/div[3]/div[1]/main/div[7]/div[2]/div[2]/div[1]/h1").text
    full_name_with_bar = driver.find_element(By.XPATH, r"/html/head/meta[10]").get_attribute("content")
    results["Full Name"] = full_name_with_bar[:full_name_with_bar.index("|") - 1]
    results["Description"] = driver.find_element(By.XPATH, r"/html/head/meta[11]").get_attribute("content")
    json_data = json.loads(driver.find_element(By.XPATH, r"/html/head/script[4]").get_attribute("innerHTML"))["@graph"][1]
    results["Job Title"] = json_data["jobTitle"]
    results["Phone Number"] = json_data["telephone"]
    if "image" in json_data:
        results["Photo URL"] = f'https://www.southampton.ac.uk{json_data["image"]["url"].replace("thumbnail", "max_1300x1300")}'
    results["Research Interests"] = [el.get_attribute("innerHTML") for el in driver.find_elements(By.XPATH, r"/html/body/div[3]/div[1]/main/div[9]/div/div/article/section/section/div[2]/div/ul/li")]
    return results


def show_id_data(id: str, show_image: bool=True) -> None:
    """Shows the data for the person with the ID id"""
    data = get_id_data(id)
    if data == {}:
        print("No staff member with that ID can be found")
    else:
        if show_image and "Photo URL" in data:
            image_data = requests.get(data["Photo URL"])
            Image.open(BytesIO(image_data.content)).show()
        print(*[f"{k}: {v}" for k, v in data.items() if k not in ["Photo URL", "Research Interests"]], sep="\n")
        if data["Research Interests"]:
            print("Research Interests:")
            print(*[f"• {interest}" for interest in data["Research Interests"]], sep="\n")


if __name__ == "__main__":
    for id in ["dem", "tsh2n14", "js9g09", "mv1g18", "Invalid ID"]:
        print(f"{show_id_data.__name__}({id}, False)")  # {show_id_data.__name__} is more durable than show_id_data
        show_id_data(id, False)
        print()

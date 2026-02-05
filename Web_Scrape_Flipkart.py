import pandas as pd
import requests 
from bs4 import BeautifulSoup
import time

Product_Name = []
Offered_Prices = []
Actual_Prices = []
Rating = []
Reviews = []
Flipkart_Assured = []

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
}

search_query = "mamaearth" 

for i in range(1, 21):
    url = f"https://www.flipkart.com/search?q={search_query}&page={i}"
    
    try:
        r = requests.get(url, headers=headers, timeout=10)
        soup = BeautifulSoup(r.text, 'lxml')
        
        # We look for the main container
        main_box = soup.find("div", class_="QSCKDh dLgFEE")
        
        items = main_box.find_all("div", class_="RGLWAk") if main_box else soup.find_all("div", class_="RGLWAk")

        if not items:
            print(f"Page {i}: No items found. Flipkart might be throttling or results ended.")
            continue

        for card in items:
            # Full Name 
            name_tag = card.find("a", class_="pIpigb")
            if name_tag:
                full_name = name_tag.get('title')
                Product_Name.append(full_name if full_name else name_tag.text)
            else:
                Product_Name.append("N/A")

            # Rating
            review_tag = card.find("div", class_="MKiFS6")
            Rating.append(review_tag.text if review_tag else "N/A")

            # Reviews
            rev = card.find("span", class_="PvbNMB")
            Reviews.append(rev.text if rev else "N/A")

            # Prices
            off = card.find("div", class_="hZ3P6w")
            Offered_Prices.append(off.text if off else "N/A")

            act = card.find("div", class_="kRYCnD")
            Actual_Prices.append(act.text if act else "N/A")

            # Assured
            assured = card.find("div", class_="FIdGa1")
            Flipkart_Assured.append("Assured" if assured else "N/A")

        print(f"Finished Page {i}. Total Items: {len(Product_Name)}")
        
        time.sleep(3) 

    except Exception as e:
        print(f"Error on page {i}: {e}")

# Save the data
df = pd.DataFrame({
    "Product Name": Product_Name, 
    "Offered_Prices": Offered_Prices, 
    "Actual_Prices": Actual_Prices, 
    "Ratings": Rating, 
    "Reviews": Reviews, 
    "Flipkart_Assured": Flipkart_Assured
})

df.to_csv("Big_Mamaearth_Data.csv", index=False)

print(f"Successfully saved {len(df)} rows to Big_Mamaearth_Data.csv")

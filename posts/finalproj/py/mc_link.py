#!/usr/bin/env python3  Line 1
# -*- coding: utf-8 -*- Line 2
#-----------------------------------------------------------------------------#
# Created By  : Harrison Deford, Dillon Mahmoudi, Alicia Sabatino
# Created Date: 2022-05-01
# version ='1.0'
# ----------------------------------------------------------------------------#
# Grabs link data as a json and stores it locally. 
# See http://mapping.capital/data
# ----------------------------------------------------------------------------#

import requests
import json
import datetime
import time
import logging

# Explicit calls and lgoging
from requests.adapters import HTTPAdapter, Retry
logging.basicConfig(level=logging.DEBUG)

# Create a session to maintain consistency
s = requests.Session()
retries = Retry(total = 10, backoff_factor = 2, status_forcelist = [ 502, 503, 504 ])
s.mount('http://', HTTPAdapter(max_retries=retries))

# Main get request
link_url = requests.get("https://mds.linkyour.city/gbfs/us_md_baltimore/free_bike_status.json")

# Get json
link_data = link_url.json()

# Create filename and write json
link_timestamp = str(datetime.datetime.fromtimestamp(link_data['last_updated']))
link_timestamp = link_timestamp.replace(" ", "_")
link_timestamp = link_timestamp.replace("-", "")
link_timestamp = link_timestamp.replace(":","")
with open("/home/jkgibsongraham/scooters.mapping.capital/data/link/json/" + link_timestamp + "_link.json", "w+") as f:
    f.write(link_url.text)
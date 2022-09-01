""" bronze_to_silver """

import boto3
import logging
import os
from datetime import datetime, date, timedelta as timedelta
import time

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()
logger.setLevel(logging.INFO)

#Fetch environment variables
ndc_env = os.environ['ENV']
src_bucket = os.environ['SOURCE_BUCKET']
src_path = os.environ['SOURCE_PATH']
dest_bucket = os.environ['DEST_BUCKET']
dest_path = os.environ['DEST_PATH']

#Fetch previous day year, month, day for source metadata path
time.tzset()
today = date.today()
# today = datetime.strptime('2021-10-06', '%Y-%m-%d')
logger.info("Todays Date: {}".format(today))
      
def lambda_handler(event, context):
    """ Main lambda handler."""
    
    logger.info(event)

    #Create required AWS Clients
    s3_client = boto3.client('s3', 'ap-southeast-2')

    run_date = today - timedelta(1)
    logger.info("Previous Date: {}".format(run_date))

    # year,month,day=str(run_date)[:10].split('-')
    year,month,day=str(run_date).split('-')
    logger.info("year: {},month: {},day: {}\n".format(year,month,day))

    #Update source path to previous day
    src_path = f"{src_path}/{year}/{month}/{day}/"
    logger.info("src_path: {}".format(src_path))

    #Update source path to previous day
    dest_path = f"{dest_path}/{year}/{month}/{day}/"
    logger.info("dest_path: {}".format(dest_path))

    #Pick reference to s3 objects at source metadata path
    result = s3_client.list_objects(Bucket=src_bucket, Delimiter='/', Prefix=src_path)
    folders = result.get('CommonPrefixes')

    if folders:
        logger.info("blah blah blah")
 
    else:
        logger.info("S3 folder doesn't exist. Batch job not triggerred.")
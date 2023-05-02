#! /usr/bin/env python3

import logging
import pathlib
import sys

logs_path = pathlib.Path("logs")
logs_path.mkdir(parents=True, exist_ok=True)

# log_format = "[%(asctime)s : %(levelname)s : %(name)s : %(pathname)s : %(lineno)s : %(funcName)s] %(message)s"
log_format = "[%(asctime)s:%(levelname)s] %(message)s"
log_datefmt = "%Y-%m-%dT%H:%M:%S%z"
log_filename = logs_path / "{:%Y-%m-%dT%H:%M:%S}.log".format(datetime.now())
logging.basicConfig(
    format=log_format,
    datefmt=log_datefmt,
    filename=log_filename,
    # stream=sys.stdout,
)

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

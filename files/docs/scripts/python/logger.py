#! /usr/bin/env python3

import logging
import sys

log_format = "[%(asctime)s : %(levelname)s : %(pathname)s : %(lineno)s : %(funcName)s] %(message)s"
logging.basicConfig(format=log_format, datefmt="%Y-%m-%dT%H:%M:%S%z", stream=sys.stdout)
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

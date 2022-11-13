#!/usr/bin/env python3

import csv
import datetime

import boto3

from opensearchpy import OpenSearch
from opensearchpy import RequestsHttpConnection
from opensearchpy.helpers import scan
from requests_aws4auth import AWS4Auth


region_name = "us-east-1"
service = "es"
domain_name = "my_domain"

aws = boto3.Session()
credentials = aws.get_credentials()
opensearch = aws.client("opensearch", region_name=region_name)
r = opensearch.describe_domain(DomainName=domain_name)
host = r["DomainStatus"]["Endpoint"]

awsauth = AWS4Auth(
    # access_id=credentials.access_key,
    # secret_key=credentials.secret_key,
    # session_token=credentials.token,
    region=region_name,
    service=service,
    refreshable_credentials=credentials,
)
search = OpenSearch(
    hosts=[{"host": host, "port": 443}],
    http_auth=awsauth,
    use_ssl=True,
    verify_certs=True,
    connection_class=RequestsHttpConnection,
)

match_host = {
    "bool": {
        "should": [
            {"match_phrase": {"ClientRequestHost": "example-1.com"}},
            {"match_phrase": {"ClientRequestHost": "example-2.com"}},
        ],
        "minimum_should_match": 1,
    },
}
match_uri = {"match_phrase": {"ClientRequestURI": {"query": "app/home"}}}
match_ip = {"match": {"ClientIP": {"query": "1.1.1.1"}}}
start = datetime.datetime.now(tz=datetime.timezone.utc)
end = start - datetime.timedelta(days=7)
match_range = {
    "range": {
        "EdgeStartTimestamp": {
            "format": "strict_date_optional_time",
            "gte": start.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
            "lte": end.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
        },
    },
}

search_index = "cloudflare-*"
search_query = {
    "size": 1000,
    "sort": [{"EdgeStartTimestamp": {"order": "desc", "unmapped_type": "boolean"}}],
    "docvalue_fields": [
        {"field": "@timestamp", "format": "date_time"},
        {"field": "EdgeEndTimestamp", "format": "date_time"},
        {"field": "EdgeStartTimestamp", "format": "date_time"},
        {"field": "cloudflare.edge.end.timestamp", "format": "date_time"},
        {"field": "cloudflare.edge.start.timestamp", "format": "date_time"},
        {"field": "cloudflare.origin.response.http.expires", "format": "date_time"},
        {"field": "cloudflare.origin.response.http.last_modified", "format": "date_time"},
        {"field": "event.end", "format": "date_time"},
        {"field": "event.start", "format": "date_time"},
    ],
    "query": {
        "bool": {
            "must": [
                match_host,
                match_uri,
                match_ip,
                match_range,
            ],
            "filter": [{"match_all": {}}],
            "should": [],
            "must_not": [],
        }
    },
}
fields = [
    "EdgeStartTimestamp",
    "EdgeEndTimestamp",
    "ClientIP",
    "ClientDeviceType",
    "ClientRequestProtocol",
    "ClientRequestMethod",
    "ClientRequestHost",
    "ClientRequestURI",
    "ClientRequestReferer",
    "ClientRequestUserAgent",
    "OriginResponseStatus",
]

items = [*scan(search, query=search_query, index=search_index)]
with open("result.csv", mode="w", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fields)
    writer.writeheader()
    for item in items:
        writer.writerow({k: item["_source"][k] for k in fields})

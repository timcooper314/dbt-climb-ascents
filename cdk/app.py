#!/usr/bin/env python3
import os
import aws_cdk as cdk
from dbt_sector_stack import DbtSector


STAGE = os.environ.get("STAGE", "dev")
AWS_ACCOUNT_ID = os.environ.get("AWS_ACCOUNT_ID", "646975365807")
AWS_REGION = os.environ.get("AWS_DEFAULT_REGION", "ap-southeast-2")


app = cdk.App()

stack_name = f"{STAGE}-dbt-sector-tc"
env = cdk.Environment(account=AWS_ACCOUNT_ID, region=AWS_REGION)

sonia_ingestion = DbtSector(
    app,
    stack_name,
    env=env,
    app_context=STAGE,
)

app.synth()

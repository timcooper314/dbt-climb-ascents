from aws_cdk import (
    Stack,
    Duration,
    aws_iam as iam,
    aws_glue as glue,
    aws_s3 as s3,
)
from constructs import Construct


class DbtSector(Stack):
    def __init__(
        self,
        scope: Construct,
        construct_id: str,
        app_context: str,
        **kwargs,
    ) -> None:
        super().__init__(scope, construct_id, **kwargs)

        resource_group = "dbt-sector"
        stack_parameters = dict(self.node.try_get_context(app_context))
        account_id = stack_parameters["AccountID"]
        s3_targets = stack_parameters["S3TargetPaths"]

        raw_seeds_data_bucket = s3.Bucket(
            self,
            "DbtSectorRawSeedsBucket",
            bucket_name=f"{app_context}-{resource_group}-raw-seeds",
            access_control=s3.BucketAccessControl.BUCKET_OWNER_FULL_CONTROL,
            encryption=s3.BucketEncryption.S3_MANAGED,
            versioned=True,
        )

        ###############################################
        #          Glue Database                      #
        ###############################################
        database_name = f"{app_context}_{resource_group.replace('-', '_')}"
        glue_database = glue.CfnDatabase(
            self,
            "AthenaDatabase",
            catalog_id=account_id,
            database_input=glue.CfnDatabase.DatabaseInputProperty(
                name=database_name,
                # description=f"Database for {resource_group.title().replace('-', ' ')}",
            ),
        )

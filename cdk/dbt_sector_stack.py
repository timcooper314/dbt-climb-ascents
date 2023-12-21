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

        glue_crawler_role = iam.Role(
            self,
            "CrawlerRole",
            role_name=f"{app_context}{resource_group.title().replace('-', '')}CsvSeedsCrawlerRole",
            assumed_by=iam.ServicePrincipal(service="glue.amazonaws.com"),
            managed_policies=[
                iam.ManagedPolicy.from_managed_policy_arn(
                    self,
                    "GlueServiceRole",
                    managed_policy_arn="arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole",
                )
            ],
        )
        raw_seeds_data_bucket.grant_read(glue_crawler_role)
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
        ###############################################
        #          Glue Crawler                       #
        ###############################################
        csv_classifier = glue.CfnClassifier(
            self,
            "CsvClassifier",
            csv_classifier=glue.CfnClassifier.CsvClassifierProperty(
                name=f"{app_context}-dbt-sector-seeds-csv-classifier",
                delimiter=",",
                quote_symbol='"',
                contains_header="PRESENT",
                allow_single_column=False,
                disable_value_trimming=False,
            ),
        )
        glue_crawler = glue.CfnCrawler(
            self,
            "GlueCrawler",
            name=f"{app_context}-{resource_group}-crawler",
            role=glue_crawler_role.role_arn,
            targets=glue.CfnCrawler.TargetsProperty(
                s3_targets=[
                    glue.CfnCrawler.S3TargetProperty(
                        path=f"s3://{raw_seeds_data_bucket.bucket_name}/{s3_path}",
                    )
                    for s3_path in s3_targets
                ]
            ),
            database_name=database_name,
            schema_change_policy=glue.CfnCrawler.SchemaChangePolicyProperty(
                delete_behavior="LOG", update_behavior="UPDATE_IN_DATABASE"
            ),
            configuration='{"Version":1.0,"CrawlerOutput":{"Partitions":{"AddOrUpdateBehavior":"InheritFromTable"},"Tables":{"AddOrUpdateBehavior":"MergeNewColumns"}}}',
            classifiers=[f"{app_context}-dbt-sector-seeds-csv-classifier"],

        )

# AWS Relational Database Service 

Using terraform to create an Amazon Aurora database service, running this script will create a db cluster, instance database and a security group. I have set it as a private database but you can go in and change it so its publicly available.

The engine has been set to use the mySQL, if you wish to change to PostgreSQL use "aurora-postgresql" instead. 
There is no up-front price for running an RDS as they go for a the pay as you go policy. The prices are based on your instance and how much its used. You can check here for more details: https://aws.amazon.com/rds/aurora/pricing/  

# Policys 
Below are the exact policys you will need to run the scipts otherwise just use the Full Access policy:

        RDS:
        DescribeDBClusterParameterGroups
        DescribeDBClusterParameters
        DescribeDBEngineVersions
        DescribeDBInstances
        DescribeDBParameterGroups
        DescribeDBParameters
        DescribeDBSubnetGroups
        DescribeOptionGroupOptions
        DescribeOptionGroups
        DescribeOrderableDBInstanceOptions
        AddTagsToResource
        CreateDBInstance
        DeleteDBInstance

        rds:CreateDBSubnetGroup
        rds:DescribeDBClusters
        rds:CreateDBCluster
        rds:DeleteDBCluster

        IAM:
        CreateServiceLinkedRole
        DeleteServiceLinkedRole


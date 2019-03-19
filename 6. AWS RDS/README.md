# AWS Relational Database Service 

Using terraform to create an Amazon Aurora database service, running this script will create a db cluster, instance database and a security group. I have set it as a private database but you can go in and change it so its publicly available.

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


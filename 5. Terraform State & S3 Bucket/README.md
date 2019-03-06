# Terraform State

Terraform stores the infrastructure and configurations in a ".tfstate file". Here 
is where your terraform resources are stored and configured, it also allows terraform to keep 
track of metadata and improve performance in large infrastructures.

The state is written in json format and editing the state directly in anyway is not recommended.

The state is created by default every time the team or you run a "terraform apply".

# State Locking
When an operation occurs such as when doing an "apply", which will cause the state to become locked, this prevents other operations
from using the state or corrupting it. An example being when one or more team members are
working with the same state and someone applies an operation. The other team member cant intervine saving allowing the new state to be created or updated 
without interference.

Disabling the lock is not recommended as this will increase the chances or someone corrupting the state when two members do an operation.

# Storing the State
Terraform can have the state stored using a "backend" resource which will determine how the state is uploaded and
how the operation is applied. 

Using an Amazon S3 will keep the state persisted throughout operations, it will also be easy access in teams if someone had to take over or make a change.


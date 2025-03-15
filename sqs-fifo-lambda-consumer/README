# SQS FIFO and Lambda Consumer

I created two lambdas: 

1. *Producer*: Create 50 messages in a SQS FIFO, in five requests with 10 messages (This is a limit from SQS, 10 message by request).
2. *Consumer*: Read Messages by SQS and print information in logs. This lambda use Event Trigger SQS. 


I try use Group Id from FIFO SQS for segregate consumers. However, The pattern to SQS as 'one by consumer', and filters in Event trigger delete messages doesn't no met with filter. 



##  Execute project 

To execute this project: 

1. Configure backend in `envs/<env>/backend.conf`
2. Define variables at `envs/<env>/terraform.tfvars`
3. Put in your terminal env vars to AWS access ou configure your profile in `provider "aws"` at `backend-provider.tf`.
4. Run command `  terraform init --backend-config=envs/<env>/backend.conf` to configure terraform.
5. Run ` terraform plan -var-file=envs/dev/terraform.tfvars` to seen creation plan.
6. Run `terraform apply -var-file=envs/dev/terraform.tfvar` to create resources. 
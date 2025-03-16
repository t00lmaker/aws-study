# SQS FIFO and Lambda Consumer

I created two lambdas: 

1. *Producer*: Create 50 messages in a SQS FIFO, in five requests with 10 messages (This is a limit from SQS, 10 message by request).
2. *Consumer*: Read Messages by SQS and print information in logs. This lambda use Event Trigger SQS. 


I tried use MessageGroupId from FIFO SQS for separated consumers using filters at sqs trigger event, I thought the messages return to sqs when not match any filter, but not. The message are delete messages doesn't match with any filter. The pattern SQS is 'one by consumer'. 

### What the hell is this MessageGroupId for?

The answer is simple: Parallelism. 
In FIFO SQS order is important, for default one consumer get group N message by time, next N message are processed when previews group finish. 
When we use MessageGroupId, SQS groups messages and orders into groups, allowing multiple consumers to consume different groups at the same time. Each consumer can receive messages from a group in an orderly manner.

### Check if it works

Filter message contains id execution from procedure, return messages from same produce execution (j = 1..5 and i=1..10 = 5 requests with 10 messages).  
Note, to sort by timestamp, different consumer_execution_id alternation is indication parallel execution in different groups. 

>timestamp != @timestamp

```
fields timestamp, consumer_execution_id, group_id, j, i
| filter @message like /3568cdb8-fdd7-4fb8-b4f9-0289189e0d31/
| sort timestamp asc
| limit 150
```
Occasionally one execution get messages from different groups.  

If you filter by group, see order with attributes j and i.
```
fields timestamp, consumer_execution_id, group_id, j, i
| filter @message like /3568cdb8-fdd7-4fb8-b4f9-0289189e0d31/
| filter group_id = 'group1'
#| filter consumer_execution_id like /a53f22b6-8ea9-58bb-ba6a-42e686200e8f/
| sort timestamp asc
| limit 150

```

The message are consumer by order generation. 


##  Execute project 

To execute this project: 

1. Configure backend in `envs/<env>/backend.conf`
2. Define variables at `envs/<env>/terraform.tfvars`
3. Put in your terminal env vars to AWS access ou configure your profile in `provider "aws"` at `backend-provider.tf`.
4. Run command `  terraform init --backend-config=envs/<env>/backend.conf` to configure terraform.
5. Run ` terraform plan -var-file=envs/dev/terraform.tfvars` to seen creation plan.
6. Run `terraform apply -var-file=envs/dev/terraform.tfvar` to create resources. 
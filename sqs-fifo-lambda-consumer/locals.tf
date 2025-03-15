locals {
   producer_zip_path = "${path.module}/lambdas/producer/producer_code.zip"
   producer_code_path = "${path.module}/lambdas/producer/code"
   
   consumer_zip_path = "${path.module}/lambdas/consumer/consumer_code.zip"
   consumer_code_path = "${path.module}/lambdas/consumer/code"
}
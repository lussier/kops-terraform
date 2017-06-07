# kops-terraform

This Terraform file implements the prerequisites to deploying a Kubernetes cluster with kops on AWS.

## Assumptions

We assume you own a domain and already have an hosted zone in Route 53 for it.

## What it does

It creates:

1. An hosted zone for the subdomain.

2. The NS records for the subdomain in the parent domain hosted zone.

3. The `kops` state S3 bucket.

It then outputs a sample `kops create cluster` that can be executed.

## Usage

1. Edit `terraform.tfvars`. You need to supply the name of your AWS profile, the region in which you want to create the S3 bucket, and the subdomain that will become the name of our Kubernetes cluster.

2. Execute `terraform plan` and validate the output. This command executes read-only calls on AWS, it won't make any change.

3. Execute `terraform apply`.

4. You can use the sample `kops` command provided in output to initiate the creation of the cluster.

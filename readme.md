```bash
terraform init
terraform apply
terraform destroy
```


Access private instance through bastion host with ssh forwarding
```bash
chmod 400 tf_demo.pem
ssh -A -i tf_demo.pem ec2-user@18.140.65.208
```

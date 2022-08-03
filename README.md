# Lacework Testing Scripts

## Summary
These scripts allow for easy testing against both:

- Control planes such as AWS and K8s
- Workloads (containers, VMs, etc)

A strong security program should include detection of:

- *Signature-based* (known-bad) detections for common attacks AND
- *Anomalous behaviors* that cannot be caught by signature detections only

It is very important to treat a test as real-world as possible.  In other words, launching an attack against yourself should always be done on hosts running real workloads, with existing baselined traffic.


## AWS Testing Scenarios

<span style="background-color: #FFFF00">Important Note: Anomaly detection needs existing baseline data to work, pick credentials that are already used for regular day-to-day traffic.</span>

| Script<br/><img src="https://upload.wikimedia.org/wikipedia/commons/c/c0/Blank.gif" height="1" width="300"> | Alerting Types<br/><img src="https://upload.wikimedia.org/wikipedia/commons/c/c0/Blank.gif" height="1" width="300"> | Instructions |
| ------ | -------------- | ------------ |
| [aws-recon.sh](./aws-recon.sh) | ✅ Anomaly<br/>✅ Policy | Dependencies: `aws` cli tool.<br/><br/>Using *an existing IAM user* or on an instance provisioned with an instance profile known to Lacework, you may execute this script to generate a high volume of (read-only) API calls to AWS across many different services (EC2, Secrets Manager, RDS, IAM, KMS).  Depending on the permissions of your user, you will see either anomaly-only alerts, OR anomalies + policy alerts if this activity generates a high number of access-denied errors.<br/><br/>To provide permissions to the `aws` cli tool, either run this from an EC2 host with privileges assigned as an instance profile, OR run this script with environment variables set for some combination of `AWS_PROFILE`, or `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`. |
| [aws-iam-s3-activity.sh](./aws-iam-s3-activity.sh) | ✅ Anomaly<br/>✅ Policy | Dependencies: `aws` cli tool.<br/><br/>Using *an existing IAM user* or on an instance provisioned with an instance profile known to Lacework, you may execute this script to generate activity in the form of creating an IAM user, assigning policy, creating and uploading content to an S3 bucket, and deleting the S3 bucket, and IAM user.  This will require administrator level permissions. The alerts generated will be a combination of policy & anomaly based alerts. <br/><br/>To provide permissions to the `aws` cli tool, either run this from an EC2 host with privileges assigned as an instance profile, OR run this script with environment variables set for some combination of `AWS_PROFILE`, or `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`. |

## Workload Testing Scenarios

<span style="background-color: #FFFF00">Important Note: Anomaly detection needs existing baseline data to work, pick hosts that are already used for regular day-to-day traffic.</span>

| Script<img src="https://upload.wikimedia.org/wikipedia/commons/c/c0/Blank.gif" height="1" width="300"> | Alerting Types<br/><img src="https://upload.wikimedia.org/wikipedia/commons/c/c0/Blank.gif" height="1" width="300"> | Instructions |
| ------ | -------------- | ------------ |
| [reverse-shell.sh](./reverse-shell.sh) | ✅ Anomaly<br/>✅ Policy | Running this script will provide a step-by-step guide on establishing a reverse shell from a target host to an attacker's host.  There are no dependencies. Customers often use this as a starting point to run further tests. |
| [xmrig.sh](./xmrig.sh) | ✅ Policy | This will download and run a cryptocurrency miner. It is not configured to mine anything, but it will establish the same connections an actual miner would make to a backend mining pool. Run this script and let it execute for a few minutes. The events to expect will be critical malware and critical known-bad external host. |
| [data-exfil.sh](./data-exfil.sh) | ✅ Anomaly | Running this script will create a ~50mb temporary file and upload it to a pastebin-equivalent site.  Make sure this is run on a host that Lacework has already baselined thoroughly.  This should trigger an anomalous external connection.  Use in conjunction with other scripts and reverse shells to simulate a wider attack. |
| [port-scan.sh](./port-scan.sh) | ✅ Anomaly<br/>✅ Policy | Running this script will provide some directions on running a port scan from an internal host.<br/><br/>TIP: Try running this after obtaining a reverse shell using the above directions. |
| [Testing Appliance](https://github.com/lacework-community/reverse-shell-simulation-app) | Special | This is a nodejs app for testing, which can be run an environment Lacework is instrumenting.  The app is designed to be browser-accessible, and noisy on the network. After 3 hours it enables a faux-reverse shell to execute commands on the remote server.  From here, one may establish a genuine reverse shell, and / or run commands directly.  It is a good stand-in for testing Lacework in an environment where there are no good candidate workloads to "attack". |

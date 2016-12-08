Treeherder 
==========
Supporting infrastructure for the Treeherder Heroku environments.

- Dev accounts and policies for managing resources
- RDS instances

SSL 
---
RDS instances supporting Heroku apps need to be publicly available currently, so all
connections are required to use SSL. After creating a new RDS instances, configure the
master account to require SSL, per https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP\_MySQL.html#MySQL.Concepts.SSLSupport:

Download the [RDS CA bundle](https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem)

Connect securely to the RDS instance:
- mysql client &lt;5.6.30 or 5.7.0-5.7.10
  **Don't' use, vulnerable to MITM! (CVE-2015-3152)**
- mysql client 5.6.30+
  $ mysql -h host -u username -p --ssl-mode=REQUIRED --ssl-verify-server-cert --ssl\_ca=rds-combined-ca-bundle.pem
- mysql client 5.7.11+
  $ mysql -h host -u username -p --ssl-mode=VERIFY\_IDENTITY --ssl\_ca=rds-combined-ca-bundle.pem

Once connected, configure future connections to only be accepted over SSL:
mysql> GRANT USAGE ON *.* TO 'username'@'%' REQUIRE SSL;

Thereafter, always connect to mysql using SSL, using the same commands as above.
NB: Even with `REQUIRE SSL` set, client connections are still vulnerable to leaking
credentials via MITM, unless the appropriate `--ssl-mode` option is used.

Parameter groups 
----------------
Some parameters may be modified dynamically, while others are static and thus require a reboot to apply. Static params must have 'apply\_method' set to 'pending-reboot', rather than the default of 'immediate'.

A quick and dirty query to list all static params:
$ aws rds describe-db-parameters --db-parameter-group-name default.mysql5.6 | jq -r '.Parameters | map([.ParameterName, .ApplyType] | join(", "))' | grep static


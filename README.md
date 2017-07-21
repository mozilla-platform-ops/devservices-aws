DevServices AWS Account Configuration
=============================================

[![Build Status](https://travis-ci.org/mozilla-platform-ops/devservices-aws.svg?branch=master)](https://travis-ci.org/mozilla-platform-ops/devservices-aws)

https://moz-devservices.signin.aws.amazon.com/console

Requirements
------------
- Terraform v0.7.12+
- AWS CLI
- AWS credentials
- (optional) [MFA helper scripts](https://github.com/mozilla-platform-ops/aws\_mfa\_scripts)
- (optional) [Shellcheck](https://github.com/koalaman/shellcheck)

Layout
------
Terraform configurations are split up into individual environments to minimize potential
impact on other areas and to make the configs easier to understand. 

There are three terraform config files at the top level that are symlinked into each
environment:
- `initialize.tf`: Empty variable declarations that must be defined in each environment.
- `resources.tf`: Data resource types that may be referenced elsewhere.
- `variables.tf`: Global variables that may be used in an environment (e.g. CentOS 7 AMIs).

The `base` environment is for global or shared resources that may be used by other areas. It
includes terraform's remote state S3 bucket, the bastion host config, Route53 top levevl
records, and some IAM users, roles, and policies. 

Each environment will have a variety of terraform configuration files; they are generally
split up by AWS resource type to make it easier to read and find things. Additionally, 
there should be an `init.sh` script which will configure terraform remote state for the
environment and update any modules in use.

Testing
-------
To test changes locally ensure Terraform and Shellcheck are on the PATH, then run:
```bash
$ ./runtests
```

Working with remote state
-------------------------
Terraform's [remote state feature](https://www.terraform.io/docs/state/remote/index.html)
allows easier collaboration and promotes better security practices by not commiting the
tfstate files to the repo. However, when using S3 as we do, there is no remote locking
provided, so care must be taken. When working on the `base` environment or collaborating
on other env, it is important to communicate with colleagues to prevent Bad Things(tm)
from happening. 

Setting up a new environment
--------------------------
1. Create a new directory for the environment (e.g. `mkdir foo`). If there will be dev,
staging, and/or production environments, that should be included in the name (e.g. `foo-dev`).
2. Symlink the three top level tf files and `init.sh` into the directory.
```bash
cd foo
for i in ../*.tf ../init.sh; do ln -s $i .; done
```
3. Create a `terraform.tfvars` file that satifies the emtpy variables in `initialize.tf`. Note: env should match the directory name.
4. Run `init.sh` to enable remote state.

Conventions used
----------------
- Tagging: All terraform resources that support tags should have them. See
  https://mana.mozilla.org/wiki/display/DEVSERVICES/Resource+Tagging for details.
- Route53: https://mana.mozilla.org/wiki/display/DEVSERVICES/Using+mozops.net+for+FQDNs

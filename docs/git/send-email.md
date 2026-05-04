# Setting Up Git Send-Email 

This guide provides instructions for configuring `git send-email` to send patch emails directly from the command line.

## Prerequisites

You need Perl and CPAN installed.

## Installation

### 1. Install Cpanminus (CPAN package manager)

Cpanminus is a simpler alternative to the traditional CPAN shell:

```bash
cpan -i App::cpanminus
```

### 2. Install Required Perl Modules

Install the necessary modules for SMTP authentication and SSL support:

```bash
cpanm --notest Authen::SASL Net::SMTP::SSL MIME::Base64
```

The `--notest` flag skips running tests, which speeds up installation.

## Usage

Send a patch via email:

```bash
git send-email --to recipient@example.com patches/
```

## References

- [git send-email documentation](https://git-scm.com/docs/git-send-email)

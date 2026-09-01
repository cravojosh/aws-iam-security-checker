# AWS IAM Security Checker

This project is intentionally designed as a simplified proof of concept. Production implementations would require additional analysis before determining whether an IAM configuration represents an actual security risk.

A PowerShell proof-of-concept security tool designed to analyze AWS IAM user configurations and identify common identity and access management security weaknesses.

The project currently uses simulated IAM data to demonstrate the detection logic without requiring access to a live AWS environment.

## Overview

The analyzer processes simulated AWS IAM user data and applies basic security checks to identify potential access control weaknesses.

`
Mock AWS IAM Data
        ->
 PowerShell Analyzer
        ->
 Security Checks
        ->
 Security Findings
        ->
Severity Classification
        ->
 Security Summary
`

## Security Checks

The current implementation checks for:

| Detection | Description | Severity |
|---|---|---|
| Administrator Access | Identifies IAM users assigned AdministratorAccess | Critical |
| MFA Not Enabled | Identifies IAM users without MFA enabled | Critical |
| Inactive IAM User | Identifies users with no activity for more than 90 days | Medium |

## Project Structure

```text
aws-iam-security-checker/
│
├── MockData/
│   └── iamUsers.json
│
├── Analyze-AWSIAM.ps1
│
└── README.md
```

## Example Output

```text
=============================================
        AWS IAM SECURITY CHECKER
=============================================

User                 Detection
----                 ---------
admin-user           Administrator Access
admin-user           MFA Not Enabled
old-user             Inactive IAM User
developer-user       Administrator Access
developer-user       MFA Not Enabled

Security Findings: 5
Critical: 4
High:     0
Medium:   1
```

## Production Implementation

The current project uses mock JSON data to provide a controlled environment for testing the security detection logic.

In a production implementation, the data collection layer could be replaced with AWS APIs and security services such as:

- AWS IAM
- AWS CloudTrail
- AWS Security Hub
- AWS Config

The analyzer could then be expanded upon to evaluate real IAM users, policies, authentication activity, and account configuration.

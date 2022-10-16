# aws-federation-github-actions

![alt text](docs/aws-federation.png)

> Terraform Modules for setting up AWS Federated access from Github Actions.

GitHub Action has a functionality that can [issue an OpenID Connect token](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect) to jobs running on Github Actions. This obviates the need to store any long-lived secrets in Github.

## Usage

### Configure AWS

First, we need to set up an AWS IAM OIDC identity provider and an AWS IAM role that Github Actions can assume. This can be done by using this module as shown below:

```hcl
module "aws_federation_github_actions" {
  source = "github.com/rpidanny/aws-federation-github-actions?ref=v1"

  github_org  = "rpidanny"
  github_repo = "example-repo"

  iam_role_name   = "ExampleGithubRole"
  iam_policy_arns = [data.aws_iam_policy.AdministratorAccess.arn]

  tags = local.tags
}
```

With this deployed, any jobs in `rpidanny/example-repo` can now assume the IAM Role created above.

The `github_org` and `github_repo` ensures that only the repo you specify here can assume the role.

**Note:** If you don't pass in `github_repo`, any repo in your Github Organization will be able to assume the role. This is useful when you want to grant all your organization's repo access to aws.

### Configure GitHub Actions Workflow

Now, this is how you would configure your Github Actions workflow to gain access to AWS.

```yml
# .github/workflows/example.yml
name: Example Job

on:
  push:

env:
  AWS_REGION: eu-central-1

jobs:
  aws-access:
    name: "AWS Access"
    runs-on: ubuntu-latest
    timeout-minutes: 5

    # This is the block you would need to add.
    permissions:
      id-token: write # This is required for requesting the JWT

    steps:
      - name: configure aws credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          role-to-assume: arn:aws:iam::0123456789012:role/ExampleGithubRole
          aws-region: ${{ env.AWS_REGION }}

      - run: aws sts get-caller-identity
```

## Example

An example integration can be found here: [examples/dog_food](examples/dog_food)

## Module Inputs

| Name            | Description                                                                                  | Type           | Default | Required |
| --------------- | -------------------------------------------------------------------------------------------- | -------------- | ------- | :------: |
| github_org      | Name of the github organization you want to allow access to.                                 | `string`       | n/a     |   yes    |
| github_repo     | Name of the github repo you want to allow access to. Default will grant access to all repos. | `string`       | `''`    |    no    |
| iam_role_name   | Name of the IAM role you want to allow access to assume.                                     | `string`       | n/a     |   yes    |
| iam_policy_arns | List of IAM policy ARNs that is attached to the IAM role.                                    | `list(string)` | `[]`    |    no    |
| tags            | Resource tags.                                                                               | `map(string)`  | `{}`    |    no    |

## Module Outputs

| Name                        | Description                         |
| --------------------------- | ----------------------------------- |
| iam_openid_connect_provider | The created OpenId Connect provider |
| iam_role                    | The created IAM Role                |

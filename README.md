# cancel-gh-workflow
Cancel the selected workflow actions for a faster feedback.

# Use-case:

## For example:

Your github repo have two github actions workflow files `node-test.yml` and `django-test.yml` run simultaneously triggered on `pull_request` 

If the `node-test.yml` workflow is failed, you don't want to continue the workflow run with `django-test.yml`

# Usage

### node-test.yml

Here if the job failed for `node-test.yml`, the action will cancel all the jobs running by the `django-test.yml` workflow

```yaml

name: Node CI Test

on:
  pull_request:
    types:
      - opened
      - reopened
      - synchronize
      - ready_for_review
jobs:
  job-1:
    name: Run node job1
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v2

    - name: Extract branch name
      id: extract_branch
      run: echo "##[set-output name=branch;]$(echo ${GITHUB_REF#refs/heads/})"

    - run: exit 1

    - uses: vishnudxb/cancel-gh-workflow@v1.3
      if: failure()
      with:
        repo: octocat/hello-world
        branch_name: ${{ steps.extract_branch.outputs.branch }}
        workflow_file_name: django-test.yml
        access_token: ${{ github.token }}

```

### django-test.yml

Here if the job failed for `django-test.yml`, the action will cancel all the jobs running by the `node-test.yml` workflow

```yaml

name: Django CI Test

on:
  pull_request:
    types:
      - opened
      - reopened
      - synchronize
      - ready_for_review

jobs:
  job-1:
    name: Run django job1
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v2

    - name: Extract branch name
      id: extract_branch
      run: echo "##[set-output name=branch;]$(echo ${GITHUB_REF#refs/heads/})"

    - run: exit 1

    - uses: vishnudxb/cancel-gh-workflow@v1.3
      if: failure()
      with:
        repo: octocat/hello-world
        branch_name: ${{ steps.extract_branch.outputs.branch }}
        workflow_file_name: node-test.yml
        access_token: ${{ github.token }}

```


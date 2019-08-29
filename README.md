# or-cloud
OR-Cloud is a platform for analytical processing on commodity cloud infrastructure.

1.  Requirements
    - [Setup the AWS commandline interface and your credentials.](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) 

    - [Install Homebrew.](https://docs.brew.sh/Installation)

    - Install Terraform: `brew install terraform`

    - Install Packer: `brew install packer`

2. Build and stand up OR-Cloud:

    `./bin/stand-up.sh`

3. Tear down the infrastructure.

    `./bin/tear-down.sh`

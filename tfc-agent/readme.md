# Configure TFC (Terraform Cloud) agent

## Install the agent on the VSI

1. Create a VPC with SSH access in the Security Groups Rules

1. Create an Ubuntu VSI with public SSH key

1. ssh @158.177.14.154
```sh
ssh -i ~/.ssh/id_rsa.pub ubuntu@158.177.14.154
```

```sh
sudo mkdir -p /opt/tfc-agent
cd /opt/tfc-agent
sudo curl -LO "https://releases.hashicorp.com/tfc-agent/1.21.0/tfc-agent_1.21.0_linux_amd64.zip"
```

1. Ensure unzip is installed:
```sh
sudo apt update && sudo apt install unzip -y
```

1. Unzip the Terraform Cloud Agent
```sh
sudo unzip tfc-agent_1.21.0_linux_amd64.zip
```

1. Move the Binary to /usr/local/bin/
```sh
sudo mv tfc-agent /usr/local/bin/
sudo mv tfc-agent-core /usr/local/bin/
sudo chmod +x /usr/local/bin/tfc-agent /usr/local/bin/tfc-agent-core
```

1. Control the installation
```sh
ubuntu@vsi-tfc-agent:/opt/tfc-agent$ tfc-agent version
Agent version: 1.21.0
Core version: 1.21.0
```

## Create an agent in Terraform Cloud

1. Create an agent pool `ibmcloud-tfc-agent-pool` in [Terraform Cloud](https://app.terraform.io/app/lionelmace/settings/agents)

1. Create an agent token `ibmcloud-tfc-agent-token`

1. Copy the token

1. Create a systemd service file to run the agent automatically
```sh
sudo tee /etc/systemd/system/tfc-agent.service <<EOF
[Unit]
Description=Terraform Cloud Agent
After=network.target

[Service]
ExecStart=/usr/local/bin/tfc-agent -token="<YOUR_AGENT_TOKEN>"
Restart=always
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOF
```

1. Start and Enable the Terraform Cloud Agent
```sh
sudo systemctl daemon-reload
sudo systemctl enable tfc-agent
sudo systemctl start tfc-agent
```

1. Check if the agent is running
```sh
sudo systemctl status tfc-agent
```

Output should be

```sh
Mar 26 15:29:45 vsi-tfc-agent systemd[1]: Started tfc-agent.service - Terraform Cloud Agent.
Mar 26 15:29:45 vsi-tfc-agent tfc-agent[4337]: 2025-03-26T15:29:45.947Z [INFO]  agent: Starting: agent_version=1.21.0 os=linux arch=amd64
Mar 26 15:29:45 vsi-tfc-agent tfc-agent[4337]: 2025-03-26T15:29:45.977Z [INFO]  core: Starting: version=1.21.0
Mar 26 15:29:46 vsi-tfc-agent tfc-agent[4337]: 2025-03-26T15:29:46.871Z [INFO]  core: Agent registered successfully with HCP Terraform: a>
Mar 26 15:29:48 vsi-tfc-agent tfc-agent[4337]: 2025-03-26T15:29:48.162Z [INFO]  agent: Newer core versions are available, but are ignored>
Mar 26 15:29:48 vsi-tfc-agent tfc-agent[4337]: 2025-03-26T15:29:48.162Z [INFO]  agent: Core version is up to date: version=1.21.0
Mar 26 15:29:48 vsi-tfc-agent tfc-agent[4337]: 2025-03-26T15:29:48.163Z [INFO]  core: Waiting for next job
```

Your Terraform Cloud Agent is running. Now, let’s install kubectl on the agent so it can be used in Terraform Cloud.

## Install kubectl in TF Agent

1. Install kubectl on the VSI

```sh
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/local/bin/
sudo chmod +x /usr/local/bin/kubectl
```

1. Verify the installation

```sh
$ kubectl version --client
Client Version: v1.32.3
Kustomize Version: v5.5.0
```

1. Add kubectl to Terraform Cloud Agent's Path

1. Edit the Terraform Cloud Agent service so it can use kubectl

```sh
sudo nano /etc/systemd/system/tfc-agent.service
```

1. Find the [Service] section and add this line
```sh
Environment="PATH=/usr/local/bin:/usr/bin:/bin"
```

1. Reload the service
```sh
sudo systemctl daemon-reload
sudo systemctl restart tfc-agent
sudo systemctl status tfc-agent
```

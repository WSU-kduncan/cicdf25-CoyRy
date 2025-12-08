## Part 1:
1. EC2 instance details
    * AMI information: ami-0ecb62995f68bb549 ubuntu
    * Instance typeL t2.medium
    * Volume Size: 30GB
    * Security Group configuration
    * Security Group configuration justification / explanation

2. Docker Setup on OS on the EC2 instance
    * How to install Docker for OS on the EC2 instance:
    `sudo apt install docker.io`
    * Additional dependencies based on OS on the EC2 instance:
    bridge-utils containerd dns-root-data dnsmasq-base pigz runc ubuntu-fan
    * How to confirm Docker is installed: `docker version`
    * How to confirm OS can run containers: `docker run hello-world`
        

3. Testing on EC2 Instance
    * How to pull container image from DockerHub repository: `docker pull coyryan/elden-cake:latest`
    * How to run container from image: `docker run -it -p 8080:80 coyryan/elden-cake:latest`
        * Flag Recommendation: Use the `-d`  and `--restart=always` flags once testing is complete. The `-it` flag is only for interactive debugging.
    * How to verify that the container is successfully serving the web application: `http://18.215.182.80:8080/` visit the website in browser. * this is temp ip haven't given it static ip yet"

4. Scripting Container Application Refresh

    * Description of the bash script: The refresh_container.sh script automates the deployment cycle by stopping/removing the old container, pulling the newest latest image from DockerHub, and starting a new container with persistent restart flags.

    * How to test / verify that the script successfully performs its taskings: Run the script locally `./refresh_container.sh`. Verify success by checking the new container ID in `docker ps` and confirming the site is still accessible at `http://18.215.182.80:8080/` 

    * LINK to bash script:

## Part 2: Listen
1. Configuring a webhook Listener on EC2 Instance
    * How to install adnanh's webhook to the EC2 instance: 
        * `sudo apt-get install webhook`
        * `wget https://github.com/adnanh/webhook/releases/download/<version>/webhook-linux-amd64.tar.gz`
        * `tar -xzf webhook-linux-amd64.tar.gz`
        * `sudo mv webhook-linux-amd64/webhook /usr/local/bin/webhook`
        * `sudo chmod +x /usr/local/bin/webhook` to make it executable
    * How to verify successful installation: `webhook -version`
    * Summary of the webhook definition file:
        * `id`: Unique identifier for the hook (elden-cake-deploy).

        * `execute-command`: Specifies the local script to run (/home/ubuntu/deployment/refresh_container.sh).

        * `trigger-rule`: Validates the payload using a shared payload-secret to ensure the request is from a trusted source.
    * How to verify definition file was loaded by webhook: Inspect the logs via `journalctl -u webhook`
    * How to verify webhook is receiving payloads that trigger it
        * Monitor logs: `sudo journalctl -u webhook -f` will show the output of the hook, including if the script was executed.
        * Docker process views: `docker ps` should show a new container ID and the running container's start time will be updated.
    * LINK to definition file in repository
2. Configure a webhook Service on EC2 Instance
    * Summary of webhook service file contents: Sets the service description, specifies `ExecStart` to run the webhook binary pointing to the `hooks.json` file, enables `Restart=always`, and runs the service as the ubuntu user.
    * How to enable and start the webhook service:
        * `sudo systemctl daemon-reload`
        * `sudo systemctl enable webhook.service`
        * `sudo systemctl start webhook.service`
    * How to verify webhook service is capturing payloads and triggering bash script:
    * LINK to service file in repository:

## Part 3: Send a Paylod
### Configuring a Payload Sender

* Justification for selecting GitHub or DockerHub as the payload sender
* How to enable your selection to send payloads to the EC2 webhook listener
* Explain what triggers will send a payload to the EC2 webhook listener
* How to verify a successful payload delivery
* How to validate that your webhook only triggers when requests are coming from appropriate sources (GitHub or DockerHub)

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

-----------------------------

Install required packages

-----------------------------

RUN apt-get update && apt-get install -y 
openssh-server 
curl 
wget 
unzip 
sudo 
python3 
ca-certificates 
&& mkdir -p /var/run/sshd 
&& rm -rf /var/lib/apt/lists/*

-----------------------------

Create user (build-arg) and give sudo

-----------------------------

ARG USERNAME=trthaodev ARG PASSWORD=thaodev@ RUN useradd -m -s /bin/bash ${USERNAME} 
&& echo "${USERNAME}:${PASSWORD}" | chpasswd 
&& usermod -aG sudo ${USERNAME} 
&& echo '%sudo ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/99_sudo_nopasswd 
&& chmod 0440 /etc/sudoers.d/99_sudo_nopasswd

-----------------------------

Configure SSH

-----------------------------

Keep password auth for simplicity; recommended: use keys instead

RUN sed -i 's/^#PasswordAuthentication./PasswordAuthentication yes/' /etc/ssh/sshd_config || true 
&& sed -i 's/^#PermitRootLogin./PermitRootLogin yes/' /etc/ssh/sshd_config || true 
&& echo 'ClientAliveInterval 60' >> /etc/ssh/sshd_config 
&& echo 'ClientAliveCountMax 3' >> /etc/ssh/sshd_config

generate host keys so sshd starts cleanly

RUN ssh-keygen -A

-----------------------------

Install Ngrok v3

-----------------------------

RUN wget -qO /tmp/ngrok.tgz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz 
&& tar -xzf /tmp/ngrok.tgz -C /tmp 
&& mv /tmp/ngrok /usr/local/bin/ngrok 
&& chmod +x /usr/local/bin/ngrok 
&& rm -f /tmp/ngrok.tgz

-----------------------------

Copy start script

-----------------------------

COPY start-ngrok-ssh.sh /usr/local/bin/start-ngrok-ssh.sh RUN chmod +x /usr/local/bin/start-ngrok-ssh.sh

-----------------------------

Expose ports

-----------------------------

EXPOSE 8080 22 14489 888 80 443 20 21

-----------------------------

Start container

-----------------------------

CMD ["/usr/local/bin/start-ngrok-ssh.sh"]
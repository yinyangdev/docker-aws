FROM amazonlinux:latest

RUN amazon-linux-extras install -y

RUN yum update -y && yum install -y systemd tar unzip sudo

RUN yum install -y gcc openssl-devel bzip2-devel libffi-devel wget zip tar gzip make && \
    cd /opt && \
    wget https://www.python.org/ftp/python/3.9.13/Python-3.9.13.tgz && \
    tar xzf Python-3.9.13.tgz && \
    /opt/Python-3.9.13/configure --enable-optimizations && \
    make altinstall && \
    rm -f /opt/Python-3.9.13.tgz && \
    python3.9 -m pip install --upgrade pip

WORKDIR /tmp

RUN yum install -y unzip less && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    rm awscliv2.zip && \
    ./aws/install

RUN useradd "ec2-user" && echo "ec2-user ALL=NOPASSWD: ALL" >> /etc/sudoers

USER ec2-user
WORKDIR /home/ec2-user/

CMD ["/sbin/init"]
import urllib2
import os
import sys
import json
import boto3
from pprint import pprint
import getopt
import subprocess
import shlex
import logging

logging.basicConfig(level=logging.INFO)

class HostCertificate(object):
    def __init__(self, hostname, private_ip):
        self.hostname = hostname
        self.private_ip = private_ip
        self.algo = "rsa"
        self.size = 2048
        self.country = "US"
        self.level = "Portland"
        self.organization = "system:nodes"
        self.organization_unit = "Kubernetes The Hard Way"
        self.state = "Oregon"

    def __getitem__(self, key):
        return self.__dict__[key]

    def generate(self):
        certificate_request_file_name = "{}-csr.json".format(self.hostname)
        self.save_text_to_file(self.host_certificate_request(), certificate_request_file_name)
        self.generate_certificate_request(self.generate_cmd_to_generate_host_certificate())

    def host_certificate_request(self):
        text = '''{
               "CN": "system:node:%s",
               "key": {
                 "algo": "%s",
                 "size": %s
               },
               "names": [
                 {
                   "C": "%s",
                   "L": "%s",
                   "O": "%s",
                   "OU": "%s",
                   "ST": "%s"
                 }
               ]
             }''' % (self.hostname, self.algo, self.size, self.country, self.level, self.organization, self.organization_unit, self.state)
        return text

    def save_text_to_file(self, contents, file_name):
        with open(file_name, 'w') as x_file:
            x_file.write(contents)

    def generate_cmd_to_generate_host_certificate(self):
        cmd =  '''cfssl gencert \
                    -ca=ca.pem \
                    -ca-key=ca-key.pem \
                    -config=ca-config.json \
                    -hostname=%s,%s \
                    -profile=kubernetes \
                    %s-csr.json | cfssljson -bare %s 
                  }''' % (self.private_ip, self.hostname, self.hostname, self.hostname)
        return cmd

    def generate_certificate_request(self, cmd):
        #print("CMD: {}".format(cmd))
        #p = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE, shell=True)
        #stdout = p.communicate()[0]
        #print('STDOUT:{}'.format(stdout))
        #p.wait()
        ps = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
        output = ps.communicate()[0]
        #print output


# Dynamically get the hosts from AWS

# DTO
class Ec2Instance(object):
    def __init__(self, public_dns, public_ip, private_ip, private_dns):
        self.public_dns = public_dns
        self.public_ip = public_ip
        self.private_ip = private_ip
        self.private_dns = private_dns

    def __getitem__(self, key):
        return self.__dict__[key]

    def generate_certificate_request(self):
        host_certificate = HostCertificate(self.public_dns, self.private_ip)
        host_certificate.generate()

    def generate_kubelet_kubeconfig(self, kube_cluster_name, load_balancer):
        text = "#!/bin/bash\n"
        text += '''kubectl config set-cluster %s \
                    --certificate-authority=ca.pem \
                    --embed-certs=true \
                    --server=https://%s:6443 \
                    --kubeconfig=%s.kubeconfig\n''' % (kube_cluster_name, load_balancer.private_ip, self.public_dns)
        text += '''kubectl config set-credentials system:node:%s \
                   --client-certificate=%s.pem \
                   --client-key=%s-key.pem \
                   --embed-certs=true \
                   --kubeconfig=%s.kubeconfig\n''' % (self.public_dns, self.public_dns, self.public_dns, self.public_dns)
        text += '''kubectl config set-context default \
                   --cluster=%s \
                   --user=system:node:%s \
                   --kubeconfig=%s.kubeconfig\n''' % (kube_cluster_name, self.public_dns, self.public_dns)
        text += "kubectl config use-context default --kubeconfig={}.kubeconfig\n".format(self.public_dns)
        self.save_text_to_file(text, "foo.sh")
        self.run_cmd("sh ./foo.sh")
        print "{}.kubeconfig".format(self.public_dns)

    def run_cmd(self, cmd):
        #print("CMD: {}".format(cmd))
        #p = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE, shell=True)
        #stdout = p.communicate()[0]
        #print('STDOUT:{}'.format(stdout))
        #p.wait()
        ps = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
        output = ps.communicate()[0]
        #print output

    def kubeconfig_for_loadbalancer(self, kube_cluster_name):
        text = "#!/bin/bash\n"
        text += '''kubectl config set-cluster %s \
                 --certificate-authority=ca.pem \
                 --embed-certs=true \
                 --server=https://%s:6443 \
                 --kubeconfig=kube-proxy.kubeconfig

               kubectl config set-credentials system:kube-proxy \
                 --client-certificate=kube-proxy.pem \
                 --client-key=kube-proxy-key.pem \
                 --embed-certs=true \
                 --kubeconfig=kube-proxy.kubeconfig

               kubectl config set-context default \
                 --cluster=%s \
                 --user=system:kube-proxy \
                 --kubeconfig=kube-proxy.kubeconfig

               kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig''' % (kube_cluster_name, self.private_ip, kube_cluster_name)
        self.save_text_to_file(text, "foo.sh")
        self.run_cmd("sh ./foo.sh")
        print "kube-proxy.kubeconfig"

    def save_text_to_file(self, contents, file_name):
        with open(file_name, 'w') as x_file:
            x_file.write(contents)

def get_hosts_by_tag_name(value):
    # Connect to EC2
    ec2 = boto3.resource('ec2')
    # Get information for all running instances
    running_instances = ec2.instances.filter(Filters=[
    {
        'Name': 'instance-state-name',
        'Values': ['running']
    },
    {
        'Name': "tag:Identity",
        'Values': [value]
    }
    ])
    instances = [] 
    for instance in running_instances:
	instances.append(Ec2Instance(instance.public_dns_name, instance.public_ip_address, instance.private_ip_address, instance.private_dns_name))
   
    return instances 


def generate_cert_hostname_string(hosts):
  # 10.32.0.1 is an ip that some PODs may use to contact the api server
  # then private ip address of controllers
  # then public hostname of controllers
  # then private ip address of load balancer and public hostname of load balancer
  # the kube specific vars
  #CERT_HOSTNAME=10.32.0.1,10.1.0.64,ip-10-1-0-64.ec2.internal,10.1.0.77,ip-10-1-0-77.ec2.internal,10.1.0.118,ip-10-1-0-118.ec2.internal,127.0.0.1,localhost,kubernetes.default
  cert_arr = ["10.32.0.1"]
  trailing_cert_arr = ["127.0.0.1", "localhost", "kubernetes.default"]
  for i in hosts:
    cert_arr.extend([i.private_ip])
    cert_arr.extend([i.public_dns])
  cert_arr.extend(trailing_cert_arr)
  return ",".join(cert_arr)

try:
    opts, args = getopt.getopt(sys.argv[1:], 'r,h,a', ['request=', 'host_type=', 'attributes='])
except getopt.GetoptError:
    logging.error("Problems")
    sys.exit(2)

host_type = ''
attributes = []
request = ''
for opt, arg in opts:
    if opt in ('-r', '--request'):
        request = arg
    elif opt in ('-h', '--host_type'):
        host_type = arg
    elif opt in ('-a', '--attributes'):
        attributes = arg.split(',')
    else:
        logging.error("Arg needs to be of type request")
        sys.exit(2)


if request == 'api_server_certificate':
    hosts = get_hosts_by_tag_name("Worker")
    load_balancer = get_hosts_by_tag_name("LoadBalancer")
    hosts.extend(load_balancer)
    cert_string = generate_cert_hostname_string(hosts)
    print cert_string
elif request == 'kubelet_kubeconfig_per_host':
    load_balancer = get_hosts_by_tag_name("LoadBalancer")
    hosts = get_hosts_by_tag_name("Worker")
    for i in hosts:
        i.generate_kubelet_kubeconfig("kubernetes-the-hard-way", load_balancer[0])
elif request == 'kubeconfig_for_loadbalancer':
    load_balancer = get_hosts_by_tag_name("LoadBalancer")
    load_balancer[0].kubeconfig_for_loadbalancer("kubernetes-the-hard-way")
elif request == 'kubelet_client_certificates':
    hosts = get_hosts_by_tag_name("Worker")
    if len(hosts) == 0:
        logging.error("No hosts found")
        sys.exit(2)
    for i in hosts:
        i.generate_certificate_request()
        print("{}.pem".format(i.public_dns))
        print("{}-key.pem".format(i.public_dns))
    
elif host_type != '':
    hosts = get_hosts_by_tag_name(host_type)
    if len(hosts) == 0:
        logging.error("No hosts found")
        sys.exit(2)
    if len(attributes) == 1:
       arr = []
       for i in hosts:
          arr.append(i[attributes[0]])
       print " ".join(arr)
    elif len(attributes) > 1:
       arr = []
       for i in hosts:
          line = []
          for attribute in attributes:
             line.append(i[attribute])
          arr.append(" ".join(line))
       print "\n".join(arr)


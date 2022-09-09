#!/usr/bin/env python3

from mmap import PROT_READ
from diagrams import Diagram
from diagrams import Cluster, Diagram, Edge
from diagrams.custom import Custom
from diagrams.aws.compute import EC2
from diagrams.onprem.compute import Nomad

with Diagram("Simple Nomad cluster", show=False):

    with Cluster("VPC"):
        with Cluster("SubNet"):
            n_server = Nomad("Nomad server")
            n_client = Nomad("Nomad Client")

            n_server >> Edge(color="darkgreen" ,label="RPC TCP/4647") << n_client

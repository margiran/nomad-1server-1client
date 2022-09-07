#!/usr/bin/env python3

from mmap import PROT_READ
from diagrams import Diagram
from diagrams import Cluster, Diagram, Edge
from diagrams.custom import Custom
from diagrams.aws.compute import EC2

with Diagram("Simple Nomad cluster", show=False):

    with Cluster("Data Center"):
        n_server = Custom("Nomad server", "./images.png")
        n_client = Custom("Nomad Client", "./images.png")

        n_server >> Edge(color="darkgreen" ,label="RPC TCP/4647") << n_client

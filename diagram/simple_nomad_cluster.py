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
            n_server1 = Nomad("Nomad server1")
            n_server2 = Nomad("Nomad server2")
            n_client = Nomad("Nomad Client")

            [ n_server1, n_server2] - n_client

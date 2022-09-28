# Diagram as code

[Diagrams](https://diagrams.mingrammer.com/) lets you draw the cloud system architecture in Python code.

## Pre-requisites

* You must have [python](https://www.python.org/downloads/) 3.6 or higher installed on your computer. 

* diagrams uses [Graphviz](https://www.graphviz.org/) to render the diagram, so you need to [install Graphviz](https://graphviz.gitlab.io/download/) to use diagrams. After installing graphviz (or already have it), install the diagrams.

<sub>
macOS users can download the Graphviz via `brew install graphviz` if you're using Homebrew. Similarly, Windows users with Chocolatey installed can run `choco install graphviz`.
</sub>


## [Installation](https://diagrams.mingrammer.com/docs/getting-started/installation)

using pip(pip3)
```
pip install diagrams
```

## Quick start

#### Sample code 

diagram.py
```
# diagram.py
from diagrams import Diagram
from diagrams.aws.compute import EC2
from diagrams.aws.database import RDS
from diagrams.aws.network import ELB

with Diagram("Web Service", show=False):
    ELB("lb") >> EC2("web") >> RDS("userdb")
```

### Generate the diagram:

```
python diagram.py
```

### Sample output

![datacenter image](https://github.com/margiran/nomad-one_server-one_client/blob/master/diagram/simple_nomad_cluster.png?raw=true)
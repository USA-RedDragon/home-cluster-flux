# home-cluster-flux

![Node Count](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.mcswain.dev%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_node_count)

![Pod Count](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.mcswain.dev%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_pod_count)

![CPU Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.mcswain.dev%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_cpu_usage)

![Memory Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.mcswain.dev%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_memory_usage)

USA-RedDragon's home cluster manifests. Each directory is a namespace and most apps are deployed using the `app` Helm chart at <https://github.com/USA-RedDragon/helm-charts>.

This cluster runs on [Talos](https://www.talos.dev/) and my configuration files for it are public at <https://github.com/USA-RedDragon/talos-configs>.

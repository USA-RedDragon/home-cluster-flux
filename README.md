# home-cluster-flux

![Node Count](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.mcswain.dev%2Fquery%3Fformat%3Dendpoint%26metric%3DNodes)&nbsp;
![Pod Count](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.mcswain.dev%2Fquery%3Fformat%3Dendpoint%26metric%3DPods)&nbsp;
![CPU Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.mcswain.dev%2Fquery%3Fformat%3Dendpoint%26metric%3DCPU)&nbsp;
![Memory Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.mcswain.dev%2Fquery%3Fformat%3Dendpoint%26metric%3DMemory)

USA-RedDragon's home cluster manifests. Each directory is a namespace and most apps are deployed using the `app` Helm chart at <https://github.com/USA-RedDragon/helm-charts>.

This cluster runs on [Talos](https://www.talos.dev/) and my configuration files for it are public at <https://github.com/USA-RedDragon/talos-configs>.

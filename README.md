# home-cluster-flux

![Node Count](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.mcswain.dev%2Fquery%3Fformat%3Dendpoint%26metric%3DNodes)&nbsp;
![Pod Count](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.mcswain.dev%2Fquery%3Fformat%3Dendpoint%26metric%3DPods)&nbsp;

![Total CPUs](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.mcswain.dev%2Fquery%3Fformat%3Dendpoint%26metric%3DTotal%2520CPUs)&nbsp;
![CPU Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.mcswain.dev%2Fquery%3Fformat%3Dendpoint%26metric%3DCPU)&nbsp;

![Total Memory](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.mcswain.dev%2Fquery%3Fformat%3Dendpoint%26metric%3DTotal%2520Memory)&nbsp;
![Memory Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.mcswain.dev%2Fquery%3Fformat%3Dendpoint%26metric%3DMemory)&nbsp;

![Disk Capacity](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.mcswain.dev%2Fquery%3Fformat%3Dendpoint%26metric%3DDisk%2520Capacity)&nbsp;
![Disk Reserved](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.mcswain.dev%2Fquery%3Fformat%3Dendpoint%26metric%3DDisk%2520Reserved)&nbsp;
![Disk Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.mcswain.dev%2Fquery%3Fformat%3Dendpoint%26metric%3DDisk%2520Usage)&nbsp;
![Disk Latency](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.mcswain.dev%2Fquery%3Fformat%3Dendpoint%26metric%3DDisk%2520Latency)&nbsp;
![Disk Throughput](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.mcswain.dev%2Fquery%3Fformat%3Dendpoint%26metric%3DDisk%2520Throughput)&nbsp;

USA-RedDragon's home cluster manifests. Each directory is a namespace and most apps are deployed using the `app` Helm chart at <https://github.com/USA-RedDragon/helm-charts>.

This cluster runs on [Talos](https://www.talos.dev/) and my configuration files for it are public at <https://github.com/USA-RedDragon/talos-configs>.

## Repo Index
<!-- Begin apps section -->
<h3>Clusters</h3>
<ul>
  <li><a href="#actions-runner-controller">actions-runner-controller</a></li>
  <li><a href="#apprise">apprise</a></li>
  <li><a href="#aredn">aredn</a></li>
  <li><a href="#aredn-dmrhub">aredn-dmrhub</a></li>
  <li><a href="#aredn-meshmap">aredn-meshmap</a></li>
  <li><a href="#aredn-ntp">aredn-ntp</a></li>
  <li><a href="#aredn-piaware">aredn-piaware</a></li>
  <li><a href="#aredn-scanner">aredn-scanner</a></li>
  <li><a href="#astro-processing">astro-processing</a></li>
  <li><a href="#astroframe">astroframe</a></li>
  <li><a href="#atuin">atuin</a></li>
  <li><a href="#authentik">authentik</a></li>
  <li><a href="#backup-sync">backup-sync</a></li>
  <li><a href="#cert-manager">cert-manager</a></li>
  <li><a href="#cnpg">cnpg</a></li>
  <li><a href="#csi-snapshotter">csi-snapshotter</a></li>
  <li><a href="#cyberchef">cyberchef</a></li>
  <li><a href="#descheduler">descheduler</a></li>
  <li><a href="#device-plugin">device-plugin</a></li>
  <li><a href="#dmrhub">dmrhub</a></li>
  <li><a href="#dump978">dump978</a></li>
  <li><a href="#envoy-gateway">envoy-gateway</a></li>
  <li><a href="#ephemeris">ephemeris</a></li>
  <li><a href="#external-dns-internal">external-dns-internal</a></li>
  <li><a href="#frigate">frigate</a></li>
  <li><a href="#gittea">gittea</a></li>
  <li><a href="#golink">golink</a></li>
  <li><a href="#hcp-operator">hcp-operator</a></li>
  <li><a href="#healthchecks">healthchecks</a></li>
  <li><a href="#http-logger">http-logger</a></li>
  <li><a href="#imagescraper-mesonet">imagescraper-mesonet</a></li>
  <li><a href="#imagescraper-sfro-allsky">imagescraper-sfro-allsky</a></li>
  <li><a href="#immich">immich</a></li>
  <li><a href="#indi-allsky">indi-allsky</a></li>
  <li><a href="#intel-device-plugin">intel-device-plugin</a></li>
  <li><a href="#iperf3">iperf3</a></li>
  <li><a href="#jellyfin">jellyfin</a></li>
  <li><a href="#json-exporter">json-exporter</a></li>
  <li><a href="#kosync">kosync</a></li>
  <li><a href="#kromgo">kromgo</a></li>
  <li><a href="#kube-system">kube-system</a></li>
  <li><a href="#kyverno">kyverno</a></li>
  <li><a href="#linx">linx</a></li>
  <li><a href="#longhorn">longhorn</a></li>
  <li><a href="#mattermost">mattermost</a></li>
  <li><a href="#mindustry">mindustry</a></li>
  <li><a href="#minecraft">minecraft</a></li>
  <li><a href="#minio">minio</a></li>
  <li><a href="#monitoring">monitoring</a></li>
  <li><a href="#mosquitto">mosquitto</a></li>
  <li><a href="#mqtt-wx">mqtt-wx</a></li>
  <li><a href="#navidrome">navidrome</a></li>
  <li><a href="#nginx-rtmp">nginx-rtmp</a></li>
  <li><a href="#nvidia-device-plugin">nvidia-device-plugin</a></li>
  <li><a href="#obico">obico</a></li>
  <li><a href="#openspeedtest">openspeedtest</a></li>
  <li><a href="#paperless-ngx">paperless-ngx</a></li>
  <li><a href="#piaware">piaware</a></li>
  <li><a href="#ping-exporter">ping-exporter</a></li>
  <li><a href="#prometheus">prometheus</a></li>
  <li><a href="#rdio-scanner">rdio-scanner</a></li>
  <li><a href="#reflector">reflector</a></li>
  <li><a href="#relax-sounds">relax-sounds</a></li>
  <li><a href="#renovate-ce">renovate-ce</a></li>
  <li><a href="#reticulum">reticulum</a></li>
  <li><a href="#rmfakecloud">rmfakecloud</a></li>
  <li><a href="#rtl-433">rtl-433</a></li>
  <li><a href="#rtz">rtz</a></li>
  <li><a href="#ses-email-service">ses-email-service</a></li>
  <li><a href="#tailscale-operator">tailscale-operator</a></li>
  <li><a href="#tailscale-peer-relay">tailscale-peer-relay</a></li>
  <li><a href="#tandoor">tandoor</a></li>
  <li><a href="#tfe">tfe</a></li>
  <li><a href="#trunk-recorder">trunk-recorder</a></li>
  <li><a href="#ultrafeeder">ultrafeeder</a></li>
  <li><a href="#vaultwarden">vaultwarden</a></li>
  <li><a href="#weave-gitops">weave-gitops</a></li>
  <li><a href="#weewx">weewx</a></li>
  <li><a href="#wheresmyscope">wheresmyscope</a></li>
  <li><a href="#zot">zot</a></li>
</ul>

<h3>Apps</h2>

<h4>actions-runner-controller</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>actions-runner-system</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/actions-runner-controller/scale-set-controller/helm.yaml">gha-runner-scale-set-controller</a></td>
    <td></td>
  </tr>
  <tr>
    <td rowspan="2">actions-runners</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/actions-runner-controller/scale-sets/dockers-private.yaml">dockers-private-runner-set</a></td>
    <td rowspan="2"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/actions-runner-controller/scale-sets/rustdar.yaml">rustdar-runner-set</a></td>
  </tr>
</table>

<h4>apprise</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">apprise</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/apprise/helm.yaml">apprise</a></td>
    <td rowspan="2"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/apprise/restic.yaml">restic</a></td>
  </tr>
</table>

<h4>aredn</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>aredn</td>
    <td><code>HelmRelease</code></td>
    <td><a href="services/aredn/helm.yaml">wireguard-tunnel</a></td>
    <td></td>
  </tr>
</table>

<h4>aredn-dmrhub</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>aredn-dmrhub</td>
    <td><code>HelmRelease</code></td>
    <td><a href="services/aredn-dmrhub/helm.yaml">aredn-dmrhub</a></td>
    <td></td>
  </tr>
</table>

<h4>aredn-meshmap</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>aredn-meshmap</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/aredn-meshmap/helm.yaml">aredn-meshmap</a></td>
    <td></td>
  </tr>
</table>

<h4>aredn-ntp</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>aredn-ntp</td>
    <td><code>HelmRelease</code></td>
    <td><a href="services/aredn-ntp/helm.yaml">aredn-ntp</a></td>
    <td></td>
  </tr>
</table>

<h4>aredn-piaware</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>aredn-piaware</td>
    <td><code>HelmRelease</code></td>
    <td><a href="services/aredn-piaware/helm.yaml">aredn-piaware</a></td>
    <td></td>
  </tr>
</table>

<h4>aredn-scanner</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>aredn-scanner</td>
    <td><code>HelmRelease</code></td>
    <td><a href="services/aredn-scanner/helm.yaml">aredn-scanner</a></td>
    <td></td>
  </tr>
</table>

<h4>astro-processing</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">astro-processing</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/astro-processing/resources/app/helm.yaml">astro-processing</a></td>
    <td rowspan="2"><a href="apps/astro-processing/resources/postgres/postgres.yaml">postgresql</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/astro-processing/resources/pixinsight-worker/helm.yaml">pixinsight-worker</a></td>
  </tr>
  <tr>
    <td>symmetricds</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/astro-processing/resources/symmetricds/helm.yaml">symmetricds</a></td>
    <td></td>
  </tr>
</table>

<h4>astroframe</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>astroframe</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/astroframe/helm.yaml">astroframe</a></td>
    <td></td>
  </tr>
</table>

<h4>atuin</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">atuin</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/atuin/helm.yaml">atuin</a></td>
    <td rowspan="2"><a href="apps/atuin/postgres.yaml">postgresql</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/atuin/restic.yaml">restic</a></td>
  </tr>
</table>

<h4>authentik</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">authentik</td>
    <td><code>HelmRelease</code></td>
    <td><a href="services/authentik/helm.yaml">authentik</a></td>
    <td rowspan="2"><a href="services/authentik/postgres.yaml">postgresql</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="services/authentik/restic.yaml">restic</a></td>
  </tr>
</table>

<h4>backup-sync</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="6">backup-sync</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/backup-sync/backup-sync-mcswain-git-backups.yaml">backup-sync-git-backups</a></td>
    <td rowspan="6"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/backup-sync/backup-sync-mcswain-home-assistant.yaml">backup-sync-home-assistant</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/backup-sync/backup-sync-mcswain-kubernetes-backups.yaml">backup-sync-kubernetes-backups</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/backup-sync/backup-sync-mcswain-backup.yaml">backup-sync-mcswain-backup</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/backup-sync/backup-sync-mcswain-minio.yaml">backup-sync-mcswain-minio</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/backup-sync/backup-sync-mcswain-router-backups.yaml">backup-sync-mcswain-router-backups</a></td>
  </tr>
</table>

<h4>cert-manager</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>cert-manager</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/cert-manager/app/helm.yaml">cert-manager</a></td>
    <td></td>
  </tr>
</table>

<h4>cnpg</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>cnpg-system</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/cnpg/app/helm.yaml">cnpg</a></td>
    <td></td>
  </tr>
</table>

<h4>csi-snapshotter</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>kube-system</td>
    <td><code>GitRepository</code></td>
    <td><a href="https://github.com/kubernetes-csi/external-snapshotter">external-snapshotter</a></td>
    <td></td>
  </tr>
</table>

<h4>cyberchef</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>cyberchef</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/cyberchef/helm.yaml">cyberchef</a></td>
    <td></td>
  </tr>
</table>

<h4>descheduler</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>descheduler</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/descheduler/app/helm.yaml">descheduler</a></td>
    <td></td>
  </tr>
</table>

<h4>device-plugin</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>device-plugin</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/device-plugin/app/helm.yaml">device-plugin</a></td>
    <td></td>
  </tr>
</table>

<h4>dmrhub</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">dmrhub</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/dmrhub/helm.yaml">dmrhub</a></td>
    <td rowspan="2"><a href="apps/dmrhub/postgres.yaml">postgresql</a>, <a href="apps/dmrhub/valkey.yaml">valkey</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/dmrhub/restic.yaml">restic</a></td>
  </tr>
</table>

<h4>dump978</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">dump978</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/dump978/helm.yaml">dump978</a></td>
    <td rowspan="2"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/dump978/restic.yaml">restic</a></td>
  </tr>
</table>

<h4>envoy-gateway</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>envoy-gateway-system</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/envoy-gateway/resources/controller/helm.yaml">envoy-gateway</a></td>
    <td></td>
  </tr>
</table>

<h4>ephemeris</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>ephemeris</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/ephemeris/helm.yaml">ephemeris</a></td>
    <td></td>
  </tr>
</table>

<h4>external-dns-internal</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>external-dns-internal</td>
    <td><code>HelmRelease</code></td>
    <td><a href="services/external-dns-internal/external-dns.yaml">external-dns-internal</a></td>
    <td></td>
  </tr>
</table>

<h4>frigate</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">frigate</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/frigate/resources/app/helm.yaml">frigate</a></td>
    <td rowspan="2"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/frigate/resources/restic/helmrelease.yaml">restic</a></td>
  </tr>
</table>

<h4>gittea</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>gitea</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/gittea/helm.yaml">gitea</a></td>
    <td><a href="apps/gittea/postgres.yaml">postgresql</a></td>
  </tr>
</table>

<h4>golink</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">golink</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/golink/helm.yaml">golink</a></td>
    <td rowspan="2"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/golink/restic.yaml">restic</a></td>
  </tr>
</table>

<h4>hcp-operator</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>hcp-operator</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/hcp-operator/app/helm.yaml">hcp-operator</a></td>
    <td></td>
  </tr>
</table>

<h4>healthchecks</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>healthchecks</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/healthchecks/helm.yaml">healthchecks</a></td>
    <td><a href="apps/healthchecks/postgres.yaml">postgresql</a></td>
  </tr>
</table>

<h4>http-logger</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>http-logger</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/http-logger/helm.yaml">http-logger</a></td>
    <td></td>
  </tr>
</table>

<h4>imagescraper-mesonet</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>imagescraper-mesonet</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/imagescraper-mesonet/helm.yaml">imagescraper-mesonet</a></td>
    <td></td>
  </tr>
</table>

<h4>imagescraper-sfro-allsky</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>imagescraper-sfro-allsky</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/imagescraper-sfro-allsky/helm.yaml">imagescraper-sfro-allsky</a></td>
    <td></td>
  </tr>
</table>

<h4>immich</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">immich</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/immich/app/helm.yaml">immich</a></td>
    <td rowspan="2"><a href="apps/immich/app/postgres.yaml">postgresql</a>, <a href="apps/immich/app/redis-helm.yaml">redis</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/immich/restic/helmrelease.yaml">restic</a></td>
  </tr>
</table>

<h4>indi-allsky</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">indi-allsky</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/indi-allsky/app/helm.yaml">indi-allsky</a></td>
    <td rowspan="2"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/indi-allsky/mariadb/helm.yaml">indi-allsky-mariadb</a></td>
  </tr>
</table>

<h4>intel-device-plugin</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">intel-device-plugin</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/intel-device-plugin/app/helm.yaml">intel-device-plugin</a></td>
    <td rowspan="2"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/intel-device-plugin/app/helm.yaml">intel-device-plugins-gpu</a></td>
  </tr>
</table>

<h4>iperf3</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>iperf3</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/iperf3/helm.yaml">iperf3</a></td>
    <td></td>
  </tr>
</table>

<h4>jellyfin</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">jellyfin</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/jellyfin/helm.yaml">jellyfin</a></td>
    <td rowspan="2"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/jellyfin/restic.yaml">restic</a></td>
  </tr>
</table>

<h4>json-exporter</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>json-exporter</td>
    <td><code>HelmRelease</code></td>
    <td><a href="services/json-exporter/app/helm.yaml">json-exporter</a></td>
    <td></td>
  </tr>
</table>

<h4>kosync</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">kosync</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/kosync/helm.yaml">kosync</a></td>
    <td rowspan="2"><a href="apps/kosync/postgres.yaml">postgresql</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/kosync/restic.yaml">restic</a></td>
  </tr>
</table>

<h4>kromgo</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>kromgo</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/kromgo/helm.yaml">kromgo</a></td>
    <td></td>
  </tr>
</table>

<h4>kube-system</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">kube-system</td>
    <td><code>CronJob</code></td>
    <td><a href="services/kube-system/etcd-backup.yaml">backup</a></td>
    <td rowspan="2"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="services/kube-system/metrics-server.yaml">metrics-server</a></td>
  </tr>
</table>

<h4>kyverno</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">kyverno</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/kyverno/app/helm.yaml">kyverno</a></td>
    <td rowspan="2"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/kyverno/policy-reporter/helm.yaml">kyverno-policy-reporter</a></td>
  </tr>
</table>

<h4>linx</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>linx</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/linx/helm.yaml">linx</a></td>
    <td></td>
  </tr>
</table>

<h4>longhorn</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>longhorn-system</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/longhorn/app/helm.yaml">longhorn</a></td>
    <td></td>
  </tr>
</table>

<h4>mattermost</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="3">mattermost</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/mattermost/app/helm.yaml">mattermost</a></td>
    <td rowspan="3"><a href="apps/mattermost/app/postgres.yaml">postgresql</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/mattermost/app/push-proxy-helm.yaml">push-proxy</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/mattermost/restic/helmrelease.yaml">restic</a></td>
  </tr>
</table>

<h4>mindustry</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>mindustry</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/mindustry/helm.yaml">mindustry</a></td>
    <td></td>
  </tr>
</table>

<h4>minecraft</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">minecraft</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/minecraft/cobblemon-helm.yaml">cobblemon</a></td>
    <td rowspan="2"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/minecraft/dragonmc-site-helm.yaml">dragonmc-site</a></td>
  </tr>
</table>

<h4>minio</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="5">minio</td>
    <td><code>HelmRelease</code></td>
    <td><a href="services/minio/backup-astro.yaml">backup-astro</a></td>
    <td rowspan="5"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="services/minio/backup-mattermost.yaml">backup-mattermost</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="services/minio/backup-rtz-uploads.yaml">backup-rtz-uploads</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="services/minio/backup-tandoor.yaml">backup-tandoor</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="services/minio/helm.yaml">minio</a></td>
  </tr>
</table>

<h4>monitoring</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="4">monitoring</td>
    <td><code>HelmRelease</code></td>
    <td><a href="services/monitoring/metrics-actioner-helm.yaml">metrics-actioner</a></td>
    <td rowspan="4"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="services/monitoring/helm.yaml">pushgateway</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="services/monitoring/helm.yaml">thanos-compactor</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="services/monitoring/helm.yaml">thanos-querier</a></td>
  </tr>
</table>

<h4>mosquitto</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">mosquitto</td>
    <td><code>HelmRelease</code></td>
    <td><a href="services/mosquitto/app/helm.yaml">mosquitto</a></td>
    <td rowspan="2"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="services/mosquitto/restic/helmrelease.yaml">restic</a></td>
  </tr>
</table>

<h4>mqtt-wx</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>mqtt-wx</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/mqtt-wx/helm.yaml">mqtt-wx</a></td>
    <td></td>
  </tr>
</table>

<h4>navidrome</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">navidrome</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/navidrome/resources/app/helm.yaml">navidrome</a></td>
    <td rowspan="2"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/navidrome/resources/restic/helmrelease.yaml">restic</a></td>
  </tr>
</table>

<h4>nginx-rtmp</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>nginx-rtmp</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/nginx-rtmp/helm.yaml">nginx-rtmp</a></td>
    <td></td>
  </tr>
</table>

<h4>nvidia-device-plugin</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>nvidia</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/nvidia-device-plugin/app/helm.yaml">nvdp</a></td>
    <td></td>
  </tr>
</table>

<h4>obico</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>obico</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/obico/helm.yaml">obico</a></td>
    <td><a href="apps/obico/valkey.yaml">valkey</a></td>
  </tr>
</table>

<h4>openspeedtest</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>openspeedtest</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/openspeedtest/resources/app/helm.yaml">openspeedtest</a></td>
    <td></td>
  </tr>
</table>

<h4>paperless-ngx</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">paperless-ngx</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/paperless-ngx/helm.yaml">paperless-ngx</a></td>
    <td rowspan="2"><a href="apps/paperless-ngx/postgres.yaml">postgresql</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/paperless-ngx/restic.yaml">restic</a></td>
  </tr>
</table>

<h4>piaware</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>piaware</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/piaware/helm.yaml">piaware</a></td>
    <td></td>
  </tr>
</table>

<h4>ping-exporter</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>ping-exporter</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/ping-exporter/app/helm.yaml">ping-exporter</a></td>
    <td></td>
  </tr>
</table>

<h4>prometheus</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">monitoring</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/prometheus/app/helm.yaml">prometheus-stack</a></td>
    <td rowspan="2"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/prometheus/app/restic.yaml">restic</a></td>
  </tr>
</table>

<h4>rdio-scanner</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">rdio-scanner</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/rdio-scanner/helm.yaml">rdio-scanner</a></td>
    <td rowspan="2"><a href="apps/rdio-scanner/postgres.yaml">postgresql</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/rdio-scanner/restic.yaml">restic</a></td>
  </tr>
</table>

<h4>reflector</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>reflector</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/reflector/app/helm.yaml">reflector</a></td>
    <td></td>
  </tr>
</table>

<h4>relax-sounds</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">relax-sounds</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/relax-sounds/helm.yaml">relax-sounds</a></td>
    <td rowspan="2"><a href="apps/relax-sounds/valkey.yaml">valkey</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/relax-sounds/restic.yaml">restic</a></td>
  </tr>
</table>

<h4>renovate-ce</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>renovate-ce</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/renovate-ce/helm.yaml">renovate-ce</a></td>
    <td></td>
  </tr>
</table>

<h4>reticulum</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="3">reticulum</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/reticulum/resources/lxmd/helm.yaml">lxmd</a></td>
    <td rowspan="3"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/reticulum/resources/restic/helmrelease.yaml">restic</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/reticulum/resources/app/helm.yaml">reticulum</a></td>
  </tr>
</table>

<h4>rmfakecloud</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">rmfakecloud</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/rmfakecloud/restic/helmrelease.yaml">restic</a></td>
    <td rowspan="2"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/rmfakecloud/app/helm.yaml">rmfakecloud</a></td>
  </tr>
</table>

<h4>rtl-433</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>rtl-433</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/rtl-433/helm.yaml">rtl-433</a></td>
    <td></td>
  </tr>
</table>

<h4>rtz</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="3">rtz</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/rtz/nats.helm.yaml">nats</a></td>
    <td rowspan="3"><a href="apps/rtz/postgres.yaml">postgresql</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/rtz/restic.yaml">restic</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/rtz/helm.yaml">rtz</a></td>
  </tr>
</table>

<h4>ses-email-service</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>ses-email-service</td>
    <td><code>GitRepository</code></td>
    <td><a href="https://github.com/USA-RedDragon/ses-email-service">ses-email-service</a></td>
    <td></td>
  </tr>
</table>

<h4>tailscale-operator</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>tailscale-operator</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/tailscale-operator/app/helm.yaml">tailscale</a></td>
    <td></td>
  </tr>
</table>

<h4>tailscale-peer-relay</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>tailscale-peer-relay</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/tailscale-peer-relay/helm.yaml">tailscale-peer-relay</a></td>
    <td></td>
  </tr>
</table>

<h4>tandoor</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">tandoor</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/tandoor/restic.yaml">restic</a></td>
    <td rowspan="2"><a href="apps/tandoor/postgres.yaml">postgresql</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/tandoor/helm.yaml">tandoor</a></td>
  </tr>
</table>

<h4>tfe</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>tfe</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/tfe/hashicorp-helm.yaml">tfe</a></td>
    <td><a href="apps/tfe/postgres.yaml">postgresql</a>, <a href="apps/tfe/redis-helm.yaml">redis</a></td>
  </tr>
</table>

<h4>trunk-recorder</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>trunk-recorder</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/trunk-recorder/helm.yaml">trunk-recorder</a></td>
    <td></td>
  </tr>
</table>

<h4>ultrafeeder</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>ultrafeeder</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/ultrafeeder/helm.yaml">ultrafeeder</a></td>
    <td></td>
  </tr>
</table>

<h4>vaultwarden</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">vaultwarden</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/vaultwarden/restic/helmrelease.yaml">restic</a></td>
    <td rowspan="2"><a href="apps/vaultwarden/app/postgres.yaml">postgresql</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/vaultwarden/app/helm.yaml">vaultwarden</a></td>
  </tr>
</table>

<h4>weave-gitops</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>flux-system</td>
    <td><code>HelmRelease</code></td>
    <td><a href="services/weave-gitops/weave-gitops-dashboard.yaml">weave</a></td>
    <td></td>
  </tr>
</table>

<h4>weewx</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">weewx</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/weewx/app/helm.yaml">weewx</a></td>
    <td rowspan="2"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/weewx/mariadb/helm.yaml">weewx-mariadb</a></td>
  </tr>
</table>

<h4>wheresmyscope</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>wheresmyscope</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/wheresmyscope/helm.yaml">wheresmyscope</a></td>
    <td></td>
  </tr>
</table>

<h4>zot</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">zot</td>
    <td><code>HelmRelease</code></td>
    <td><a href="services/zot/app/restic.yaml">restic</a></td>
    <td rowspan="2"><a href="services/zot/app/valkey.yaml">valkey</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="services/zot/app/helm.yaml">zot</a></td>
  </tr>
</table>
<!-- End apps section -->

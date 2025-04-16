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
  <li><a href="#apprise">apprise</a></li>
  <li><a href="#aredn">aredn</a></li>
  <li><a href="#aredn-dmrhub">aredn-dmrhub</a></li>
  <li><a href="#aredn-meshmap">aredn-meshmap</a></li>
  <li><a href="#aredn-ntp">aredn-ntp</a></li>
  <li><a href="#aredn-piaware">aredn-piaware</a></li>
  <li><a href="#aredn-scanner">aredn-scanner</a></li>
  <li><a href="#atuin">atuin</a></li>
  <li><a href="#authentik">authentik</a></li>
  <li><a href="#calibre">calibre</a></li>
  <li><a href="#cert-manager">cert-manager</a></li>
  <li><a href="#changedetection">changedetection</a></li>
  <li><a href="#cnpg">cnpg</a></li>
  <li><a href="#csi-snapshotter">csi-snapshotter</a></li>
  <li><a href="#cyberchef">cyberchef</a></li>
  <li><a href="#descheduler">descheduler</a></li>
  <li><a href="#device-plugin">device-plugin</a></li>
  <li><a href="#dmrhub">dmrhub</a></li>
  <li><a href="#ffmpeg-printer-webcam">ffmpeg-printer-webcam</a></li>
  <li><a href="#gittea">gittea</a></li>
  <li><a href="#go2rtc">go2rtc</a></li>
  <li><a href="#golink">golink</a></li>
  <li><a href="#healthchecks">healthchecks</a></li>
  <li><a href="#hp-scan-to">hp-scan-to</a></li>
  <li><a href="#immich">immich</a></li>
  <li><a href="#indi-allsky">indi-allsky</a></li>
  <li><a href="#ingress-nginx">ingress-nginx</a></li>
  <li><a href="#intel-device-plugin">intel-device-plugin</a></li>
  <li><a href="#jellyfin">jellyfin</a></li>
  <li><a href="#kosync">kosync</a></li>
  <li><a href="#kromgo">kromgo</a></li>
  <li><a href="#kube-system">kube-system</a></li>
  <li><a href="#kyverno">kyverno</a></li>
  <li><a href="#longhorn">longhorn</a></li>
  <li><a href="#mattermost">mattermost</a></li>
  <li><a href="#minecraft">minecraft</a></li>
  <li><a href="#minio">minio</a></li>
  <li><a href="#minio-operator">minio-operator</a></li>
  <li><a href="#monitoring">monitoring</a></li>
  <li><a href="#mqtt-wx">mqtt-wx</a></li>
  <li><a href="#nginx-rtmp">nginx-rtmp</a></li>
  <li><a href="#nvidia-device-plugin">nvidia-device-plugin</a></li>
  <li><a href="#obico">obico</a></li>
  <li><a href="#palworld">palworld</a></li>
  <li><a href="#paperless-ngx">paperless-ngx</a></li>
  <li><a href="#piaware">piaware</a></li>
  <li><a href="#ping-exporter">ping-exporter</a></li>
  <li><a href="#prometheus">prometheus</a></li>
  <li><a href="#rdio-scanner">rdio-scanner</a></li>
  <li><a href="#readsb">readsb</a></li>
  <li><a href="#redis">redis</a></li>
  <li><a href="#reflector">reflector</a></li>
  <li><a href="#renovate-ce">renovate-ce</a></li>
  <li><a href="#rtl-433">rtl-433</a></li>
  <li><a href="#rtz">rtz</a></li>
  <li><a href="#scrypted">scrypted</a></li>
  <li><a href="#ses-email-service">ses-email-service</a></li>
  <li><a href="#site-inspector">site-inspector</a></li>
  <li><a href="#split-dns">split-dns</a></li>
  <li><a href="#tailscale-operator">tailscale-operator</a></li>
  <li><a href="#tandoor">tandoor</a></li>
  <li><a href="#tdarr">tdarr</a></li>
  <li><a href="#tfe">tfe</a></li>
  <li><a href="#trunk-recorder">trunk-recorder</a></li>
  <li><a href="#uptime-kuma">uptime-kuma</a></li>
  <li><a href="#vaultwarden">vaultwarden</a></li>
  <li><a href="#weave-gitops">weave-gitops</a></li>
  <li><a href="#weewx">weewx</a></li>
  <li><a href="#zot">zot</a></li>
</ul>

<h3>Apps</h2>

<h4>apprise</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>apprise</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/apprise/helm.yaml">apprise</a></td>
    <td></td>
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

<h4>atuin</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>atuin</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/atuin/helm.yaml">atuin</a></td>
    <td><a href="apps/atuin/postgres.yaml">postgresql</a></td>
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
    <td rowspan="2"><a href="services/authentik/postgres.yaml">postgresql</a>, <a href="services/authentik/redis-helm.yaml">redis</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="services/authentik/helm.yaml">authentik-workers</a></td>
  </tr>
</table>

<h4>calibre</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>calibre</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/calibre/helm.yaml">calibre</a></td>
    <td></td>
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

<h4>changedetection</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>changedetection</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/changedetection/helm.yaml">changedetection</a></td>
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
    <td>dmrhub</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/dmrhub/helm.yaml">dmrhub</a></td>
    <td><a href="apps/dmrhub/postgres.yaml">postgresql</a>, <a href="apps/dmrhub/redis-helm.yaml">redis</a></td>
  </tr>
</table>

<h4>ffmpeg-printer-webcam</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>ffmpeg-printer-webcam</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/ffmpeg-printer-webcam/helm.yaml">ffmpeg-printer-webcam</a></td>
    <td></td>
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

<h4>go2rtc</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="2">go2rtc</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/go2rtc/helm.yaml">go2rtc</a></td>
    <td rowspan="2"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/go2rtc/helm.yaml">go2rtc-real</a></td>
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
    <td>golink</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/golink/helm.yaml">golink</a></td>
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

<h4>hp-scan-to</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>hp-scan-to</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/hp-scan-to/helm.yaml">hp-scan-to</a></td>
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
    <td>immich</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/immich/app/helm.yaml">immich</a></td>
    <td><a href="apps/immich/app/postgres.yaml">postgresql</a>, <a href="apps/immich/app/redis-helm.yaml">redis</a></td>
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

<h4>ingress-nginx</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>nginx</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/ingress-nginx/app/helm.yaml">nginx</a></td>
    <td></td>
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

<h4>jellyfin</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>jellyfin</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/jellyfin/helm.yaml">jellyfin</a></td>
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
    <td>kosync</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/kosync/helm.yaml">kosync</a></td>
    <td><a href="apps/kosync/postgres.yaml">postgresql</a></td>
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
    <td>kyverno</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/kyverno/app/helm.yaml">kyverno</a></td>
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
    <td rowspan="2">mattermost</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/mattermost/app/helm.yaml">mattermost</a></td>
    <td rowspan="2"><a href="apps/mattermost/app/postgres.yaml">postgresql</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/mattermost/app/push-proxy-helm.yaml">push-proxy</a></td>
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
    <td><a href="apps/minecraft/dragonmc-site-helm.yaml">dragonmc-site</a></td>
    <td rowspan="2"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/minecraft/origins-helm.yaml">origins</a></td>
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
    <td>minio</td>
    <td><code>HelmRelease</code></td>
    <td><a href="services/minio/helm.yaml">minio</a></td>
    <td></td>
  </tr>
</table>

<h4>minio-operator</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>minio-operator</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/minio-operator/app/helm.yaml">minio</a></td>
    <td></td>
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
    <td></td>
  </tr>
</table>

<h4>palworld</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>palworld</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/palworld/helm.yaml">palworld</a></td>
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
    <td>paperless-ngx</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/paperless-ngx/helm.yaml">paperless-ngx</a></td>
    <td><a href="apps/paperless-ngx/postgres.yaml">postgresql</a></td>
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
    <td>monitoring</td>
    <td><code>HelmRelease</code></td>
    <td><a href="infrastructure/prometheus/app/helm.yaml">prometheus-stack</a></td>
    <td></td>
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
    <td>rdio-scanner</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/rdio-scanner/helm.yaml">rdio-scanner</a></td>
    <td><a href="apps/rdio-scanner/postgres.yaml">postgresql</a></td>
  </tr>
</table>

<h4>readsb</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>readsb</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/readsb/helm.yaml">readsb</a></td>
    <td></td>
  </tr>
</table>

<h4>redis</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>redis</td>
    <td></td>
    <td></td>
    <td><a href="services/redis/helm.yaml">redis</a></td>
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
    <td><a href="apps/renovate-ce/postgres.yaml">postgresql</a></td>
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
    <td rowspan="2">rtz</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/rtz/nats.helm.yaml">nats</a></td>
    <td rowspan="2"><a href="apps/rtz/postgres.yaml">postgresql</a></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/rtz/helm.yaml">rtz</a></td>
  </tr>
</table>

<h4>scrypted</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>scrypted</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/scrypted/helm.yaml">scrypted</a></td>
    <td></td>
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

<h4>site-inspector</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>site-inspector</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/site-inspector/helm.yaml">site-inspector</a></td>
    <td><a href="apps/site-inspector/postgres.yaml">postgresql</a></td>
  </tr>
</table>

<h4>split-dns</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td rowspan="3">split-dns</td>
    <td><code>Deployment</code></td>
    <td><a href="services/split-dns/coredns.deployment.yaml">coredns</a></td>
    <td rowspan="3"></td>
  </tr>
  <tr>
    <td><code>HelmRelease</code></td>
    <td><a href="services/split-dns/etcd.helm.yaml">etcd</a></td>
  </tr>
  <tr>
    <td><code>Deployment</code></td>
    <td><a href="services/split-dns/external-dns.yaml">external-dns</a></td>
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

<h4>tandoor</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>tandoor</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/tandoor/helm.yaml">tandoor</a></td>
    <td><a href="apps/tandoor/postgres.yaml">postgresql</a></td>
  </tr>
</table>

<h4>tdarr</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>tdarr</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/tdarr/helm.yaml">tdarr</a></td>
    <td></td>
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

<h4>uptime-kuma</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>uptime-kuma</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/uptime-kuma/helm.yaml">uptime-kuma</a></td>
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
    <td>vaultwarden</td>
    <td><code>HelmRelease</code></td>
    <td><a href="apps/vaultwarden/helm.yaml">vaultwarden</a></td>
    <td><a href="apps/vaultwarden/postgres.yaml">postgresql</a></td>
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

<h4>zot</h2>
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td>zot</td>
    <td><code>HelmRelease</code></td>
    <td><a href="services/zot/app/helm.yaml">zot</a></td>
    <td><a href="services/zot/app/redis.yaml">redis</a></td>
  </tr>
</table>
<!-- End apps section -->

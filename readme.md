## Extending Keycloak's Functionality with Observability Metrics using an SPI

In this post, I will explore how to use this SPI to add observability metrics to Keycloak and display them in Grafana. We will use Podman to deploy each application in a separate container : 

 - Keycloak 21.0.2
 - Prometheus
 - Grafana
 - Keycloak Metrics SPI (https://github.com/aerogear/keycloak-metrics-spi/releases)

You can find more details about how to add observability to Keycloak in my [blog](https://anissetiouajni.com/posts/extending_keycloak_functionality_with_observability_metrics/)

1. **Deploy Keycloak, Prometheus and Grafana:**

Open a terminal and run the following commands:
```
git clone http://github.com/atiouajni/keycloak-observability
cd keycloak-observability

podman build -t keycloak-observability -f Containerfile

podman create network net1
podman pod create -p 8181:8080 --network podman keycloak-pod
podman pod create -p 9191:9090 --network podman prometheus-pod
podman pod create -p 3131:3000 --network podman grafana-pod

podman run --name keycloak -d --pod keycloak-pod -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin localhost/keycloak-observability start-dev --metrics-enabled=true
podman run --name prometheus -d --pod prometheus-pod -v $(pwd)/prometheus-config.yaml:/etc/prometheus/prometheus.yml quay.io/prometheus/prometheus:v2.44.0
podman run --name grafana -d --pod grafana-pod grafana/grafana:9.5.2
```


2. **Check Prometheus status**

   - Open a browser and access the URL `http://localhost:9191` to access the Prometheus interface.
   - Select 'Status' > 'Targets' and check the endpoint `http://keycloak-pod:8080/realms/master/metrics`is `UP`.

   [Endpoint status UP](/img/2023-05-28/status_endpoint_up.png)

3. **Access to Keycloak observability**

- Open a browser and access the URL `http://localhost:3131` to access the Grafana interface.

- Log in with the default credentials (admin/admin).

- Click on the menu icon (represented by three horizontal lines) located at the top-left corner and select `Connections`. Create a Prometheus Connections and specify the url `http://prometheus-pod:9090`.

- From the menu, click now on "Dashboards" and select "New -> Import"  

- Import the dashboard file `grafana-dashboard-legacy.json` and set Prometheus instance as a datasource.

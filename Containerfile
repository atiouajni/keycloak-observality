FROM quay.io/keycloak/keycloak:21.0.2
# On build stage
COPY keycloak-metrics-spi-3.0.0.jar /opt/keycloak/providers/

# On run stage
COPY keycloak-metrics-spi-3.0.0.jar /opt/keycloak/providers/

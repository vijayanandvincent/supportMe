#!/bin/bash
set -e

echo "Starting Grafana lab setup..."

# Update system
apt update -y

# Install required packages
apt install -y wget curl stress software-properties-common

# -------------------------------
# Install Node Exporter
# -------------------------------
cd /opt
wget -q https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar xzf node_exporter-*.tar.gz
./node_exporter-*/node_exporter &

# -------------------------------
# Install Prometheus
# -------------------------------
wget -q https://github.com/prometheus/prometheus/releases/download/v2.52.0/prometheus-2.52.0.linux-amd64.tar.gz
tar xzf prometheus-*.tar.gz

cp /root/assets/prometheus.yml prometheus-*/prometheus.yml
cp /root/assets/alert.rules.yml prometheus-*/alert.rules.yml

./prometheus-*/prometheus \
  --config.file=prometheus-*/prometheus.yml &

# -------------------------------
# Install Grafana
# -------------------------------
apt install -y grafana
systemctl start grafana-server

# -------------------------------
# Simulate CPU Incident
# -------------------------------
stress --cpu 2 &

echo "Grafana lab ready!"
echo "Open Grafana at http://localhost:3000"

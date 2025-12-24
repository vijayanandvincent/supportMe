#!/bin/bash



echo "🚀 Starting Grafana CPU Incident Lab Setup..."

# Update OS
apt update -y

# Install dependencies
apt install -y wget curl stress software-properties-common

# -------------------------------
# Install Node Exporter
# -------------------------------
cd /opt
wget -q https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar xzf node_exporter-1.7.0.linux-amd64.tar.gz
nohup ./node_exporter-1.7.0.linux-amd64/node_exporter > /dev/null 2>&1 &

# -------------------------------
# Install Prometheus
# -------------------------------
wget -q https://github.com/prometheus/prometheus/releases/download/v2.52.0/prometheus-2.52.0.linux-amd64.tar.gz
tar xzf prometheus-2.52.0.linux-amd64.tar.gz

cp /root/assets/prometheus.yml prometheus-2.52.0.linux-amd64/
cp /root/assets/alert.rules.yml prometheus-2.52.0.linux-amd64/

nohup ./prometheus-2.52.0.linux-amd64/prometheus \
  --config.file=prometheus-2.52.0.linux-amd64/prometheus.yml > /dev/null 2>&1 &

# -------------------------------
# Install Grafana
# -------------------------------
apt install -y grafana
systemctl start grafana-server

# -------------------------------
# Simulate CPU Issue
# -------------------------------
stress --cpu 2 &

echo "✅ Grafana Lab Ready"
echo "🌐 Grafana URL: http://localhost:3000"
echo "👤 Login: admin / admin"

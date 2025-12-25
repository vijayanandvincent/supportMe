#!/bin/bash


echo "🚀 Starting Grafana CPU Incident Lab Setup..."

# -------------------------------
# Install dependencies
# -------------------------------
apt update -y
apt install -y wget curl stress tar

cd /opt

# -------------------------------
# Install Node Exporter
# -------------------------------
echo "📦 Installing Node Exporter..."
wget -q https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar xzf node_exporter-1.7.0.linux-amd64.tar.gz

nohup /opt/node_exporter-1.7.0.linux-amd64/node_exporter \
  > /var/log/node_exporter.log 2>&1 &

sleep 2

# -------------------------------
# Install Prometheus
# -------------------------------
echo "📦 Installing Prometheus..."
wget -q https://github.com/prometheus/prometheus/releases/download/v2.52.0/prometheus-2.52.0.linux-amd64.tar.gz
tar xzf prometheus-2.52.0.linux-amd64.tar.gz

cp /root/assets/prometheus.yml /opt/prometheus-2.52.0.linux-amd64/
cp /root/assets/alert.rules.yml /opt/prometheus-2.52.0.linux-amd64/

nohup /opt/prometheus-2.52.0.linux-amd64/prometheus \
  --config.file=/opt/prometheus-2.52.0.linux-amd64/prometheus.yml \
  > /var/log/prometheus.log 2>&1 &

sleep 3

# -------------------------------
# Install Grafana (BINARY)
# -------------------------------
echo "📦 Installing Grafana..."
wget -q https://dl.grafana.com/oss/release/grafana-10.2.3.linux-amd64.tar.gz
tar xzf grafana-10.2.3.linux-amd64.tar.gz

# IMPORTANT: actual extracted directory name
GRAFANA_DIR="/opt/grafana-v10.2.3"

nohup $GRAFANA_DIR/bin/grafana-server \
  --homepath=$GRAFANA_DIR \
  > /var/log/grafana.log 2>&1 &

sleep 5

# -------------------------------
# Simulate CPU Issue (1-core safe)
# -------------------------------
echo "🔥 Simulating CPU stress (1 core)..."
stress --cpu 1 --timeout 300 &

# -------------------------------
# Done
# -------------------------------
echo "✅ Grafana CPU Incident Lab Ready"
echo "🌐 Grafana: http://localhost:3000"
echo "📊 Prometheus: http://localhost:9090"
echo "👤 Grafana Login: admin / admin"

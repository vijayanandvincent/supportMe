#!/bin/bash


echo "🚀 Starting Grafana CPU Incident Lab Setup..."

# -------------------------------
# Install dependencies
# -------------------------------
apt update
apt install -y wget curl stress

cd /opt

# -------------------------------
# Install Node Exporter
# -------------------------------
echo "📦 Installing Node Exporter..."
wget -q https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar xzf node_exporter-1.7.0.linux-amd64.tar.gz

nohup /opt/node_exporter-1.7.0.linux-amd64/node_exporter \
  > /var/log/node_exporter.log 2>&1 &

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

# -------------------------------
# Install Grafana (BINARY)
# -------------------------------
echo "📦 Installing Grafana..."
wget -q https://dl.grafana.com/oss/release/grafana-10.2.3.linux-amd64.tar.gz
tar xzf grafana-10.2.3.linux-amd64.tar.gz

nohup /opt/grafana-v10.2.3/bin/grafana-server \
  --homepath=/opt/grafana-10.2.3 \
  > /var/log/grafana.log 2>&1 &

# -------------------------------
# Simulate CPU Issue
# -------------------------------
echo "🔥 Simulating CPU stress..."
stress --cpu 2 --timeout 1200 &

# -------------------------------
# Done
# -------------------------------
echo "✅ Grafana CPU Incident Lab Ready"
echo "🌐 Grafana: http://localhost:3000"
echo "📊 Prometheus: http://localhost:9090"
echo "👤 Grafana Login: admin / admin"

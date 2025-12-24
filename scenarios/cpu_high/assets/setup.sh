#!/bin/bash
set -e

echo "🚀 Starting Grafana lab setup..."

# -------------------------------
# System preparation
# -------------------------------
apt update -y
apt install -y wget curl stress software-properties-common

# -------------------------------
# Install Node Exporter
# -------------------------------
cd /opt
wget -q https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar xzf node_exporter-1.7.0.linux-amd64.tar.gz

nohup /opt/node_exporter-1.7.0.linux-amd64/node_exporter \
  > /var/log/node_exporter.log 2>&1 &

echo "✅ Node Exporter started"

# -------------------------------
# Install Prometheus
# -------------------------------
wget -q https://github.com/prometheus/prometheus/releases/download/v2.52.0/prometheus-2.52.0.linux-amd64.tar.gz
tar xzf prometheus-2.52.0.linux-amd64.tar.gz

cp /root/assets/prometheus.yml /opt/prometheus-2.52.0.linux-amd64/prometheus.yml
cp /root/assets/alert.rules.yml /opt/prometheus-2.52.0.linux-amd64/alert.rules.yml

nohup /opt/prometheus-2.52.0.linux-amd64/prometheus \
  --config.file=/opt/prometheus-2.52.0.linux-amd64/prometheus.yml \
  > /var/log/prometheus.log 2>&1 &

echo "✅ Prometheus started"

# -------------------------------
# Install Grafana (CORRECT WAY)
# -------------------------------
mkdir -p /etc/apt/keyrings
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor \
  > /etc/apt/keyrings/grafana.gpg

echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" \
  > /etc/apt/sources.list.d/grafana.list

apt update -y
apt install -y grafana

nohup /usr/sbin/grafana-server \
  --homepath=/usr/share/grafana \
  --config=/etc/grafana/grafana.ini \
  > /var/log/grafana.log 2>&1 &

echo "✅ Grafana started"

# -------------------------------
# Simulate CPU Incident
# -------------------------------
nohup stress --cpu 2 \
  > /var/log/stress.log 2>&1 &

echo "🔥 CPU stress started"

# -------------------------------
# Marker file
# -------------------------------
touch /tmp/grafana_lab_ready

echo "🎉 Grafana lab READY"
echo "👉 Grafana URL: http://localhost:3000"
echo "👉 Login: admin / admin"

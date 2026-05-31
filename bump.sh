#!/usr/bin/env bash
# Bump dummy_app version + reload. Usage: bash bump.sh 1.1.0
set -e
NEW="$1"
[ -z "$NEW" ] && { echo "usage: bash bump.sh <version>  e.g. 1.1.0"; exit 1; }

APP=~/frappe-bench/apps/dummy_app/dummy_app/__init__.py
SITE=restaurant-demo.localhost

OLD=$(grep -oE '"[0-9]+\.[0-9]+\.[0-9]+"' "$APP" | tr -d '"')
sed -i '' "s/__version__ = \"$OLD\"/__version__ = \"$NEW\"/" "$APP"
echo "version $OLD -> $NEW"

cd ~/frappe-bench
bench --site "$SITE" clear-cache >/dev/null 2>&1

# restart web so the new __version__ is re-imported
pkill -f "frappe.utils.bench_helper" >/dev/null 2>&1 || true
sleep 2
nohup bench start > ~/frappe-bench/bench-start.log 2>&1 &
sleep 12

echo "live version: $(curl -s -H "Host: $SITE" http://localhost:8000/dummy | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+')"

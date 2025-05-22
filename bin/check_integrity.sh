#!/bin/bash

# === Tanımlar ===
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPTS_DIR="/opt/scripts"
BASELINE_FILE="$ROOT_DIR/data/baseline_hashes.txt"
REPORT_FILE="$ROOT_DIR/data/integrity_report.txt"
TEMP_FILE="$ROOT_DIR/data/current_hashes.tmp"
LOG_FILE="$ROOT_DIR/logs/integrity.log"

# === Terminal çıktısı olmamalı ===
exec > /dev/null
exec 2>> "$LOG_FILE"

# === İlk çalıştırma: baseline yoksa oluştur ===
if [ ! -s "$BASELINE_FILE" ]; then
    echo "$(date): [INFO] Baseline dosyası oluşturuluyor." >> "$LOG_FILE"
    find "$SCRIPTS_DIR" -type f -exec /sbin/sha256sum {} \; > "$BASELINE_FILE"
    exit 0
fi

# === Güncel dosya hash'lerini geçici dosyaya yaz ===
find "$SCRIPTS_DIR" -type f -exec /sbin/sha256sum {} \; > "$TEMP_FILE"
echo "$(date): [INFO] Integrity kontrolü başladı." >> "$LOG_FILE"


# === integrity_report.txt'yi oluştur ===
echo "==== Dosya Bütünlüğü Raporu ($(date)) ====" > "$REPORT_FILE"

# === 1. Silinmiş veya değişmiş dosyaları bul ===
while read -r old_hash old_path; do
    if [ ! -f "$old_path" ]; then
        echo "[SİLİNMİŞ] $old_path" >> "$REPORT_FILE"
        echo "$(date): [SİLİNMİŞ] $old_path silinmiş." >> "$LOG_FILE"

    else
        new_hash=$(/sbin/sha256sum "$old_path" | awk '{print $1}')
        if [ "$old_hash" != "$new_hash" ]; then
            echo "[DEĞİŞMİŞ] $old_path" >> "$REPORT_FILE"
            echo "$(date): [DEĞİŞMİŞ] $old_path değişmiş." >> "$LOG_FILE"

        fi
    fi
done < "$BASELINE_FILE"

# === 2. Yeni dosyaları bul ===
while read -r new_hash new_path; do
    if ! grep -q "  $new_path\$" "$BASELINE_FILE"; then
        echo "[YENİ] $new_path" >> "$REPORT_FILE"
    fi
done < "$TEMP_FILE"

# === Temizlik ===
rm "$TEMP_FILE"

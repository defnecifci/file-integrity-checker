# 🔍 File Integrity Checker

Sunucunuzda **/opt/scripts/** klasöründe bulunan kritik script dosyalarının değiştirilip değiştirilmediğini otomatik olarak kontrol eden, cron uyumlu bash uygulaması.

---

## 🚀 Özellikler

* `sha256sum` ile dosya bütünlüğü kontrolü yapar
* İlk çalışmada `baseline_hashes.txt` dosyasını oluşturur
* Daha sonraki çalışmalarda:

  * 🔄 Değişen dosyaları tespit eder
  * 🗑️ Silinmiş dosyaları tanımlar
  * ➕ Yeni dosyaları algılar
* Farkları `integrity_report.txt` dosyasına yazar
* `integrity.log` ile işlem kayıtlarını tutar
* Cron ile otomatikleştirilebilir
* Sessiz çalışır, terminal çıktısı üretmez

---

## 📁 Klasör Yapısı

```
file-integrity-checker/
├── bin/
│   └── check_integrity.sh
├── data/
│   ├── baseline_hashes.txt
│   ├── integrity_report.txt
├── logs/
│   └── integrity.log
```

---

## ⚙️ Kurulum

### 1. Script klasörünü yerleştirin:

```bash
cd /Users/kullanici_adi/scripts/
git clone <repo-url> file-integrity-checker
```

### 2. Kayıt klasörünü oluşturun:

```bash
mkdir -p /opt/scripts
```

> Bu klasör kontrol edilecek scriptlerin yer alacağı dizindir.

### 3. Cron görevini tanımlayın:

```bash
crontab -e
```

Ve aşağıdaki satırı ekleyin:

```bash
0 3 * * * /bin/bash /Users/defnecifci/scripts/file-integrity-checker/bin/check_integrity.sh
```

> Bu komut, her gece 03:00'te integrity kontrolünü otomatik olarak başlatır.

---

## 🧠 Integrity Kontrolü Nedir?

**Integrity (bütünlük)** kontrolü, dosyaların **izinsiz, bilinmeyen veya beklenmeyen şekilde değişip değişmediğini** belirlemek amacıyla yapılan bir işlemdir.

Bu kontrol sayesinde:

* Dosyalar değiştirildi mi?
* Yeni dosyalar eklendi mi?
* Mevcut dosyalar silindi mi?

sorularının yanıtları bulunur.

Bu sistem, özellikle güvenlik açısından hassas ortamlarda **dosya güvenilirliğini** sağlamak için kullanılır.

---

## 🧪 Örnek Çıktı

```
==== Dosya Bütünlüğü Raporu (Fri May 24 03:00:00 +03 2025) ====
[DEĞİŞMİŞ] /opt/scripts/deploy.sh
[YENİ] /opt/scripts/debug_helper.sh
[SİLİNMİŞ] /opt/scripts/old_cleanup.sh
```

---

## 📦 Gereksinimler

* macOS veya Linux terminal
* `sha256sum` komutu (macOS’te `/sbin/sha256sum` olarak çağrılır)
* `cron` yüklü ve aktif

---

## 📝 Not

`data/baseline_hashes.txt` ve `logs/integrity.log` dosyaları repoda yer almaz.

Bu dosyalar script çalıştığında otomatik olarak oluşturulur.

Her kullanıcıda farklı değerler üretileceği için repoda paylaşılmaz.

`data/integrity_report.txt` dosyası repoda boş olarak yer alır.

Script çalıştığında bu dosya otomatik olarak doldurulur.

Böylece klasör yapısı eksik görünmez.

---

## 📜 Lisans

MIT Lisansı

---



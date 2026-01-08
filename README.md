# 🛠️ E-Commerce Admin Dashboard (Yönetici Paneli)

Bu proje, E-Ticaret ekosisteminin **Yönetim Merkezi (Back-Office)** ayağıdır. İşletme sahibinin envanterini yönetmesi, siparişleri takip etmesi ve ürün kataloğunu güncellemesi için geliştirilmiştir.

> **🔗 Ekosistem Bağlantısı:**
> Bu panelde yapılan tüm değişiklikler (Ürün ekleme, fiyat güncelleme vb.) anlık olarak **Müşteri Uygulaması**'na yansır.
>
> 📱 **Müşteri (User) Uygulamasını İncelemek İçin Tıklayın:**
> [![Client App](https://img.shields.io/badge/Müşteri_Uygulamasına_Git-Blue?style=for-the-badge&logo=flutter)](https://github.com/younessemre/eticaret_uygulamasi)

---

## 💻 Yönetim Paneli Ekranları

Panel, verimlilik ve hızlı işlem yapabilme üzerine tasarlanmıştır.

| 📊 Ana Kontrol Paneli (Dashboard) | ➕ Ürün Ekleme & Düzenleme |
|:---:|:---:|
| https://github.com/user-attachments/assets/dfd666d4-e41d-4136-b879-171ed19fa091 | https://github.com/user-attachments/assets/c0ce0417-1e21-4879-ab66-6e79a5a0009e
 |
| *Hızlı erişim menüsü ve genel bakış* | *Görsel yükleme, stok ve fiyat giriş formu* |

| 📦 Ürün Kataloğu & Arama | 📋 Sipariş Takibi |
|:---:|:---:|
| ![All Products](3.jpeg) | ![Orders](4.jpeg) |
| *Canlı arama, filtreleme ve ürün silme* | *Gelen siparişlerin listesi ve detayları* |

![Uploading 1.jpeg…]()

---

## ✨ Temel Yetenekler (Admin Capabilities)

* **CRUD İşlemleri:** Ürünleri ekleme, güncelleme ve silme yetkisi.
* **☁️ Bulut Depolama (Cloud Storage):** `image_picker` entegrasyonu ile ürün fotoğraflarını cihazdan seçip Firebase Storage'a yükleme.
* **📦 Sipariş Yönetimi:** Müşterilerden gelen siparişlerin anlık olarak listelenmesi.
* **🔍 Dinamik Arama:** Binlerce ürün arasından anında filtreleme yapabilme.
* **📉 Stok Kontrolü:** Ürün adetlerini ve kategorilerini yönetme.
* **🎨 Dashboard UI:** `Dynamic Height Grid View` ve `Card Swiper` ile modern ve responsive bir arayüz.

## 🛠️ Teknik Altyapı

Tıpkı müşteri uygulamasında olduğu gibi, bu projede de **Clean Architecture** ve **Scalable (Ölçeklenebilir)** kod yapısı kullanılmıştır.

| Kategori | Teknoloji | Açıklama |
| :--- | :--- | :--- |
| **State Management** | `Provider` | Tüm uygulama genelinde veri akışı yönetimi. |
| **Backend** | `Firebase` | Firestore (Veri), Auth (Güvenlik), Storage (Resim). |
| **UI Components** | `Shimmer Effect` | Veriler yüklenirken profesyonel dolum efekti. |
| **Form Handling** | `TextControllers` | Hata yakalama ve validasyon işlemleri. |

## 📂 Klasör Yapısı

* `screens/`:
    * `dashboard_screen.dart`: Ana menü.
    * `edit_upload_product.dart`: Ürün form işlemleri.
    * `orders_screen.dart`: Sipariş listesi.
* `services/`: Global fonksiyonlar ve Firebase yardımcı metodları.
* `providers/`: Ürün ve Sipariş verilerinin yönetildiği mantıksal katman.
* `models/`: Veri güvenliği için oluşturulmuş nesne modelleri.

## 🚀 Kurulum

1.  Repoyu klonlayın:
    ```bash
    git clone [https://github.com/KULLANICI_ADIN/ecommerce-admin.git](https://github.com/KULLANICI_ADIN/ecommerce-admin.git)
    ```
2.  Paketleri yükleyin:
    ```bash
    flutter pub get
    ```
3.  **Firebase Ayarı:** Aynı Firebase projesine ait `google-services.json` dosyasını `android/app` klasörüne ekleyin (Müşteri uygulamasıyla aynı veritabanını kullanmalıdır).
4.  Başlatın:
    ```bash
    flutter run
    ```

---
*Geliştirici: [Senin Adın]*

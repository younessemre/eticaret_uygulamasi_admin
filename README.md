<div align="center">
  <br>
  <img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&height=100&section=header&text=E-Ticaret Uygulaması%20Admin%20Paneli&fontSize=30&animation=fadeIn&fontAlign=50" width="100%"/>
  
  <p>
    <i>Ürün ekleme, stok takibi ve sipariş yönetiminin yapıldığı merkez.</i>
  </p>

  <a href="https://github.com/younessemre/eticaret_uygulamasi">
    <img src="https://img.shields.io/badge/🚀_Müşteri_Uygulamasına_Git-İNCELE-FF7043?style=for-the-badge&logo=flutter&logoColor=white&color=black&labelColor=FF7043" height="45">
  </a>
  <br><br>
</div>


## 💻 Yönetim Paneli Ekranları

Panel, verimlilik ve hızlı işlem yapabilme üzerine tasarlanmıştır.

| 📊 Ana Kontrol Paneli (Dashboard) | ➕ Ürün Ekleme & Düzenleme |
|:---:|:---:|
| ![1](https://github.com/user-attachments/assets/0687816b-cbf3-4cf5-adf1-266be76b3753) | ![2](https://github.com/user-attachments/assets/d3b9f7b8-85e3-4a8b-bf14-950fb0abb92c) |
| *Hızlı erişim menüsü ve genel bakış* | *Görsel yükleme, stok ve fiyat giriş formu* |

| 📦 Ürün Kataloğu & Arama | 📋 Sipariş Takibi |
|:---:|:---:|
| ![3](https://github.com/user-attachments/assets/bef1404f-ea81-4012-9ea1-d4e7eeb836cd) | ![4](https://github.com/user-attachments/assets/66f5cd06-f17e-4d5b-afb0-b60e95106096) |
| *Canlı arama, filtreleme ve ürün silme* | *Gelen siparişlerin listesi ve detayları* |

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

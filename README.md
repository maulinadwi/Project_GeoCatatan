# geo_catatan_project
LANGKAH KERJA
- menambahkan depedensi di pubspec.yaml
  flutter_map: ^6.1.0: digunakan untuk menampilkan peta interaktif.
  latlong2: ^0.9.0: digunakan untuk koordinat geografis(LatLng).
  shared_preferences: ^2.2.2: digunakan untuk menyimpan data agar tidak hilang saat aplikasi ditutup
  
  <img width="164" height="104" alt="image" src="https://github.com/user-attachments/assets/0ed0d6d6-9a1a-43b1-8cc5-69a5d7c4647e" />

- PENGATURAN IZIN
  menambahkan ijin pada android android/app/src/main/AndroidManifest.xml
 tepatdiatastag<application>
 
 <img width="416" height="50" alt="image" src="https://github.com/user-attachments/assets/4d502249-044d-4985-9c8e-5bfd1eed2cea" />

- Membuat model data
  dengan nama catatan_model, digunakan untuk menyimpan informasi setiap marker di peta termasuk posisi, alamat, jenis nya
  
  <img width="237" height="128" alt="image" src="https://github.com/user-attachments/assets/e0ca04f1-018b-4da7-aed2-610a20cbd6a1" />
  
  dan menambahkan ini di catatan_model buat simpan dan ambil catatan ke/dari penyimpanan (SharedPreferences) dalam bentuk JSON.
  
  <img width="283" height="181" alt="image" src="https://github.com/user-attachments/assets/a5850796-ecc0-41db-9662-226f7ddf5deb" />


# TUGAS MANDIRI
1. Kustomisasi Marker: Ubah ikon marker agar berbeda-beda tergantung jenis
 catatan(misal:Toko,Rumah,Kantor).
- menambahkan fungsi _handlelongpress digunakan untuk mengambil lokasi dan jenis catatan serta fungsi ini digunakan saat menekan lama di peta baru muncul pilihan jenis lokasi
<img width="423" height="280" alt="image" src="https://github.com/user-attachments/assets/3f7de857-56d5-4500-8ab0-b086f52977a1" />

- selanjutnya untuk kustom marker , kode ini digunakan untuk kustomisasi marker dan membuat ikon marker berbeda-beda yang sesuai jenis catatan, disini rumah berwarna hijau, toko warna biru dan kantor warna oren. disini juga menggunakan switch case untuk memetakan tiap jenis catatan ke ikon & warna spesifik dengan cara yang jelas, rapi
  
   <img width="323" height="227" alt="image" src="https://github.com/user-attachments/assets/f7e038ed-4477-474a-abc3-1373dd466791" />


2. Hapus Data: Tambahkan fitur untuk menghapus marker yang sudah dibuat
   singkatnya saat pengguna mengetuk marker di peta OnTap di marker terpanggil dan muncul tulisan pertanyaan “Apakah yakin ingin menghapus marker ini?”, jika batal ditutup dan marker ada, dan jika dihapus marker dihapus dari list _savedNotes → _savedNotes.remove(n), dan untuk _saveNotes() → memperbarui data di SharedPreferences agar tetap tersimpan.
   
   <img width="356" height="284" alt="image" src="https://github.com/user-attachments/assets/63300df3-a916-4afb-ac1c-4db351710887" />

   
3. SimpanData: (Opsional) Gunakan Shared Preferences atau Hive agar data
 tidak hilang saat aplikasi ditutup.
-  _saveNotes() digunakan untuk menyimpan catatan, yang pertama Memanggil SharedPreferences.getInstance() → untuk mengakses penyimpanan lokal perangkat. kedua Mengubah setiap objek catatanmodel di _savedNotes menjadi Map dengan toJson(). ketiga mengubah list Map menjadi JSON string dengan jsonEncode(). terakhir menyimpan JSON string tersebut ke SharedPreferences dengan key 'saved_notes'. dimana intinya digunakan untuk mengubah list catatan menjadi format yang bisa disimpan di memori perangkat sehingga tetap ada walaupun aplikasi ditutup.
-  _loadNotes() digunakan untuk memuat catatan, yang pertama Mengakses SharedPreferences dengan getInstance(), kedua mengakses SharedPreferences dengan getInstance(), ketiga kalau ada data maka mengubah JSON string menjadi list dynamic (jsonDecode) dan mengubah setiap item menjadi objek catatanModel dengan fromJson() serta menyimpan hasilnya ke _savedNotes dan menampilkan marker di peta. intinya ini digunakan mengambil catatan yang sudah disimpan dan menampilkannya lagi saat aplikasi dibuka.
 
  <img width="389" height="281" alt="image" src="https://github.com/user-attachments/assets/39e301fb-582d-4698-832a-da30363c3bb1" />

  # Hasil Tampilan
  - tampilan awal
    
  <img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/a4f4b78d-fd4c-4115-a043-31318a8e5b3b" />

  - setelah di atur lokasi sekarang, disini masih kosong belum ada marker
    
    <img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/6be777f3-a88a-45a3-a095-a9fb851a07ec" />

   - saat di pencet lama akan muncul pilihan jenis lokasi
     
     <img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/b1937eda-854a-439b-a1fa-01f0aae9a6aa" />

   - tampilan saat sudah ada marker rumah yang berwarna hijau, toko berwarna biru dan kantor warna oren disesuaikan dengan pilihan jenis lokasi tadi
     
     <img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/854bae2b-8c2d-4351-836d-fb07a0bab749" />

  - tampilan pilihan hapus salah satu marker , saat di pencet salah satu marker akan menampilkan hapus marker yang menampilkan dialog seperti digambar dan pilihan batal/hapus
    
    <img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/8324f6e8-59ff-4870-a8b5-7e4ef6d62cc8" />

   - tampilan saat salah satu marker dihapus
     
     <img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/196f56c6-454c-44b3-bd46-cc3729a87e4f" />

   - tampilan aplikasi setelah ditutup marker yang awalnya dihapus akan tampil kembali menggunakan Shared Preferences

     <img width="576" height="1280" alt="image" src="https://github.com/user-attachments/assets/61387d2c-af20-4480-b13a-c4d315985e6a" />

     

    



     






  



  

 


  
  



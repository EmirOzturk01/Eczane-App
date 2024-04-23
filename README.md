Bu uygulama konumunuza göre en yakın 20 eczaneyi harita üzerinde göstermektedir. Pazar günleri ve kalan günlerin 19.00 - 09.00 saatleri arasında nöbetçi eczaneler gösterilmektedir.
Eczaneye en kısa yoldan ulaşmak için istenilen eczane seçilerek navigasyon butonuyla navigasyon ekranına yönlendireleceksiniz. Bu ekrandan dilediğiniz yolları seçebilirsiniz.
Eczaneyi aramak isterseniz de istenilen eczaneyi seçerek arayabilirsiniz.
Başka bir konumdaki veya sık kullandığınız (Örneğin: iş yeri vb.) başka bir konumdaki en yakın eczaneleri öğrenmek içinse adreslerim sayfasından dilediğiniz adresi ekleyebilirsiniz.

- 100% Programmatic UI
- Kullanılan 3.Parti kütüphaneler
  - IQKeyboardManager (Swift Package Manager)
- Core Data
- Kullanılan API'ler
  - https://www.nosyapi.com/api/nobetci-eczane
  - https://www.nosyapi.com/api/turkiye-eczane-listesi

Uygulamadaki eksiklikler;
- Kaydedilen adresten eczane seçip navigasyon butonuna tıklandığında navigasyon kayıtlı adres konumunu değil şuanki konumunuzu çekiyor.
- MVVM Design Pattern kullanmış olmama rağmen View lerin içerisinde bazı aksiyonlar yazdım. Bunların delegate kullanılarak bağlantılı VC de override edilerek düzeltilmesi gerekmektedir. (Düzeltmek için çok vaktim yok)
- Eczane Listesi ekranına gelince TabBar'ın renginin değişmesi ve öyle kalması.
- İnternetin yavaşlığı göz önünde bulundurulup veri yüklenene kadar ekranda dönen bir indicator eklenebilir.

Not: Uygulamayı kullanabilmeniz için nosyapi sitesinden apikeyinizi Utilities klasöründeki Constants sınıfındaki API_KEY e atamanız gerekmektedir. Ayrıca site üzerinden ilgili apilerin ücretsiz kredilerini alıp aktif hala getirmeniz gerekmektedir.

![harita1](https://github.com/EmirOzturk01/Eczane-App/assets/104322642/daa59f69-87a0-45b1-ab1d-0aedf9c77ec6) ![harita2](https://github.com/EmirOzturk01/Eczane-App/assets/104322642/411d2ba8-eb95-4bee-a254-7d96126e2b21)
![liste1](https://github.com/EmirOzturk01/Eczane-App/assets/104322642/3cb6bac4-9212-4576-a38b-c1642e9d0fd8) ![liste2](https://github.com/EmirOzturk01/Eczane-App/assets/104322642/b982d57b-8620-4b79-8cb7-9370b3947b46)
![Ekran Resmi 2024-04-23 05 33 20](https://github.com/EmirOzturk01/Eczane-App/assets/104322642/ed080daa-ea89-47aa-919c-b03aff5b0b93)
![adreslerim1](https://github.com/EmirOzturk01/Eczane-App/assets/104322642/2d177336-c62f-44a2-a486-e7219f9e25ef) ![adreslerim2](https://github.com/EmirOzturk01/Eczane-App/assets/104322642/2047694b-2945-4aa3-ba7d-e428e2e680e8)
![adreslerim3](https://github.com/EmirOzturk01/Eczane-App/assets/104322642/fdaa75f7-72d0-4455-90e1-05d98e89499a)

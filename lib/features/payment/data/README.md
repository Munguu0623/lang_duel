# payment/data — Төлбөрийн өгөгдлийн давхарга

Одоогийн `payment_screen.dart` нь зүгээр `isPremium = true` болгодог.
Жинхэнэ in-app purchase + backend баталгаажуулалт руу шилжинэ.

---

## datasources/

### payment_remote_datasource.dart
**Үүрэг:** Backend-ийн payment endpoint-уудтай харилцана

Хийх зүйл:
- `verifyPurchase(PurchaseVerifyRequestDto body)` → `POST /payments/verify`
  - body: `{ platform: 'ios'|'android', productId: String, receiptData: String }`
  - Backend нь App Store / Google Play API-р баталгаажуулна
  - Response: `PremiumStatusDto` (isPremium, expiresAt, productId)
- `getSubscriptionStatus()` → `GET /users/me/subscription`
  - App нээх болгонд premium статус шалгана

---

## models/

### premium_status_dto.dart
`POST /payments/verify` болон `GET /users/me/subscription` хариуны shape:
- `isPremium: bool`
- `productId: String?` ('monthly' | 'annual')
- `expiresAt: DateTime?`
- `autoRenewing: bool`

### purchase_verify_request_dto.dart
`POST /payments/verify` request body:
- `platform: String` ('ios' | 'android')
- `productId: String`
- `receiptData: String` — iOS: receipt-data, Android: purchaseToken
- `transactionId: String`

---

## repositories/

### payment_repository_impl.dart
**Үүрэг:** In-app purchase + backend verification нэгтгэнэ

Урсгал:
1. `in_app_purchase` package-аас purchase stream сонсоно
2. Purchase амжилттай бол receipt-г remote datasource-д илгээнэ
3. Backend баталгаажуулбал `UserNotifier.setPremium(true)` дуудна
4. Error үед хэрэглэгчид мессеж харуулна (орлого тооцохгүй)

**ЧУХАЛ:** `in_app_purchase` package-г pubspec.yaml-д нэмэх шаардлагатай.

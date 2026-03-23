# payment/domain — Төлбөрийн бизнес логик

---

## payment_repository.dart
**Үүрэг:** Payment feature-ийн abstract interface

Тодорхойлох method-ууд:
- `Future<PremiumStatus> verifyPurchase(String platform, String productId, String receiptData)` — purchase баталгаажуулна
- `Future<PremiumStatus> getSubscriptionStatus()` — одоогийн premium статус
- `Future<List<ProductDetails>> getAvailableProducts()` — App Store/Play Store-с бүтээгдэхүүн жагсаалт

`PremiumStatus` entity:
- `isPremium: bool`
- `expiresAt: DateTime?`
- `productId: String?`

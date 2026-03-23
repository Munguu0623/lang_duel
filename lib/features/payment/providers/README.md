# payment/providers — Төлбөрийн Riverpod state management

---

## payment_providers.dart
**Үүрэг:** Subscription болон purchase state удирдах provider-ууд

### paymentRepositoryProvider — Provider<PaymentRepository>
- `PaymentRepositoryImpl` instance буцаана

### subscriptionStatusProvider — FutureProvider<PremiumStatus>
- App нээх үед `getSubscriptionStatus()` дуудна
- `currentUserProvider`-г watch хийж нэвтрэхэд автоматаар refresh хийнэ

### purchaseProvider — AsyncNotifierProvider<PurchaseNotifier, void>
- `purchase(String productId)` action:
  1. `in_app_purchase`-аар худалдан авалт эхлүүлнэ
  2. Receipt-г backend-д баталгаажуулна
  3. Амжилттай бол `subscriptionStatusProvider` refresh хийнэ
- Loading: "Баталгаажуулж байна..." spinner
- Error: тухайн алдааны мессеж харуулна (network error, payment declined гэх мэт)

### availableProductsProvider — FutureProvider<List<ProductDetails>>
- App Store / Google Play-с ongoin бүтээгдэхүүний үнэ, нэр ачаална
- `payment_screen.dart`-д ашиглана

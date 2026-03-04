import 'package:flutter/foundation.dart';

/// Lightweight global subscription state.
///
/// In production this would be backed by RevenueCat / StoreKit,
/// but for the prototype it's a simple in-memory singleton.
class SubscriptionState extends ValueNotifier<bool> {
  SubscriptionState._() : super(false);

  static final SubscriptionState instance = SubscriptionState._();

  /// Whether the user has an active Pro subscription (persisted state).
  bool get isPro => value;

  /// Mark as Pro (called after successful purchase).
  void markPro() {
    value = true;
  }

  /// Reset (for testing / logout).
  void reset() {
    value = false;
  }
}

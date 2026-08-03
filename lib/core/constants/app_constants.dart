class AppConstants {
  const AppConstants._();

  static const appName = 'PRITICIOUS DRY FRUITS';
  static const appVersion = '1.0.0';
  static const currencySymbol = '₹';
  static const freeDeliveryThreshold = 999.0;
  static const standardDeliveryCharge = 49.0;
  
  /// Whether to charge a delivery fee below the free delivery threshold.
  /// Set to `false` to make all deliveries free.
  static const enableDeliveryCharges = false;

  /// Firebase Cloud Messaging Web Push Certificate (VAPID) Key
  static const vapidKey = 'BEcKftkfBkVn8D5I96OtW62XEnnQXTOUHpEi921kUSYZVHIR-7Z92QsytXOZF67D7AMqsWyc1Hl7FtzYqIYnfXw';
}

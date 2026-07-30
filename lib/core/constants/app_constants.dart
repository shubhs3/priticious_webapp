class AppConstants {
  const AppConstants._();

  static const appName = 'PRITICIOUS DRY FRUITS';
  static const appVersion = '1.0.0';
  static const currencySymbol = '₹';
  static const freeDeliveryThresholdInPaise = 99900;
  static const standardDeliveryChargeInPaise = 4900;
  
  /// Whether to charge a delivery fee below the free delivery threshold.
  /// Set to `false` to make all deliveries free.
  static const enableDeliveryCharges = false;
}

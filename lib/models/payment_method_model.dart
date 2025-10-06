enum PaymentType { cod, qris }

class PaymentMethod {
  final String name;
  final String description;
  final String logoAsset;
  final PaymentType type;

  PaymentMethod({
    required this.name,
    required this.description,
    required this.logoAsset,
    required this.type,
  });
}
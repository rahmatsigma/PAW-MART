import 'package:flutter/material.dart';
import 'models/payment_method_model.dart';

class PaymentMethodPage extends StatefulWidget {
  final PaymentMethod? currentMethod;

  const PaymentMethodPage({super.key, this.currentMethod});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  PaymentMethod? _selectedMethod;

  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(
      name: 'QRIS',
      description: 'Pembayaran via QR Code (Gopay, OVO, Dana, dll)',
      logoAsset: 'assets/qris.png', 
      type: PaymentType.qris,
    ),
    PaymentMethod(
      name: 'COD (Bayar di Tempat)',
      description: 'Bayar tunai saat pesanan tiba',
      logoAsset: '', 
      type: PaymentType.cod,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.currentMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Metode Pembayaran'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: ListView.separated(
        itemCount: _paymentMethods.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final method = _paymentMethods[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Image.asset(
                method.logoAsset,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.payment), 
              ),
            ),
            title: Text(method.name),
            subtitle: Text(method.description),
            trailing: Radio<PaymentMethod>(
              value: method,
              groupValue: _selectedMethod,
              onChanged: (PaymentMethod? value) {
                setState(() {
                  _selectedMethod = value;
                });
              },
            ),
            onTap: () {
              setState(() {
                _selectedMethod = method;
              });
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: _selectedMethod == null
              ? null
              : () {
                  Navigator.pop(context, _selectedMethod);
                },
          child: const Text('Konfirmasi'),
        ),
      ),
    );
  }
}
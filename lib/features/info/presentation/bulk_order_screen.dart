import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/responsive_page.dart';

class BulkOrderScreen extends StatefulWidget {
  const BulkOrderScreen({super.key});

  @override
  State<BulkOrderScreen> createState() => _BulkOrderScreenState();
}

class _BulkOrderScreenState extends State<BulkOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitEnquiry() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you! Your bulk order inquiry has been submitted. Our team will contact you within 2 hours.'),
            backgroundColor: Colors.green,
          ),
        );
        _formKey.currentState!.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bulk & Corporate Orders')),
      body: SingleChildScrollView(
        child: ResponsivePage(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF382A03),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CORPORATE & WHOLESALE SUPPLY',
                        style: GoogleFonts.josefinSans(
                          color: const Color(0xFFE8B830),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bulk Dry Fruits, Nuts & Personalised Gift Hampers',
                        style: GoogleFonts.josefinSans(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Whether you need bulk supplies for weddings, corporate gifting, retail distribution, or festive hampers, we offer direct wholesale rates with custom branding options.',
                        style: GoogleFonts.josefinSans(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFEBE5DF)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bulk Inquiry Form',
                          style: GoogleFonts.josefinSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4A3700),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name *',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (val) => val == null || val.isEmpty ? 'Please enter your name' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _companyController,
                          decoration: const InputDecoration(
                            labelText: 'Company / Organization Name',
                            prefixIcon: Icon(Icons.business_outlined),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  labelText: 'Phone Number *',
                                  prefixIcon: Icon(Icons.phone_outlined),
                                ),
                                validator: (val) => val == null || val.length < 8 ? 'Enter valid phone number' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'Email Address *',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                                validator: (val) => val == null || !val.contains('@') ? 'Enter valid email' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _quantityController,
                          decoration: const InputDecoration(
                            labelText: 'Estimated Quantity (e.g. 50 kg / 100 Hampers) *',
                            prefixIcon: Icon(Icons.inventory_2_outlined),
                          ),
                          validator: (val) => val == null || val.isEmpty ? 'Enter estimated quantity' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _notesController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Specific Products & Customization Requirements',
                            prefixIcon: Icon(Icons.notes_outlined),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitEnquiry,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC59B27),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : Text(
                                    'SUBMIT BULK INQUIRY',
                                    style: GoogleFonts.josefinSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

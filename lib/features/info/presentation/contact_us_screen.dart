import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/responsive_page.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSending = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isSending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Message sent successfully! We will get back to you shortly.'),
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
      appBar: AppBar(title: const Text('Contact Us')),
      body: SingleChildScrollView(
        child: ResponsivePage(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GET IN TOUCH',
                  style: GoogleFonts.josefinSans(
                    color: const Color(0xFF4A3700),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Have questions about products, delivery, or feedback? Send us a message below.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 20),

                Row(
                  children: const [
                    Expanded(
                      child: _ContactDetailCard(
                        icon: Icons.phone,
                        title: 'Call Us',
                        value: '+91-7483600212\n+91-9364896022',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _ContactDetailCard(
                        icon: Icons.email,
                        title: 'Email Us',
                        value: 'info@priticious.com\nsupport@priticious.com',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

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
                          'Send a Message',
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
                            labelText: 'Your Name *',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (val) => val == null || val.isEmpty ? 'Enter your name' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Your Email *',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (val) => val == null || !val.contains('@') ? 'Enter valid email' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _messageController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Your Message *',
                            prefixIcon: Icon(Icons.message_outlined),
                          ),
                          validator: (val) => val == null || val.isEmpty ? 'Enter your message' : null,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isSending ? null : _sendMessage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC59B27),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: _isSending
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : Text(
                                    'SEND MESSAGE',
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

class _ContactDetailCard extends StatelessWidget {
  const _ContactDetailCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEBE5DF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFC59B27), size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.josefinSans(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: const Color(0xFF4A3700),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

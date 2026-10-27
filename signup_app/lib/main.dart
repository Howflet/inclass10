import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// 🧓 Great-Grandparent
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun Signup App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // 🔑 The Global Key - acts like a remote control for the form
  final _formKey = GlobalKey<FormState>();
  
  // 📝 Controllers to track what the user types
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 💡 Fixed preset tips for one category (never uses form values)
  static const String _tipCategory = 'password_help';
  static const Map<String, List<String>> _presetTips = {
    'password_help': [
      'Try a short phrase of random words; longer passwords are stronger.',
      'Avoid reusing a password from another site.',
      'A password manager can create and remember strong passwords for you.',
    ],
  };

  bool _tipLoading = false;
  bool _simulateTipError = false; // demo switch for the local error case
  String? _tipText;
  String? _tipError;
  int _tipIndex = 0;

  Future<void> _getTip() async {
    setState(() {
      _tipLoading = true;
      _tipText = null;
      _tipError = null;
    });
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    if (_simulateTipError) {
      setState(() {
        _tipLoading = false;
        _tipError = 'Could not load a tip. Please try again.';
      });
      return;
    }
    final tips = _presetTips[_tipCategory]!;
    final tip = tips[_tipIndex % tips.length];
    _tipIndex++;
    setState(() {
      _tipLoading = false;
      _tipText = tip.length > 240 ? tip.substring(0, 240) : tip;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // 👨 Parent
      appBar: AppBar(
        title: const Text('Join Us Today for the Cash Money!'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
         child: Form( // 👶 Child
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Create Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // 👤 Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // 📧 Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // 🔒 Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // 🚀 Sign Up Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Demo signup complete — your form passed validation!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),

              // 💡 Sign up tip (preset demo only)
              TextButton.icon(
                onPressed: _tipLoading ? null : _getTip,
                icon: const Icon(Icons.lightbulb_outline),
                label: const Text('Get a sign up tip'),
              ),
              SwitchListTile(
                dense: true,
                title: const Text('Simulate tip error (demo)'),
                value: _simulateTipError,
                onChanged: (v) => setState(() => _simulateTipError = v),
              ),
              if (_tipLoading) const CircularProgressIndicator(),
              if (_tipText != null) ...[
                Text(_tipText!, style: const TextStyle(fontStyle: FontStyle.italic)),
              ],
              if (_tipError != null) ...[
                Text(_tipError!, style: const TextStyle(color: Colors.red)),
                TextButton(onPressed: _getTip, child: const Text('Retry')),
              ],
            ],
          ),
         ),
        ),
      ),
    );
  }
}
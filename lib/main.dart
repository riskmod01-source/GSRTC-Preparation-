import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase Initialization Note: $e');
  }
  runApp(const GSRTCSarthiApp());
}

class GSRTCSarthiApp extends StatelessWidget {
  const GSRTCSarthiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GSRTC સારથિ & મિત્ર',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'sans-serif',
        colorSchemeSeed: const Color(0xFF0D5C46),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const SplashScreen(),
    );
  }
}

// ---------------- ૦. SPLASH SCREEN (લોડિંગ સ્ક્રીન) ----------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MasterAppRouter()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF0D5C46);
    const accentYellow = Color(0xFFE5A93C);

    return Scaffold(
      backgroundColor: primaryGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: accentYellow,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.directions_bus_rounded, color: Colors.black87, size: 55),
            ),
            const SizedBox(height: 24),
            const Text(
              'GSRTC સારથિ & મિત્ર',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'કંડક્ટર & ડ્રાઈવર ભરતી પરીક્ષા તૈયારી',
              style: TextStyle(
                color: accentYellow,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 40),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                color: accentYellow,
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- મોડેલ્સ ----------------
class CompleteQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  CompleteQuestion({required this.question, required this.options, required this.correctIndex});
}

class SpecialExamModel {
  final String id;
  final String title;
  final String targetRole;
  final int price;
  final int durationMinutes;
  final List<CompleteQuestion> questions;

  SpecialExamModel({
    required this.id,
    required this.title,
    required this.targetRole,
    required this.price,
    required this.durationMinutes,
    required this.questions,
  });
}

// ---------------- સેન્ટ્રલ ડેટા સ્ટોર ----------------
class AppDataStore {
  static Map<String, List<CompleteQuestion>> fullMockQuestions = {
    'કંડક્ટર': List.generate(
      100,
      (i) => CompleteQuestion(
        question: 'કંડક્ટર ફુલ મોક પ્રશ્ન ${i + 1}: સિલેબસ આધારિત પ્રશ્ન વિગત?',
        options: ['વિકલ્પ A (સાચો)', 'વિકલ્પ B', 'વિકલ્પ C', 'વિકલ્પ D'],
        correctIndex: 0,
      ),
    ),
    'ડ્રાઈવર': List.generate(
      100,
      (i) => CompleteQuestion(
        question: 'ડ્રાઈવર ફુલ મોક પ્રશ્ન ${i + 1}: સિલેબસ આધારિત પ્રશ્ન વિગત?',
        options: ['વિકલ્પ A (સાચો)', 'વિકલ્પ B', 'વિકલ્પ C', 'વિકલ્પ D'],
        correctIndex: 0,
      ),
    ),
  };

  static Map<String, List<CompleteQuestion>> subjectQuestions = {};

  static List<SpecialExamModel> activeSpecialTests = [
    SpecialExamModel(
      id: 'spec_cond_1',
      title: 'કંડક્ટર મેગા સિલેક્શન ટેસ્ટ 2026',
      targetRole: 'કંડક્ટર',
      price: 49,
      durationMinutes: 60,
      questions: List.generate(
        100,
        (i) => CompleteQuestion(
          question: 'કંડક્ટર સ્પેશિયલ પેઇડ પ્રશ્ન ${i + 1}: ભાડા ગણતરી અને લગેજ નિયમ?',
          options: ['વિકલ્પ A (સાચો)', 'વિકલ્પ B', 'વિકલ્પ C', 'વિકલ્પ D'],
          correctIndex: 0,
        ),
      ),
    ),
    SpecialExamModel(
      id: 'spec_driv_1',
      title: 'ડ્રાઈવર એન્જિન & સેફ્ટી સ્પેશિયલ ટેસ્ટ',
      targetRole: 'ડ્રાઈવર',
      price: 59,
      durationMinutes: 60,
      questions: List.generate(
        100,
        (i) => CompleteQuestion(
          question: 'ડ્રાઈવર સ્પેશિયલ પેઇડ પ્રશ્ન ${i + 1}: એન્જિન ફોલ્ટ અને કૂલિંગ સિસ્ટમ?',
          options: ['વિકલ્પ A (સાચો)', 'વિકલ્પ B', 'વિકલ્પ C', 'વિકલ્પ D'],
          correctIndex: 0,
        ),
      ),
    ),
  ];
}

// ---------------- ૧. માસ્ટર રાઉટર ----------------
class MasterAppRouter extends StatefulWidget {
  const MasterAppRouter({super.key});

  @override
  State<MasterAppRouter> createState() => _MasterAppRouterState();
}

class _MasterAppRouterState extends State<MasterAppRouter> {
  static const String _adminEmail = 'thakor.xyz.admin@gsrtc.in';
  int _currentStep = 1;
  String _currentUserEmail = '';
  String _currentUserName = '';

  void _onGoogleSignIn(String email, String defaultName) {
    setState(() {
      _currentUserEmail = email;
      if (email.toLowerCase() == _adminEmail.toLowerCase()) {
        _currentUserName = 'Thakor XYZ (Admin)';
        _currentStep = 4;
      } else {
        _currentUserName = defaultName;
        _currentStep = 2;
      }
    });
  }

  void _onProfileCompleted(String enteredName) {
    setState(() {
      _currentUserName = enteredName;
      _currentStep = 3;
    });
  }

  void _onLogout() {
    setState(() {
      _currentStep = 1;
      _currentUserEmail = '';
      _currentUserName = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentStep) {
      case 1:
        return CompleteLoginScreen(onLogin: _onGoogleSignIn);
      case 2:
        return CompleteProfileScreen(
          suggestedName: _currentUserName,
          onComplete: _onProfileCompleted,
          onBack: _onLogout,
        );
      case 3:
        return MainExamHomeScreen(
          candidateName: _currentUserName,
          onLogout: _onLogout,
        );
      case 4:
        return CompleteAdminPanel(
          adminEmail: _currentUserEmail,
          onLogout: _onLogout,
          onTestsUpdated: () => setState(() {}),
        );
      default:
        return CompleteLoginScreen(onLogin: _onGoogleSignIn);
    }
  }
}

// ---------------- ૨. લૉગિન પેજ ----------------
class CompleteLoginScreen extends StatelessWidget {
  final Function(String email, String name) onLogin;
  const CompleteLoginScreen({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF0D5C46);
    const accentYellow = Color(0xFFE5A93C);

    return Scaffold(
      backgroundColor: primaryGreen,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: accentYellow, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.directions_bus_rounded, color: Colors.black87, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('GSRTC', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2)),
                      Text('EXAM ROUTE', style: TextStyle(color: accentYellow, fontWeight: FontWeight.w600, fontSize: 10, letterSpacing: 1.5)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),
              const Text('YOUR NEXT STOP: SELECTION', style: TextStyle(color: accentYellow, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              const SizedBox(height: 6),
              const Text('Study with a route.\nArrive ready.', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, height: 1.2)),
              const SizedBox(height: 8),
              Text(
                'A focused practice desk for GSRTC conductor and driver candidates. Gujarati-friendly from the first question.',
                style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 12),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(22.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(30), blurRadius: 15, offset: const Offset(0, 8))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Sign In / પ્રવેશ કરો', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 8),
                    Text('સુરક્ષિત રીતે તૈયારી શરૂ કરવા Google વડે જોડાઓ', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    const SizedBox(height: 22),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => onLogin('student.candidate@gmail.com', 'વિદ્યાર્થી મિત્ર'),
                      icon: Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/480px-Google_%22G%22_logo.svg.png',
                        height: 20,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, color: Colors.red, size: 24),
                      ),
                      label: const Text('Continue with Google', style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton.icon(
                        onPressed: () => onLogin('thakor.xyz.admin@gsrtc.in', 'Thakor XYZ'),
                        icon: const Icon(Icons.security, size: 16, color: primaryGreen),
                        label: const Text('[ગુપ્ત એડમિન એક્સેસ ટેસ્ટ]', style: TextStyle(fontSize: 11, color: primaryGreen, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('06', 'official subjects'),
                  _buildStatItem('Mega', 'full mock exams'),
                  _buildStatItem('Special', 'admin paid tests'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(color: Color(0xFFE5A93C), fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.white.withAlpha(160), fontSize: 10)),
      ],
    );
  }
}

// ---------------- ૩. પ્રોફાઇલ પેજ ----------------
class CompleteProfileScreen extends StatefulWidget {
  final String suggestedName;
  final Function(String) onComplete;
  final VoidCallback onBack;
  const CompleteProfileScreen({super.key, required this.suggestedName, required this.onComplete, required this.onBack});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  late TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.suggestedName == 'વિદ્યાર્થી મિત્ર' ? '' : widget.suggestedName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF0D5C46);
    const accentYellow = Color(0xFFE5A93C);

    return Scaffold(
      backgroundColor: primaryGreen,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: widget.onBack),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(padding: const EdgeInsets.all(16), decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle), child: const Icon(Icons.person_pin, size: 60, color: accentYellow)),
              const SizedBox(height: 16),
              const Text('સ્વાગત છે ઉમેદવાર!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 6),
              const Text('તમારું પૂરું નામ દાખલ કરો', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.white70)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.badge_outlined),
                          hintText: 'દા.ત. Thakor XYZ',
                          labelText: 'તમારું પૂરું નામ',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'કૃપા કરીને નામ દાખલ કરો' : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.onComplete(_nameController.text.trim());
                          }
                        },
                        child: const Text('તૈયારી શરૂ કરો', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- ૪. હોમ પેજ ----------------
class MainExamHomeScreen extends StatelessWidget {
  final String candidateName;
  final VoidCallback onLogout;
  const MainExamHomeScreen({super.key, required this.candidateName, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF0D5C46);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GSRTC સારથિ ડેસ્ક'),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        actions: [IconButton(icon: const Icon(Icons.logout), onPressed: onLogout)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 8, offset: const Offset(0, 3))],
              ),
              child: Row(
                children: [
                  const CircleAvatar(radius: 26, backgroundColor: Color(0xFFE8F5E9), child: Icon(Icons.person, color: primaryGreen, size: 30)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('નમસ્તે, $candidateName 👋', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const Text('તૈયારી માટે શ્રેણી પસંદ કરો', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RoleExamHubScreen(role: 'કંડક્ટર'))),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF1976D2), Color(0xFF1565C0)]),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: Colors.blue.withAlpha(70), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.confirmation_number_outlined, color: Colors.white, size: 40),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('કંડક્ટર પરીક્ષા હબ', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('આખો ભેગો ટેસ્ટ • ૬ વિષયવાર ટેસ્ટ • સ્પેશિયલ પેઇડ ટેસ્ટ્સ', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RoleExamHubScreen(role: 'ડ્રાઈવર'))),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF00796B), Color(0xFF004D40)]),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: Colors.teal.withAlpha(70), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.drive_eta, color: Colors.white, size: 40),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ડ્રાઈવર પરીક્ષા હબ', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('આખો ભેગો ટેસ્ટ • ૬ વિષયવાર ટેસ્ટ • સ્પેશિયલ પેઇડ ટેસ્ટ્સ', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // AdMob Placeholder Widget
            const AdMobBannerWidget(),
          ],
        ),
      ),
    );
  }
}

// ---------------- ૫. એક્ઝામ હબ ----------------
class RoleExamHubScreen extends StatefulWidget {
  final String role;
  const RoleExamHubScreen({super.key, required this.role});

  @override
  State<RoleExamHubScreen> createState() => _RoleExamHubScreenState();
}

class _RoleExamHubScreenState extends State<RoleExamHubScreen> {
  final Set<String> _unlockedExamIds = {};

  void _showPaymentDialog(SpecialExamModel exam) {
    final accessCodeCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.workspace_premium, color: Colors.amber),
            SizedBox(width: 8),
            Text('સ્પેશિયલ ટેસ્ટ અનલૉક'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(exam.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 8),
              const Text('સત્તાવાર ફી:', style: TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  '₹ ${exam.price}',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text('(${exam.questions.length} પ્રશ્નો • ${exam.durationMinutes} મિનિટ)', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ),
              const Divider(height: 24),

              // Option 1: Direct UPI Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.payment, size: 18),
                label: const Text('UPI દ્વારા ચૂકવો (GPay / PhonePe)'),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() => _unlockedExamIds.add(exam.id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(backgroundColor: Colors.green, content: Text('ચૂકવણી સફળ! સ્પેશિયલ ટેસ્ટ અનલૉક થઈ ગયો! 🎉')),
                  );
                },
              ),
              const SizedBox(height: 14),

              const Center(child: Text('— અથવા Access Code વાપરો —', style: TextStyle(fontSize: 11, color: Colors.grey))),
              const SizedBox(height: 10),

              TextField(
                controller: accessCodeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Access Code',
                  hintText: 'દા.ત. PASS2026',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('રદ કરો')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D5C46), foregroundColor: Colors.white),
            onPressed: () {
              final code = accessCodeCtrl.text.trim().toUpperCase();
              if (code == 'PASS2026' || code == 'GSRTC2026' || code == 'ADMIN') {
                Navigator.pop(context);
                setState(() => _unlockedExamIds.add(exam.id));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(backgroundColor: Colors.green, content: Text('Access Code માન્ય છે! ટેસ્ટ અનલૉક થઈ ગયો! 🎉')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(backgroundColor: Colors.red, content: Text('અમાન્ય Access Code! ફરી પ્રયાસ કરો.')),
                );
              }
            },
            child: const Text('કોડથી અનલૉક'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.role == 'કંડક્ટર' ? const Color(0xFF1976D2) : const Color(0xFF00796B);
    final specialTests = AppDataStore.activeSpecialTests.where((t) => t.targetRole == widget.role).toList();
    final fullMockList = AppDataStore.fullMockQuestions[widget.role] ?? [];

    final List<Map<String, dynamic>> subjects = widget.role == 'કંડક્ટર'
        ? [
            {'title': '૧. કંડક્ટર ફરજો & ટિકિટિંગ', 'desc': 'લગેજ નિયમો, ભાડા ગણતરી', 'icon': Icons.assignment_turned_in},
            {'title': '૨. પ્રાથમિક સારવાર (First Aid)', 'desc': 'પ્રાથમિક ઉપચાર, CPR', 'icon': Icons.medical_services_outlined},
            {'title': '૩. મોટર વ્હીકલ એક્ટ & ટ્રાફિક સાઈન', 'desc': 'ટ્રાફિક નિયમો અને દંડ', 'icon': Icons.traffic},
            {'title': '૪. ગુજરાતી ભાષા અને વ્યાકરણ', 'desc': 'જોડણી, સમાસ, અલંકાર', 'icon': Icons.menu_book},
            {'title': '૫. સામાન્ય જ્ઞાન (GK) & કરંટ અફેર્સ', 'desc': 'ગુજરાત ભૂગોળ, ઇતિહાસ', 'icon': Icons.public},
            {'title': '૬. સામાન્ય ગણિત અને રીઝનિંગ', 'desc': 'તાર્કિક કસોટી અને ગણતરી', 'icon': Icons.calculate_outlined},
          ]
        : [
            {'title': '૧. મોટર મિકેનિઝમ & સ્પેરપાર્ટ્સ', 'desc': 'એન્જિન રચના, કૂલિંગ સિસ્ટમ', 'icon': Icons.build_circle_outlined},
            {'title': '૨. MV એક્ટ, નિયમો & રોડ સેફ્ટી', 'desc': 'હેવી વ્હીકલ ડ્રાઇવિંગ રૂલ્સ', 'icon': Icons.traffic},
            {'title': '૩. પ્રાથમિક સમારકામ & ફોલ્ટ્સ', 'desc': 'બ્રેક, ક્લચ ફોલ્ટ નિવારણ', 'icon': Icons.car_repair},
            {'title': '૪. ગુજરાતી ભાષા અને વ્યાકરણ', 'desc': 'સામાન્ય ભાષા કસોટી', 'icon': Icons.menu_book},
            {'title': '૫. સામાન્ય જ્ઞાન (GK) & ગુજરાત પરિચય', 'desc': 'માર્ગ વ્યવહાર ઇતિહાસ', 'icon': Icons.public},
            {'title': '૬. રોડ સેફ્ટી & મુસાફર વર્તણૂક', 'desc': 'સુરક્ષિત ડ્રાઇવિંગ માર્ગદર્શન', 'icon': Icons.shield_outlined},
          ];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.role} પરીક્ષા હબ'),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 3,
            color: Colors.deepOrange.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.deepOrange.shade300)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const CircleAvatar(radius: 24, backgroundColor: Colors.deepOrange, child: Icon(Icons.star, color: Colors.white)),
              title: const Text('આખો ભેગો મોક ટેસ્ટ (Full Exam)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text('બધા ૬ વિષયોમાંથી કુલ ${fullMockList.length} પ્રશ્નો • ૧ કલાક સમય'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExamQuizScreen(
                      role: widget.role,
                      testTitle: '${widget.role} ફુલ મોક ટેસ્ટ',
                      questions: fullMockList,
                      durationSeconds: 3600,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('સ્પેશિયલ પેઇડ ટેસ્ટ્સ (Admin Added):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.amber.shade200, borderRadius: BorderRadius.circular(8)),
                child: Text('${specialTests.length} સક્રિય', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (specialTests.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text('અત્યારે કોઈ સ્પેશિયલ ટેસ્ટ સક્રિય નથી.', style: TextStyle(color: Colors.grey))),
            )
          else
            ...specialTests.map((exam) {
              final isUnlocked = _unlockedExamIds.contains(exam.id);
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                color: Colors.amber.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Colors.amber.shade600)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber.shade700,
                    child: Icon(isUnlocked ? Icons.lock_open : Icons.lock, color: Colors.white),
                  ),
                  title: Row(
                    children: [
                      Expanded(child: Text(exam.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                        child: Text('₹ ${exam.price}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                  subtitle: Text('${exam.questions.length} પ્રશ્નો • ${exam.durationMinutes} મિનિટ • ${isUnlocked ? 'અનલૉક કરેલ' : 'ક્લિક કરીને અનલૉક કરો'}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    if (isUnlocked) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExamQuizScreen(
                            role: widget.role,
                            testTitle: exam.title,
                            questions: exam.questions,
                            durationSeconds: exam.durationMinutes * 60,
                          ),
                        ),
                      );
                    } else {
                      _showPaymentDialog(exam);
                    }
                  },
                ),
              );
            }),

          const SizedBox(height: 18),

          const Text('વિષયવાર પ્રેક્ટિસ ટેસ્ટ (૫૦ પ્રશ્નો | ૩૦ મિનિટ):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),
          ...subjects.map((sub) {
            final subKey = '${widget.role}_${sub['title']}';
            final currentSubQuestions = AppDataStore.subjectQuestions[subKey] ??
                List.generate(
                  50,
                  (i) => CompleteQuestion(
                    question: '[${sub['title']}] પ્રશ્ન ${i + 1}: સત્તાવાર મોડેલ પ્રશ્ન વિગત?',
                    options: ['વિકલ્પ A (સાચો)', 'વિકલ્પ B', 'વિકલ્પ C', 'વિકલ્પ D'],
                    correctIndex: 0,
                  ),
                );

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: themeColor.withAlpha(25),
                  child: Icon(sub['icon'] as IconData, color: themeColor),
                ),
                title: Text(sub['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text('${sub['desc']} (${currentSubQuestions.length} પ્રશ્નો)', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExamQuizScreen(
                        role: widget.role,
                        testTitle: sub['title'] as String,
                        questions: currentSubQuestions,
                        durationSeconds: 1800,
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ---------------- ૬. પરીક્ષા સ્ક્રીન ----------------
class ExamQuizScreen extends StatefulWidget {
  final String role;
  final String testTitle;
  final List<CompleteQuestion> questions;
  final int durationSeconds;

  const ExamQuizScreen({
    super.key,
    required this.role,
    required this.testTitle,
    required this.questions,
    required this.durationSeconds,
  });

  @override
  State<ExamQuizScreen> createState() => _ExamQuizScreenState();
}

class _ExamQuizScreenState extends State<ExamQuizScreen> {
  int currentIndex = 0;
  int score = 0;
  int? selectedAnswer;
  Timer? _timer;
  late int remainingSeconds;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.durationSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        _timer?.cancel();
        _showResult();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('પરીક્ષા પરિણામ 🎯', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('ટેસ્ટ: ${widget.testTitle}\nતમારો સ્કોર: $score / ${widget.questions.length}'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('હોમ પેજ પર જાઓ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.testTitle)),
        body: const Center(child: Text('આ ટેસ્ટમાં કોઈ પ્રશ્નો મળ્યા નથી.')),
      );
    }

    final currentQ = widget.questions[currentIndex];
    final themeColor = widget.role == 'કંડક્ટર' ? const Color(0xFF1976D2) : const Color(0xFF00796B);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.testTitle, style: const TextStyle(fontSize: 16)),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.timer_outlined, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('બાકી સમય:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                    ],
                  ),
                  Text(_formatTime(remainingSeconds), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('પ્રશ્ન ${currentIndex + 1} / ${widget.questions.length}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(currentQ.question, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(currentQ.options.length, (index) {
              final isChosen = selectedAnswer == index;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: isChosen ? themeColor.withAlpha(20) : Colors.white,
                  border: Border.all(color: isChosen ? themeColor : Colors.grey.shade300, width: isChosen ? 2 : 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    title: Text(currentQ.options[index], style: const TextStyle(fontSize: 14)),
                    leading: Icon(isChosen ? Icons.check_circle : Icons.radio_button_unchecked, color: isChosen ? themeColor : Colors.grey),
                    onTap: () => setState(() => selectedAnswer = index),
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: selectedAnswer == null
                  ? null
                  : () {
                      if (selectedAnswer == currentQ.correctIndex) {
                        score++;
                      }
                      if (currentIndex < widget.questions.length - 1) {
                        setState(() {
                          currentIndex++;
                          selectedAnswer = null;
                        });
                      } else {
                        _timer?.cancel();
                        _showResult();
                      }
                    },
              child: Text(currentIndex == widget.questions.length - 1 ? 'ટેસ્ટ સબમિટ કરો' : 'આગળનો પ્રશ્ન (${currentIndex + 1}/${widget.questions.length})', style: const TextStyle(fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- ૭. એડમિન પેનલ (Bulk Upload) ----------------
class CompleteAdminPanel extends StatefulWidget {
  final String adminEmail;
  final VoidCallback onLogout;
  final VoidCallback onTestsUpdated;

  const CompleteAdminPanel({
    super.key,
    required this.adminEmail,
    required this.onLogout,
    required this.onTestsUpdated,
  });

  @override
  State<CompleteAdminPanel> createState() => _CompleteAdminPanelState();
}

class _CompleteAdminPanelState extends State<CompleteAdminPanel> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String _bulkTargetRole = 'કંડક્ટર';
  String _bulkExamType = 'આખો ભેગો મોક ટેસ્ટ';
  String _bulkSelectedSubject = '૧. કંડક્ટર ફરજો & ટિકિટિંગ';
  final _generalBulkJsonCtrl = TextEditingController();

  String _specialTargetRole = 'કંડક્ટર';
  final _specialTitleCtrl = TextEditingController();
  final _specialPriceCtrl = TextEditingController(text: '49');
  final _specialDurationCtrl = TextEditingController(text: '60');
  final _specialBulkJsonCtrl = TextEditingController();

  final List<String> _conductorSubjects = [
    '૧. કંડક્ટર ફરજો & ટિકિટિંગ',
    '૨. પ્રાથમિક સારવાર (First Aid)',
    '૩. મોટર વ્હીકલ એક્ટ & ટ્રાફિક સાઈન',
    '૪. ગુજરાતી ભાષા અને વ્યાકરણ',
    '૫. સામાન્ય જ્ઞાન (GK) & કરંટ અફેર્સ',
    '૬. સામાન્ય ગણિત અને રીઝનિંગ',
  ];

  final List<String> _driverSubjects = [
    '૧. મોટર મિકેનિઝમ & સ્પેરપાર્ટ્સ',
    '૨. MV એક્ટ, નિયમો & રોડ સેફ્ટી',
    '૩. પ્રાથમિક સમારકામ & ફોલ્ટ્સ',
    '૪. ગુજરાતી ભાષા અને વ્યાકરણ',
    '૫. સામાન્ય જ્ઞાન (GK) & ગુજરાત પરિચય',
    '૬. રોડ સેફ્ટી & મુસાફર વર્તણૂક',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _generalBulkJsonCtrl.text = '''[
  {
    "question": "કંડક્ટરે મુસાફરો પાસેથી ભાડું ક્યારે વસૂલ કરવું જોઈએ?",
    "options": ["બસ ઉપડ્યા પછી તરત", "બસ સ્ટેન્ડ પહોંચવા આવે ત્યારે", "ગમે ત્યારે", "મુસાફર કહે ત્યારે"],
    "correctIndex": 0
  }
]''';

    _specialBulkJsonCtrl.text = '''[
  {
    "question": "સ્પેશિયલ પેઇડ પ્રશ્ન: બસમાં અગ્નિશામક (Fire Extinguisher) ક્યાં રાખવામાં આવે છે?",
    "options": ["ડ્રાઈવર કેબિન નજીક", "છેલ્લી સીટ નીચે", "બસની છત પર", "કંડક્ટર બેગમાં"],
    "correctIndex": 0
  }
]''';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _generalBulkJsonCtrl.dispose();
    _specialTitleCtrl.dispose();
    _specialPriceCtrl.dispose();
    _specialDurationCtrl.dispose();
    _specialBulkJsonCtrl.dispose();
    super.dispose();
  }

  void _uploadGeneralBulkQuestions() {
    final text = _generalBulkJsonCtrl.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('કૃપા કરીને JSON ડેટા પેસ્ટ કરો')));
      return;
    }

    try {
      final List<dynamic> decoded = jsonDecode(text);
      List<CompleteQuestion> newQuestions = [];
      for (var item in decoded) {
        newQuestions.add(
          CompleteQuestion(
            question: item['question'] as String,
            options: List<String>.from(item['options'] as List),
            correctIndex: item['correctIndex'] as int,
          ),
        );
      }

      setState(() {
        if (_bulkExamType == 'આખો ભેગો મોક ટેસ્ટ') {
          AppDataStore.fullMockQuestions[_bulkTargetRole]?.insertAll(0, newQuestions);
        } else {
          final subKey = '${_bulkTargetRole}_$_bulkSelectedSubject';
          AppDataStore.subjectQuestions.putIfAbsent(subKey, () => []);
          AppDataStore.subjectQuestions[subKey]!.insertAll(0, newQuestions);
        }
      });
      widget.onTestsUpdated();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.green, content: Text('સફળ! ${newQuestions.length} પ્રશ્નો [$_bulkTargetRole - $_bulkExamType] માં ઉમેરાઈ ગયા! 🎉')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.redAccent, content: Text('JSON ફોર્મેટમાં ભૂલ છે! બરાબર ચકાસો.')),
      );
    }
  }

  void _uploadSpecialBulkTest() {
    final title = _specialTitleCtrl.text.trim();
    final price = int.tryParse(_specialPriceCtrl.text.trim()) ?? 49;
    final duration = int.tryParse(_specialDurationCtrl.text.trim()) ?? 60;
    final jsonText = _specialBulkJsonCtrl.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('કૃપા કરીને સ્પેશિયલ ટેસ્ટનું નામ લખો')));
      return;
    }

    try {
      final List<dynamic> decoded = jsonDecode(jsonText);
      List<CompleteQuestion> loadedQuestions = [];
      for (var item in decoded) {
        loadedQuestions.add(
          CompleteQuestion(
            question: item['question'] as String,
            options: List<String>.from(item['options'] as List),
            correctIndex: item['correctIndex'] as int,
          ),
        );
      }

      final newExam = SpecialExamModel(
        id: 'spec_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        targetRole: _specialTargetRole,
        price: price,
        durationMinutes: duration,
        questions: loadedQuestions,
      );

      setState(() {
        AppDataStore.activeSpecialTests.insert(0, newExam);
      });
      widget.onTestsUpdated();

      _specialTitleCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.green, content: Text('સ્પેશિયલ પેઇડ ટેસ્ટ "$title" (${loadedQuestions.length} પ્રશ્નો - ₹$price) લાઈવ થઈ ગયો! 🎉')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.redAccent, content: Text('સ્પેશિયલ પ્રશ્નોના JSON ફોર્મેટમાં ભૂલ છે!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF0D5C46);
    final currentSubjectList = _bulkTargetRole == 'કંડક્ટર' ? _conductorSubjects : _driverSubjects;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Master Desk (Thakor XYZ)'),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        actions: [IconButton(icon: const Icon(Icons.logout), onPressed: widget.onLogout)],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFE5A93C),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.upload_file), text: 'મોક / વિષયો Bulk Upload'),
            Tab(icon: Icon(Icons.workspace_premium), text: 'સ્પેશિયલ પેઇડ Bulk Upload'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                  child: const Row(
                    children: [
                      Icon(Icons.flash_on, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'કંડક્ટર કે ડ્રાઈવરના "આખો ભેગો મોક ટેસ્ટ" અથવા "૬ વિષયવાર ટેસ્ટ" માં સેંકડો પ્રશ્નો એકસાથે પેસ્ટ કરીને અપલોડ કરો.',
                          style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                DropdownButtonFormField<String>(
                  initialValue: _bulkTargetRole,
                  decoration: InputDecoration(labelText: 'વિભાગ પસંદ કરો', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  items: const [
                    DropdownMenuItem(value: 'કંડક્ટર', child: Text('કંડક્ટર પરીક્ષા')),
                    DropdownMenuItem(value: 'ડ્રાઈવર', child: Text('ડ્રાઈવર પરીક્ષા')),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _bulkTargetRole = val!;
                      _bulkSelectedSubject = val == 'કંડક્ટર' ? _conductorSubjects[0] : _driverSubjects[0];
                    });
                  },
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  initialValue: _bulkExamType,
                  decoration: InputDecoration(labelText: 'ટેસ્ટનો પ્રકાર પસંદ કરો', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  items: const [
                    DropdownMenuItem(value: 'આખો ભેગો મોક ટેસ્ટ', child: Text('આખો ભેગો મોક ટેસ્ટ (Full Mock Exam)')),
                    DropdownMenuItem(value: 'વિષયવાર ટેસ્ટ', child: Text('૬ સત્તાવાર વિષયવાર ટેસ્ટ (Subject-wise)')),
                  ],
                  onChanged: (val) => setState(() => _bulkExamType = val!),
                ),
                const SizedBox(height: 12),

                if (_bulkExamType == 'વિષયવાર ટેસ્ટ') ...[
                  DropdownButtonFormField<String>(
                    initialValue: currentSubjectList.contains(_bulkSelectedSubject) ? _bulkSelectedSubject : currentSubjectList[0],
                    decoration: InputDecoration(labelText: 'વિષય પસંદ કરો', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                    items: currentSubjectList.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13)))).toList(),
                    onChanged: (val) => setState(() => _bulkSelectedSubject = val!),
                  ),
                  const SizedBox(height: 12),
                ],

                TextFormField(
                  controller: _generalBulkJsonCtrl,
                  maxLines: 12,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  decoration: InputDecoration(
                    labelText: 'પ્રશ્નોનો JSON Bulk Data',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 16),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _uploadGeneralBulkQuestions,
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('બધા પ્રશ્નો એકસાથે અપલોડ કરો (Bulk Upload)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.amber.shade300)),
                  child: const Row(
                    children: [
                      Icon(Icons.workspace_premium, color: Colors.amber),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'અહીંથી તમે નવો સ્પેશિયલ પેઇડ ટેસ્ટ બનાવીને તેના તમામ પ્રશ્નો એકસાથે JSON માં અપલોડ કરી શકો છો.',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                DropdownButtonFormField<String>(
                  initialValue: _specialTargetRole,
                  decoration: InputDecoration(labelText: 'વિભાગ પસંદ કરો', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  items: const [
                    DropdownMenuItem(value: 'કંડક્ટર', child: Text('કંડક્ટર પરીક્ષા')),
                    DropdownMenuItem(value: 'ડ્રાઈવર', child: Text('ડ્રાઈવર પરીક્ષા')),
                  ],
                  onChanged: (val) => setState(() => _specialTargetRole = val!),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _specialTitleCtrl,
                  decoration: InputDecoration(
                    labelText: 'સ્પેશિયલ ટેસ્ટનું નામ',
                    hintText: 'દા.ત. સુપર સિલેક્શન મેગા પેઇડ ટેસ્ટ 2026',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _specialPriceCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'ફી (₹ રૂપિયા)',
                          prefixText: '₹ ',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _specialDurationCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'સમય (મિનિટ)',
                          suffixText: 'મિનિટ',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _specialBulkJsonCtrl,
                  maxLines: 10,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  decoration: InputDecoration(
                    labelText: 'સ્પેશિયલ ટેસ્ટના પ્રશ્નો (JSON Format)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 16),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _uploadSpecialBulkTest,
                  icon: const Icon(Icons.publish),
                  label: const Text('નવો સ્પેશિયલ ટેસ્ટ લાઈવ કરો (Publish Bulk Test)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- ૮. ADMOB BANNER પ્લેસહોલ્ડર વિજેટ ----------------
class AdMobBannerWidget extends StatelessWidget {
  const AdMobBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ad_units, color: Colors.grey, size: 18),
            SizedBox(width: 8),
            Text(
              'AdMob Banner Ad Space',
              style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

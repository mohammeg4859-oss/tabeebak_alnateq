import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const TabeebakApp());
}

class TabeebakApp extends StatelessWidget {
  const TabeebakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'طبيبك الناطق',
      locale: const Locale('ar', 'YE'),
      supportedLocales: const [Locale('ar', 'YE')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF0F4F8),
        fontFamily: 'Arial',
      ),
      home: const WelcomeSplashScreen(),
    );
  }
}

// ==========================================
// 1. شاشة الترحيب الافتتاحية باسمك وتحيتك الصوتية
// ==========================================
class WelcomeSplashScreen extends StatefulWidget {
  const WelcomeSplashScreen({super.key});

  @override
  State<WelcomeSplashScreen> createState() => _WelcomeSplashScreenState();
}

class _WelcomeSplashScreenState extends State<WelcomeSplashScreen> {
  final FlutterTts flutterTts = FlutterTts();
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _playWelcomeGreeting();
  }

  Future<void> _playWelcomeGreeting() async {
    await flutterTts.setLanguage("ar-SA");
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(
        "أهلاً وسهلاً بكم في تطبيق طبيبك الناطق. تصميم وبرمجة الأستاذ المهندس محمد عبدالواحد الهمداني. نتمنى لكم دوام الصحة والعافية.");

    _navigationTimer = Timer(const Duration(seconds: 6), () {
      _goToHome();
    });
  }

  void _goToHome() {
    _navigationTimer?.cancel();
    flutterTts.stop();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen3D()),
      );
    }
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF00796B), Color(0xFF004D40)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.health_and_safety_rounded,
                    size: 90,
                    color: Color(0xFF00695C),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'طبيبك الناطق',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'رفيقك الصحي بالصوت والصورة بدون إنترنت',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.amberAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 36),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.amber, width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFF00251A),
                        offset: Offset(0, 8),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'فكرة وتصميم وبرمجة',
                        style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'أ. م. محمد عبدالواحد الهمداني',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004D40),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'هدية مجتمعية لخدمة الجميع',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFFE65100),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: _goToHome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: const Color(0xFF004D40),
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 8,
                  ),
                  icon: const Icon(Icons.arrow_back_rounded, size: 28),
                  label: const Text(
                    'دخول للتطبيق',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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

// ==========================================
// 2. الشاشة الرئيسية ثلاثية الأبعاد (4 أقسام)
// ==========================================
class HomeScreen3D extends StatefulWidget {
  const HomeScreen3D({super.key});

  @override
  State<HomeScreen3D> createState() => _HomeScreen3DState();
}

class _HomeScreen3DState extends State<HomeScreen3D> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("ar-SA");
    await flutterTts.setSpeechRate(0.45);
  }

  Future<void> _speak(String text) async {
    await flutterTts.stop();
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00695C),
        elevation: 8,
        centerTitle: true,
        title: const Column(
          children: [
            Text('طبيبك الناطق 🏥',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('إعداد: أ. م. محمد عبدالواحد الهمداني',
                style: TextStyle(fontSize: 12, color: Colors.amberAccent)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up, size: 30, color: Colors.amberAccent),
            onPressed: () => _speak(
                "اختر القسم المطلوب: الأحمر للإسعافات، الأزرق لمنبه الدواء، الأخضر لصحة الأم والطفل، والبرتقالي للاتصال السريع."),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.touch_app, color: Color(0xFF00695C), size: 28),
                  SizedBox(width: 8),
                  Text('المس الصورة الكبيرة للدخول والاستماع',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  Card3DButton(
                    title: 'الإسعافات\nالطارئة',
                    icon: Icons.medical_services_rounded,
                    topColor: const Color(0xFFFF5252),
                    bottomColor: const Color(0xFFB71C1C),
                    shadowColor: const Color(0xFF7F0000),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyScreen()));
                    },
                  ),
                  Card3DButton(
                    title: 'منبه الأدوية\nالمصور',
                    icon: Icons.medication_rounded,
                    topColor: const Color(0xFF448AFF),
                    bottomColor: const Color(0xFF0D47A1),
                    shadowColor: const Color(0xFF002171),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicineScreen()));
                    },
                  ),
                  Card3DButton(
                    title: 'صحة الأم\nوالطفل',
                    icon: Icons.child_care_rounded,
                    topColor: const Color(0xFF26A69A),
                    bottomColor: const Color(0xFF004D40),
                    shadowColor: const Color(0xFF00251A),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MotherChildScreen()));
                    },
                  ),
                  Card3DButton(
                    title: 'اتصال طوارئ\nسريع',
                    icon: Icons.phone_in_talk_rounded,
                    topColor: const Color(0xFFFFB74D),
                    bottomColor: const Color(0xFFE65100),
                    shadowColor: const Color(0xFFAC1900),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const QuickCallScreen()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Card3DButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color topColor;
  final Color bottomColor;
  final Color shadowColor;
  final VoidCallback onTap;

  const Card3DButton({
    super.key,
    required this.title,
    required this.icon,
    required this.topColor,
    required this.bottomColor,
    required this.shadowColor,
    required this.onTap,
  });

  @override
  State<Card3DButton> createState() => _Card3DButtonState();
}

class _Card3DButtonState extends State<Card3DButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: EdgeInsets.only(top: _isPressed ? 8 : 0, bottom: _isPressed ? 0 : 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [widget.topColor, widget.bottomColor],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(color: widget.shadowColor, offset: const Offset(0, 8), blurRadius: 0),
                  BoxShadow(color: Colors.black.withOpacity(0.25), offset: const Offset(0, 14), blurRadius: 15),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
              child: Icon(widget.icon, size: 58, color: Colors.white),
            ),
            const SizedBox(height: 14),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. القسم الأول: شاشة الإسعافات الطارئة الناطقة
// ==========================================
class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final FlutterTts flutterTts = FlutterTts();
  int? _playingIndex;

  final List> cases = [
    {
      'title': 'لدغة ثعبان أو عقرب',
      'icon': Icons.pest_control_rounded,
      'color': const Color(0xFFD32F2F),
      'advice':
          'اهدأ ولا تجري حتى لا ينتشر السم. اربط قطعة قماش فوق مكان اللدغة بشكل خفيف، واغسل المكان بالماء والصابون، وتوجه فوراً لأقرب مستشفى ولا تحاول مص السم بالفم.',
    },
    {
      'title': 'الحروق (نار أو ماء ساخن)',
      'icon': Icons.local_fire_department_rounded,
      'color': const Color(0xFFE64A19),
      'advice':
          'ضع المكان المحروق تحت ماء بارد جاري لمدة عشر دقائق. لا تضع معجون أسنان أو ثلج أو زيت أبداً، وغطِّ الحرق بشاش نظيف وتوجه للطبيب.',
    },
    {
      'title': 'الجروح والنزيف',
      'icon': Icons.healing_rounded,
      'color': const Color(0xFFC2185B),
      'advice':
          'اضغط بقوة على الجرح بقطعة قماش نظيفة لوقف الدم، وارفع العضو المصاب للأعلى، ولا تزِل قطعة القماش إذا امتلأت بالدم بل ضع فوقها قطعة أخرى.',
    },
    {
      'title': 'ارتفاع ضغط الدم المفاجئ',
      'icon': Icons.favorite_rounded,
      'color': const Color(0xFF7B1FA2),
      'advice':
          'اجعل المصاب يجلس في مكان هادئ وبارد ويرتاح تماماً، وتجنب الموالح والمنبهات، وقم بقياس الضغط، وإذا استمرت الدوخة انقله للمركز الصحي.',
    },
    {
      'title': 'هبوط السكر المفاجئ',
      'icon': Icons.water_drop_rounded,
      'color': const Color(0xFF1976D2),
      'advice':
          'إذا كان المصاب واعياً، أعطه فوراً كوب ماء مذاب فيه ملعقتان من السكر أو عصيراً محلى. إذا كان فاقداً للوعي لا تضع شيئاً في فمه وانقله للمستشفى فوراً.',
    },
    {
      'title': 'ارتفاع حرارة الأطفال',
      'icon': Icons.thermostat_rounded,
      'color': const Color(0xFFF57C00),
      'advice':
          'خفف ملابس الطفل، واعمل له كمادات ماء فاتر من الحنفية على الجبهة وتحت الإبطين والفخذين، وأعطه خافض حرارة مناسب لعمره.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("ar-SA");
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.speak("قسم الإسعافات الطارئة. المس أي حالة لسماع طريقة الإسعاف.");
  }

  Future<void> _speakCase(int index) async {
    setState(() => _playingIndex = index);
    await flutterTts.stop();
    await flutterTts.speak("${cases[index]['title']}. ${cases[index]['advice']}");
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C),
        title: const Text('الإسعافات الطارئة 🚑', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cases.length,
        itemBuilder: (context, index) {
          final item = cases[index];
          final isPlaying = _playingIndex == index;
          return GestureDetector(
            onTap: () => _speakCase(index),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: isPlaying ? Colors.amber : item['color'], width: isPlaying ? 3.5 : 2),
                boxShadow: [
                  BoxShadow(color: (item['color'] as Color).withOpacity(0.3), offset: const Offset(0, 6), blurRadius: 0),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: item['color'],
                        child: Icon(item['icon'], size: 30, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(item['title'],
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: item['color'])),
                      ),
                      Icon(isPlaying ? Icons.volume_up_rounded : Icons.play_circle_fill_rounded,
                          size: 40, color: isPlaying ? Colors.amber[800] : item['color']),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(item['advice'], style: const TextStyle(fontSize: 17, height: 1.5)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// 4. القسم الثاني: منبه الأدوية المصور بالكاميرا
// ==========================================
class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  final FlutterTts flutterTts = FlutterTts();
  List> medicines = [];

  @override
  void initState() {
    super.initState();
    _loadMedicines();
    _speak("قسم منبه الأدوية المصور. اضغط على الزر الأزرق بالأسفل لتصوير علبة الدواء وحفظ موعدها.");
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("ar-SA");
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.speak(text);
  }

  Future<void> _loadMedicines() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('saved_medicines');
    if (data != null) {
      setState(() {
        medicines = List>.from(
            json.decode(data).map((item) => Map<String, String>.from(item)));
      });
    }
  }

  Future<void> _saveMedicines() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_medicines', json.encode(medicines));
  }

  Future<void> _addMedicine() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo == null) return;

    if (!mounted) return;
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime == null) return;

    String dose = 'حبة واحدة بعد الأكل';
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('اختر الجرعة', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('حبة واحدة صباحاً ومساءً', style: TextStyle(fontSize: 18)),
              onTap: () {
                dose = 'حبة واحدة صباحاً ومساءً';
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('حبة واحدة بعد الأكل', style: TextStyle(fontSize: 18)),
              onTap: () {
                dose = 'حبة واحدة بعد الأكل';
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('ملعقة شراب ثلاث مرات', style: TextStyle(fontSize: 18)),
              onTap: () {
                dose = 'ملعقة شراب ثلاث مرات';
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );

    setState(() {
      medicines.add({
        'image': photo.path,
        'time': selectedTime.format(context),
        'dose': dose,
      });
    });
    await _saveMedicines();
    _speak("تم حفظ صورة الدواء بنجاح. الجرعة: $dose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        title: const Text('منبه الأدوية المصور 💊', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0D47A1),
        onPressed: _addMedicine,
        icon: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 30),
        label: const Text('صور دواء جديد', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: medicines.isEmpty
          ? const Center(
              child: Text(
                'لا توجد أدوية محفوظة حالياً.\nاضغط على "صور دواء جديد" بالأسفل.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final med = medicines[index];
                return GestureDetector(
                  onTap: () => _speak("موعد هذا الدواء الساعة ${med['time']}. الجرعة: ${med['dose']}"),
                  child: Card(
                    elevation: 6,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              File(med['image']!),
                              width: 95,
                              height: 95,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.medication, size: 80, color: Colors.blue),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('⏰ الوقت: ${med['time']}',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
                                const SizedBox(height: 6),
                                Text('💊 ${med['dose']}', style: const TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_forever, color: Colors.red, size: 32),
                            onPressed: () async {
                              setState(() => medicines.removeAt(index));
                              await _saveMedicines();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ==========================================
// 5. القسم الثالث: شاشة صحة الأم والطفل
// ==========================================
class MotherChildScreen extends StatefulWidget {
  const MotherChildScreen({super.key});

  @override
  State<MotherChildScreen> createState() => _MotherChildScreenState();
}

class _MotherChildScreenState extends State<MotherChildScreen> {
  final FlutterTts flutterTts = FlutterTts();

  final List> topics = [
    {
      'title': 'جدول تطعيمات الطفل الأساسية',
      'icon': Icons.vaccines_rounded,
      'info':
          'تطعيمات الطفل تحميه من الأمراض الخطيرة: الجرعة الأولى عند الولادة، ثم في عمر شهر ونصف، وشهرين ونصف، وثلاثة أشهر ونصف، ثم عند عمر تسعة أشهر وسنة ونصف. احرصي على أخذ بطاقة التطعيم للمركز الصحي.',
    },
    {
      'title': 'علامات الخطر عند الرضيع',
      'icon': Icons.warning_amber_rounded,
      'info':
          'توجهي بالطفل للطبيب فوراً إذا لاحظتِ: رفض الرضاعة تماماً، صعوبة أو سرعة في التنفس، حرارة مرتفعة لا تنخفض، خمول شديد، أو إسهال مستمر.',
    },
    {
      'title': 'الرضاعة الطبيعية والتغذية',
      'icon': Icons.baby_changing_station_rounded,
      'info':
          'حليب الأم هو أفضل غذاء للطفل في أول ستة أشهر ولا يحتاج معه لماء أو أعشاب. بعد الشهر السادس نبدأ بإدخال الخضار والفواكه المهروسة تدريجياً.',
    },
    {
      'title': 'صحة الأم الحامل والمرضع',
      'icon': Icons.pregnant_woman_rounded,
      'info':
          'على الأم الحامل والمرضع الإكثار من شرب الماء، وتناول الأغذية الغنية بالحديد والكالسيوم مثل البيض والحليب والخضروات الورقية، والمتابعة الدورية في المركز الصحي.',
    },
  ];

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("ar-SA");
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.stop();
    await flutterTts.speak(text);
  }

  @override
  void initState() {
    super.initState();
    _speak("قسم صحة الأم والطفل. المس أي بطاقة لسماع الإرشادات الطبية.");
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004D40),
        title: const Text('صحة الأم والطفل 👶', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final item = topics[index];
          return GestureDetector(
            onTap: () => _speak("${item['title']}. ${item['info']}"),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFF00796B), width: 2),
                boxShadow: const [
                  BoxShadow(color: Color(0xFF004D40), offset: Offset(0, 6), blurRadius: 0),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: const Color(0xFF00796B),
                        child: Icon(item['icon'], size: 30, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(item['title'],
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF004D40))),
                      ),
                      const Icon(Icons.volume_up_rounded, size: 36, color: Color(0xFF00796B)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(item['info'], style: const TextStyle(fontSize: 17, height: 1.5)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// 6. القسم الرابع: شاشة اتصال الطوارئ السريع
// ==========================================
class QuickCallScreen extends StatefulWidget {
  const QuickCallScreen({super.key});

  @override
  State<QuickCallScreen> createState() => _QuickCallScreenState();
}

class _QuickCallScreenState extends State<QuickCallScreen> {
  final FlutterTts flutterTts = FlutterTts();
  Map<String, String> numbers = {
    'ambulance': '',
    'doctor': '',
    'pharmacy': '',
    'family': '',
  };

  @override
  void initState() {
    super.initState();
    _loadNumbers();
    _speak("قسم الاتصال السريع. اضغط على الصورة للاتصال مباشرة، أو اضغط على القلم لحفظ الرقم.");
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("ar-SA");
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.speak(text);
  }

  Future<void> _loadNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      numbers['ambulance'] = prefs.getString('num_ambulance') ?? '';
      numbers['doctor'] = prefs.getString('num_doctor') ?? '';
      numbers['pharmacy'] = prefs.getString('num_pharmacy') ?? '';
      numbers['family'] = prefs.getString('num_family') ?? '';
    });
  }

  Future<void> _editNumber(String key, String label) async {
    final controller = TextEditingController(text: numbers[key]);
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('حفظ رقم: $label'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(hintText: 'أدخل رقم الهاتف هنا'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('num_$key', controller.text.trim());
              setState(() => numbers[key] = controller.text.trim());
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  Future<void> _callNumber(String key, String label) async {
    final num = numbers[key] ?? '';
    if (num.isEmpty) {
      _speak("لم يتم حفظ رقم $label بعد. اضغط على أيقونة التعديل لحفظ الرقم.");
      _editNumber(key, label);
      return;
    }
    _speak("جاري الاتصال بـ $label");
    final Uri uri = Uri(scheme: 'tel', path: num);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final contacts = [
      {'key': 'ambulance', 'label': 'سيارة الإسعاف', 'icon': Icons.airport_shuttle_rounded, 'color': Colors.red[700]!},
      {'key': 'doctor', 'label': 'الطبيب / المركز الصحي', 'icon': Icons.local_hospital_rounded, 'color': Colors.teal[700]!},
      {'key': 'pharmacy', 'label': 'الصيدلية القريبة', 'icon': Icons.local_pharmacy_rounded, 'color': Colors.blue[700]!},
      {'key': 'family', 'label': 'قريب للطوارئ', 'icon': Icons.family_restroom_rounded, 'color': Colors.orange[800]!},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE65100),
        title: const Text('اتصال طوارئ سريع 📞', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final item = contacts[index];
          final key = item['key'] as String;
          final label = item['label'] as String;
          final savedNum = numbers[key]!;
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              onTap: () => _callNumber(key, label),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: item['color'] as Color,
                child: Icon(item['icon'] as IconData, size: 34, color: Colors.white),
              ),
              title: Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text(
                savedNum.isEmpty ? 'اضغط لحفظ الرقم' : savedNum,
                style: TextStyle(fontSize: 17, color: savedNum.isEmpty ? Colors.red : Colors.green[700]),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit_rounded, size: 30, color: Colors.grey),
                onPressed: () => _editNumber(key, label),
              ),
            ),
          );
        },
      ),
    );
  }
}
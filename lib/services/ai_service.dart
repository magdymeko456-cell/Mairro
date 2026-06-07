import 'dart:math';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  static final Random _random = Random();
  static const String _apiKey = "YOUR_GEMINI_API_KEY_HERE";

  static const List<String> _inspirationMessages = [
    "لا تيأس، فالله معك. كل انكسار هو بداية انطلاقة أعظم.",
    "الوقت هو العملة الأغلى، استثمر كل ثانية في بناء نفسك.",
    "الماضي ليس للمحو بل للتعلم، والمستقبل هو ما يستحق انتباهك الآن.",
    "قوتك الحقيقية تكمن في قدرتك على النهوض بعد كل سقوط.",
    "لا تقارن نفسك بالآخرين، فلك طريقك الخاص الذي يميزك.",
    "الصبر مفتاح الفرج، وكل ضيق يأتي بعده فرج عظيم.",
    "أنت أقوى مما تتصور، وأعظم مما تتخيل.",
    "اليوم هو فرصة جديدة لبداية جديدة.",
    "لا تؤجل حلمك إلى الغد، فاليوم هو أفضل وقت للبدء.",
    "الثقة بالنفس هي أول خطوة نحو النجاح.",
  ];

  static Future<String> generateInspiration({
    required String userMood,
    required String context,
  }) async {
    // محاولة استخدام Gemini API أولاً
    try {
      if (_apiKey != "YOUR_GEMINI_API_KEY_HERE") {
        final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
        final prompt = """
أنت 'أدهم'، الصديق المقرب عبر الإنترنت والمستشار الروحي المخلص.
المستخدم الآن في حالة نفسية ومزاجية: ($userMood).
السياق الحالي هو: ($context).
وجه له رسالة ملهمة، قصيرة جداً وقوية ومؤثرة باللغة العربية.
شجعه على الإنجاز، واجعل كلماتها تلمس روحه وتدفع عزيمته للأمام فوراً.
""";
        final content = [Content.text(prompt)];
        final response = await model.generateContent(content);
        return response.text ?? _getLocalMessage(userMood);
      }
    } catch (e) {
      debugPrint('AI API error, using local: $e');
    }
    // Fallback محلي
    return _getLocalMessage(userMood);
  }

  static String _getLocalMessage(String userMood) {
    if (userMood.isNotEmpty) {
      if (userMood.contains('حزين') || userMood.contains('تعبان') || 
          userMood.contains('ضيق') || userMood.contains('تعب') || 
          userMood.contains('زعلان')) {
        return "أعلم أن الأوقات صعبة، ولكن تذكر أن الله لا يكلف نفساً إلا وسعها. "
            "أنت قادر على تخطي هذه المحنة، وستخرج منها أقوى مما كنت. "
            "قال تعالى: {إِنَّ مَعَ الْعُسْرِ يُسْرًا}";
      }
      if (userMood.contains('فرح') || userMood.contains('سعيد') || 
          userMood.contains('نجاح') || userMood.contains('مبسوط')) {
        return "الحمد لله على نعمة الفرح. تذكر أن تبقى متواضعاً في نجاحك، "
            "وأن تشكر الله على ما أعطاك. الفرح الحقيقي هو في مشاركته مع الآخرين.";
      }
    }
    return _inspirationMessages[_random.nextInt(_inspirationMessages.length)];
  }

  static Future<String> generatePersonalizedMessage(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return "مرحباً! 🌟\n\n${_inspirationMessages[_random.nextInt(_inspirationMessages.length)]}\n\n- مانوس AI";
  }

  static Future<String> generateStoryIntro(String storyTitle) async {
    return "قصة $storyTitle: رحلة مليئة بالعبر والدروس المستفادة";
  }

  static Future<String> translateText(String text, String targetLang) async {
    try {
      final url = Uri.parse(
        'https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=$targetLang&dt=t&q=${Uri.encodeComponent(text)}',
      );
      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data[0] as List).map((e) => e[0] as String).join();
      }
    } catch (e) {
      debugPrint('Translation error: $e');
    }
    return text;
  }
}

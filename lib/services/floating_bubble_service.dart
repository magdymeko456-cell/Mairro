import 'package:flutter/material.dart';  
import 'package:flutter/services.dart';  
import 'package:shared_preferences/shared_preferences.dart';  
import 'package:dash_bubble_local/dash_bubble_local.dart';  
  
/// Enhanced Floating Bubble Service with full translation tools  
class FloatingBubbleService extends ChangeNotifier {  
  static final FloatingBubbleService _instance = FloatingBubbleService._internal();  
    
  factory FloatingBubbleService() => _instance;  
  FloatingBubbleService._internal();  
    
  late SharedPreferences _prefs;  
  bool _isStarted = false;  
  bool _isEnabled = false;  
  double _opacity = 0.8;  
  int _size = 120;  
  String _selectedLanguage = 'ar';  
  bool _autoTranslate = true;  
  bool _soundEnabled = true;  
    
  // Translation state  
  String _sourceText = '';  
  String _translatedText = '';  
  String _sourceLanguage = 'auto';  
  bool _isTranslating = false;  
    
  // Getters  
  bool get isStarted => _isStarted;  
  bool get isEnabled => _isEnabled;  
  double get opacity => _opacity;  
  int get size => _size;  
  String get selectedLanguage => _selectedLanguage;  
  bool get autoTranslate => _autoTranslate;  
  bool get soundEnabled => _soundEnabled;  
  String get sourceText => _sourceText;  
  String get translatedText => _translatedText;  
  String get sourceLanguage => _sourceLanguage;  
  bool get isTranslating => _isTranslating;  
    
  /// Initialize the service  
  Future<void> initialize() async {  
    _prefs = await SharedPreferences.getInstance();  
    _loadSettings();  
  }  
    
  /// Load settings from SharedPreferences  
  void _loadSettings() {  
    _isEnabled = _prefs.getBool('bubble_enabled') ?? false;  
    _opacity = _prefs.getDouble('bubble_opacity') ?? 0.8;  
    _size = _prefs.getInt('bubble_size') ?? 120;  
    _selectedLanguage = _prefs.getString('bubble_language') ?? 'ar';  
    _autoTranslate = _prefs.getBool('bubble_auto_translate') ?? true;  
    _soundEnabled = _prefs.getBool('bubble_sound') ?? true;  
    notifyListeners();  
  }  
    
  /// Save settings to SharedPreferences  
  Future<void> _saveSettings() async {  
    await _prefs.setBool('bubble_enabled', _isEnabled);  
    await _prefs.setDouble('bubble_opacity', _opacity);  
    await _prefs.setInt('bubble_size', _size);  
    await _prefs.setString('bubble_language', _selectedLanguage);  
    await _prefs.setBool('bubble_auto_translate', _autoTranslate);  
    await _prefs.setBool('bubble_sound', _soundEnabled);  
  }  
    
  /// Start the floating bubble  
  Future<void> startBubble(BuildContext context) async {  
    if (_isStarted) return;  
      
    try {  
      // Check and request overlay permission  
      final hasOverlay = await DashBubble.instance.hasOverlayPermission();  
      if (!hasOverlay) {  
        final granted = await DashBubble.instance.requestOverlayPermission();  
        if (!granted) {  
          if (context.mounted) {  
            ScaffoldMessenger.of(context).showSnackBar(  
              const SnackBar(content: Text('يجب تفعيل إذن الظهور فوق التطبيقات لتشغيل الفقاعة')),  
            );  
          }  
          return;  
        }  
      }  
        
      debugPrint('🫧 Starting floating bubble...');  
        
      // Start the bubble with saved settings  
      final started = await DashBubble.instance.startBubble(  
        bubbleOptions: BubbleOptions(  
          bubbleIcon: "launcher_icon",  
          distanceToClose: 100,  
          enableAnimateToEdge: true,  
          enableClose: true,  
          bubbleSize: _size.toDouble(),  
          opacity: _opacity,  
        ),  
        onTap: () {  
          debugPrint('🫧 Bubble Tapped!');  
          _onBubbleTapped(context);  
        },  
      );  
        
      if (started) {  
        _isStarted = true;  
        _isEnabled = true;  
        await _saveSettings();  
        notifyListeners();  
        debugPrint('🫧 Floating bubble started successfully!');  
      }  
    } catch (e) {  
      debugPrint('❌ Error starting bubble: $e');  
      _isStarted = false;  
    }  
  }  
    
  /// Stop the floating bubble  
  Future<void> stopBubble() async {  
    try {  
      final stopped = await DashBubble.instance.stopBubble();  
      if (stopped) {  
        _isStarted = false;  
        _isEnabled = false;  
        await _saveSettings();  
        notifyListeners();  
        debugPrint('🫧 Floating bubble stopped');  
      }  
    } catch (e) {  
      debugPrint('❌ Error stopping bubble: $e');  
    }  
  }  
    
  /// Toggle bubble on/off  
  Future<void> toggleBubble(BuildContext context, bool enabled) async {  
    if (enabled) {  
      await startBubble(context);  
    } else {  
      await stopBubble();  
    }  
    notifyListeners();  
  }  
    
  /// Update bubble opacity  
  Future<void> setOpacity(double opacity) async {  
    _opacity = opacity.clamp(0.3, 1.0);  
    await _saveSettings();  
    if (_isStarted) {  
      await stopBubble();  
    }  
    notifyListeners();  
  }  
    
  /// Update bubble size  
  Future<void> setSize(int size) async {  
    _size = size.clamp(60, 200);  
    await _saveSettings();  
    if (_isStarted) {  
      await stopBubble();  
    }  
    notifyListeners();  
  }  
    
  /// Set target language for translation  
  Future<void> setTargetLanguage(String language) async {  
    _selectedLanguage = language;  
    await _saveSettings();  
    notifyListeners();  
  }  
    
  /// Toggle auto-translate feature  
  Future<void> toggleAutoTranslate(bool enabled) async {  
    _autoTranslate = enabled;  
    await _saveSettings();  
    notifyListeners();  
  }  
    
  /// Handle bubble tap event - Show full translation interface  
  void _onBubbleTapped(BuildContext context) {  
    showDialog(  
      context: context,  
      builder: (context) => _BubbleTranslationDialog(  
        service: this,  
      ),  
    );  
  }  
    
  /// Get text from clipboard  
  Future<void> getTextFromClipboard() async {  
    try {  
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);  
      if (clipboardData?.text != null) {  
        _sourceText = clipboardData!.text!;  
        notifyListeners();  
      }  
    } catch (e) {  
      debugPrint('Clipboard error: $e');  
    }  
  }  
    
  /// Copy translated text to clipboard  
  Future<void> copyTranslatedText() async {  
    try {  
      await Clipboard.setData(ClipboardData(text: _translatedText));  
    } catch (e) {  
      debugPrint('Copy error: $e');  
    }  
  }  
    
  /// Simulate translation (in real app, call translation API)  
  Future<void> translateText() async {  
    if (_sourceText.isEmpty) return;  
      
    _isTranslating = true;  
    notifyListeners();  
      
    // Simulate translation delay  
    await Future.delayed(const Duration(seconds: 1));  
      
    // Simple translation simulation (in real app, use Google Translate API)  
    _translatedText = '[$_selectedLanguage] $_sourceText';  
      
    _isTranslating = false;  
    notifyListeners();  
  }  
    
  /// Clear translation  
  void clearTranslation() {  
    _sourceText = '';  
    _translatedText = '';  
    notifyListeners();  
  }  
}  
  
/// Full translation dialog for bubble  
class _BubbleTranslationDialog extends StatefulWidget {  
  final FloatingBubbleService service;  
    
  const _BubbleTranslationDialog({required this.service});  
    
  @override  
  State<_BubbleTranslationDialog> createState() => _BubbleTranslationDialogState();  
}  
  
class _BubbleTranslationDialogState extends State<_BubbleTranslationDialog> {  
  final TextEditingController _sourceController = TextEditingController();  
  final TextEditingController _targetController = TextEditingController();  
    
  @override  
  void initState() {  
    super.initState();  
    _sourceController.text = widget.service.sourceText;  
    _targetController.text = widget.service.translatedText;  
  }  
    
  @override  
  void dispose() {  
    _sourceController.dispose();  
    _targetController.dispose();  
    super.dispose();  
  }  
    
  @override  
  Widget build(BuildContext context) {  
    return Dialog(  
      backgroundColor: Colors.transparent,  
      child: Container(  
        width: MediaQuery.of(context).size.width * 0.9,  
        constraints: const BoxConstraints(maxHeight: 600),  
        decoration: BoxDecoration(  
          gradient: const LinearGradient(  
            begin: Alignment.topCenter,  
            end: Alignment.bottomCenter,  
            colors: [Color(0xFF0D1B2A), Color(0xFF1B2838)],  
          ),  
          borderRadius: BorderRadius.circular(20),  
          border: Border.all(color: Colors.amber.withOpacity(0.3)),  
        ),  
        child: Column(  
          mainAxisSize: MainAxisSize.min,  
          children: [  
            // Header  
            Container(  
              padding: const EdgeInsets.all(16),  
              decoration: BoxDecoration(  
                color: Colors.amber.withOpacity(0.1),  
                borderRadius: const BorderRadius.only(  
                  topLeft: Radius.circular(20),  
                  topRight: Radius.circular(20),  
                ),  
              ),  
              child: Row(  
                mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                children: [  
                  const Row(  
                    children: [  
                      Icon(Icons.translate, color: Colors.amber),  
                      SizedBox(width: 8),  
                      Text(  
                        'ميرور سكربيون - ترجمة فورية',  
                        style: TextStyle(  
                          color: Colors.white,  
                          fontWeight: FontWeight.bold,  
                          fontSize: 16,  
                        ),  
                      ),  
                    ],  
                  ),  
                  IconButton(  
                    icon: const Icon(Icons.close, color: Colors.white),  
                    onPressed: () => Navigator.pop(context),  
                  ),  
                ],  
              ),  
            ),  
              
            // Content  
            Expanded(  
              child: SingleChildScrollView(  
                padding: const EdgeInsets.all(16),  
                child: Column(  
                  crossAxisAlignment: CrossAxisAlignment.start,  
                  children: [  
                    // Language selection  
                    Row(  
                      children: [  
                        Expanded(  
                          child: _buildLanguageDropdown(  
                            'من',  
                            ['auto', 'en', 'ar', 'fr', 'de', 'es'],  
                            widget.service.sourceLanguage,  
                            (value) {  
                              setState(() {  
                                widget.service._sourceLanguage = value;  
                              });  
                            },  
                          ),  
                        ),  
                        const SizedBox(width: 8),  
                        const Icon(Icons.arrow_forward, color: Colors.amber),  
                        const SizedBox(width: 8),  
                        Expanded(  
                          child: _buildLanguageDropdown(  
                            'إلى',  
                            ['ar', 'en', 'fr', 'de', 'es', 'tr'],  
                            widget.service.selectedLanguage,  
                            (value) {  
                              widget.service.setTargetLanguage(value);  
                            },  
                          ),  
                        ),  
                      ],  
                    ),  
                      
                    const SizedBox(height: 16),  
                      
                    // Source text  
                    Container(  
                      decoration: BoxDecoration(  
                        color: Colors.white.withOpacity(0.05),  
                        borderRadius: BorderRadius.circular(12),  
                        border: Border.all(color: Colors.white.withOpacity(0.1)),  
                      ),  
                      child: Column(  
                        crossAxisAlignment: CrossAxisAlignment.start,  
                        children: [  
                          Row(  
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                            children: [  
                              const Padding(  
                                padding: EdgeInsets.all(8),  
                                child: Text(  
                                  'النص الأصلي',  
                                  style: TextStyle(color: Colors.white70, fontSize: 12),  
                                ),  
                              ),  
                              Row(  
                                children: [  
                                  IconButton(  
                                    icon: const Icon(Icons.content_paste, color: Colors.amber, size: 20),  
                                    onPressed: () async {  
                                      await widget.service.getTextFromClipboard();  
                                      setState(() {  
                                        _sourceController.text = widget.service.sourceText;  
                                      });  
                                    },  
                                    tooltip: 'لصق من الحافظة',  
                                  ),  
                                  IconButton(  
                                    icon: const Icon(Icons.clear, color: Colors.red, size: 20),  
                                    onPressed: () {  
                                      widget.service.clearTranslation();  
                                      setState(() {  
                                        _sourceController.clear();  
                                        _targetController.clear();  
                                      });  
                                    },  
                                    tooltip: 'مسح',  
                                  ),  
                                ],  
                              ),  
                            ],  
                          ),  
                          Padding(  
                            padding: const EdgeInsets.symmetric(horizontal: 8),  
                            child: TextField(  
                              controller: _sourceController,  
                              maxLines: 4,  
                              style: const TextStyle(color: Colors.white),  
                              decoration: const InputDecoration(  
                                hintText: 'أدخل النص للترجمة...',  
                                hintStyle: TextStyle(color: Colors.white30),  
                                border: InputBorder.none,  
                              ),  
                              onChanged: (value) {  
                                widget.service._sourceText = value;  
                              },  
                            ),  
                          ),  
                        ],  
                      ),  
                    ),  
                      
                    const SizedBox(height: 16),  
                      
                    // Translate button  
                    SizedBox(  
                      width: double.infinity,  
                      child: ElevatedButton.icon(  
                        onPressed: widget.service.isTranslating  
                            ? null  
                            : () async {  
                                await widget.service.translateText();  
                                setState(() {  
                                  _targetController.text = widget.service.translatedText;  
                                });  
                              },  
                        icon: widget.service.isTranslating  
                            ? const SizedBox(  
                                width: 20,  
                                height: 20,  
                                child: CircularProgressIndicator(  
                                  strokeWidth: 2,  
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),  
                                ),  
                              )  
                            : const Icon(Icons.translate),  
                        label: Text(  
                          widget.service.isTranslating ? 'جاري الترجمة...' : 'ترجمة',  
                          style: const TextStyle(fontWeight: FontWeight.bold),  
                        ),  
                        style: ElevatedButton.styleFrom(  
                          backgroundColor: Colors.amber,  
                          foregroundColor: Colors.black,  
                          padding: const EdgeInsets.symmetric(vertical: 12),  
                          shape: RoundedRectangleBorder(  
                            borderRadius: BorderRadius.circular(12),  
                          ),  
                        ),  
                      ),  
                    ),  
                      
                    const SizedBox(height: 16),  
                      
                    // Translated text  
                    Container(  
                      decoration: BoxDecoration(  
                        color: Colors.green.withOpacity(0.05),  
                        borderRadius: BorderRadius.circular(12),  
                        border: Border.all(color: Colors.green.withOpacity(0.2)),  
                      ),  
                      child: Column(  
                        crossAxisAlignment: CrossAxisAlignment.start,  
                        children: [  
                          Row(  
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                            children: [  
                              const Padding(  
                                padding: EdgeInsets.all(8),  
                                child: Text(  
                                  'الترجمة',  
                                  style: TextStyle(color: Colors.green, fontSize: 12),  
                                ),  
                              ),  
                              IconButton(  
                                icon: const Icon(Icons.copy, color: Colors.green, size: 20),  
                                onPressed: () async {  
                                  await widget.service.copyTranslatedText();  
                                  if (mounted) {  
                                    ScaffoldMessenger.of(context).showSnackBar(  
                                      const SnackBar(content: Text('تم نسخ الترجمة')),  
                                    );  
                                  }  
                                },  
                                tooltip: 'نسخ الترجمة',  
                              ),  
                            ],  
                          ),  
                          Padding(  
                            padding: const EdgeInsets.symmetric(horizontal: 8),  
                            child: TextField(  
                              controller: _targetController,  
                              maxLines: 4,  
                              style: const TextStyle(color: Colors.white),  
                              decoration: const InputDecoration(  
                                hintText: 'ستظهر الترجمة هنا...',  
                                hintStyle: TextStyle(color: Colors.white30),  
                                border: InputBorder.none,  
                              ),  
                              readOnly: true,  
                            ),  
                          ),  
                        ],  
                      ),  
                    ),  
                  ],  
                ),  
              ),  
            ),  
          ],  
        ),  
      ),  
    );  
  }  
    
  Widget _buildLanguageDropdown(  
    String label,  
    List<String> languages,  
    String selectedValue,  
    Function(String) onChanged,  
  ) {  
    return Column(  
      crossAxisAlignment: CrossAxisAlignment.start,  
      children: [  
        Text(  
          label,  
          style: const TextStyle(color: Colors.white70, fontSize: 12),  
        ),  
        const SizedBox(height: 4),  
        Container(  
          padding: const EdgeInsets.symmetric(horizontal: 12),  
          decoration: BoxDecoration(  
            color: Colors.white.withOpacity(0.05),  
            borderRadius: BorderRadius.circular(8),  
            border: Border.all(color: Colors.white.withOpacity(0.1)),  
          ),  
          child: DropdownButtonHideUnderline(  
            child: DropdownButton<String>(  
              value: selectedValue,  
              dropdownColor: const Color(0xFF1B2838),  
              style: const TextStyle(color: Colors.white),  
              isExpanded: true,  
              items: languages.map((String lang) {  
                return DropdownMenuItem<String>(  
                  value: lang,  
                  child: Text(  
                    lang == 'auto' ? 'تلقائي' : lang.toUpperCase(),  
                    style: const TextStyle(color: Colors.white),  
                  ),  
                );  
              }).toList(),  
              onChanged: (String? newValue) {  
                if (newValue != null) {  
                  onChanged(newValue);  
                }  
              },  
            ),  
          ),  
        ),  
      ],  
    );  
  }  
}  

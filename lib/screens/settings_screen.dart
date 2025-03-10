import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/session_manager.dart';
import 'package:flutter_application_1/utils/global_values.dart';
import 'package:flutter_application_1/utils/theme_settings.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _keepSession = false;
  String _currentTheme = 'light';
  Map<String, Color> _colors = {
    'primary': Colors.blue,
    'secondary': Colors.amber,
    'surface': Colors.grey,
    'error': Colors.red,
    'background': Colors.white,
    'container': Colors.white70,
  };
  String _selectedFont = 'Roboto'; // Añadir variable para la fuente
  
  final List<String> _availableFonts = [
    'Roboto',
    'Lato',
    'Montserrat',
    'Poppins',
    'Raleway',
    'Ubuntu',
  ];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final keepSession = await SessionManager.getKeepSession();
    final themePrefs = await SessionManager.getThemePreferences();

    setState(() {
      _keepSession = keepSession;
      _currentTheme = themePrefs['themeMode'];
      if (themePrefs['primaryColor'] != null) {
        _colors['primary'] = Color(themePrefs['primaryColor']);
      }
      if (themePrefs['surfaceColor'] != null) {
        _colors['surface'] = Color(themePrefs['surfaceColor']);
      }
      if (themePrefs['containerColor'] != null) {
        _colors['container'] = Color(themePrefs['containerColor']);
      }
      _selectedFont = themePrefs['fontFamily'] ?? 'Roboto';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: ListView(
        children: [
          // === LOGIN ===
          Card(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Configuración de Sesión',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SwitchListTile(
                  title: const Text('Mantener sesión iniciada'),
                  subtitle: const Text(
                    "La sesión se mantendrá activa al cerrar la aplicación",
                  ),
                  value: _keepSession,
                  onChanged: (bool value) async {
                    await SessionManager.setKeepSession(value);
                    setState(() {
                      _keepSession = value;
                    });
                  },
                ),
              ],
            ),
          ),

          // === TEMAS ===
          Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Tema',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                RadioListTile(
                  title: const Text('Claro'),
                  value: 'light',
                  groupValue: _currentTheme,
                  onChanged: _updateTheme,
                ),
                RadioListTile(
                  title: const Text('Oscuro'),
                  value: 'dark',
                  groupValue: _currentTheme,
                  onChanged: _updateTheme,
                ),
                RadioListTile(
                  title: const Text('Personalizado'),
                  value: 'custom',
                  groupValue: _currentTheme,
                  onChanged: _updateTheme,
                ),
              ],
            ),
          ),

          // === COLORES PERSONALIZADOS ===
          if (_currentTheme == 'custom')
            Card(
              margin: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Colores Personalizados',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildColorTile(
                    'Color Principal',
                    'primary',
                    'Color de los elementos principales como botones, switches',
                  ),
                  _buildColorTile(
                    'Color de Fondo',
                    'surface',
                    'Color de fondo para contenedores',
                  ),

                  _buildColorTile(
                    'Color de Contenedores',
                    'container',
                    'Color de fondo para los contenedores y widgets',
                  ),
                ],
              ),
            ),

          // Sección de tipografía
          Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Tipografía',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _availableFonts.length,
                  itemBuilder: (context, index) {
                    final font = _availableFonts[index];
                    return RadioListTile(
                      title: Text(
                        font,
                        style: GoogleFonts.getFont(font),
                      ),
                      subtitle: Text(
                        'Ejemplo de texto con esta fuente',
                        style: GoogleFonts.getFont(font),
                      ),
                      value: font,
                      groupValue: _selectedFont,
                      onChanged: (value) => _updateFont(value as String),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorTile(String title, String colorKey, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _colors[colorKey],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onTap: () => _showColorPicker(colorKey),
    );
  }

  void _showColorPicker(String colorKey) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Seleccionar ${colorKey.toUpperCase()}'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _colors[colorKey]!,
            onColorChanged: (color) {
              setState(() {
                _colors[colorKey] = color;
              });
            },
            portraitOnly: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _applyCustomTheme();
            },
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }

  void _updateTheme(String? value) async {
    if (value != null) {
      setState(() {
        _currentTheme = value;
      });

      switch (value) {
        case 'dark':
          await SessionManager.saveThemePreferences('dark');
          GlobalValues.themeApp.value = ThemeSettings.darkTheme();
          break;
        case 'light':
          await SessionManager.saveThemePreferences('light');
          GlobalValues.themeApp.value = ThemeSettings.lightTheme();
          break;
        case 'custom':
          // Solo cambiar a custom, los colores se aplicarán después
          await SessionManager.saveThemePreferences('custom');
          break;
      }
    }
  }

  void _updateFont(String font) async {
    setState(() {
      _selectedFont = font;
    });
    await SessionManager.saveThemePreferences(
      _currentTheme,
      fontFamily: font,
    );
    _applyCustomTheme();
  }

  void _applyCustomTheme() async {
    final customTheme = ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.getTextTheme(
        _selectedFont,
        ThemeData.light().textTheme,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: _colors['primary']!,
        primary: _colors['primary'],
        secondary: _colors['secondary'],
        background: _colors['background'],
      ),
      cardTheme: CardTheme(
        color: _colors['container'],
      ),
      dialogTheme: DialogTheme(
        backgroundColor: _colors['container'],
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: _colors['container'],
      ),
    );

    await SessionManager.saveThemePreferences(
      'custom',
      primaryColor: _colors['primary']!.value,
      accentColor: _colors['secondary']!.value,
      surfaceColor: _colors['surface']!.value,
      containerColor: _colors['container']!.value, // Añadir color de contenedor
      fontFamily: _selectedFont,
    );

    setState(() {
      GlobalValues.themeApp.value = customTheme;
    });
  }
}

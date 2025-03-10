import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/session_manager.dart';
import 'package:flutter_application_1/utils/global_values.dart';
import 'package:flutter_application_1/utils/theme_settings.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _keepSession = false;
  String _currentTheme = 'light';
  Color _primaryColor = Colors.blue;
  Color _accentColor = Colors.amber;

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
        _primaryColor = Color(themePrefs['primaryColor']);
      }
      if (themePrefs['accentColor'] != null) {
        _accentColor = Color(themePrefs['accentColor']);
      }
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
          // Sección de Sesión
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

          // Sección de Tema
          Card(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Tema de la Aplicación',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                RadioListTile(
                  title: const Text('Tema Claro'),
                  value: 'light',
                  groupValue: _currentTheme,
                  onChanged: _updateTheme,
                ),
                RadioListTile(
                  title: const Text('Tema Oscuro'),
                  value: 'dark',
                  groupValue: _currentTheme,
                  onChanged: _updateTheme,
                ),
                RadioListTile(
                  title: const Text('Tema Personalizado'),
                  value: 'custom',
                  groupValue: _currentTheme,
                  onChanged: _updateTheme,
                ),
                if (_currentTheme == 'custom')
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('Color Primario'),
                          trailing: Container(
                            width: 24,
                            height: 24,
                            color: _primaryColor,
                          ),
                          onTap: () => _showColorPicker(true),
                        ),
                        ListTile(
                          title: const Text('Color de Acento'),
                          trailing: Container(
                            width: 24,
                            height: 24,
                            color: _accentColor,
                          ),
                          onTap: () => _showColorPicker(false),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
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

  void _showColorPicker(bool isPrimary) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isPrimary ? 'Color Primario' : 'Color de Acento'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: isPrimary ? _primaryColor : _accentColor,
            onColorChanged: (color) {
              setState(() {
                if (isPrimary) {
                  _primaryColor = color;
                } else {
                  _accentColor = color;
                }
              });
            },
          ),
        ),
        actions: [
          TextButton(
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

  void _applyCustomTheme() async {
    final customTheme = ThemeData(
      useMaterial3: true, // Añadir esto para mejor soporte de temas
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        primary: _primaryColor,
        secondary: _accentColor,
      ),
    );

    await SessionManager.saveThemePreferences(
      'custom',
      primaryColor: _primaryColor.value,
      accentColor: _accentColor.value,
    );

    setState(() {
      GlobalValues.themeApp.value = customTheme;
    });
  }
}
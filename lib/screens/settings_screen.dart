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
  String _selectedFont = 'Roboto';
  Color _primaryColor = Colors.blue;
  Color _surfaceColor = Colors.white;
  Color _textColor = Colors.black;
  Color _containerColor = Colors.white;

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
    final currentTheme = await ThemeSettings.getCurrentThemeMode();
    final currentFont = await ThemeSettings.getCurrentFont();
    final themePrefs = await ThemeSettings.getCustomThemeColors();

    setState(() {
      _keepSession = keepSession;
      _currentTheme = currentTheme;
      _selectedFont = currentFont;
      _primaryColor = themePrefs['primary'] ?? Colors.blue;
      _surfaceColor = themePrefs['surface'] ?? Colors.white;
      _textColor = themePrefs['text'] ?? Colors.black;
      _containerColor = themePrefs['container'] ?? Colors.white;
    });
  }

  void _showColorPicker(String colorType, Color initialColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color pickedColor = initialColor;
        return AlertDialog(
          title: Text('Seleccionar color para $colorType'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: initialColor,
              onColorChanged: (Color color) {
                pickedColor = color;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Seleccionar'),
              onPressed: () {
                _updateCustomColor(colorType, pickedColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateCustomColor(String colorType, Color color) async {
    setState(() {
      switch (colorType) {
        case 'primary':
          _primaryColor = color;
          break;
        case 'surface':
          _surfaceColor = color;
          break;
        case 'text':
          _textColor = color;
          break;
        case 'container':
          _containerColor = color;
          break;
      }
    });

    await ThemeSettings.saveThemePreferences(
      themeMode: 'custom',
      primaryColor: _primaryColor,
      surfaceColor: _surfaceColor,
      textColor: _textColor,
      containerColor: _containerColor,
      fontFamily: _selectedFont,
    );

    // Forzar la actualización del tema inmediatamente
    final updatedTheme = await ThemeSettings.loadCustomTheme();
    GlobalValues.themeApp.value = updatedTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.3),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // Sección de Sesión
                  _buildSection(
                    'Sesión',
                    [
                      SwitchListTile(
                        title: const Text('Mantener sesión iniciada'),
                        value: _keepSession,
                        onChanged: (value) async {
                          await SessionManager.setKeepSession(value);
                          setState(() {
                            _keepSession = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  // Sección de Apariencia
                  _buildSection(
                    'Apariencia',
                    [
                      ListTile(
                        title: const Text('Tema'),
                        trailing: DropdownButton<String>(
                          value: _currentTheme,
                          items: const [
                            DropdownMenuItem(value: 'light', child: Text('Claro')),
                            DropdownMenuItem(value: 'dark', child: Text('Oscuro')),
                            DropdownMenuItem(value: 'custom', child: Text('Personalizado')),
                          ],
                          onChanged: _updateTheme,
                        ),
                      ),
                      if (_currentTheme == 'custom') ...[
                        const Divider(),
                        ListTile(
                          title: const Text('Color primario'),
                          trailing: GestureDetector(
                            onTap: () => _showColorPicker('primary', _primaryColor),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _primaryColor,
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          title: const Text('Color de fondo'),
                          trailing: GestureDetector(
                            onTap: () => _showColorPicker('surface', _surfaceColor),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _surfaceColor,
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          title: const Text('Color de texto'),
                          trailing: GestureDetector(
                            onTap: () => _showColorPicker('text', _textColor),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _textColor,
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                      const Divider(),
                      ListTile(
                        title: const Text('Fuente'),
                        trailing: DropdownButton<String>(
                          value: _selectedFont,
                          items: _availableFonts
                              .map((font) => DropdownMenuItem(
                                    value: font,
                                    child: Text(font),
                                  ))
                              .toList(),
                          onChanged: (font) async {
                            if (font != null) {
                              await ThemeSettings.updateFont(font);
                              setState(() {
                                _selectedFont = font;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateTheme(String? value) async {
  if (value != null) {
    setState(() {
      _currentTheme = value;
    });

    switch (value) {
      case 'light':
        await ThemeSettings.updateThemeMode(value);
        GlobalValues.themeApp.value = ThemeSettings.lightTheme();
        break;
      case 'dark':
        await ThemeSettings.updateThemeMode(value);
        GlobalValues.themeApp.value = ThemeSettings.darkTheme();
        break;
      case 'custom':
        final customTheme = await ThemeSettings.loadCustomTheme();
        GlobalValues.themeApp.value = customTheme;
        break;
    }
  }
}

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}

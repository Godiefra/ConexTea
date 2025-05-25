import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/principal_menu.dart';
import 'dart:convert';

// Modelo de Usuario
class User {
  final String nombre;
  final String apellidos;
  final int edad;
  final String usuario;
  final String contrasena;

  User({
    required this.nombre,
    required this.apellidos,
    required this.edad,
    required this.usuario,
    required this.contrasena,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      edad: json['edad'],
      usuario: json['usuario'],
      contrasena: json['contrasena'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'apellidos': apellidos,
      'edad': edad,
      'usuario': usuario,
      'contrasena': contrasena,
    };
  }
}




// Servicio de autenticación
class AuthService {
  static List<User>? _users;
  
  // Cargar usuarios desde el archivo JSON
  static Future<List<User>> loadUsers() async {
    if (_users != null) {
      return _users!; // Retorna cache si ya está cargado
    }
    
    try {
      // Leer el archivo JSON desde assets
      final String jsonString = await rootBundle.loadString('assets/data/users.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      
      // Convertir a lista de usuarios
      _users = jsonList.map((userJson) => User.fromJson(userJson)).toList();
      
      return _users!;
    } catch (e) {
      print('Error al cargar usuarios: $e');
      return [];
    }
  }

  // Validar credenciales de login
  static Future<User?> validateLogin(String usuario, String contrasena) async {
    final users = await loadUsers();
    
    try {
      return users.firstWhere(
        (user) => user.usuario == usuario && user.contrasena == contrasena,
      );
    } catch (e) {
      return null; // Usuario no encontrado
    }
  }

  // Obtener lista de usuarios para mostrar en ayuda
  static Future<List<User>> getUsers() async {
    return await loadUsers();
  }

  // Limpiar cache (útil para testing)
  static void clearCache() {
    _users = null;
  }
}

void main() {
  runApp(const ConexTEAApp());
}

class ConexTEAApp extends StatelessWidget {
  const ConexTEAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF3CA2E0),
        scaffoldBackgroundColor: const Color(0xFFECF6FF),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberUser = false;
  bool isLoading = false;
  bool obscurePassword = true;
  bool isLoadingUsers = false;
  
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  // Método para manejar el login
  Future<void> _handleLogin() async {
    final usuario = _usuarioController.text.trim();
    final contrasena = _contrasenaController.text.trim();

    if (usuario.isEmpty || contrasena.isEmpty) {
      _showErrorDialog('Por favor, completa todos los campos');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final user = await AuthService.validateLogin(usuario, contrasena);
      
      if (user != null) {
        // Login exitoso
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SecondPage(),
            ),
          );
        }
      } else {
        // Credenciales incorrectas
        _showErrorDialog('Usuario o contraseña incorrectos');
      }
    } catch (e) {
      _showErrorDialog('Error al iniciar sesión. Intenta nuevamente.');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showUsersDialog() {
    setState(() {
      isLoadingUsers = true;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Usuarios disponibles'),
          content: FutureBuilder<List<User>>(
            future: AuthService.getUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              
              final users = snapshot.data ?? [];
              
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: users.map((user) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user.nombre} ${user.apellidos}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Usuario: ${user.usuario}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Contraseña: ${user.contrasena}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const Divider(),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isLoadingUsers = false;
                });
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {
        isLoadingUsers = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.7),
              const Color(0xFFECF6FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Iconos de la parte superior
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFBB450),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.smartphone,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3CA2E0),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Text(
                            'ConexTEA',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: isLoadingUsers ? null : _showUsersDialog,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Color(0xFF5AD67D),
                              shape: BoxShape.circle,
                            ),
                            child: isLoadingUsers
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(
                                    Icons.info_outline,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 60),

                    // Tarjeta de login
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Logo circular
                          Container(
                            width: 120,
                            height: 120,
                            decoration: const BoxDecoration(
                              color: Color(0xFF3CA2E0),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                'ConexTEA',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 40),

                          // Campo de usuario
                          TextField(
                            controller: _usuarioController,
                            decoration: InputDecoration(
                              hintText: 'Usuario o correo',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: Color(0xFF3CA2E0),
                                size: 24,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Color(0xFF3CA2E0)),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              contentPadding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                          
                          const SizedBox(height: 20),

                          // Campo de contraseña
                          TextField(
                            controller: _contrasenaController,
                            obscureText: obscurePassword,
                            decoration: InputDecoration(
                              hintText: 'Contraseña',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color(0xFF3CA2E0),
                                size: 24,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey[400],
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Color(0xFF3CA2E0)),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              contentPadding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                          
                          const SizedBox(height: 15),

                          // Checkbox para recordar usuario
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: rememberUser,
                                  activeColor: const Color(0xFF3CA2E0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: BorderSide(
                                    color: Colors.grey[400]!,
                                    width: 1.5,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      rememberUser = value!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Recordar usuario',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 30),

                          // Botón de ingresar
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3CA2E0),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 0,
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    )
                                  : const Text(
                                      'Ingresar',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Texto de ayuda
                          GestureDetector(
                            onTap: isLoadingUsers ? null : _showUsersDialog,
                            child: Text(
                              '¿Necesitas ayuda para ingresar?',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usuarioController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }
}


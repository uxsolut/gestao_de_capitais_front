import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/login_controller.dart';
import '../pages/home_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MenuPerfil extends StatelessWidget {
  final VoidCallback onLogout;

  const MenuPerfil({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const CircleAvatar(
        backgroundColor: Color(0xFF4285f4),
        child: Text("P", style: TextStyle(color: Colors.white)),
      ),
      color: const Color(0xFF2c2c2c),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 'logout') {
          onLogout();
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: const [
              Icon(Icons.logout, color: Colors.redAccent),
              SizedBox(width: 10),
              Text("Logout", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }
}

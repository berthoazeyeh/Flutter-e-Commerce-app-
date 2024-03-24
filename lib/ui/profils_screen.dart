// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'dart:developer';
import 'package:ecommerce_bts/components/custom_cached_network_image.dart';
import 'package:ecommerce_bts/models/user.dart';
import 'package:ecommerce_bts/service/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({super.key, required this.users, required this.canUpdate});
  Users users;
  bool canUpdate;
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    log(_nameController.text);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil:  ${widget.users.nom}'),
        actions: [
          if (widget.canUpdate)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _nameController.text = authService.user!.nom;
                _emailController.text = authService.user!.email;
                _showEditDialog(setState, authService);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                InkWell(
                  onTap: widget.canUpdate ? () {} : null,
                  child: CircleAvatar(
                    radius: 80,
                    child: ClipOval(
                        child: CustomCachedNetworkImage(
                            cover: BoxFit.cover,
                            imageUrl: widget.users.profilUrl)),
                  ),
                ),
                if (widget.canUpdate)
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[300], shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Action à effectuer lorsque l'icône d'édition est cliquée

                        if (kDebugMode) {
                          print('Icône d\'édition cliquée');
                        }
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard('Nom', widget.users.nom),
            _buildInfoCard('E-mail', widget.users.email),
            _buildInfoCard(
                'Statut', widget.users.status ? 'Activé' : 'Désactivé'),
            _buildInfoCard(
                'Administrateur', widget.users.isAdmin ? 'OUI' : 'NON'),
            const SizedBox(height: 16),
            Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  "Nommer <<${widget.users.nom}>> comme administrateur",
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Visibility(
                visible: isLoading, child: const CircularProgressIndicator()),
            Visibility(visible: isLoading, child: const Text("chargement")),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Future<void> _showEditDialog(
      StateSetter stateSetter, AuthService authService) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier les informations'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                enabled: true,
                enableSuggestions: true,
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nouveau nom'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                enabled: false,
                decoration: const InputDecoration(labelText: 'Nouvel e-mail'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                stateSetter(
                  () {},
                );
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                log(_nameController.text);
                stateSetter(
                  () {
                    isLoading = true;
                  },
                );

                _nameController.clear();
                _emailController.clear();
                stateSetter(
                  () {
                    isLoading = false;
                  },
                );
                _showSnackbar('Informations mises à jour avec succès');
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

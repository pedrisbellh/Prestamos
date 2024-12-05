import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'create_screen.dart'; 
import 'view_loan_screen.dart';
import 'client_detail_screen.dart';
import '../utils/upper_case_text_formatter.dart';
import '../utils/snack_bar_top.dart';
import '/models/client.dart';
import '/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final List<Client> clients = [];

  List<Client> filteredClients = []; // Nueva lista para almacenar los clientes filtrados
  bool isSearching = false; // Estado para saber si estamos en modo búsqueda
  final TextEditingController searchController = TextEditingController();
  
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emergencyContactNameController = TextEditingController();
  final TextEditingController emergencyContactPhoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser ?.uid; // Obtener el UID del usuario actual
    _loadClients(); // Cargar los clientes al iniciar la pantalla
  }

  Future<void> _loadClients() async {
    try {
      if (userId != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('clients')
            .where('userId', isEqualTo: userId)
            .get();

        setState(() {
          clients.clear();
          for (var doc in querySnapshot.docs) {
            var data = doc.data() as Map<String, dynamic>;
            clients.add(Client(
              doc.id,
              data['name'],
              data['phone'],
              data['emergencyContactName'],
              data['emergencyContactPhone'],
              data['address'], 
              data['identityCard'], 
            ));
          }
          filteredClients = clients; // Inicializa la lista filtrada
        });
      }
    } catch (e) {
      print("Error al cargar clientes: $e");
      SnackBarTop.showTopSnackBar(context, 'Error al cargar clientes: $e');
    }
  }

// Método para filtrar clientes
  void _filterClients(String query) {
    if (query.isEmpty) {
      setState(() {
        isSearching = false; // Si no hay texto, no estamos buscando
        filteredClients = clients; // Reiniciar la lista filtrada a la original
      });
    } else {
      setState(() {
        isSearching = true; // Estamos buscando
        filteredClients = clients.where((client) {
          return client.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }


  @override
  void dispose() {
    clientNameController.dispose();
    phoneNumberController.dispose();
    emergencyContactNameController.dispose();
    emergencyContactPhoneController.dispose();
    searchController.dispose(); // Asegúrate de limpiar el controlador de búsqueda
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().split(' ').length < 3) {
      return 'Ingresa el nombre completo.';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$'); // Permitir números con código de país
    if (value == null || !phoneRegex.hasMatch(value)) {
      return 'El número de teléfono no es válido.';
    }
    return null;
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      inputFormatters: [UpperCaseTextFormatter()],
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal, width: 2.0),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal, width: 2.0),
          ),
        ),
      validator: validator,
      keyboardType: TextInputType.number,
    );
  }

void addClient() {
  clientNameController.clear();
  phoneNumberController.clear();
  emergencyContactNameController.clear();
  emergencyContactPhoneController.clear();
  // Nuevos controladores para los campos de dirección y carne de identidad
  final TextEditingController addressController = TextEditingController();
  final TextEditingController identityCardController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('Agregar Cliente', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  controller: clientNameController,
                  hintText: 'Nombre del Cliente',
                  validator: _validateName,
                ),
                const SizedBox(height: 10),
                _buildNumberField(
                  controller: phoneNumberController,
                  hintText: 'Teléfono del Cliente',
                  validator: _validatePhone,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: addressController,
                  hintText: 'Dirección del Cliente',
                  validator: (value) => value == null || value.isEmpty ? 'Ingresa la dirección.' : null,
                ),
                const SizedBox(height: 10),
                _buildNumberField(
                  controller: identityCardController,
                  hintText: 'Cédula de Identidad',
                  validator: (value) => value == null || value.isEmpty ? 'Ingresa la cédula de identidad.' : null,
                ),
                const SizedBox(height: 20),
                const Text('Contacto de Emergencia', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: emergencyContactNameController,
                  hintText: 'Nombre de Emergencia',
                  validator: _validateName,
                ),
                const SizedBox(height: 10),
                _buildNumberField(
                  controller: emergencyContactPhoneController,
                  hintText: 'Teléfono de Emergencia',
                  validator: _validatePhone,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                String clientNameInput = clientNameController.text;
                String phoneNumberInput = phoneNumberController.text;
                String emergencyContactNameInput = emergencyContactNameController.text;
                String emergencyContactPhoneInput = emergencyContactPhoneController.text;
                String addressInput = addressController.text; 
                String identityCardInput = identityCardController.text;

                if (!clients.any((client) => client.name == clientNameInput)) {
                  await FirebaseFirestore.instance.collection('clients').add({
                    'name': clientNameInput,
                    'phone': phoneNumberInput,
                    'emergencyContactName': emergencyContactNameInput,
                    'emergencyContactPhone': emergencyContactPhoneInput,
                    'address': addressInput, 
                    'identityCard': identityCardInput,
                    'userId': userId,
                  });
                  await _loadClients();
                  Navigator.of(context).pop();
                  SnackBarTop.showTopSnackBar(context, 'Cliente $clientNameInput agregado');
                } else {
                  SnackBarTop.showTopSnackBar(context, 'El cliente ya existe');
                }
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            child: const Text('Crear'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  );
}

void removeClient(String clientName) async {
  try {
    // Primero, busca el cliente por nombre para obtener su ID
    var clientDoc = await FirebaseFirestore.instance
        .collection('clients')
        .where('name', isEqualTo: clientName)
        .where('userId', isEqualTo: userId) // Asegúrate de que el cliente pertenezca al usuario actual
        .get();

    if (clientDoc.docs.isNotEmpty) {
      String clientId = clientDoc.docs.first.id; // Obtén el ID del primer cliente encontrado

      // Primero, elimina el préstamo asociado al cliente
      await deleteLoanForClient(clientName, userId!);
      
      // Luego, elimina el cliente
      await deleteClientFromFirestore(clientId);
      
      setState(() {
        clients.removeWhere((client) => client.name == clientName);
      });
      SnackBarTop.showTopSnackBar(context, "Cliente '$clientName' eliminado");
    } else {
      SnackBarTop.showTopSnackBar(context, 'Cliente no encontrado o no pertenece al usuario actual');
    }
  } catch (e) {
    print("Error al eliminar el cliente: $e");
    SnackBarTop.showTopSnackBar(context, 'Error al eliminar el cliente');
  }
}

  Widget _buildClientTile(Client client, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ListTile(
        title: Text(client.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClientDetailsScreen(
                      clientName: client.name,
                      clientPhone: client.phone,
                      emergencyContactName: client.emergencyContactName,
                      emergencyContactPhone: client.emergencyContactPhone,
                      address: client.address,
                      identityCard: client.identityCard,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_balance),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('loan')
                    .where('clientName', isEqualTo: client.name)
                    .where('userId', isEqualTo: userId)
                    .get()
                    .then((querySnapshot) {
                      if (querySnapshot.docs.isNotEmpty) {
                        // Si ya existe un préstamo para este cliente
                        SnackBarTop.showTopSnackBar(context, 'Ya existe un préstamo para ${client.name}');
                      } else {
                        // Si no existe un préstamo, navega a la pantalla de creación de préstamo
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SecondScreen(clientName: client.name),
                          ),
                        );
                      }
                    }).catchError((error) {
                      SnackBarTop.showTopSnackBar(context, 'Error al buscar el préstamo: $error');
                    });
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_balance_wallet),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('loan')
                    .where('clientName', isEqualTo: client.name)
                    .where('userId', isEqualTo: userId)
                    //.where('completado', isEqualTo: false)
                    .where('renovado', isEqualTo: false)
                    .get()
                    .then((querySnapshot) {
                      if (querySnapshot.docs.isNotEmpty) {
                        String loanId = querySnapshot.docs.first.id;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewLoanScreen(
                              loanId: loanId,
                            ),
                          ),
                        );
                      } else {
                        SnackBarTop.showTopSnackBar(context, 'No se encontró ningún préstamo para ${client.name}');
                      }
                    }).catchError((error) {
                      SnackBarTop.showTopSnackBar(context, 'Error al buscar el préstamo: $error');
                    });
              },
            ),
            // IconButton(
            //   icon: const Icon(Icons.delete),
            //   onPressed: () {
            //     // Mostrar el diálogo de confirmación
            //     showDialog(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return AlertDialog(
            //           title: const Text('¿Desea eliminar este cliente?'),
            //           content: const Text('NOTA: Eliminar este cliente elimina sus prestamos asociados.'),
            //           actions: [
            //             TextButton(
            //               onPressed: () {
            //                 // Llamar al método removeClient y cerrar el diálogo
            //                 removeClient(client.name);
            //                 Navigator.of(context).pop(); // Cerrar el diálogo
            //               },
            //               style: TextButton.styleFrom(
            //               backgroundColor: Colors.teal,
            //               foregroundColor: Colors.white,
            //             ),
            //               child: const Text('Eliminar'),
            //             ),
            //             TextButton(
            //               onPressed: () {
            //                 // Cerrar el diálogo al presionar Cancelar
            //                 Navigator.of(context).pop();
            //               },
            //               style: TextButton.styleFrom(
            //               backgroundColor: Colors.red,
            //               foregroundColor: Colors.white,
            //             ),
            //               child: const Text('Cancelar'),
            //             ),
            //           ],
            //         );
            //       },
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed('/');
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: isSearching
          ? TextField(
              controller: searchController,
              onChanged: (value) {
                _filterClients(value);
              },
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Buscar cliente...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
            )
          : const Text('Gestión de Clientes'),
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: Icon(isSearching ? Icons.clear : Icons.search),
          onPressed: () {
            setState(() {
              if (isSearching) {
                // Solo cerrar el campo de búsqueda si se presiona la X
                isSearching = false;
                searchController.clear();
                filteredClients = clients; // Restaurar vista original
              } else {
                isSearching = true;
              }
            });
          },
        ),
      ],
    ),
    body: isSearching
        ? filteredClients.isEmpty
            ? const Center(child: Text('No existe el cliente.'))
            : ListView.builder(
                itemCount: filteredClients.length,
                itemBuilder: (context, index) {
                  return _buildClientTile(filteredClients[index], index);
                },
              )
        : clients.isEmpty
            ? const Center(child: Text('No hay clientes disponibles.'))
            : ListView.builder(
                itemCount: clients.length,
                itemBuilder: (context, index) {
                  return _buildClientTile(clients[index], index);
                },
              ),
    floatingActionButton: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: addClient,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          heroTag: 'add_client', // Tag único para el botón de adicionar
          child: const Icon(Icons.add),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          onPressed: () async {
            await _logout(context);
          },
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          heroTag: 'logout', // Tag único para el botón de cerrar sesión
          child: const Icon(Icons.logout),
        ),
      ],
    ),
  );
}

}
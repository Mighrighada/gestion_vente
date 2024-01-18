import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buy/pages/login.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  String gender = 'male';
  String country = 'Select Country';
  DateTime? selectedDate;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    } else if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Widget buildTextFormField(
    TextEditingController controller,
    TextInputType keyboardType,
    String hintText,
    String? Function(String?) validator,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: keyboardType == TextInputType.text ? false : true,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: validator,
    );
  }

  Widget buildDropdownField(
      String value, List<String> items, Function(String) onChanged) {
    return Row(
      children: [
        Text("Country: "),
        DropdownButton<String>(
          value: value,
          onChanged: (String? newValue) {
            onChanged(newValue!);
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildRadioField(String groupValue, Function(String) onChanged) {
    return Row(
      children: [
        Text("Gender: "),
        Radio(
          value: 'male',
          groupValue: groupValue,
          onChanged: (value) {
            onChanged(value.toString());
          },
        ),
        Text("Male"),
        Radio(
          value: 'female',
          groupValue: groupValue,
          onChanged: (value) {
            onChanged(value.toString());
          },
        ),
        Text("Female"),
      ],
    );
  }

  register() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Create user with email and password
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Get the currently logged-in user
      User? user = _auth.currentUser;

      // Save additional user data to Firestore
      await _firestore.collection('users').doc(user!.uid).set({
        'username': usernameController.text,
        'email': user.email,
        'gender': gender,
        'country': country,
        'dateOfBirth': selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(selectedDate!)
            : null,
      });

      // Navigate to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );
    } catch (e) {
      // Handle registration errors
      print('Error during registration: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ))!;
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 112, 240, 176),
          title: Text('Registration'),
        ),
        backgroundColor: Color.fromARGB(255, 247, 247, 247),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(33.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 64,
                    ),
                    buildTextFormField(
                      usernameController,
                      TextInputType.text,
                      "Enter Your username : ",
                      validateUsername,
                    ),
                    const SizedBox(
                      height: 33,
                    ),
                    buildTextFormField(
                      emailController,
                      TextInputType.emailAddress,
                      "Enter Your Email : ",
                      validateEmail,
                    ),
                    const SizedBox(
                      height: 33,
                    ),
                    buildTextFormField(
                      passwordController,
                      TextInputType.text,
                      "Enter Your Password : ",
                      validatePassword,
                    ),
                    const SizedBox(
                      height: 33,
                    ),
                    buildRadioField(gender, (value) {
                      setState(() {
                        gender = value;
                      });
                    }),
                    const SizedBox(
                      height: 16,
                    ),
                    buildDropdownField(country, [
                      'Select Country',
                      'Tunis',
                      'Sfax',
                      'kairouan'
                    ], (value) {
                      setState(() {
                        country = value;
                      });
                    }),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Text("Date of Birth: "),
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: Text(
                            selectedDate != null
                                ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                                : 'Select Date',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 33,
                    ),
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState?.validate() ?? false) {
                                register();
                              }
                            },
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Register",
                              style: TextStyle(fontSize: 19),
                            ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                        padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 33,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Do not have an account?",
                            style: TextStyle(fontSize: 18)),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                            );
                          },
                          child: Text('sign in',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 36, 175, 163),
                                  fontSize: 18)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

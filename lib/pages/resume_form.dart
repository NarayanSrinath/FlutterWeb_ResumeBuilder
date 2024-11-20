import 'package:flutter/material.dart';

class ResumeForm extends StatefulWidget {
  @override
  _ResumeFormState createState() => _ResumeFormState();
}

class _ResumeFormState extends State<ResumeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final List<Map<String, dynamic>> _dynamicFields = [];

  // Controllers for dynamic field inputs
  TextEditingController fieldNameController = TextEditingController();
  TextEditingController dropdownValuesController = TextEditingController();

  String selectedFieldType = 'TextField'; // Default field type
  String dropdownValues = ''; // For dropdown field
  bool showAddFieldSection =
      false; // To toggle visibility of the "Add New Field" section

  // Method to handle adding a dynamic field
  void _addDynamicField() {
    String fieldName = fieldNameController.text.trim();
    if (fieldName.isEmpty) {
      return; // Prevent adding empty fields
    }

    setState(() {
      _dynamicFields.add({
        'name': fieldName,
        'type': selectedFieldType,
        'controller': TextEditingController(),
        'dropdownValues': selectedFieldType == 'Dropdown'
            ? dropdownValuesController.text.split(',')
            : [],
      });
      showAddFieldSection = false; // Hide the Add Field section after adding
    });

    // Clear the controllers after adding the field
    fieldNameController.clear();
    dropdownValuesController.clear();
  }

  // Method to handle removing a dynamic field
  void _removeDynamicField(int index) {
    setState(() {
      _dynamicFields.removeAt(index);
    });
  }

  // Validation methods
  bool _isValidEmail(String value) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zAZ0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(value);
  }

  bool _isValidPhone(String value) {
    return RegExp(r"^[0-9]{10}$").hasMatch(value);
  }

  bool _isTextArea(String fieldType) {
    return fieldType == 'TextArea';
  }

  bool _isPhone(String fieldType) {
    return fieldType == 'NumberField';
  }

  bool _isEmail(String fieldType) {
    return fieldType == 'TextField'; // Just as an example
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade200,
        title: const Text("Resume Builder"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Left side: Main form
            Expanded(
              flex: 7,
              child: Card(
                color: Colors.yellow.shade200,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          
                            borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                       const Text("Resume Editor",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 30),
                      // Static form fields for name, email, etc.
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? "Name is required"
                            : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || !_isValidEmail(value)
                            ? "Invalid email"
                            : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: "Phone Number",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) => value == null || !_isValidPhone(value)
                            ? "Invalid phone number"
                            : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _summaryController,
                        decoration: const InputDecoration(
                          labelText: "Professional Summary",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 5,
                      ),
                  
                      const Divider(),
                  
                      const Divider(),
                      // Display dynamic fields
                      ..._dynamicFields.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> field = entry.value;
                        final fieldName = field['name'];
                        final fieldType = field['type'];
                        final controller = field['controller'];
                        final dropdownValues = field['dropdownValues'];
                  
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fieldName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              if (fieldType == 'TextField')
                                TextFormField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                    labelText: fieldName,
                                    border: const OutlineInputBorder(),
                                  ),
                                  validator: (value) => _isEmail(fieldType) &&
                                          value != null &&
                                          !_isValidEmail(value)
                                      ? "Please enter a valid email address"
                                      : null,
                                ),
                              if (_isTextArea(fieldType))
                                TextFormField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                    labelText: fieldName,
                                    border: const OutlineInputBorder(),
                                  ),
                                  maxLines: 5,
                                ),
                              if (_isPhone(fieldType))
                                TextFormField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                    labelText: fieldName,
                                    border: const OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) =>
                                      value != null && !_isValidPhone(value)
                                          ? "Invalid phone number"
                                          : null,
                                ),
                              if (fieldType == 'Dropdown')
                                DropdownButtonFormField<String>(
                                  value: controller.text.isNotEmpty
                                      ? controller.text
                                      : null,
                                  onChanged: (value) {
                                    setState(() {
                                      controller.text = value ?? '';
                                    });
                                  },
                                  items: dropdownValues
                                      .map<DropdownMenuItem<String>>(
                                        (value) => DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        ),
                                      )
                                      .toList(),
                                  decoration: InputDecoration(
                                    labelText: fieldName,
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              const SizedBox(height: 10),
                              // Remove Button
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () => _removeDynamicField(index),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Icon(Icons.delete),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            
            
            
            const SizedBox(
                width: 40), // Space between form and "Add New Field" section

            // Right side: Add New Field section
            Expanded(
              flex: 3,
              child: Card(
                  color: Colors.yellow.shade200,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          
                            borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          ...[
                            const Text("Builder",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            // Field type dropdown
                            DropdownButtonFormField<String>(
                              value: selectedFieldType,
                              decoration:
                                  const InputDecoration(labelText: 'Field Type'),
                              items: [
                                'TextField',
                                'TextArea',
                                'NumberField',
                                'Dropdown'
                              ]
                                  .map((type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(type),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedFieldType =
                                      value ?? 'TextField'; // Default value
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            // Field name input
                            TextFormField(
                              controller: fieldNameController,
                              decoration: const InputDecoration(
                                labelText: 'Field Name',
                              ),
                            ),
                            const SizedBox(height: 10),
                            // If dropdown is selected, show dropdown values input
                            if (selectedFieldType == 'Dropdown') ...[
                              TextFormField(
                                controller: dropdownValuesController,
                                decoration: const InputDecoration(
                                  labelText:
                                      'Dropdown Values (comma separated)',
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],

                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: _addDynamicField,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              child: const Text("Add Field"),
                            ),
                          ],
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

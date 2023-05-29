import 'package:flutter/material.dart';

class PhoneNumberDialog extends StatefulWidget {
  const PhoneNumberDialog({Key? key}) : super(key: key);

  @override
  _PhoneNumberDialogState createState() => _PhoneNumberDialogState();
}

class _PhoneNumberDialogState extends State<PhoneNumberDialog> {
  String _selectedCountryCode = '+1'; // default country code
  String? _phoneNumber;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Phone Number'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Country Code'),
              DropdownButton<String>(
                value: _selectedCountryCode,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCountryCode = newValue!;
                  });
                },
                items:
                    <String>['+1', '+91', '+44', '+81'] // list of country codes
                        .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(hintText: 'Phone Number'),
            onChanged: (value) {
              _phoneNumber = value;
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Submit'),
          onPressed: () {
            String phoneNumber = _selectedCountryCode + _phoneNumber!;
            Navigator.of(context).pop(phoneNumber);
          },
        ),
      ],
    );
  }
}

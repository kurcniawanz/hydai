import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/network/api.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';

class DetailProfileForm extends StatefulWidget {
  const DetailProfileForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DetailProfileFormState createState() => _DetailProfileFormState();
}

class _DetailProfileFormState extends State<DetailProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? firstName;
  String? phoneNumber;
  String? email;
  String? street;
  String? city;
  String? iduser;
  // String? provinsi;

  final TextEditingController _controllerNama = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerMobile = TextEditingController();
  final TextEditingController _controllerCity = TextEditingController();
  final TextEditingController _controllerStreet = TextEditingController();

  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future<void> _getData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var nama = localStorage.getString('name').toString().replaceAll('"', '');
    var mail = localStorage.getString('email').toString().replaceAll('"', '');
    var mobile =
        localStorage.getString('mobile').toString().replaceAll('"', '');
    var iduserr =
        localStorage.getString('id_user').toString().replaceAll('"', '');
    var cityy =
        localStorage.getString('street2').toString().replaceAll('"', '');
    var streett =
        localStorage.getString('street').toString().replaceAll('"', '');

    setState(() {
      firstName = nama;
      phoneNumber = mobile;
      email = mail;
      iduser = iduserr;
      city = cityy;
      street = streett;
    });

    _controllerNama.text = nama;
    _controllerEmail.text = email!;
    _controllerMobile.text = phoneNumber!;
    _controllerCity.text = cityy;
    _controllerStreet.text = streett;
  }

  Future<void> _updateData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('name', firstName!);
    localStorage.setString('mobile', phoneNumber!);
    localStorage.setString('email', email!);
    localStorage.setString('street', street!);
    localStorage.setString('street2', city!);

    _controllerNama.text = firstName!;
    _controllerEmail.text = email!;
    _controllerMobile.text = phoneNumber!;
    _controllerStreet.text = street!;
    _controllerCity.text = city!;
  }

  Future<void> _updateprofile() async {
    EasyLoading.show(status: 'loading...');

    var data = {
      'name': firstName,
      'street': street,
      'street2': city,
      'mobile': phoneNumber,
      'email': email,
      'partner_id': iduser
    };

    var res = await Network().auth(data, '/profile');
    var body = json.decode(res.body);

    if (body['partner_id'] > 0) {
      _updateData();
      // ignore: use_build_context_synchronously
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(
            'Hydai',
          ),
          content: const SizedBox(
            width: 150,
            height: 40,
            child: Center(child: Text('Update Profile Sukses')),
          ),
          actions: [
            SizedBox(
              width: 80,
              height: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      );
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(
            'Hydai',
          ),
          content: const SizedBox(
            width: 150,
            height: 40,
            child: Center(child: Text('Failed')),
          ),
          actions: [
            SizedBox(
              width: 80,
              height: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      );
    }
  }

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            onSaved: (newValue) => firstName = newValue,
            controller: _controllerNama,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kNamelNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "First Name",
              hintText: "Enter your first name",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            controller: _controllerEmail,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kEmailNullError);
              } else if (emailValidatorRegExp.hasMatch(value)) {
                removeError(error: kInvalidEmailError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kEmailNullError);
                return "";
              } else if (!emailValidatorRegExp.hasMatch(value)) {
                addError(error: kInvalidEmailError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.phone,
            onSaved: (newValue) => phoneNumber = newValue,
            controller: _controllerMobile,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPhoneNumberNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPhoneNumberNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Phone Number",
              hintText: "Enter your phone number",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            onSaved: (newValue) => street = newValue,
            controller: _controllerStreet,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kAddressNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kAddressNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Street",
              hintText: "Enter your Street",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            onSaved: (newValue) => city = newValue,
            controller: _controllerCity,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kCityNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kCityNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "City/State",
              hintText: "Enter your City/State",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
            ),
          ),
          const SizedBox(height: 20),
          // TextFormField(
          //   onSaved: (newValue) => provinsi = newValue,
          //   onChanged: (value) {
          //     if (value.isNotEmpty) {
          //       removeError(error: kProvinsiNullError);
          //     }
          //     return;
          //   },
          //   validator: (value) {
          //     if (value!.isEmpty) {
          //       addError(error: kProvinsiNullError);
          //       return "";
          //     }
          //     return null;
          //   },
          //   decoration: const InputDecoration(
          //     labelText: "Provinsi",
          //     hintText: "Enter your Provinsi",
          //     // If  you are using latest version of flutter then lable text and hint text shown like this
          //     // if you r using flutter less then 1.20.* then maybe this is not working properly
          //     floatingLabelBehavior: FloatingLabelBehavior.always,
          //     suffixIcon:
          //         CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          //   ),
          // ),
          FormError(errors: errors),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                _updateprofile();
              }
            },
            child: const Text(
              "Continue Update",
              style: TextStyle(color: Color(0xFF083652)),
            ),
          ),
        ],
      ),
    );
  }
}

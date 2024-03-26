import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/network/api.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? passlama;
  String? passbaru1;
  String? passbaru2;
  String? iduser;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future<void> _getData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var passlamaa = localStorage.getString('user_pass').toString();
    var iduserr =
        localStorage.getString('id_user').toString().replaceAll('"', '');

    setState(() {
      passlama = passlamaa;
      iduser = iduserr;
    });
  }

  Future<void> _deleteAll() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('id_user');
    localStorage.remove('name');
    localStorage.remove('mobile');
    localStorage.remove('email');
  }

  Future<void> _updatepassword() async {
    EasyLoading.show(status: 'loading...');

    var data = {
      'user_pass_baru2': passbaru2,
      'user_pass_baru1': passbaru1,
      'user_pass_lama': passlama,
      'partner_id': iduser
    };

    var res = await Network().auth(data, '/change_pass');
    var body = json.decode(res.body);

    if (body['partner_id'] > 0) {
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
            child: Center(
                child: Text('Update Password Sukses, silahkan login ulang')),
          ),
          actions: [
            SizedBox(
              width: 80,
              height: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () => {_deleteAll(), SystemNavigator.pop()},
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      );
      EasyLoading.dismiss();
    } else if (body['partner_id'] == -1) {
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
            child: Center(child: Text('Confirm New Password tidak sama.')),
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
    } else if (body['partner_id'] == -2) {
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
            child: Center(child: Text('Password lama tidak sesuai')),
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
            obscureText: true,
            onSaved: (newValue) => passlama = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError2);
              } else if (value.length >= 8) {
                removeError(error: kShortPassError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError2);
                return "";
              } else if (value.length < 8) {
                addError(error: kShortPassError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Old Password",
              hintText: "Enter your old password",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            onSaved: (newValue) => passbaru1 = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError3);
              } else if (value.length >= 8) {
                removeError(error: kShortPassError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError3);
                return "";
              } else if (value.length < 8) {
                addError(error: kShortPassError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "New Password",
              hintText: "Enter your new password",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            onSaved: (newValue) => passbaru2 = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError3);
              } else if (value.length >= 8) {
                removeError(error: kShortPassError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError3);
                return "";
              } else if (value.length < 8) {
                addError(error: kShortPassError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Confirm New Password",
              hintText: "Re-Enter your new password",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
          ),
          const SizedBox(height: 20),
          FormError(errors: errors),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                _updatepassword();
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

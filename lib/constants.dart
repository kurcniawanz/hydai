import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFFcce235);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFdbeb72), Color(0xFFcce235)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Colors.black;

const kAnimationDuration = Duration(milliseconds: 200);

const headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Mohon Isi Email";
const String kInvalidEmailError = "Mohon isi Email dengan benar";
const String kPassNullError = "Mohon Isi Password";
const String kPassNullError2 = "Mohon Isi Password Lama";
const String kPassNullError3 = "Mohon Isi Password Baru";
const String kShortPassError = "Password minimal 8 caracter";
const String kMatchPassError = "Passwords tidak sesuai";
const String kNamelNullError = "Mohon Isi Nama Lengkap";
const String kPhoneNumberNullError = "Mohon Isi Nomor Telp";
const String kAddressNullError = "Mohon Isi Alamat";
const String kCityNullError = "Mohon Isi Kota";
const String kProvinsiNullError = "Mohon Isi Provinsi";

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 16),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: kTextColor),
  );
}

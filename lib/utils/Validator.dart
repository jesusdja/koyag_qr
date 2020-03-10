class Validator {
  //**************
  //VALIDAR QUE SEA UN EMAIL
  //**************
  static String validateEmail(String value) {
    Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Ingresar dirección de correo valido.';
    else
      return null;
  }
  //**************
  //VALIDAR CONTRASEÑA - QUE NO ESTE VACIA
  //**************
  static String validatePassword(String value) {
    if (value.isEmpty)
      return 'Ingresar contraseña';
    else
      return null;
  }

}
class Validator {
  static String validateEmail(String value) {
    Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Ingresar dirección de correo valido.';
    else
      return null;
  }

  static String validatePassword(String value) {
    if (value.isEmpty)
      return 'Ingresar contraseña';
    else
      return null;
  }

  static String validateName(String value) {
    Pattern pattern = r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Ingrese un nombre valido.';
    else
      return null;
  }

  static String validatelefono(String value) {
    Pattern pattern = r'^[0-9]*$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Ingrese un numero valido';
    else
      return null;
  }
  static String validateEmpresa(String value) {
    Pattern pattern = r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[',. -][a-zA-Z]*)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Ingrese un nombre valido.';
    else
      return null;
  }
  static String validateIdentificacion(String value) {
    Pattern pattern = r"^[a-zA-Z0-9]+(([',. -][a-zA-Z0-9])?[',. -][a-zA-Z0-9]*)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Ingrese un identificacion fiscal valido.';
    else
      return null;
  }
  static String validatePais(String value) {
    Pattern pattern = r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Ingrese un pais valido.';
    else
      return null;
  }
  static String validateRepresentante(String value) {
    Pattern pattern = r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Ingrese un nombre valido.';
    else
      return null;
  }
}
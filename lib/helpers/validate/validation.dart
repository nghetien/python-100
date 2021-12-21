import '../../constants/constants.dart';

class Validators {
  static checkValidEmail(String email) {
    if(email.isEmpty){
      return $EMPTY;
    }else{
      final regularExpression = RegExp(r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
      if(regularExpression.hasMatch(email)){
        return "";
      }else{
        return $INVALID;
      }
    }
  }
  static checkValidPassword(String password){
    if(password.isEmpty){
      return $EMPTY;
    }else{
      if(password.length >= 6){
        return "";
      }else{
        return $INVALID;
      }
    }
  }

  static checkEmpty(String value){
    if(value.isEmpty){
      return $EMPTY;
    }else{
      return "";
    }
  }
}

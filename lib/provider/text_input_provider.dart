import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginEmailProvider=StateProvider<String>((ref)=>'');
final loginPasswordProvider=StateProvider<String>((ref)=>'');
final loginPasswordVisibleProvider=StateProvider<bool>((ref)=>false);


final signupEmailProvider=StateProvider<String>((ref)=>'');
final signupPasswordProvider=StateProvider<String>((ref)=>'');
final signupConfirmPasswordProvider=StateProvider<String>((ref)=>'');
final signupPasswordVisibleProvider=StateProvider<bool>((ref)=>false);



final roomNameProvider=StateProvider<String>((ref)=>'');
final messageProvider1=StateProvider<String>((ref)=>'');
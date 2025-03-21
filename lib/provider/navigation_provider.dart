import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';

enum AppScreen{login,signup,chatRoomList}
final navigationProvider=StateProvider<AppScreen>((ref){
  final userId=ref.watch(authProvide);
  return userId==null?AppScreen.login:AppScreen.chatRoomList;
});
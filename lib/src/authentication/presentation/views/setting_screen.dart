import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sos_app/core/components/views/alert_dialog.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/core/router/app_router.dart';
import 'package:sos_app/core/services/injection_container_service.dart';
import 'package:sos_app/src/authentication/data/datasources/local/authentication_local_datasource.dart';
import 'package:sos_app/src/authentication/data/models/user_model.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_bloc.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_event.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_state.dart';
import 'package:sos_app/src/friendship/domain/params/get_friendship_params.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_bloc.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_event.dart';
import 'package:sos_app/src/friendship/presentation/widgets/notify_call.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  UserModel currentUser = UserModel.constructor();

  Future<void> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 500), () async {
      final user = await sl<AuthenticationLocalDataSource>().getCurrentUser();
      setState(() {
        currentUser = user;
      });
    });
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _handleInfoCurrentUser(BuildContext context) {
    context.read<AuthenticationBloc>().add(const GetProfileEvent());
    Navigator.of(context).pushNamed(AppRouter.updateProfile);
  }

  _handleChangePassword(BuildContext context) {
    Navigator.of(context).pushNamed(AppRouter.changePassword);
  }

  _handleContact(BuildContext context) {
    context.read<FriendshipBloc>().add(const GetFriendshipRecommendsEvent(
        params: GetFriendshipParams(userId: '', page: 1)));
    Navigator.of(context).pushNamed(AppRouter.contacts, arguments: 0);
  }

  _handleInfoApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialogBase(
          title: Center(
            child: Text(
              'Thông tin ứng dụng',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Text(''),
        );
      },
    );
  }

  _handlePolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialogBase(
          title: Center(
            child: Text(
              'Điều khoản và chính sách',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Text(''),
        );
      },
    );
  }

  _handleBugReport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialogBase(
          title: const Center(
            child: Text(
              'Báo lỗi ứng dụng',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: const Text('Bạn có chắc chắn báo lỗi ứng dụng?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Từ chối'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Đồng ý',
                style: TextStyle(
                  color: Colors.green[800],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _handleLogout(BuildContext context) {
    context.read<AuthenticationBloc>().add(const LogoutUserEvent());
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRouter.authentication,
      ModalRoute.withName(''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotifyCall(
      child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {},
        builder: (context, state) {
          // if (state is LoggingUserOut) {
          //   return const LoadingColumn(message: 'Đang đăng xuất');
          // }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Cài đặt',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
            ),
            body: Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  ListTile(
                    onTap: () => _handleInfoCurrentUser(context),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: Image.network(
                        '${ApiConfig.BASE_IMAGE_URL}${currentUser.avatarUrl}',
                        width: 100,
                      ).image,
                    ),
                    title: Text(
                      currentUser.fullName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      currentUser.contactPhone,
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    onTap: () => _handleChangePassword(context),
                    leading: Icon(
                      Icons.shield,
                      size: 25,
                      color: Colors.yellow[800],
                    ),
                    title: const Text(
                      'Thay đổi mật khẩu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    onTap: () => _handleContact(context),
                    leading: const Icon(
                      Icons.group_add,
                      size: 25,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'Liên hệ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    onTap: () => _handleInfoApp(context),
                    leading: Icon(
                      Icons.info,
                      size: 25,
                      color: Colors.blue[800],
                    ),
                    title: const Text(
                      'Thông tin ứng dụng',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    onTap: () => _handlePolicy(context),
                    leading: Icon(
                      Icons.menu_book,
                      size: 25,
                      color: Colors.pink[800],
                    ),
                    title: const Text(
                      'Điều khoản và chính sách',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    onTap: () => _handleBugReport(context),
                    leading: Icon(
                      Icons.bug_report,
                      size: 25,
                      color: Colors.red[800],
                    ),
                    title: const Text(
                      'Báo lỗi',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red[500],
                    ),
                    child: ListTile(
                      onTap: () => _handleLogout(context),
                      title: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.white),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Đăng xuất',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

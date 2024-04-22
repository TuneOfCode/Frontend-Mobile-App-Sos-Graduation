import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_bloc.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_event.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_state.dart';
import 'package:sos_app/src/authentication/presentation/widgets/create_user_dialog.dart';
import 'package:sos_app/src/authentication/presentation/widgets/get_users_listview.dart';
import 'package:sos_app/src/authentication/presentation/widgets/loading_column.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void getUsers() {
    context.read<AuthenticationBloc>().add(const GetUsersEvent());
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }

        if (state is UserCreated) {
          getUsers();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: (state is GettingUsers
              ? const LoadingColumn(message: 'Đang tải dữ liệu người dùng')
              : state is CreatingUser
                  ? const LoadingColumn(message: 'Đang tạo người dùng')
                  : state is UsersLoaded
                      ? Center(
                          child: GetUsersListView(users: state.users),
                        )
                      : const SizedBox.shrink()),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CreateUserDialog(
                  lastNameController: lastNameController,
                  firstNameController: firstNameController,
                  emailController: emailController,
                  contactPhoneController: contactPhoneController,
                  passwordController: passwordController,
                  confirmPasswordController: confirmPasswordController,
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Thêm người dùng'),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_bloc.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_state.dart';
import 'package:sos_app/src/authentication/presentation/widgets/loading_column.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_bloc.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_state.dart';
import 'package:sos_app/src/friendship/presentation/widgets/get_friendship_listview.dart';
import 'package:sos_app/src/friendship/presentation/widgets/notify_call.dart';

class FriendshipScreen extends StatefulWidget {
  const FriendshipScreen({
    super.key,
  });

  @override
  State<FriendshipScreen> createState() => _FriendshipScreenState();
}

class _FriendshipScreenState extends State<FriendshipScreen> {
  @override
  Widget build(BuildContext context) {
    return NotifyCall(
      child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is CreateUserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return NotifyCall(
            child: BlocConsumer<FriendshipBloc, FriendshipState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Material(
                  type: MaterialType.transparency,
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              top: 20,
                              left: 20,
                            ),
                            child: const Text(
                              'Danh sách bạn bè của tôi',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Container(
                              margin: const EdgeInsets.only(
                                top: 20,
                                left: 5,
                                right: 5,
                              ),
                              child: (state is GettingFriendships
                                  ? const LoadingColumn(
                                      message: 'Đang tải dữ liệu bạn bè')
                                  : state is FriendshipsLoaded
                                      ? const Center(
                                          child: GetFriendshipListView(
                                              // friendships: state.friendships,
                                              ),
                                        )
                                      : const SizedBox.shrink()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

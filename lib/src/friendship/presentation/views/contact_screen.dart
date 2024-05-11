import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sos_app/core/components/widgets/toast_error.dart';
import 'package:sos_app/src/authentication/presentation/widgets/loading_column.dart';
import 'package:sos_app/src/friendship/domain/params/get_friendship_params.dart';
import 'package:sos_app/src/friendship/domain/params/query_friendship_request_params.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_bloc.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_event.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_request_bloc.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_request_event.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_request_state.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_state.dart';
import 'package:sos_app/src/friendship/presentation/widgets/received_invitations_tab.dart';
import 'package:sos_app/src/friendship/presentation/widgets/recommend_friends_tab.dart';
import 'package:sos_app/src/friendship/presentation/widgets/sent_invitations_tab.dart';

class ContactScreen extends StatefulWidget {
  final int? tabIndex;
  const ContactScreen({super.key, this.tabIndex});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: widget.tabIndex!.isNaN ? 0 : widget.tabIndex!,
      length: 3,
      vsync: this,
    );
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    switch (_tabController.index) {
      case 0:
        context.read<FriendshipBloc>().add(const GetFriendshipRecommendsEvent(
            params: GetFriendshipParams(userId: '', page: 1)));
        break;
      case 1:
        context.read<FriendshipRequestBloc>().add(
            const GetFriendshipRequestsSentByUserEvent(
                params: QueryFriendshipRequestParams(userId: '')));
        break;
      case 2:
        context.read<FriendshipRequestBloc>().add(
            const GetFriendshipRequestsReceivedByUserEvent(
                params: QueryFriendshipRequestParams(userId: '')));
        break;
      default:
        context.read<FriendshipBloc>().add(const GetFriendshipRecommendsEvent(
            params: GetFriendshipParams(userId: '', page: 1)));
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liên hệ'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Đề xuất kết bạn'),
            Tab(text: 'Lời mời đã gửi'),
            Tab(text: 'Chưa phản hồi'),
          ],
        ),
      ),
      body: BlocConsumer<FriendshipRequestBloc, FriendshipRequestState>(
        listener: (context, state) {
          if (state is FriendshipRequestError) {
            ScaffoldMessenger.of(context).showSnackBar(
              ToastError(message: state.message).build(context),
            );
          }

          if (state is FriendshipRequestCreated) {
            context.read<FriendshipBloc>().add(
                  const GetFriendshipRecommendsEvent(
                    params: GetFriendshipParams(userId: '', page: 1),
                  ),
                );
          }
          if (state is FriendshipRequestCancelled) {
            context.read<FriendshipRequestBloc>().add(
                const GetFriendshipRequestsSentByUserEvent(
                    params: QueryFriendshipRequestParams(userId: '')));
            if (state is FriendshipRequestAccepted ||
                state is FriendshipRequestRejected) {
              context.read<FriendshipRequestBloc>().add(
                  const GetFriendshipRequestsReceivedByUserEvent(
                      params: QueryFriendshipRequestParams(userId: '')));
            }
          }
        },
        // buildWhen: (previous, current) =>
        //     previous != current &&
        //         current is FriendshipRequestsSentByUserLoaded ||
        //     current is FriendshipRequestsReceivedByUserLoaded,
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: [
              BlocConsumer<FriendshipBloc, FriendshipState>(
                listener: (context, state) {
                  if (state is FriendshipError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      ToastError(message: state.message).build(context),
                    );
                  }
                },
                buildWhen: (previous, current) =>
                    previous != current &&
                    current is FriendshipRecommendsLoaded,
                builder: (context, state) {
                  if (state is GettingFriendshipRecommends) {
                    return const LoadingColumn(message: 'Đang tải dữ liệu');
                  }
                  return RecommendFriendsTab(
                    users:
                        state is FriendshipRecommendsLoaded ? state.users : [],
                  );
                },
              ),
              state is GettingFriendshipRequestsSentByUser
                  ? const LoadingColumn(message: 'Đang tải dữ liệu')
                  : SentInvitationsTab(
                      tabController: _tabController,
                      friendshipRequests:
                          state is FriendshipRequestsSentByUserLoaded
                              ? state.friendshipRequests
                              : [],
                    ),
              state is GettingFriendshipRequestsReceivedByUser
                  ? const LoadingColumn(message: 'Đang tải dữ liệu')
                  : ReceivedInvitationsTab(
                      friendshipRequests:
                          state is FriendshipRequestsReceivedByUserLoaded
                              ? state.friendshipRequests
                              : [],
                    ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/services.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../services/users_service.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final usersService = UsersService();

  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          authService.user?.name ?? '',
          style: const TextStyle(color: Colors.black87),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.logout('token');
          },
          icon: const Icon(Icons.exit_to_app, color: Colors.black87),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            //Icons.cancel
            child: socketService.serverStatus == ServerStatus.Online
                ? Icon(Icons.check_circle, color: Colors.blue[400])
                : Icon(Icons.cancel, color: Colors.red[400]),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _loadUsers,
        header: const WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue),
          waterDropColor: Colors.lightBlue,
        ),
        child: _listViewUsuarios(),
      ),
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
        itemBuilder: (context, index) {
          return _userListTile(users[index]);
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: users.length);
  }

  ListTile _userListTile(User user) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(user.name.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: user.online ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.recipient = user;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _loadUsers() async {
    users = await usersService.getUsers();
    setState(() {});
    _refreshController.refreshCompleted();
  }
}

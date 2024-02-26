import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class DemoUser {
  final User user;
  final Token token;

  const DemoUser({
    required this.user,
    required this.token,
  });
}

extension UserData on User {
  String get handle => data?['handle'] as String? ?? '';
  String get firstName => data?['first_name'] as String? ?? '';
  String get lastName => data?['last_name'] as String? ?? '';
  String get fullName => data?['full_name'] as String? ?? '';
  String get profileImage => data?['profile_image'] as String? ?? '';
}

const demoUsers = [
  DemoUser(
    user: User(
      id: 'sachaarbonel',
      data: {
        'handle': '@sachaarbonel',
        'first_name': 'Sacha',
        'last_name': 'Arbonel',
        'full_name': 'Sacha Arbonel',
        'profile_image': 'https://avatars.githubusercontent.com/u/18029834?v=4',
      },
    ),
    token: Token(
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic2FjaGFhcmJvbmVsIn0.OsRUaTl5b4UzUjlzwVGDw6qUkmk-Kjsk89ldimKihNU'),
  ),
  DemoUser(
    user: User(
      id: 'GroovinChip',
      data: {
        'handle': '@GroovinChip',
        'first_name': 'Reuben',
        'last_name': 'Turner',
        'full_name': 'Reuben Turner',
        'profile_image': 'https://avatars.githubusercontent.com/u/4250470?v=4',
      },
    ),
    token: Token(
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiR3Jvb3ZpbkNoaXAifQ.tg0gI4C4khE82OqbNb5jdj22_yT6YysrhFCnimscgKU'),
  ),
  DemoUser(
    user: User(
      id: 'gordonphayes',
      data: {
        'handle': '@gordonphayes',
        'first_name': 'Gordon',
        'last_name': 'Hayes',
        'full_name': 'Gordon Hayes',
        'profile_image': 'https://avatars.githubusercontent.com/u/13705472?v=4',
      },
    ),
    token: Token(
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiZ29yZG9ucGhheWVzIn0.XadI53gbQceRziL3kKtgjc7iJT4DnjqE42b_feBmYuw'),
  ),
];


Future<void> main() async {
  const apiKey = String.fromEnvironment("streamfeed", defaultValue: "none");
  final client = StreamFeedClient(apiKey);

  runApp( MainApp(client: client) );
}

class MainApp extends StatelessWidget {
  const MainApp({
    Key? key,
    required this.client,
  }) : super(key: key);

  final StreamFeedClient client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => FeedProvider(
        bloc: FeedBloc(
          client: client,
        ),
        child: child!,
      ),
      home: const SelectUserPage(),
    );
  }
}

class SelectUserPage extends StatelessWidget {
  const SelectUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select user")),
      body: ListView(
        children: demoUsers
            .map(
              (demoUser) => UserTile(
                user: demoUser.user,
                onTap: () async {
                  try {
                    await context.feedClient
                        .setUser(demoUser.user, demoUser.token);

                    if( !context.mounted ) return;

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const Placeholder(),
                      ),
                    );
                  } on Exception catch (e, st) {
                    debugPrintStack(stackTrace: st);
                  }
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  const UserTile({
    Key? key,
    required this.user,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  final User user;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(user.profileImage)),
      title: Text(user.fullName),
      onTap: onTap,
      trailing: trailing,
    );
  }
}
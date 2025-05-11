import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_api_dicoding/model/story.dart';
import 'package:story_api_dicoding/repository/story_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _logout(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('token');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Logout Success")));
        context.goNamed('login');
      }
    });
  }

  Future<ListStory> _getListStory(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) {
        if (context.mounted) _logout(context);
      }
      return await StoryRepository(token: token!).getAllStory(100);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
        return ListStory(listStory: []);
      } else {
        rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text("Home Screen"),
        actions: [
          IconButton(
            onPressed: () {
              _logout(context);
            },
            icon: Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),
      body: SizedBox(
        height: deviceSize.height,
        width: deviceSize.width,
        child: FutureBuilder<ListStory>(
          future: _getListStory(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else if (snapshot.hasData) {
              return RefreshIndicator(
                onRefresh: () async => setState(() {}),
                child: _listStory(snapshot.data!.listStory, deviceSize),
              );
            } else {
              return Center(child: Text("There is no story was made"));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed('add_new_story');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _listStory(List<Story> listStory, Size deviceSize) {
    return ListView.builder(
      itemCount: listStory.length,
      itemBuilder: (BuildContext context, int index) {
        return _storyItem(deviceSize: deviceSize, story: listStory[index]);
      },
    );
  }

  Widget _storyItem({required Size deviceSize, required Story story}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(color: Colors.black, height: 1, thickness: 1),
        Container(
          constraints: BoxConstraints(maxHeight: deviceSize.width),
          width: deviceSize.width,
          child: Image.network(story.photoUrl, fit: BoxFit.contain),
        ),
        Text(story.createdAt),
        Text(story.name),
        Text(story.description),
        const SizedBox(height: 20),
      ],
    );
  }
}

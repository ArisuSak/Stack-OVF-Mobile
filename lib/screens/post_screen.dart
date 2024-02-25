import 'package:flutterapp/constant.dart';
import 'package:flutterapp/models/api_response.dart';
import 'package:flutterapp/models/post.dart';
import 'package:flutterapp/screens/comment_screen.dart';
import 'package:flutterapp/services/post_service.dart';
import 'package:flutterapp/services/user_service.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'post_form.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<dynamic> _postList = [];
  int userId = 0;
  bool _loading = true;

  // get all posts
  Future<void> retrievePosts() async {
    userId = await getUserId();
    ApiResponse response = await getPosts();

    if (response.error == null) {
      setState(() {
        _postList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  //delete post
  void _handleDeletePost(int postId) async {
    ApiResponse response = await deletePost(postId);
    if (response.error == null) {
      retrievePosts();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // post like dislike
  void _handlePostLikeDislike(int postId) async {
    ApiResponse response = await likeUnlikePost(postId);

    if (response.error == null) {
      retrievePosts();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () {
              return retrievePosts();
            },
            child: ListView.builder(
                itemCount: _postList.length,
                itemBuilder: (BuildContext context, int index) {
                  Post post = _postList[index];
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '${post.user!.name}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  )
                                ],
                              ),
                            ),
                            post.user!.id == userId
                                ? PopupMenuButton(
                                    child: Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Icon(
                                          Icons.more_vert,
                                          color: Colors.black,
                                        )),
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                          child: Text(
                                            'Edit',
                                            style: TextStyle(
                                              color: Colors
                                                  .black, // Change the color of the text to grey
                                            ),
                                          ),
                                          value: 'edit'),
                                      PopupMenuItem(
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Colors
                                                .black, // Change the color of the text to grey
                                          ),
                                        ),
                                        value: 'delete',
                                      ),
                                    ],
                                    onSelected: (val) {
                                      if (val == 'edit') {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => PostForm(
                                                      title: 'Edit Post',
                                                      post: post,
                                                    )));
                                      } else if (val == 'delete') {
                                        // _handleDeletePost(post.id ?? 0);
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: Colors
                                                  .grey, // Change the color of AlertDialog to grey
                                              title: Text('Confirm Delete'),
                                              content: Text(
                                                  'Are you sure you want to delete this post?'),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  child: Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      color: Colors
                                                          .black, // Change the color of the text to orange
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                    _handleDeletePost(
                                                        post.id ?? 0);
                                                  },
                                                ),
                                                OutlinedButton(
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      color: Colors
                                                          .black, // Change the color of the text to orange
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                  )
                                : SizedBox()
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 18), // specify the left padding here
                          child: SizedBox(
                            width: 1000, // specify the width here
                            child: Text('${post.body}'),
                          ),
                        ),
                        post.image != null
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                height: 180,
                                margin: EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: NetworkImage('${post.image}'),
                                  fit: BoxFit.scaleDown,
                                )),
                              )
                            : SizedBox(
                                height: post.image != null ? 0 : 16,
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            kLikeAndComment(
                                post.likesCount ?? 0,
                                post.selfLiked == true
                                    ? Icons.arrow_upward
                                    : Icons.arrow_upward,
                                post.selfLiked == true
                                    ? Colors.orange
                                    : Colors.grey, () {
                              _handlePostLikeDislike(post.id ?? 0);
                            }),
                            Container(
                              height: 25,
                              width: 0.5,
                              color: Colors.black38,
                            ),
                            kLikeAndComment(post.commentsCount ?? 0,
                                Icons.comment, Colors.grey, () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CommentScreen(
                                        postId: post.id,
                                      )));
                            }),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 0.3,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  );
                }),
          );
  }
}

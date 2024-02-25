import 'package:flutterapp/models/api_response.dart';
import 'package:flutterapp/models/comment.dart';
import 'package:flutterapp/services/comment_service.dart';
import 'package:flutterapp/services/user_service.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import 'login.dart';

class CommentScreen extends StatefulWidget {
  final int? postId;

  CommentScreen({
    this.postId
  });

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<dynamic> _commentsList = [];
  bool _loading = true;
  int userId = 0;
  int _editCommentId = 0;
  TextEditingController _txtCommentController = TextEditingController();

  // Get comments
  Future<void> _getComments() async {
    userId = await getUserId();
    ApiResponse response = await getComments(widget.postId ?? 0);

    if(response.error == null){
      setState(() {
        _commentsList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false)
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}')
      ));
    }
  }
  // create comment
  void _createComment() async {
    ApiResponse response = await createComment(widget.postId ?? 0, _txtCommentController.text);

    if(response.error == null){
      _txtCommentController.clear();
      _getComments();
    } 
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false)
      });
    }
    else {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}')
      ));
    }
  }

  // edit comment
void _editComment() async {
    ApiResponse response = await editComment(_editCommentId, _txtCommentController.text);

    if(response.error == null) {
      _editCommentId = 0;
      _txtCommentController.clear();
      _getComments();
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false)
      });
    } 
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}')
      ));
    }
  }


  // Delete comment
  void _deleteComment(int commentId) async {
    ApiResponse response = await deleteComment(commentId);

    if(response.error == null){
      _getComments();
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false)
      });
    } 
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}')
      ));
    }
  }

  @override
  void initState() {
    _getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DefaultTextStyle(
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
          child: Text('Answer'),
        ),
      ),
      body: _loading ? Center(child: CircularProgressIndicator(),) :
      Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: (){
                return _getComments();
              },
              child: ListView.builder(
                itemCount: _commentsList.length,
                itemBuilder: (BuildContext context, int index) {
                  Comment comment = _commentsList[index];
                  return Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black26, width: 0.5)
                      )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(width: 10,),
                                Padding(
                                  padding: EdgeInsets.only(left: 0.1), // adjust the value as needed
                                  child: Text(
                                    '${comment.user!.name}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            comment.user!.id == userId ?
                             PopupMenuButton(
                              child: Padding(
                                padding: EdgeInsets.only(right:10),
                                child: Icon(Icons.more_vert, color: Colors.black,)
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: Text('Edit'),
                                  value: 'edit'
                                ),
                                PopupMenuItem(
                                  child: Text('Delete'),
                                  value: 'delete'
                                )
                              ],
                              onSelected: (val){
                                if(val == 'edit'){
                                  setState(() {
                                    _editCommentId = comment.id ?? 0;
                                    _txtCommentController.text = comment.comment ?? '';
                                    }
                                  );
                                 showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.grey, // Change the background color to grey
                                      title: Text(
                                        'Edit Comment',
                                        style: TextStyle(
                                          color: Colors.black, // Change the title color to black
                                        ),
                                      ),
                                      content: TextFormField(
                                        controller: _txtCommentController,
                                        decoration: InputDecoration(
                                          hintText: comment.comment ?? '', // Set old comment as hintText
                                          hintStyle: TextStyle(
                                            color: Colors.black, // Change the hintText color to black
                                          ),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: Text(
                                            'Save',
                                            style: TextStyle(
                                              color: Colors.black, // Change the button text color to black
                                            ),
                                          ),
                                          onPressed: () {
                                            if(_txtCommentController.text.isNotEmpty){
                                              setState(() {
                                                _loading = true;
                                              });
                                              if (_editCommentId > 0){
                                                _editComment();
                                              } else {
                                                _createComment();
                                              }
                                            }
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                        ),
                                        OutlinedButton(
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: Colors.black, // Change the button text color to black
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                  
                                } else if (val == 'delete') {
                                  // _deleteComment(comment.id ?? 0);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.grey, // Change the background color to grey
                                        title: Text(
                                          'Confirm Delete',
                                          style: TextStyle(
                                            color: Colors.black, // Change the title color to black
                                          ),
                                        ),
                                        content: Text(
                                          'Are you sure you want to delete this comment?',
                                          style: TextStyle(
                                            color: Colors.black, // Change the content color to black
                                          ),
                                        ),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Colors.black, // Change the button text color to black
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Close the dialog
                                              _deleteComment(comment.id ?? 0);
                                            },
                                          ),
                                          OutlinedButton(
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Colors.black, // Change the button text color to black
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Close the dialog
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            ) : SizedBox()
                          ],
                        ), SizedBox(height: 10,),
                        Padding(
                          padding: EdgeInsets.only(left: 40), // adjust the value as needed
                          child: Text('${comment.comment}'),
                        ),
                      ],
                    ),
                  );
                }
              )
            )
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.black26, width: 0.5
              )
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: kInputDecoration('Comment'),
                  controller: _txtCommentController,
                ),
              ),
              IconButton(
                icon: Icon(Icons.upload),
                onPressed: (){
                  if(_txtCommentController.text.isNotEmpty){
                    setState(() {
                      _loading = true;
                    });
                  if (_editCommentId > 0){
                    _editComment();
                  } else {
                    _createComment();
                  }
                  }
                },
              )
            ],
          ),
        )
        ]
      ),
    );
  }
}
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freelancer/models/user.dart';
import 'package:freelancer/provider/user_provider.dart';
import 'package:freelancer/resourses/firestore.dart';
import 'package:freelancer/utils/colors.dart';
import 'package:freelancer/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? _file;
  bool _isloading = false;
  final TextEditingController _description = TextEditingController();

  _selectImage(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a Post"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
                child: const Text("Take a photo"),
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
                child: const Text("Pick from gallery"),
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              )
            ],
          );
        });
  }

  postImage(String username, String uid, String profImage) async {
    try {
      setState(() {
        _isloading = true;
      });
      String res = await FirestoreFunc()
          .post(uid, _description.text, _file!, username, profImage);
      if (res == "success") {
        setState(() {
          _isloading = false;
          _file = null;
        });
        showSnackBar("Posted", context);
      } else {
        setState(() {
          _isloading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      setState(() {
        _isloading = false;
      });
      showSnackBar(e.toString(), context);
    }
  }

  @override
  void Dispose() {
    super.dispose();
    _description.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyUser user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: Container(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: (() {
                _selectImage(context);
              }),
            ),
          ))
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: (() {
                    setState(() {
                      _file = null;
                    });
                  })),
              title: const Text(
                "Post to",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    postImage(user.username, user.uid, user.photoUrl);
                  },
                  child: const Text("Post",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blueAccent)),
                )
              ],
            ),
            body: Column(children: [
              _isloading
                  ? const LinearProgressIndicator()
                  : const Padding(padding: EdgeInsets.only(top: 0)),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl.toString()),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextField(
                      controller: _description,
                      maxLines: 8,
                      decoration: const InputDecoration(
                          hintText: "Write a caption...",
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: AspectRatio(
                      aspectRatio: 487 / 451,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(_file!),
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter)),
                      ),
                    ),
                  )
                ],
              ),
            ]),
          );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:password_manager/controller/encrypter.dart';

class Passwords extends StatefulWidget {
  @override
  _PasswordsState createState() => _PasswordsState();
}

class _PasswordsState extends State<Passwords> {
  Box box = Hive.box('passwords');
  bool longPressed = false;
  EncryptService _encryptService = new EncryptService();
  Future fetch() async {
    if (box.values.isEmpty) {
      return Future.value(null);
    } else {
      return Future.value(box.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Your Passwords",
          style: TextStyle(
            fontFamily: "customFont",
            fontSize: 22.0,
          ),
        ),
      ),
      //
      floatingActionButton: FloatingActionButton(
        onPressed: insertDB,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        // backgroundColor: Color(0xff892cdc),
        backgroundColor: Colors.black,
      ),
      //
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      //
      body: FutureBuilder(
        future: fetch(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: Text(
                "You have saved no password.\nSave some...\nEverything is in your Phone..",
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.black,
                  fontFamily: "customFont",
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Map data = box.getAt(index);
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // if you need this
                    side: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: Slidable(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                      child: Container(
                        child: ListTile(
                          leading: Icon(
                            Icons.lock,
                            color: Colors.black,
                            size: 32.0,
                          ),
                          title: Text(
                            "${data['nick']}",
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.black,
                              fontFamily: 'RobotoMono',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    startActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          label: 'Delete',
                          autoClose: true,
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.red.withOpacity(0.95),
                          // backgroundColor: Colors.red.withOpacity(0.95),
                          icon: Icons.delete_outline_rounded,
                          onPressed: (context) {
                            modalAlertDelete(index, data['type']);
                          },
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: DrawerMotion(),
                      children: [
                        SlidableAction(
                          label: 'Copy',
                          autoClose: true,
                          backgroundColor: Colors.amber,
                          icon: Icons.copy_rounded,
                          onPressed: (context) {
                            _encryptService.copyToClipboard(
                                data['password'], context);
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void modalAlertDelete(int index, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
            child: Text(
          'Delete $type',
        )),
        content: Text('Are you sure to delete $type'),
        actions: [
          TextButton(
              child: Text('Yes'),
              onPressed: () async {
                await box.deleteAt(index);
                setState(() {});
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  void insertDB() {
    String type;
    String nick;
    // String email;
    String password;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(
          12.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Service",
                    hintText: "Enter Original Service",
                    fillColor: Colors.black),
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: "customFont",
                ),
                onChanged: (val) {
                  type = val;
                },
                validator: (val) {
                  if (val.trim().isEmpty) {
                    return "Enter A Value !";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 12.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Display Name",
                  hintText: "Will be dispplayed as a Title",
                ),
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: "customFont",
                ),
                onChanged: (val) {
                  nick = val;
                },
                validator: (val) {
                  if (val.trim().isEmpty) {
                    return "Enter A Value !";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 12.0,
              ),
              // TextFormField(
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(),
              //     labelText: "Username/Email/Phone",
              //   ),
              //   style: TextStyle(
              //     fontSize: 18.0,
              //     fontFamily: "customFont",
              //   ),
              //   onChanged: (val) {
              //     email = val;
              //   },
              //   validator: (val) {
              //     if (val.trim().isEmpty) {
              //       return "Enter A Value !";
              //     } else {
              //       return null;
              //     }
              //   },
              // ),
              // SizedBox(
              //   height: 12.0,
              // ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: "customFont",
                ),
                onChanged: (val) {
                  password = val;
                },
                validator: (val) {
                  if (val.trim().isEmpty) {
                    return "Enter A Value !";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 12.0,
              ),
              ElevatedButton(
                onPressed: () {
                  // encrypt
                  password = _encryptService.encrypt(password);
                  // insert into db
                  Box box = Hive.box('passwords');
                  // insert
                  var value = {
                    'type': type.toLowerCase(),
                    'nick': nick,
                    // 'email': email,
                    'password': password,
                  };
                  box.add(value);

                  Navigator.of(context).pop();
                  setState(() {});
                },
                child: Text(
                  "Save",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: "customFont",
                      color: Colors.white),
                ),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 50.0,
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    // Color(0xff892cdc),
                    Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

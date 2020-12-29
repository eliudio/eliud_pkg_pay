import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> _colors = <String>['', 'red', 'green', 'blue', 'orange'];
  String _color = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Form(
        key: _formKey,
        autovalidate: true,
        child:
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              new Text(
                  "Hello hello, how are you doing? kjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjshkjdsahkajsd hasdk jhads kjhads kdjsh"),
              new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'Enter your first and last name',
                  labelText: 'Name',
                ),
              ),
              new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.calendar_today),
                  hintText: 'Enter your date of birth',
                  labelText: 'Dob',
                ),
                keyboardType: TextInputType.datetime,
              ),
              new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.phone),
                  hintText: 'Enter a phone number',
                  labelText: 'Phone',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
              ),
              new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.email),
                  hintText: 'Enter a email address',
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              new FormField(
                builder: (FormFieldState state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      icon: const Icon(Icons.color_lens),
                      labelText: 'Color',
                    ),
                    isEmpty: _color == '',
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                        value: _color,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            //newContact.favoriteColor = newValue;
                            _color = newValue;
                            state.didChange(newValue);
                          });
                        },
                        items: _colors.map((String value) {
                          return new DropdownMenuItem(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              new Container(
                  padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                  child: new RaisedButton(
                    child: const Text('Submit'),
                    onPressed: null,
                  )),
            ],
          )
        );
  }
}

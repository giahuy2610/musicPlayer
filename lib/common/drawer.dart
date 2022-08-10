import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/control.dart';
import '../themes/defaultValue.dart';
import './setting/setting.dart';

class DrawerContainer extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      width: DefaultValue.drawerWidth,
      child: Drawer(
          child: ListView(
        children: [
          Container(
//height: DefaultValue.screenHeight * 0.3,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              boxShadow: [
                BoxShadow(
                  color: Colors.lightBlue.shade300,
                  offset: const Offset(
                    -10,
                    5,
                  ),
                  blurRadius: 10.0,
                  spreadRadius: 0.1,
                ), //BoxShadow
              ],
            ),
            child: Stack(children: [
              Image.network(
                'https://mcdn.wallpapersafari.com/medium/12/93/Ei0zCM.jpg',
                fit: BoxFit.cover,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.only(right: 15.0),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius:
                            BorderRadius.all(Radius.circular((505555)))),
                    child: Text(
                      'ND',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text('UserName'), Text('PremiumAccount')])
                ],
              )
            ]),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Setting();
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone_android),
            title: const Text('My song'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Setting();
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text('My favorite'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Setting();
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Setting'),
            onTap: () {
// Update the state of the app
// ...
// Then close the drawer
              Navigator.push(context, MaterialPageRoute(builder: (context) {
// do something
                return Setting();
              }));
            },
          ),
          ListTile(
            leading: context.select<Control, bool>((a) => a.isLogIn)
                ? const Icon(Icons.logout_rounded)
                : const Icon(Icons.login_rounded),
            title: context.select<Control, bool>((a) => a.isLogIn)
                ? const Text('Log out')
                : const Text('Log in'),
            onTap: () {
// Update the state of the app
// ...
// Then close the drawer
              Navigator.pop(context);
            },
          )
        ],
      ) // Populate the Drawer in the next step.
          ),
    );
  }
}

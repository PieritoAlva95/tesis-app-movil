import 'package:flutter/material.dart';


class BottomSwitchListTile extends StatefulWidget {
  
  bool bloquear = false;

  BottomSwitchListTile({ Key? key, required this.bloquear }) : super(key: key);

  @override
  _BottomSwitchListTileState createState() => _BottomSwitchListTileState();
}

class _BottomSwitchListTileState extends State<BottomSwitchListTile> {
  bool isSwitched = false;


  void _onSwitchChanged(bool value) {
//    setState(() {
    isSwitched = value;
//    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[

          SwitchListTile(
            secondary: Icon(Icons.notifications, color: Colors.white,),
            title:Text('Notification'), // just a custom font, otherwise a regular Text widget
            value: isSwitched,
            onChanged: (bool value){
              setState(() {
                _onSwitchChanged(value);
                //print(bloqueados.toString());
              });
            },
          ),

        ],
      ),
    );
  }
}

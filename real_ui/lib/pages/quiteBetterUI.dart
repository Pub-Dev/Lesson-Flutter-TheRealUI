import 'package:flutter/material.dart';

class QuiteBetterUI extends StatefulWidget {
  @override
  _QuiteBetterUIState createState() => _QuiteBetterUIState();
}

class _QuiteBetterUIState extends State<QuiteBetterUI> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  bool _canBeDragged;

  @override
  void initState() { 
    super.initState(); 
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250)
    );
  }

  void toggle() => _animationController.isDismissed ? _animationController.forward() : _animationController.reverse();

  void _onDragStart(DragStartDetails details){
    bool isDragOpenFromLeft = _animationController.isDismissed && details.globalPosition.dx < 100;
    bool isDragOpenFromRight = _animationController.isCompleted && details.globalPosition.dx > 0;
    _canBeDragged = isDragOpenFromLeft || isDragOpenFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details){
    if(_canBeDragged){
      double delta = details.primaryDelta / 250;
      _animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details){
    if(_animationController.value > 0.5){
      _animationController.forward();
    }
    else{
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 50, left: 20),
          color: Colors.blueAccent[400],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quite', style: TextStyle(fontSize: 20, color: Colors.white), textAlign: TextAlign.left),
              Text('Complex UI', style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),),
              SizedBox(height: 40),
              ItemDrawer(text: 'Home', icon: Icons.home),
              ItemDrawer(text: 'Profile', icon: Icons.perm_identity),
              ItemDrawer(text: 'Settings', icon: Icons.settings),
              ItemDrawer(text: 'Logout', icon: Icons.exit_to_app),
            ],
          ),
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            double translateValue = 100 * _animationController.value;
            double scaleValue = 1 - (0.4 * _animationController.value);
            
            return Transform(
              alignment: Alignment.centerRight,   
              transform: Matrix4.identity()
                ..translate(translateValue)
                ..scale(scaleValue),
              child: child
            );
          },
          child: GestureDetector(
            onHorizontalDragStart: _onDragStart,
            onHorizontalDragUpdate: _onDragUpdate,
            onHorizontalDragEnd: _onDragEnd,
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => this.toggle(),
                ),
                title: Text("Quite Better UI"),
              ),
              body: Container(
                color: Colors.white,
                child: Center(child: Text('aaah agora sim!', style: TextStyle(fontSize: 20, color: Colors.black),),),
              ),
            ),
          ),
        ),
      ]
    );
  }
}

class ItemDrawer extends StatelessWidget {
  final String text;
  final IconData icon;

  ItemDrawer({this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(this.icon, color: Colors.white,),
          SizedBox(width: 20), 
          Text(this.text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}
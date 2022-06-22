import 'package:flutter/material.dart';

class Futures extends StatefulWidget {
  Futures({@required this.future, this.child,this.refresh});
  Future future;
  Widget Function(dynamic) child;
  bool refresh;
  @override
  State<Futures> createState() => _FuturesState();
}

class _FuturesState extends State<Futures> {
  Future _future;
  bool _refresh;
  @override
  initState(){
    _future = widget.future;
  }

  @override
  Widget build(BuildContext context) {
    _refresh = widget.refresh ?? false;
    if(_refresh){ _future=widget.future; }
      return FutureBuilder(builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data["res"]) {
               return widget.child(snapshot.data["data"]);
          } else {
              return Center(child: Text(snapshot.data["err"]),);
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return const Center(child: Text("No Records Recieved from Server"));
       },
       future: _future,
      );
  }
}

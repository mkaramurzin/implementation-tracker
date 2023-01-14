import 'package:flutter/material.dart';
import 'package:tracker/widgets/tracker.dart';

class Default extends StatelessWidget {
  Function(Tracker data) onAccept;
  Function(String data) onWillAccept;
  Default({super.key, required this.onAccept, required this.onWillAccept});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: DragTarget<Tracker>(
        builder: (context, accepted, rejected) {
          return CircleAvatar(
            backgroundColor: Colors.grey[200],
            radius: 37,
            child: CircleAvatar(
              backgroundColor: Colors.grey[50],
              radius: 30,
              child: Text(""),
            ),
          );
        },
        onWillAccept: (data) {
          return true;
        },
        onAccept: this.onAccept
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// class Default extends StatelessWidget {
//   Function(String data) _onAccept;
//   const Default({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.fromLTRB(0, 20, 5, 5),
//       child: DragTarget<String>(
//         builder: (context, accepted, rejected) {
//           return CircleAvatar(
//             backgroundColor: Colors.black,
//             radius: 25,
//             child: Center(child: Text("")),
//           );
//         },
//         onWillAccept: (data) {
//           return data.toString() != "" && tracker.name == "";
//         },
//         onAccept: (data) {
//           setState(() {
//             trackerMatrix.forEach((subList) {
//               subList.forEach((e) {
//                 if(e.name == data.toString()) {
//                   e.name = "";
//                 }
//               });
//             });
//           });
//           tracker.name = data.toString();
//         },
//       ),
//     );
//   }
// }


// Container(
// margin: EdgeInsets.fromLTRB(0, 20, 5, 5),
// child: DragTarget(
// builder: (context, accepted, rejected) {
// return Draggable<String>(
// data: tracker.name,
// child: CircleAvatar(
// backgroundColor: Colors.black,
// radius: 25,
// child: Center(child: Text(tracker.name)),
// ),
// feedback: CircleAvatar(
// backgroundColor: Colors.red,
// radius: 25,
// child: Center(child: Text(tracker.name)),
// ),
// );
// },
// onWillAccept: (data) {
// return data.toString() != "" && tracker.name == "";
// },
// onAccept: (data) {
// setState(() {
// trackerMatrix.forEach((subList) {
// subList.forEach((e) {
// if(e.name == data.toString()) {
// e.name = "";
// }
// });
// });
// });
// tracker.name = data.toString();
// },
// ),
// )


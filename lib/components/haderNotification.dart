import 'package:flutter/material.dart';

class HeaderNotification extends StatelessWidget {
  const HeaderNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration:
            const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
        height: (MediaQuery.of(context).size.height / 2) - 30,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Notification Liste",
                        style: TextStyle(color: Colors.teal, fontSize: 20),
                        textAlign: TextAlign.center),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.orangeAccent,
                        ))
                  ]),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 2,
            ),
            Container(
              child: const Column(children: [
                Text("0 Notification(s)"),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

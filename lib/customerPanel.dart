import 'package:flutter/material.dart';

class CustomerPanel extends StatefulWidget {
  const CustomerPanel({Key? key}) : super(key: key);

  @override
  _CustomerPanelState createState() => _CustomerPanelState();
}

class _CustomerPanelState extends State<CustomerPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("customer panel"),
        ),
        body: Text("customer hun"));
  }
}

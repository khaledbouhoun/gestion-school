import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget{
  String? title;
  String? subtitle;
  String? secondSubtitle;
  String? section;
  DetailCard({super.key, this.title, this.subtitle, this.section, this.secondSubtitle});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget? widget;

    widget = ListTile(
        title: Text(title!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.05),),
        subtitle: Text(subtitle!, style: TextStyle(fontSize: width * 0.045),));


    //the whole card
    if(section != null){
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: width * 0.08),
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            alignment: Alignment.centerLeft,
            child: Text(section!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.06)),
          ),
          Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(width: 0.2, color: Colors.grey))
              ),
              child: widget),
        ],
      );
    }else{
      return Container(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 0.2, color: Colors.grey))
          ),
          child: widget);
    }
  }

}
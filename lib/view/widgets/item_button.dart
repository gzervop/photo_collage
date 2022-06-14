import 'package:flutter/material.dart';

class ItemButton extends StatelessWidget {
  const ItemButton({Key? key, required this.name, required this.dateTime, required this.id, required this.delete, required this.open})
      : super(key: key);
  final int id;
  final String name;
  final String dateTime;
  final Function delete, open;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        open(id);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [Text(name,style: const TextStyle(fontSize: 18),), Text(dateTime,style: const TextStyle(fontSize: 12))],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      delete(id);
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomPopupMenuButton extends StatelessWidget {
  final Function(String value)? onSelected;
  final void Function()? onopened;
  final void Function()? oncanceled;
  final List<String> menuItems;

  const CustomPopupMenuButton({
    super.key,
    this.onSelected,
    this.onopened,
    this.oncanceled,
    this.menuItems = const ["one", "two",],

    });

  

  @override
  Widget build(BuildContext context) {
    List<PopupMenuItem<String>> popupMenuItems = 
  menuItems.map(
    (element){
      return PopupMenuItem<String>(
        value: element,
        child: Text(element),
        );
    }
  ).toList();

    return PopupMenuButton(
      onSelected: (value) => onSelected!(value) ?? (){},
      onOpened: onopened,
      onCanceled: oncanceled,
      itemBuilder: (item){
       return popupMenuItems;
      },

      );
  }
}
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/custom_widgets.dart';

class CommunitiesTabView extends StatelessWidget {
  const CommunitiesTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CustomWidgets.text(context, "Communities tab"),);
  }
}
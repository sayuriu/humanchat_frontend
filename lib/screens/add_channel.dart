import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:humanchat_frontend/utils/pair.dart';



class AddChatPage extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('New channel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name of channel'),
                validator: (value) {
                  return value!.trim().isEmpty ? 'Required' : null;
                },
              ),
              const MaxGap(20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Members'),
                validator: (value) {
                  return value!.trim().isEmpty ? 'Required' : null;
                },
                maxLines: null,
              ),

              // Autocomplete<String>(
              //   optionsBuilder: (TextEditingValue textEditingValue) {
              //     if (textEditingValue.text == '') {
              //       return const Iterable<String>.empty();
              //     }
              //     return chatController.getAll().map((e) => e.name).where(
              //           (element) =>
              //               element.toLowerCase().contains(textEditingValue.text.toLowerCase()),
              //         );
              //   },
              //   onSelected: (String selection) {
              //     debugPrint('You just selected $selection');
              //   },
              // ),
              ...[
                Pair('Friend #1', '@numberone'),
                Pair('Friend #2', '@numbertwo'),
                Pair('Friend #3', '@numberthree'),
              ].map((p) {
                return ListTile(
                  title: Text(p.key),
                  leading: const CircleAvatar(child: Icon(Icons.person),),
                  subtitle: Text(p.value),
                );
              }),
              const MaxGap(40),
              ElevatedButton(
                onPressed: () => formKey.currentState!.validate(),
                child: const Text('Xác nhận'),
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

void showDeleteDialog(
    {required BuildContext context,
    required Function() handleOnDelete,
    Function()? handleOnCancel,
    String subtitle = 'Êtes-vous sûr de vouloir supprimer cette élément ?'}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Supprimer l\'élément sélectionné'),
      content: Text(subtitle),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            handleOnCancel?.call();
          },
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            handleOnDelete();
          },
          child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

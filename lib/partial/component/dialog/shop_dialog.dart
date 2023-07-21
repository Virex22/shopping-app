import 'package:flutter/material.dart';
import 'package:shopping_app/api/shop_api.dart';
import 'package:shopping_app/helper/global_helper.dart';
import 'package:shopping_app/model/shop.dart';

void showShopDeleteDialog(
    {required BuildContext context,
    required Function(String, Shop) handleShopAction,
    required dynamic shop}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Supprimer le magasin'),
      content: const Text('Êtes-vous sûr de vouloir supprimer ce magasin ?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () async {
            ShopAPI shopApi = ShopAPI();
            Navigator.of(context).pop();
            ScaffoldMessengerState snackBar = ScaffoldMessenger.of(context);
            bool response = await shopApi.deleteShop(shop.id);
            showSnackBar(
                snackBar: snackBar,
                message: response
                    ? 'Magasin supprimé'
                    : 'Erreur lors de la suppression du magasin');
            if (response) handleShopAction('delete', shop);
          },
          child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

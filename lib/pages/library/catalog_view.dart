import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labcure/models/catalog.dart';

class CatalogView extends StatelessWidget {
  const CatalogView({super.key, required this.catalog});
  final Catalog catalog;

  @override
  Widget build(BuildContext context) {
    IconThemeData iconTheme = Theme.of(context).iconTheme;
    return Scaffold(
      appBar: AppBar(
        iconTheme: iconTheme.copyWith(size: 20.0),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(CupertinoIcons.chevron_back),
        ),
        title: Text(catalog.label),
      ),
    );
  }
}

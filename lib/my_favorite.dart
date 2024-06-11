import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/main.dart';
import 'package:testapp/rpovider/coundprovider.dart';

class MyFavorite extends StatefulWidget {
  const MyFavorite({super.key});

  @override
  State<MyFavorite> createState() => _MyFavoriteState();
}

class _MyFavoriteState extends State<MyFavorite> {
  @override
  Widget build(BuildContext context) {
    var providers = Provider.of<CountProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Favorite'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: providers.selectItem.length,
                  itemBuilder: (context, index) {
                    return Consumer<CountProvider>(
                        builder: (context, value, child) {
                      return ListTile(
                        title: const Text('Item'),
                        leading: const Icon(Icons.numbers),
                        trailing: Icon(
                          value.selectItem.contains(index)
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: value.selectItem.contains(index)
                              ? Colors.red
                              : Colors.black,
                        ),
                        onTap: () {
                          if (value.selectItem.contains(index)) {
                            value.setRemove(index);
                            context.showSnackBar(
                                message: 'Remove from favorite');
                          } else {
                            value.setCount(index);
                            context.showSnackBar(message: 'Add to favorite');
                          }
                        },
                      );
                    });
                  }),
            ),
          ],
        ));
  }
}

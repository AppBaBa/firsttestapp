import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/databasHelper.dart';
import 'package:testapp/my_favorite.dart';
import 'package:testapp/post.dart';
import 'package:testapp/postResponse.dart';
import 'package:testapp/rpovider/authProvider.dart';

import 'package:testapp/rpovider/coundprovider.dart';
import 'package:testapp/rpovider/databaseModel.dart';
import 'package:testapp/rpovider/provider_text.dart';
import 'package:testapp/rpovider/themeprovider.dart';
import 'package:testapp/sharedpreference.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await PrefrencesTest.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CountProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ProviderText())
        ],
        child: Builder(builder: (context) {
          final themeChange = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            themeMode: themeChange.mode,
            title: 'Speedy Current Affiar',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
                useMaterial3: true,
                brightness: Brightness.light),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
            ),
            home: const MyHomePage(title: 'Speedy Current Affairs'),
          );
        }));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var x = 50.0;
  var y = 50.0;
  Color color = Colors.green;
  BorderRadiusGeometry radiusGeometry = BorderRadius.circular(8.0);
  ValueNotifier<int> notifier = ValueNotifier<int>(0);
  ValueNotifier<bool> toggle = ValueNotifier<bool>(false);
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  late Animation<Color> animation;
  List<Post>? posts = [];
  var isLoaded = false;
  TextEditingController textEditingController = TextEditingController();
  DateTime dateTime = DateTime.now();

  Map<String, bool> chekcbox = {
    'Option 1': false,
    'Option 2': false,
    'Option 3': false
  };

  Future<List<DatabaseModel>>? listDatabase;

  List<Widget> checkboxWidget(BuildContext context) {
    List<Widget> emptyWidget = [];
    chekcbox.forEach((key, value) {
      emptyWidget.add(CheckboxListTile(
          title: Text(key),
          value: value,
          onChanged: (newChanged) {
            setState(() {
              chekcbox[key] = newChanged!;
              PrefrencesTest.setPreferences(chekcbox[key]!);
            });
          }));
    });
    return emptyWidget;
  }

  final channels =
      WebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));

  DatabaseHelper? helper;
  double dx = 0.0;
  double dy = 0.0;

  @override
  void initState() {
    super.initState();
    getPost();
    PrefrencesTest.getPreference();
    helper = DatabaseHelper();
    loadData();
  }

  loadData() {
    listDatabase = DatabaseHelper().getList();
  }

  getPost() async {
    posts = await Postonse().getPost();
    if (posts != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Flutter',
              ),
              Tab(
                text: 'Dart',
              ),
              Tab(
                text: 'Provider',
              )
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MyFavorite();
                  }));
                },
                icon: const Icon(Icons.favorite)),
            PopupMenuButton(
              icon: const Icon(
                Icons.flag,
                color: Colors.red,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: 1,
                    child: Text('Flutter'),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Text('Provider'),
                  ),
                  const PopupMenuItem(
                    value: 3,
                    child: Text('Firebase'),
                  )
                ];
              },
              onSelected: (value) async {
                switch (value) {
                  case 1:
                    {
                      context.showSnackBar(message: 'Message Delayed');
                    }
                    break;
                  case 2:
                    {
                      await showModalBottomSheet(
                          context: context,
                          elevation: 2.0,
                          builder: (context) {
                            return Center(
                              child: ElevatedButton(
                                  onPressed: () {
                                    return showAboutDialog(context: context);
                                  },
                                  child: const Center(
                                    child: Text('Show About Me'),
                                  )),
                            );
                          });
                    }
                    break;
                  case 3:
                    {
                      Navigator.of(context).push(create());
                    }
                }
              },
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: const [
              DrawerHeader(
                  padding: EdgeInsets.only(top: 25.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.yellowAccent,
                    child: Text(
                      'H',
                      style: TextStyle(fontSize: 24.0),
                    ),
                  )),
              Text('Hello Flutter')
            ],
          ),
        ),
        body: TabBarView(children: [
          Visibility(
            visible: isLoaded,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: ListView.builder(
                itemCount: posts?.length,
                itemBuilder: (context, index) {
                  return Consumer<CountProvider>(
                      builder: (context, value, child) {
                    return ExpansionTile(
                      leading: Text(posts![index].id.toString()),
                      title: Text(posts![index].title!),
                      children: [
                        ListTile(
                          title: Text('Item$index'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          leading: CircleAvatar(
                            child: Text('$index'),
                          ),
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
                        ),
                      ],
                    );
                  });
                }),
          ),
          Center(
            child: Column(
              children: [
                RadioListTile(
                    title: const Text('Light Theme'),
                    value: ThemeMode.light,
                    groupValue: themeProvider.mode,
                    onChanged: themeProvider.setTheme),
                RadioListTile(
                    title: const Text('Dark Theme'),
                    value: ThemeMode.dark,
                    groupValue: themeProvider.mode,
                    onChanged: themeProvider.setTheme),
                RadioListTile(
                    title: const Text('System Theme'),
                    value: ThemeMode.system,
                    groupValue: themeProvider.mode,
                    onChanged: themeProvider.setTheme),
                20.ph,
                Expanded(
                  child: Positioned(
                    left: dx,
                    top: dy,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        dx = max(0, details.delta.dx);
                        dy = max(0, details.delta.dy);
                        setState(() {});
                      },
                      onTap: () {},
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.yellow),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: listDatabase,
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                return ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: snapShot.data?.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          helper!.upDateData(DatabaseModel(
                              id: snapShot.data![index].id,
                              name: 'Hello Flutter',
                              email: 'How are yoy'));
                          setState(() {
                            listDatabase = helper?.getList();
                          });
                        },
                        child: Dismissible(
                          key: ValueKey(snapShot.data![index].id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            child: const Icon(Icons.delete),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(snapShot.data![index].id!.toString()),
                            ),
                            title: Text(snapShot.data![index].name!),
                            subtitle: Text(snapShot.data![index].email!),
                          ),
                          onDismissed: (direction) {
                            setState(() {
                              helper?.removeItem(snapShot.data![index].id!);
                              helper?.getList();
                              snapShot.data?.remove(snapShot.data![index]);
                            });
                          },
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            helper
                ?.dbHelper(DatabaseModel(
                    name: 'Flutter', email: 'amitkumar@gmail.com'))
                .then((value) {
              print('Database Added');
              setState(() {
                listDatabase = helper?.getList();
              });
              // ignore: avoid_print
            });
          },
          child: const Icon(Icons.play_arrow),
        ),
      ),
    );
  }

  Widget onHammer(CountProvider provider) {
    return Consumer<CountProvider>(builder: (context, value, child) {
      return const Center(
        child: Text(
          'hell0',
          style: TextStyle(fontSize: 50.0),
        ),
      );
    });
  }

  Route create() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondAnimation) => const Page2(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.1);
        const end = Offset.zero;
        var cureve = Curves.bounceInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: cureve));
        final curvedAnimation =
            CurvedAnimation(parent: animation, curve: cureve);
        var offsetAnimation = tween.animate(curvedAnimation);
        return SlideTransition(
          position: offsetAnimation,
          textDirection: TextDirection.ltr,
          child: child,
        );
      },
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hi Second'),
      ),
      body: const Column(
        children: [
          Center(
            child: Text('Hello Flutter'),
          ),
        ],
      ),
    );
  }
}

extension Padding on num {
  SizedBox get ph => SizedBox(
        height: toDouble(),
      );
  SizedBox get pw => SizedBox(
        width: toDouble(),
      );
}

extension SnackBarExtension on BuildContext {
  void showSnackBar({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }
}

extension EmailValidator on String {
  bool emailValid() {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    bool emalValidator = RegExp(pattern).hasMatch(this);
    return emalValidator;
  }
}

class FloatButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;

  const FloatButton({super.key, this.onPressed, this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.circle,
      color: Colors.red,
      child: SizedBox(
        width: 56.0,
        height: 56.0,
        child: child,
      ),
    );
  }
}

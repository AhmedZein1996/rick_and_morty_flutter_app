import 'package:flutter/material.dart';
import 'package:flutterblockapp/app_router.dart';
import 'package:flutterblockapp/constants/strings.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  await initHiveForFlutter();
  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}

class MyApp extends StatefulWidget {
  final AppRouter appRouter;

  const MyApp({Key? key, required this.appRouter}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ValueNotifier<GraphQLClient>? client;

  @override
  void initState() {
    client = ValueNotifier(graphQLClient);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: widget.appRouter.generateRoute,
      ),
    );
  }
}

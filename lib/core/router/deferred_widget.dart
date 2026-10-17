import 'package:flutter/material.dart';

class DeferredWidget extends StatefulWidget {
  final Future<void> Function() loadLibrary;
  final Widget Function() builder;

  const DeferredWidget({
    super.key,
    required this.loadLibrary,
    required this.builder,
  });

  @override
  State<DeferredWidget> createState() => _DeferredWidgetState();
}

class _DeferredWidgetState extends State<DeferredWidget> {
  late Future<void> _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = widget.loadLibrary();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Failed to load page: ${snapshot.error}'),
              ),
            );
          }
          return widget.builder();
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

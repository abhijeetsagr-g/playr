import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:playr/logic/providers/file_provider.dart';
import 'package:playr/ui/root/root_page.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<FileProvider>(context, listen: false).init();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RootPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SvgPicture.asset(
                "assets/images/splash.svg",
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colors.grey,
                strokeWidth: 4,
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mahavir_finance/splash/splash_provider.dart';
import 'package:provider/provider.dart';

import '../constants/asset_constants.dart';
import '../constants/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashProvider? _provider;
  bool _hasNavigated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_provider != null) return;

    _provider = context.read<SplashProvider>();
    _provider!.addListener(_navigateWhenCompleted);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _provider?.start();
      }
    });
  }

  void _navigateWhenCompleted() {
    final provider = _provider;

    if (!mounted ||
        provider == null ||
        !provider.isCompleted ||
        _hasNavigated) {
      return;
    }

    final route = provider.nextRoute;
    if (route == null) return;

    _hasNavigated = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed(route);
    });
  }

  @override
  void dispose() {
    _provider?.removeListener(_navigateWhenCompleted);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            return Stack(
              fit: StackFit.expand,
              children: [
                const _SplashBackground(),

                SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.09),

                      // Mahavir Finance logo.
                      Image.asset(
                        AssetsConstants.mahavirLogo,
                        width: width * 0.72,
                        height: height * 0.25,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 8),

                      // Financial growth illustration.
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.025,
                          ),
                          child: Image.asset(
                            AssetsConstants.Illustration,
                            width: width,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),




                      // Animated loading progress.
                      Consumer<SplashProvider>(
                        builder: (context, provider, child) {
                          return SizedBox(
                            width: 182,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: LinearProgressIndicator(
                                value: provider.progress,
                                minHeight: 7,
                                backgroundColor:
                                const Color(0xFFDDE7EE),
                                valueColor:
                                const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF079B6A),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // Text styled using AppTextStyles.
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Text(
                            'Building Brighter Financial Futures...',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: width < 360 ? 13 : 15,
                              color: const Color(0xFF0B2545),

                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.09),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SplashBackground extends StatelessWidget {
  const _SplashBackground();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      painter: _SplashCurvePainter(),
      child: SizedBox.expand(),
    );
  }
}

class _SplashCurvePainter extends CustomPainter {
  const _SplashCurvePainter();

  static const Color navy = Color(0xFF0B2545);
  static const Color green = Color(0xFF16A36A);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final navyPaint = Paint()..color = navy;
    final greenPaint = Paint()..color = green;

    final linePaint = Paint()
      ..color = navy.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Top-left green curve.
    final topGreen = Path()
      ..moveTo(0, 0)
      ..lineTo(w * 0.48, 0)
      ..cubicTo(
        w * 0.39,
        h * 0.075,
        w * 0.25,
        h * 0.145,
        0,
        h * 0.205,
      )
      ..close();

    canvas.drawPath(topGreen, greenPaint);

    // Top-left navy curve.
    final topNavy = Path()
      ..moveTo(0, 0)
      ..lineTo(w * 0.46, 0)
      ..cubicTo(
        w * 0.37,
        h * 0.065,
        w * 0.23,
        h * 0.12,
        0,
        h * 0.165,
      )
      ..close();

    canvas.drawPath(topNavy, navyPaint);

    // Fine line at the top.
    final topLine = Path()
      ..moveTo(0, h * 0.225)
      ..cubicTo(
        w * 0.16,
        h * 0.14,
        w * 0.34,
        h * 0.11,
        w * 0.52,
        0,
      );

    canvas.drawPath(topLine, linePaint);

    // Bottom-right green curve.
    final bottomGreen = Path()
      ..moveTo(w, h * 0.745)
      ..lineTo(w, h)
      ..lineTo(w * 0.50, h)
      ..cubicTo(
        w * 0.62,
        h * 0.925,
        w * 0.80,
        h * 0.84,
        w,
        h * 0.745,
      )
      ..close();

    canvas.drawPath(bottomGreen, greenPaint);

    // Bottom-right navy curve.
    final bottomNavy = Path()
      ..moveTo(w, h * 0.78)
      ..lineTo(w, h)
      ..lineTo(w * 0.58, h)
      ..cubicTo(
        w * 0.70,
        h * 0.935,
        w * 0.87,
        h * 0.865,
        w,
        h * 0.78,
      )
      ..close();

    canvas.drawPath(bottomNavy, navyPaint);

    // Fine line at the bottom.
    final bottomLine = Path()
      ..moveTo(w * 0.45, h)
      ..cubicTo(
        w * 0.61,
        h * 0.91,
        w * 0.82,
        h * 0.84,
        w,
        h * 0.75,
      );

    canvas.drawPath(bottomLine, linePaint);
  }

  @override
  bool shouldRepaint(covariant _SplashCurvePainter oldDelegate) {
    return false;
  }
}


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

String globalUserName ="";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Firebase Initialization Error: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto', useMaterial3: true),
      home: const SplashScreen(),
            routes: {
        "/home": (context) => BarcodeHomeScreen(userId: "12345",userName: globalUserName),
        "/signout": (context) => SignOutDialog(),
        "/safe": (context) => ProductSafeScreen(
          productName: "productName",
          companyName: "companyName",
          ingredients: ["ingredient1", "ingredient2", "ingredient3"],
        ),
        "/danger": (context) => ProductWarningScreen(
          productName: "productName",
          companyName: "companyName",
          ingredients: ["ingredient1", "ingredient2", "ingredient3"],
          allergicIngredients: ["ingredient1"],
        ),
      },
    );
  }
}

class AppColors {
  static const Color primaryGreen = Color(0xFF52C47D);
  static const Color lightGreen = Color(0xFF7FD99A);
  static const Color mintGreen = Color(0xFFB8E8C8);
  static const Color darkGreen = Color(0xFF3A9B5F);
  static const Color bgGradientTop = Color(0xFFE8F5E9);
  static const Color bgGradientBottom = Color(0xFF52C47D);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFF9E9E9E);
  static const Color darkGrey = Color(0xFF616161);
  static const Color inputBg = Color(0xFFF5F5F5);
  static const Color red = Colors.red;
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgGradientTop, AppColors.bgGradientBottom],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(color: AppColors.white.withOpacity(0.3), shape: BoxShape.circle),
                    child: const Icon(Icons.eco, size: 60, color: AppColors.darkGreen),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Allergy",
                    style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: AppColors.black),
                  ),
                  const Text(
                    "Guide",
                    style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: AppColors.black),
                  ),
                  const SizedBox(height: 15),
                  const Text("Your personal food safety", style: TextStyle(fontSize: 14, color: AppColors.darkGrey)),
                  const Text("companion", style: TextStyle(fontSize: 14, color: AppColors.darkGrey)),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      backgroundColor: AppColors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.darkGreen),
                      minHeight: 3,
                    ),
                  ),
                  const SizedBox(height: 60),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
                    },
                    child: Container(
                      width: 280,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Get Started",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18, color: AppColors.black),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.search,
      title: "Scan Any Product\nInstantly",
      description: "Just point your camera at any barcode and we'll check it against your allergy profile in seconds.",
    ),
    OnboardingPage(
      icon: Icons.health_and_safety,
      title: "Stay Safe\nAlways",
      description: "Get instant alerts when a product contains ingredients you're allergic to.",
    ),
    OnboardingPage(
      icon: Icons.restaurant_menu,
      title: "Find Safe\nAlternatives",
      description: "Discover safe alternative products that match your dietary needs.",
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgGradientTop, AppColors.bgGradientBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(color: AppColors.white.withOpacity(0.3), shape: BoxShape.circle),
                child: Icon(_pages[_currentPage].icon, size: 60, color: AppColors.darkGreen),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? AppColors.darkGreen : AppColors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(color: AppColors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5)),
                    ],
                  ),
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              _pages[index].title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _pages[index].description,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 15, color: AppColors.grey, height: 1.5),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                if (_currentPage < _pages.length - 1) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                                  );
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.mintGreen,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _currentPage < _pages.length - 1 ? "Next" : "Get Started",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward, size: 18, color: AppColors.black),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            if (_currentPage < _pages.length - 1)
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Text(
                                    "Skip Intro",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 14, color: AppColors.grey),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;

  OnboardingPage({required this.icon, required this.title, required this.description});
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields"), backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        globalUserName = _emailController.text.trim();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BarcodeHomeScreen(userId: "12345",userName: globalUserName)));
      }
    } on FirebaseAuthException catch (e) {
      String message = "Login failed";
      if (e.code == 'user-not-found')
        message = "No user found with this email";
      else if (e.code == 'wrong-password')
        message = "Wrong password";
      else if (e.code == 'invalid-email') message = "Invalid email format";

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (mounted) {
        globalUserName = googleUser.displayName ?? "User";
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BarcodeHomeScreen(userId: "12345",userName: globalUserName)));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Google Sign In Error: $e"), backgroundColor: Colors.red));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgGradientTop, AppColors.bgGradientBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.eco, size: 40, color: AppColors.darkGreen),
              const SizedBox(height: 20),
              const Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.black),
              ),
              const SizedBox(height: 5),
              const Text("Sign in to your account", style: TextStyle(fontSize: 14, color: AppColors.darkGrey)),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(color: AppColors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5)),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "Email Address",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.black),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.inputBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.grey.withOpacity(0.2)),
                          ),
                          child: TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined, color: AppColors.grey, size: 20),
                              hintText: "dana@example.com",
                              hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Password",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.black),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.inputBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.grey.withOpacity(0.2)),
                          ),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.grey, size: 20),
                              hintText: "password",
                              hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: AppColors.grey,
                                  size: 20,
                                ),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()));
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(fontSize: 13, color: AppColors.darkGreen, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        GestureDetector(
                          onTap: _isLoading ? null : _signIn,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: AppColors.mintGreen,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: _isLoading
                                ? const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.black),
                                      ),
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.login, size: 18, color: AppColors.black),
                                      SizedBox(width: 8),
                                      Text(
                                        "Sign In",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            Expanded(child: Divider(color: AppColors.grey.withOpacity(0.3))),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text("Or continue with", style: TextStyle(fontSize: 12, color: AppColors.grey)),
                            ),
                            Expanded(child: Divider(color: AppColors.grey.withOpacity(0.3))),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: _isLoading ? null : _signInWithGoogle,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                                  child: const Center(
                                    child: Text(
                                      "G",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "Google",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen()));
                            },
                            child: RichText(
                              text: const TextSpan(
                                text: "Don't have account? ",
                                style: TextStyle(fontSize: 14, color: AppColors.grey),
                                children: [
                                  TextSpan(
                                    text: "create account",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.darkGreen,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields"), backgroundColor: Colors.red));
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords don't match!"), backgroundColor: Colors.red));
      return;
    }

    if (_passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 8 characters"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await userCredential.user?.updateDisplayName(_nameController.text.trim());

      await FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid).set({
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "allergies": [],
        "createdAt": FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>  BarcodeHomeScreen(userId: "12345",userName: globalUserName)));
      }
    } on FirebaseAuthException catch (e) {
      String message = "Sign up failed";
      if (e.code == 'email-already-in-use')
        message = "Email already in use";
      else if (e.code == 'invalid-email')
        message = "Invalid email format";
      else if (e.code == 'weak-password') message = "Password is too weak";

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgGradientTop, AppColors.bgGradientBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.eco, size: 40, color: AppColors.darkGreen),
              const SizedBox(height: 20),
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.black),
              ),
              const SizedBox(height: 5),
              const Text("Join Allergy Guide today", style: TextStyle(fontSize: 14, color: AppColors.darkGrey)),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(color: AppColors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5)),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Full Name",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.black),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.inputBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.grey.withOpacity(0.2)),
                          ),
                          child: TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person_outline, color: AppColors.grey, size: 20),
                              hintText: "Dana Al-Malki",
                              hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Email Address",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.black),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.inputBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.grey.withOpacity(0.2)),
                          ),
                          child: TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined, color: AppColors.grey, size: 20),
                              hintText: "you@email.com",
                              hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Password",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.black),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.inputBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.grey.withOpacity(0.2)),
                          ),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.grey, size: 20),
                              hintText: "Min 8 characters",
                              hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: AppColors.grey,
                                  size: 20,
                                ),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Confirm Password",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.black),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.inputBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.grey.withOpacity(0.2)),
                          ),
                          child: TextField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.grey, size: 20),
                              hintText: "Repeat password",
                              hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                  color: AppColors.grey,
                                  size: 20,
                                ),
                                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "By signing up you agree to our Terms & Privacy Policy",
                          style: TextStyle(fontSize: 12, color: AppColors.grey),
                        ),
                        const SizedBox(height: 25),
                        GestureDetector(
                          onTap: _isLoading ? null : _signUp,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: AppColors.mintGreen,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: _isLoading
                                ? const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.black),
                                      ),
                                    ),
                                  )
                                 : GestureDetector(
                                    onTap:() {
                                      globalUserName = _nameController.text;
                                      Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>BarcodeHomeScreen(userId: "12345",userName: globalUserName),
                                      ),
                                      );
                                    },
                               child: const Center(
                                    child: Text(
                                      "Create Account",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                          ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter your email"), backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      setState(() => _emailSent = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reset link sent! Check your email.")));
    } on FirebaseAuthException catch (e) {
      String message = "Failed to send reset link";
      if (e.code == 'user-not-found')
        message = "No user found with this email";
      else if (e.code == 'invalid-email') message = "Invalid email format";

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgGradientTop, AppColors.bgGradientBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(color: AppColors.white.withOpacity(0.3), shape: BoxShape.circle),
                child: const Icon(Icons.key, size: 40, color: AppColors.darkGreen),
              ),
              const SizedBox(height: 20),
              const Text(
                "Forgot Password?",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.black),
              ),
              const SizedBox(height: 5),
              const Text(
                "Enter your email and we'll send you a reset link",
                style: TextStyle(fontSize: 14, color: AppColors.darkGrey),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(color: AppColors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5)),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        if (_emailSent) ...[
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.mintGreen.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Column(
                              children: [
                                Icon(Icons.check_circle, color: AppColors.darkGreen, size: 50),
                                SizedBox(height: 15),
                                Text(
                                  "Check your spam folder if you don't see the email within a few minutes.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14, color: AppColors.darkGreen),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          const Text(
                            "Email Address",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.black),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.inputBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.grey.withOpacity(0.2)),
                            ),
                            child: TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined, color: AppColors.grey, size: 20),
                                hintText: "you@email.com",
                                hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 25),
                        GestureDetector(
                          onTap: _isLoading || _emailSent ? null : _sendResetLink,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: AppColors.mintGreen,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: _isLoading
                                ? const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.black),
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(_emailSent ? Icons.check : Icons.send, size: 18, color: AppColors.black),
                                      const SizedBox(width: 8),
                                      Text(
                                        _emailSent ? "Email Sent!" : "Send Reset Link",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_back, size: 16, color: AppColors.darkGreen),
                                SizedBox(width: 5),
                                Text(
                                  "Back to Login",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.darkGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgGradientTop, AppColors.bgGradientBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(color: AppColors.white.withOpacity(0.3), shape: BoxShape.circle),
                child: const Icon(Icons.eco, size: 40, color: AppColors.darkGreen),
              ),
              const SizedBox(height: 30),
              const Text(
                "Welcome to",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.black),
              ),
              const Text(
                "Allergy Guide",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.black),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Welcome to Allergy Guide, designing your perfect menu options and managing preferences more effectively. Learn how we can help you stay safe",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppColors.darkGrey, height: 1.5),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(color: AppColors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5)),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) =>  BarcodeHomeScreen(userId: "12345",userName: globalUserName)),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: Text(
                                "next",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BarcodeHomeScreen extends StatefulWidget {
  final String userId; // رقم المستخدم لجلب حساسيته
 final String userName;

 const BarcodeHomeScreen({super.key,
  required this.userId,
  required this.userName,
  });

 


  @override
  State<BarcodeHomeScreen> createState() => _BarcodeHomeScreenState();
}

class _BarcodeHomeScreenState extends State<BarcodeHomeScreen> {
  bool isProcessing = false;

  // الدالة الأساسية: تصوير + قراءة + فايربيس + مقارنة + توجيه
  Future<void> scanProduct(String barcodeValue) async {
    if (isProcessing) return;
    setState(() => isProcessing = true);

    try {
      // 3) جلب بيانات المنتج من فايربيس
      var productSnapshot = await FirebaseFirestore.instance.collection("products").doc(barcodeValue).get();

      if (!productSnapshot.exists) {
        setState(() => isProcessing = false);
      }

      String productName = productSnapshot["name"];
      String companyName = productSnapshot["company"];
      List<String> ingredients = List<String>.from(productSnapshot["ingredients"]);

      // 4) جلب حساسية المستخدم
      var userSnapshot = await FirebaseFirestore.instance.collection("users").doc(widget.userId).get();

      List<String> userAllergies = List<String>.from(userSnapshot["allergies"]);

      // 5) المقارنة
      List<String> dangerousIngredients = ingredients.where((item) => userAllergies.contains(item)).toList();

      // 6) التوجيه
      if (dangerousIngredients.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ProductSafeScreen(productName: productName, companyName: companyName, ingredients: ingredients),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductWarningScreen(
              productName: productName,
              companyName: companyName,
              ingredients: ingredients,
              allergicIngredients: dangerousIngredients,
            ),
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
    }

    setState(() => isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // الكاميرا
          MobileScanner(
            onDetect: (BarcodeCapture capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                debugPrint('Barcode found! ${barcode.rawValue}');
              }
            },
          ),
          // الشريط السفلي الأخضر
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 85,
              decoration: const BoxDecoration(color: Color(0xFF52C47D)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // زر البروفايل
                  IconButton(
                    icon: const Icon(Icons.person_rounded, size: 32, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen(userName:globalUserName)),
                      );
                    },
                  ),

                  // زر الكاميرا
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MobileScanner(
                            onDetect: (capture) {
                              final List<Barcode> barcodes = capture.barcodes;
                              if (barcodes.isNotEmpty) {
                                final String? code = barcodes.first.rawValue;
                                if (code != null) {
                                  Navigator.pop(context); // إغلاق الكاميرا
                                  scanProduct(code); // استدعاء الدالة
                                }
                              }
                            },
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.camera_alt_rounded, size: 32, color: Colors.black),
                    ),
                  ),

                  // زر الجرس
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, size: 30, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String userName;
  const ProfileScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      drawer: Drawer(),

      body: Column(
        children: [
          // الهيدر الأخضر
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 40, bottom: 30),
            decoration: BoxDecoration(
              color: Color(0xFF52C47D),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: Icon(Icons.menu_rounded, size: 30, color: Colors.black),
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).push(MaterialPageRoute(builder: (context) => MenuScreen(userName: globalUserName )));
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.4)),
                  child: Icon(Icons.person_rounded, size: 60, color: Colors.black54),
                ),

                SizedBox(height: 12),

                Text(
                  userName,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),

          SizedBox(height: 25),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'My Allergies',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ),
          ),

          SizedBox(height: 15),

          Padding(padding: EdgeInsets.symmetric(horizontal: 24), child: Wrap(spacing: 15, runSpacing: 15)),

          SizedBox(height: 40),

          Expanded(child: Container()),

          Container(
            height: 85,
            color: Color(0xFF52C47D),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.notifications_none_rounded, size: 30, color: Colors.black),
                  onPressed: () {},
                ),

                IconButton(
                  icon: Icon(Icons.camera_alt_rounded, size: 32, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                Icon(Icons.person_rounded, size: 32, color: Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  final String userName;

  const MenuScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          // المستطيل الأبيض الخاص بالمنيو
          Container(
            width: MediaQuery.of(context).size.width * 0.65, // يأخذ 65% من عرض الشاشة
            height: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1) الهيدر الأخضر
                Container(
                  padding: const EdgeInsets.only(top: 50, bottom: 25, left: 10, right: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF52C47D),
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(35)),
                  ),
                  child: Column(
                    children: [
                      // سهم الرجوع
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // صورة البروفايل داخل الهيدر
                      Container(
                        width: 75,
                        height: 75,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white24),
                        child: const Icon(Icons.person_rounded, size: 45, color: Colors.black54),
                      ),
                      const SizedBox(height: 10),
                      // اسم المستخدم
                      Text(
                        userName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),

                // 2) قائمة الأزرار (تحت الهيدر الأخضر مباشرة)
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.health_and_safety_outlined, color: Colors.black),
                        title: const Text("Allergy Management", style: TextStyle(fontSize: 16, color: Colors.black)),
                        onTap: () {
                          // هنا تيم الحساسية يربط صفحته
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.manage_accounts_outlined, color: Colors.black),
                        title: const Text("Account Management", style: TextStyle(fontSize: 16, color: Colors.black)),
                        onTap: () {
                          // هنا التيم الثاني يربط صفحته
                        },
                      ),
                      const Divider(), // خط فاصل جمالي
                      ListTile(
                        leading: const Icon(Icons.logout_rounded, color: Colors.red),
                        title: const Text(
                          "Sign Out",
                          style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          showDialog(context: context, builder: (context) => const SignOutDialog());
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // المساحة الشفافة الباقية من الشاشة (إذا ضغط عليها اليوزر يقفل المنيو)
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(color: Colors.white.withValues(alpha: 0.3)), // تظليل خفيف جداً خلف المنيو
            ),
          ),
        ],
      ),
    );
  }
}

class SignOutDialog extends StatelessWidget {
  const SignOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // طبقة شفافة
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(color: Colors.black.withValues(alpha: 0.4)),
        ),

        // مربع تسجيل الخروج الأخضر
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF52C47D), // أخضر
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // العنوان
                Text(
                  "⁠Sign Out?⁠",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),

                SizedBox(height: 10),

                // النص
                Text(
                  "Are you sure you want to sign out?⁠",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),

                SizedBox(height: 20),

                // الأزرار
                Row(
                  children: [
                    // زر تسجيل خروج (أحمر)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => SplashScreen()),
                            (route) =>false
                            );
                          // يودّي لأول صفحة في التطبيق (التيم الثاني)
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(9)),
                          child: const Center(
                            child: Text(
                              "Sign Out",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),

                    // زر Cancel (أبيض)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // يرجع للمنيو
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(9)),
                          child: const Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ProductSafeScreen extends StatelessWidget {
  final String productName; // اسم المنتج من الفايربيس
  final String companyName; // اسم الشركة من الفايربيس
  final List<String> ingredients; // قائمة المكونات

  const ProductSafeScreen({super.key, required this.productName, required this.companyName, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الهيدر الأخضر
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 40, bottom: 15),
            color: Color(0xFF52C47D),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded, size: 22, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context); // يرجع لصفحة الكام
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 15),

          // مستطيل الصورة (بدون لون – بدون أيقونة)
          SizedBox(
            width: double.infinity,
            height: 360,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                color: Colors.grey[300],
                child: Center(child: Icon(Icons.qr_code_scanner, size: 80, color: Colors.grey[700])),
              ),
            ),
          ),

          SizedBox(height: 20),

          // اسم المنتج
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(productName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),

          // اسم الشركة
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(companyName, style: TextStyle(fontSize: 16, color: Colors.black54)),
          ),

          SizedBox(height: 15),

          // خط أسود
          Container(
            width: double.infinity,
            height: 1.5,
            color: Colors.black,
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),

          SizedBox(height: 15),

          // عنوان المكونات
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("INGREDIENTS", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),

          SizedBox(height: 10),

          // قائمة المكونات (كلها آمنة)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ingredients
                  .map(
                    (item) => Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: Text(item, style: TextStyle(fontSize: 16, color: Colors.black)),
                    ),
                  )
                  .toList(),
            ),
          ),

          Spacer(),

          // المستطيل الأخضر (SAFE)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 25),
            color: Color(0xFF52C47D),
            child: Column(
              children: [
                Text(
                  "SAFE",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 5),
                Text("Eat it safely", style: TextStyle(fontSize: 15, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductWarningScreen extends StatelessWidget {
  final String productName;
  final String companyName;
  final List<String> ingredients; // كل المكونات
  final List<String> allergicIngredients; // المكونات اللي المستخدم حساس لها

  const ProductWarningScreen({
    super.key,
    required this.productName,
    required this.companyName,
    required this.ingredients,
    required this.allergicIngredients,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الهيدر الأخضر
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 40, bottom: 15),
            color: Color(0xFF52C47D),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded, size: 22, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 15),

          // صورة المنتج
          SizedBox(
            width: double.infinity,
            height: 360,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                color: Colors.grey[300],
                child: Center(child: Icon(Icons.qr_code_scanner, size: 80, color: Colors.grey[700])),
              ),
            ),
          ),

          SizedBox(height: 20),

          // اسم المنتج
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(productName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),

          // اسم الشركة
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(companyName, style: TextStyle(fontSize: 16, color: Colors.black54)),
          ),

          SizedBox(height: 15),

          // خط
          Container(
            width: double.infinity,
            height: 1.5,
            color: Colors.black,
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),

          SizedBox(height: 15),

          // عنوان المكونات
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("INGREDIENTS", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),

          SizedBox(height: 10),

          // قائمة المكونات (الخطر أحمر)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ingredients
                  .map(
                    (item) => Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 16,
                          color: allergicIngredients.contains(item) ? Colors.red : Colors.black,
                          fontWeight: allergicIngredients.contains(item) ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          Spacer(),

          // المستطيل الأحمر (DANGEROUS)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 25),
            color: Colors.red,
            child: Column(
              children: [
                Text(
                  "DANGEROUS",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                ),

                SizedBox(height: 10),

                Text("This product contains:", style: TextStyle(fontSize: 16, color: Colors.white)),

                SizedBox(height: 5),

                // قائمة المكونات الخطيرة
                Text(
                  allergicIngredients.join(", "),
                  style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 15),

                // زر البدائل الآمنة
                GestureDetector(
                  onTap: () {
                    // التيم الثاني بيربطه
                  },
                  child: Text(
                    "Click here to view safe alternatives",
                    style: TextStyle(fontSize: 15, color: Colors.blueAccent, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_app_development/DataLayer/Providers/APIConnectionProvider/apiConnectionProvider.dart';
import 'package:ts_app_development/DataLayer/Providers/DataProvider/dataProvider.dart';
import 'package:ts_app_development/UserControls/AppLargeButton/appLargeButton.dart';
import '../../DataLayer/Models/ApiResponse/ApiResponse.dart';
import '../../DataLayer/Providers/UserProvider/userProvider.dart';
import '../../DataLayer/Services/AuthenticationService/authenticationService.dart';
import '../../Generic/Functions/functions.dart';
import '../../Generic/appConst.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ApiResponse rolesDataFuture = ApiResponse();
  late bool obscure;
  bool isLoading = false;
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _appKeyController = TextEditingController();

  @override
  void initState() {
    obscure = true;
    isLoading = false;
    super.initState();
  }

  Future<List<ApiResponse>> APICalls() async {
    rolesDataFuture =
        await AuthenticationService.getRolesDetails({'appid': '6289'});
    return [rolesDataFuture];
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var userProvider = Provider.of<UserSessionProvider>(context);
    DataProvider dataProvider = Provider.of<DataProvider>(context);
    APIConnectionProvider apiProvider =
        Provider.of<APIConnectionProvider>(context);
    return Container(
      width: double.infinity,
      height: screenSize.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login_background.jpg'),
          fit: BoxFit.cover,
          opacity: 0.6,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Stack(
            // mainAxisAlignment: MainAxisAlignment.start,
          fit: StackFit.expand,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConst.appMainPaddingSmall),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppConst.appMainPaddingSmall),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TweenAnimationBuilder(
                                tween: Tween<double>(begin: 0.0, end: 1.0),
                                duration: const Duration(milliseconds: 1000),
                                builder: (BuildContext context, double value, Widget? child) {
                                  return AnimatedOpacity(
                                    opacity: 1.0 * value,
                                    duration: const Duration(milliseconds: 1000),
                                    child: const Text(
                                      'Powered By',
                                      style: TextStyle(
                                        fontSize: AppConst.appFontSizeh12,
                                        color: AppConst.appColorWhite,
                                      ),
                                    ),
                                  );
                                },
                                child: null,
                              ),
                              TweenAnimationBuilder(
                                tween: Tween<double>(begin: 0.0, end: 1.0),
                                duration: const Duration(milliseconds: 2000),
                                builder: (BuildContext context, double value, Widget? child) {
                                  return AnimatedOpacity(
                                    opacity: 1.0 * value,
                                    duration: const Duration(milliseconds: 2000),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/tslogo_white.png',
                                        width: 140.0,
                                        height: 60.0,
                                      ),
                                    ),
                                  );
                                },
                                child: null,
                              ),
                              TweenAnimationBuilder(
                                tween: Tween<double>(begin: 0.0, end: 1.0),
                                duration: const Duration(milliseconds: 2500),
                                builder: (BuildContext context, double value, Widget? child) {
                                  return AnimatedOpacity(
                                    opacity: 1.0 * value,
                                    duration: const Duration(milliseconds: 2500),
                                    child: const Padding(
                                      padding: EdgeInsets.only(top: AppConst.appMainPaddingExtraSmall),
                                      child: Center(
                                        child: Text(
                                          'www.technosysint.com',
                                          style: TextStyle(
                                            fontSize: AppConst.appFontSizeh12,
                                            color: AppConst.appColorWhite,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: null,
                              ),
                            ],
                          ),
                        ),
                        TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 2000),
                          builder: (BuildContext context, double value, Widget? child) {
                            return AnimatedOpacity(
                              opacity: 1.0 * value,
                              duration: const Duration(milliseconds: 2000),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: AppConst.appMainPaddingExtraSmall),
                                child: Image.asset(
                                  'assets/images/bx_wo_back.png',
                                  width: (screenSize.width/2)*0.3,
                                  height: (screenSize.height/2)*0.6,
                                ),
                              ),
                            );
                          },
                          child: null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Column(
                children: [
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 1500),
                    builder: (BuildContext context, double value, Widget? child) {
                      return AnimatedOpacity(
                        opacity: 1.0 * value,
                        duration: const Duration(milliseconds: 1500),
                        child: Padding(
                          padding: EdgeInsets.only(top: screenSize.height*0.15),
                          child: const Text(
                            'Login to your Account',
                            style: TextStyle(
                              color: AppConst.appColorWhite,
                              fontSize: AppConst.appFontSizeh8,
                            ),
                          ),
                        ),
                      );
                    },
                    child: null,
                  ),

                  const SizedBox(
                    height: 80.0,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConst.appMainPaddingLarge),
                    child: Column(
                      children: [
                        // Login Id Text Field
                        TweenAnimationBuilder(
                          tween: Tween<double>(begin: 1.0, end: 0.0),
                          duration: const Duration(milliseconds: 500),
                          builder: (BuildContext context, double value, Widget? child) {
                            return Transform.translate(
                              offset: Offset(-screenSize.width*value,0.0),
                              child: AnimatedOpacity(
                                opacity: value == 0.0 ? 1.0 : value,
                                duration: const Duration(milliseconds: 500),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppConst.appMainPaddingLarge),
                                  child: TextFormField(
                                    controller: _loginIdController,
                                    decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppConst.appColorWhite,
                                          width: 2.0,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppConst.appColorTechnoSysBlueLight,
                                          width: 2.0,
                                        ),
                                      ),
                                      // icon: Icon(Icons.person),
                                      hintText: 'Login Id',
                                      hintStyle: TextStyle(
                                        color: AppConst.appColorWhite,
                                        fontSize: AppConst.appFontSizeh10,
                                        fontWeight: AppConst.appTextHintFontWeight,
                                      ),
                                    ),
                                    style: const TextStyle(color: AppConst.appColorWhite),
                                    textInputAction: TextInputAction.next,
                                    onSaved: (String? value) {},
                                    validator: (String? value) {
                                      return (value != null && value.length < 10)
                                          ? 'Please enter Valid Login Id'
                                          : null;
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                          child: null,
                        ),
                        // Password Text Field
                        TweenAnimationBuilder(
                          tween: Tween<double>(begin: 1.0, end: 0.0),
                          duration: const Duration(milliseconds: 600),
                          builder: (BuildContext context, double value, Widget? child) {
                            return Transform.translate(
                              offset: Offset(-screenSize.width*value,0.0),
                              child: AnimatedOpacity(
                                opacity: value == 0.0 ? 1.0 : value,
                                duration: const Duration(milliseconds: 600),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppConst.appMainPaddingLarge),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            obscure = !obscure;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.visibility,
                                          color: obscure
                                              ? AppConst.appColorWhite
                                              : AppConst.appColorTechnoSysBlueLight,
                                        ),
                                      ),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppConst.appColorWhite,
                                          width: 2.0,
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppConst.appColorTechnoSysBlueLight,
                                          width: 2.0,
                                        ),
                                      ),
                                      // icon: Icon(Icons.person),
                                      hintText: 'Password',
                                      hintStyle: const TextStyle(
                                        color: AppConst.appColorWhite,
                                        fontSize: AppConst.appFontSizeh10,
                                        fontWeight: AppConst.appTextHintFontWeight,
                                      ),
                                    ),
                                    style: const TextStyle(color: AppConst.appColorWhite),
                                    textInputAction: TextInputAction.next,
                                    onSaved: (String? value) {},
                                    validator: (String? value) {
                                      return (value != null && value.length < 10)
                                          ? 'Please enter Valid Login Id'
                                          : null;
                                    },
                                    obscureText: obscure,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: null,
                        ),
                        // AppKey Text Field
                        TweenAnimationBuilder(
                          tween: Tween<double>(begin: 1.0, end: 0.0),
                          duration: const Duration(milliseconds: 700),
                          builder: (BuildContext context, double value, Widget? child) {
                            return Transform.translate(
                              offset: Offset(-screenSize.width*value,0.0),
                              child: AnimatedOpacity(
                                opacity: value == 0.0 ? 1.0 : value,
                                duration: const Duration(milliseconds: 700),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppConst.appMainPaddingLarge),
                                  child: TextFormField(
                                    controller: _appKeyController,
                                    decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppConst.appColorWhite,
                                          width: 2.0,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppConst.appColorTechnoSysBlueLight,
                                          width: 2.0,
                                        ),
                                      ),
                                      // icon: Icon(Icons.person),
                                      hintText: 'App Key',
                                      hintStyle: TextStyle(
                                        color: AppConst.appColorWhite,
                                        fontSize: AppConst.appFontSizeh10,
                                        fontWeight: AppConst.appTextHintFontWeight,
                                      ),
                                    ),
                                    style: const TextStyle(color: AppConst.appColorWhite),
                                    textInputAction: TextInputAction.done,
                                    onSaved: (String? value) {},
                                    validator: (String? value) {
                                      return (value != null && value.length < 10)
                                          ? 'Please enter Valid App Key.'
                                          : null;
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                          child: null,
                        ),
                        // Login Button
                        TweenAnimationBuilder(
                          tween: Tween<double>(begin: 1.0, end: 0.0),
                          duration: const Duration(milliseconds: 800),
                          builder: (BuildContext context, double value, Widget? child) {
                            return Transform.translate(
                              offset: Offset(-screenSize.width*value,0.0),
                              child: AnimatedOpacity(
                                opacity: value == 0.0 ? 1.0 : value,
                                duration: const Duration(milliseconds: 800),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: AppConst.appMainPaddingLarge),
                                  child: AppLargeButton(
                                    backgroundColor: AppConst.appColorWhite,
                                    titleWidget: !isLoading
                                        ? const Text(
                                      'Continue',
                                      style: TextStyle(
                                        color: AppConst.appColorTechnoSysBlueLight,
                                        fontSize: AppConst.appFontSizeh9,
                                        fontWeight: AppConst.appTextHintFontWeight,
                                      ),
                                    )
                                        : const Center(
                                      child: CircularProgressIndicator(
                                          color: AppConst.appColorTechnoSysBlueLight),
                                    ),
                                    onPressedFunc: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      try {
                                        if (_loginIdController.value.text.trim().isNotEmpty &&
                                            _passwordController.value.text.trim().isNotEmpty &&
                                            _appKeyController.value.text.trim().isNotEmpty) {
                                          dynamic result = await AuthenticationService()
                                              .authenticateUser(
                                              context,
                                              _loginIdController.value.text.trim(),
                                              _passwordController.value.text.trim(),
                                              _appKeyController.value.text.trim());

                                          if (result.Data != null) {
                                            // bool userResult =
                                            //     await userProvider.checkUserSession();
                                            if (result.Data.length > 0) {
                                              apiProvider.setAppKey();
                                              setState(() {
                                                isLoading = false;
                                              });
                                              if (mounted) {
                                                Navigator.pushReplacementNamed(
                                                    context, '/Auth');
                                              }
                                            } else {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              if (mounted) {
                                                Functions.ShowSnackBar(
                                                    context, 'No User Found.');
                                              }
                                            }
                                          } else {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            if (mounted) {
                                              Functions.ShowSnackBar(context,
                                                  'Something went wrong, please try again.');
                                            }
                                          }
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Functions.ShowSnackBar(
                                              context, 'Please Enter All Fields');
                                        }
                                      } catch (e) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Functions.ShowSnackBar(
                                            context, 'Something went wrong, please try again.');
                                      }
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                          child: null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
      ),
    );
  }
}

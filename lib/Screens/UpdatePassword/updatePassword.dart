import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataLayer/Providers/ThemeProvider/themeProvider.dart';
import '../../Generic/Settings/settingsData.dart';
import '../../Generic/appConst.dart';


class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({Key? key}) : super(key: key);

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  // final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _passwordConfirmController =
  //     TextEditingController();
  // bool obscurePassword = true;
  // bool obscureConfirmPassword = true;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppConst.appMainBodyVerticalPadding, horizontal: AppConst.appMainBodyHorizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < SettingsData.updatePasswordFaqs.length; i++)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Q. ${SettingsData.updatePasswordFaqs[i][0]}',
                    style: TextStyle(
                      color: context.read<ThemeProvider>().selectedPrimaryColor,
                      fontSize:
                      AppConst.appFontSizeh9,
                      fontWeight: AppConst
                          .appTextFontWeightBold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: AppConst.appMainPaddingSmall),
                    child: Text(
                      'A. ${SettingsData.updatePasswordFaqs[i][1]}',
                      style: TextStyle(
                        color: context.read<ThemeProvider>().selectedPrimaryColor,
                        fontSize:
                        AppConst.appFontSizeh9,
                        fontWeight: AppConst
                            .appTextFontWeightLight,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.symmetric(
    //     vertical: AppConst.appMainBodyVerticalPadding,
    //     horizontal: AppConst.appMainPaddingSmall,
    //   ),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       // Password Text Field
    //       Padding(
    //         padding:
    //             const EdgeInsets.only(bottom: AppConst.appMainPaddingLarge),
    //         child: TextFormField(
    //           controller: _passwordController,
    //           decoration: InputDecoration(
    //             suffixIcon: IconButton(
    //               onPressed: () {
    //                 setState(() {
    //                   obscurePassword = !obscurePassword;
    //                 });
    //               },
    //               icon: Icon(
    //                 Icons.visibility,
    //                 color: obscurePassword
    //                     ? context.read<ThemeProvider>().selectedPrimaryColor
    //                     : AppConst.appColorGrey,
    //               ),
    //             ),
    //             enabledBorder: const UnderlineInputBorder(
    //               borderSide: BorderSide(
    //                 color: context.read<ThemeProvider>().selectedPrimaryColor,
    //                 width: 2.0,
    //               ),
    //             ),
    //             focusedBorder: const UnderlineInputBorder(
    //               borderSide: BorderSide(
    //                 color: context.read<ThemeProvider>().selectedPrimaryColor,
    //                 width: 2.0,
    //               ),
    //             ),
    //             // icon: Icon(Icons.person),
    //             hintText: 'Password',
    //             hintStyle: const TextStyle(
    //               fontSize: AppConst.appFontSizeh10,
    //               fontWeight: AppConst.appTextHintFontWeight,
    //             ),
    //           ),
    //           onSaved: (String? value) {},
    //           validator: (String? value) {
    //             return (value != null && value.length < 10)
    //                 ? 'Please enter Valid Login Id'
    //                 : null;
    //           },
    //           obscureText: obscurePassword,
    //         ),
    //       ),
    //
    //       // Confirm Password Text Field
    //       Padding(
    //         padding:
    //             const EdgeInsets.only(bottom: AppConst.appMainPaddingLarge),
    //         child: TextFormField(
    //           controller: _passwordConfirmController,
    //           decoration: InputDecoration(
    //             suffixIcon: IconButton(
    //               onPressed: () {
    //                 setState(() {
    //                   obscureConfirmPassword = !obscureConfirmPassword;
    //                 });
    //               },
    //               icon: Icon(
    //                 Icons.visibility,
    //                 color: obscureConfirmPassword
    //                     ? context.read<ThemeProvider>().selectedPrimaryColor
    //                     : AppConst.appColorGrey,
    //               ),
    //             ),
    //             enabledBorder: const UnderlineInputBorder(
    //               borderSide: BorderSide(
    //                 color: context.read<ThemeProvider>().selectedPrimaryColor,
    //                 width: 2.0,
    //               ),
    //             ),
    //             focusedBorder: const UnderlineInputBorder(
    //               borderSide: BorderSide(
    //                 color: context.read<ThemeProvider>().selectedPrimaryColor,
    //                 width: 2.0,
    //               ),
    //             ),
    //             // icon: Icon(Icons.person),
    //             hintText: 'Confirm Password',
    //             hintStyle: const TextStyle(
    //               fontSize: AppConst.appFontSizeh10,
    //               fontWeight: AppConst.appTextHintFontWeight,
    //             ),
    //           ),
    //           onSaved: (String? value) {},
    //           validator: (String? value) {
    //             return (value != null && value.length < 10)
    //                 ? 'Please enter Valid Login Id'
    //                 : null;
    //           },
    //           obscureText: obscureConfirmPassword,
    //         ),
    //       ),
    //
    //       // Update Password Button
    //       AppLargeButton(
    //         titleWidget: const Text(
    //           'Update Password',
    //           style: TextStyle(
    //             fontSize: AppConst.appFontSizeh9,
    //             fontWeight: AppConst.appTextHintFontWeight,
    //           ),
    //         ),
    //         onPressedFunc: () async {
    //           try {
    //             bool isUpdatingDone = false;
    //             bool isErrorGot = false;
    //             bool isSessionExpired = false;
    //             if (_passwordController.value.text.trim().isNotEmpty &&
    //                 _passwordConfirmController.value.text.trim().isNotEmpty && (_passwordController.value.text.trim() ==
    //                 _passwordConfirmController.value.text.trim())) {
    //               dynamic result = await AuthenticationService()
    //                   .changePassword({'password' : _passwordConfirmController.value.text.trim()});
    //               if (result.Data != null) {
    //                 if(mounted) {
    //                   Navigator.pushReplacementNamed(context, '/Dashboard');
    //                   Functions.ShowPopUpDialog(
    //                     context,
    //                     'Password Changed Successfully',
    //                     SizedBox(
    //                       height: 60,
    //                       width: 150,
    //                       child: Column(
    //                         children: const [
    //                           SizedBox(
    //                             width: 60,
    //                             height: 60,
    //                             child: Icon(
    //                               size:
    //                               AppConst.appFontSizeh5,
    //                               Icons.done_outline_sharp,
    //                               color: AppConst
    //                                   .appColorPrimary,
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                         () {},
    //                     false,
    //                     isCloseBtn: true,
    //                     isHeader: true,
    //                   );
    //                 }
    //               } else if (result.ApiError['StatusCode']==401) {
    //                 if (mounted) {
    //                   Functions.ShowPopUpDialog(
    //                       context,
    //                       'Session Expired',
    //                       SizedBox(
    //                         height: 60,
    //                         width: 150,
    //                         child: Column(
    //                           children: [
    //                             ElevatedButton(
    //                               onPressed: () {},
    //                               style: ElevatedButton
    //                                   .styleFrom(
    //                                 // Foreground color
    //                                 onPrimary: AppConst
    //                                     .appColorAccent,
    //                                 // Background color
    //                                 primary: AppConst
    //                                     .appColorPrimary,
    //                                 fixedSize:
    //                                 const Size(80, 60),
    //                                 shape: RoundedRectangleBorder(
    //                                     borderRadius: BorderRadius
    //                                         .circular(AppConst
    //                                         .appButtonsBorderRadiusMed)),
    //                               ).copyWith(
    //                                   elevation:
    //                                   ButtonStyleButton
    //                                       .allOrNull(
    //                                       0.0)),
    //                               child: const Text(
    //                                 'Login',
    //                                 style: TextStyle(
    //                                     fontSize: AppConst
    //                                         .appFontSizeh10,
    //                                     fontWeight: AppConst
    //                                         .appTextFontWeightMedium),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                           () {},
    //                       false,
    //                       isCloseBtn: false,
    //                       isHeader: true);
    //                 }
    //               } else if (result.ApiError['StatusCode']!=200 && result.ApiError['StatusCode']!=401) {
    //                 if (mounted) {
    //                   Functions.ShowPopUpDialog(
    //                     context,
    //                     'Something went wrong',
    //                     SizedBox(
    //                       height: 60,
    //                       width: 150,
    //                       child: Column(
    //                         children: const [
    //                           SizedBox(
    //                             width: 60,
    //                             height: 60,
    //                             child: Icon(
    //                               size:
    //                               AppConst.appFontSizeh5,
    //                               Icons.error_outline_rounded,
    //                               color: AppConst
    //                                   .appColorPrimary,
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                         () {},
    //                     false,
    //                     isCloseBtn: false,
    //                     isHeader: true,
    //                   );
    //                 }
    //               } else {
    //                 if (mounted) {
    //                   Functions.ShowPopUpDialog(
    //                       context,
    //                       'Awaiting Result',
    //                       SizedBox(
    //                         height: 60,
    //                         width: 150,
    //                         child: Column(
    //                           children: const [
    //                             SizedBox(
    //                               width: 60,
    //                               height: 60,
    //                               child:
    //                               CircularProgressIndicator(color: context.read<ThemeProvider>().selectedPrimaryColor,),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                           () {},
    //                       false,
    //                       isCloseBtn: false,
    //                       isHeader: false);
    //                 }
    //               }
    //             }
    //           } catch (e) {
    //             Functions.ShowSnackBar(
    //                 context, 'Something went wrong, please try again.');
    //           }
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }
}

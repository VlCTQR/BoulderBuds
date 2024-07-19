RegExp emailRexExp = RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$');

//At least 8 characters, 1 uppercase, 1 lowercase, 1 number, 1 special character
RegExp passwordRexExp = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$');

RegExp specialCharRexExp =
    RegExp(r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])');

RegExp nameRegExp = RegExp(r'^[a-zA-Z\s]+$');

RegExp boulderingGradeRegExp = RegExp(r'^[1-9][abc]?$');

RegExp ageRegExp = RegExp(r'^[1-9][0-9]?$');

RegExp ageSearchRegExp = RegExp(r'^(\d{1,2})\s*-\s*(\d{1,2})$');

RegExp facebookUsernameRegExp =
    RegExp(r'^[a-zA-Z0-9](?:[a-zA-Z0-9.]{3,}[a-zA-Z0-9])?$');

RegExp instagramUsernameRegExp = RegExp(r'^[a-zA-Z0-9._]+$');

RegExp twitterUsernameRegExp = RegExp(r'^[a-zA-Z0-9_]{1,15}$');

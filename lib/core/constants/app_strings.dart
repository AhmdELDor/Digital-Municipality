class AppStrings {
  const AppStrings();

  static const String appName = "EduLift";
}

class AppCommonStrings extends AppStrings {
  static const String btnNext = "Next";
  static const String btnPrevious = "Previous";
  static const String btnBack = "Back";
  static const String btnDone = "Done";
  static const String btnSave = "Save";
  static const String btnUpdate = "Update";
  static const String btnVerify = "Verify";
  static const String btnGetStarted = "Get Started";
  static const String btnSignIn = "Sign In";
  static const String btnSignUp = "Sign Up";
  static const String btnNo = "No";
  static const String btnApply = "Apply";
  static const String btnCancel = "Cancel";
  static const String btnRemove = "remove";
  static const String yesSignOut = "Yes Sign Out";
  static const String areYouSureYouWantSignOut =
      "Are you sure you want to sign out?";
  static const String btnAdd = "Add";
  static const String btnSkip = "Skip";
  static const String btnContinue = "Continue";
  static const String btnSendCode = "Send Code";
  static const String btnBackToLogIn = "Back to Sign in";

  static const String searchHint = "Search Food, Drink, Restaurant, etc.";
  static const String viewAll = "View All";
  static const email = "Email";
  static const password = "Password";
}

class PermissionStrings extends AppStrings {
  static const String goToSettings = "Go to settings";
  static const String permissionNotGranted = "Permission not granted!";
  static const String permissionNotGrantedDesc = "Permission not granted for";
  static const String permissionToEnable = "to enable";
  static const String permissionContact = "contact";
  static const String descContactPermission = "grant access to your contacts";
  static const String permissionCamera = "camera";
  static const String descCameraPermission = "grant camera access";
  static const String permissionPhotos = "photos";
  static const String descPhotosPermission = "grant photos access";
  static const String permissionLocation = "location";
  static const String descLocationPermission = "grant location permission";
  static const String permissionLocationAlways = "always location";
  static const String descAlwaysLocationPermission =
      "grant always location permission";
  static const String permissionStorage = "storage";
  static const String descStoragePermission = "grant storage access";
  static const String descLocationGet =
      "please keep sun sirius open or in the background always to ensure accurate and updated location logs.";
  static const String titleLocationGet = "update location log and trust level";
  static const String locationLogsAndTrustSystem =
      "location logs and trust system";
  static const String locationPermissionDescription =
      "please set your location sharing to “always”. this will ensure your  location logs and trust level are accurately updated. we will only fetch your location once every hour.";
  static const String locationPermission = "location";
  static const String allow = "allow";
}

class SignInStrings extends AppStrings {
  static const simplifyYourManagement =
      "Simplify your\nmanagement with\nadmin portal";
  static const simplifyYourManagementDes =
      "Hello! You're now in the Admin Portal. Take control and keep\neverything running smoothly.";
  static const signInToYourAccount = "Sign in to Your Account";
  static const signInToYourAccountDes =
      "Enter your credentials to Sign in successfully";
  static const enterEmailId = "enter email id";
  static const enterPassword = "enter password";
  static const rememberMe = "Remember me";
  static const forGotPassword = "Forgot password?";
  static const or = "or";
  static const loginWithGoogle = "Sign in with Google";
  static const loginWithApple = "Sign in with Apple";
  static const doNotHaveAnAccount = "Didn’t have account yet?";
}

class ForgotPasswordStrings extends AppStrings {
  static const forgotPasswordTitle = "Forgot Password";
  static const forgotPasswordDes = "Enter your email to reset your credentials";
  static const sendCode = "Send Code";
}

class OtpVerificationStrings extends AppStrings {
  static const otpVerifyTitle = "Verify Email";
  static const otpVerifyDes =
      "verify your email to continue to the admin portal ";
  static const didNotReceiveCode = "Didn’t receive code?";
  static const resend = "Resend";
  static const String sendCodeReloadIn = "Send code reload in";
  static const String verifyEmail = "Verify Email";
  static const String otpSendSuccessfully = "Otp Send Successfully.. ";
}

class ResetPasswordStrings extends AppStrings {
  static const resetYourPassword = "Reset Password";
  static const resetYourPasswordDes =
      "Create a strong new password to continue to the portal";
  static const newPassword = "New Password";
  static const confirmPassword = "Confirm Password";
  static const resetPassword = "Reset Password";
  static const enterNewPassword = "Enter New password";
  static const confirmNewPassword = "Confirm New Password";
}

class ResetPasswordSuccessfullyStrings extends AppStrings {
  static const passwordResetSuccessfully = "Password Reset Successfully!";
  static const passwordResetSuccessfullyDes =
      "All set! your password has been reset successfully! Sign in \nto continue to the portal";
}


class DashboardViewStrings extends AppStrings {
  static const dashboard = "Dashboard";
  static const approvals = "Approvals";
  static const courseManagement = "Course Management";
  static const classManagement = "Class Management";
  static const instructorManagement = "Instructor Management";
  static const universityManagement = "University Management";
  static const category = "Category";
  static const quiz = "Quiz";
  static const test = "Test";
  static const studentManagement = "Student Management";
  static const financeManagement = "Finance Management";
  static const reportsAndAnalytics = "Reports & Analytics";
  static const certificateManagement = "Certificate Management";
  static const userManagement = "User Management";
  static const setting = "Setting";
  static const searchAnything = "Search anything...";
  static const newCourse = "New Course";
  static const darkMode = "Dark Mode";
  static const lightMode = "Light Mode";
  static const revenueChart = "Revenue Chart";
  static const requestForApprovals = "Request for Approvals";
  static const myNotes = "My Notes";
  static const topInstructor = "Top Instructor";
  static const topCourses = "Top Courses";
  static const viewCourse = "View Course";
  static const topCategories = "Top Categories";
  static const userSummary = "User Summary";
  static const totalStudents = "Total Students";
  static const totalInstructors = "Total Instructors";
  static const totalCourses = "Total Courses";
  static const monthlyRevenue = "Monthly Revenue";
  static const newUsers = "New Users";
  static const activeUsers = "Active Users";
  static const inactiveUsers = "Inactive Users";
  static const quizLeaderBoard = "Quiz Leader Board";



}

class AddNoteStrings extends AppStrings {
  static const addNote = "Add Note";
  static const title = "Title";
  static const enterTitle = "enter title";
  static const note = "Note";
  static const enterNote = "enter note...";
  static const saveNote = "Save Note";


}

class ChangesPasswordStrings extends AppStrings {
  static const changePassword = "Change Password";
  static const currentPassword = "Current Password";
  static const enterPassword = "enter password";
  static const newPassword = "New Password";
  static const enterNewPassword = "enter new password";
  static const confirmPassword = "Confirm Password";



}
class LogOutStrings extends AppStrings {
  static const confirmLogout = "Confirm Sign out";
  static const confirmLogoutDes = "You are exiting the secure Super Admin area. Proceed with sign out?";
  static const stayHere = "Stay Here";

}
class NotificationStrings extends AppStrings {
  static const String notification = "Notification";
  static const String notificationDes = "You’ve 5 unread notification";
  static const String markASAllRead = "Mark all as Read";
  static const String all = "All";
  static const String newText = "New";
  static const String unread = "Unread";

}
class NotesListStrings extends AppStrings {
  static const String notes = "Notes";
  static const String useful = "Useful";
  static const String notUseful = "Not Useful";
  static const String delete = "Delete";


}

class ApprovalsStrings extends AppStrings {
  static const String notes = "Approvals";
  static const String coursesApproval = "Courses Approval";
  static const String instructorsApproval = "Instructors Approval";
  static const String universityApproval = "University Approval";
  static const String videoClass = "Video Class";
  static const String contactDetails = "Contact Details";
  static const String verificationDetails = "Verification Details";
  static const String viewProfile = "View Profile";
  static const String approve = "Approve";
  static const String decline = "Decline";
  static const String delete = "Delete";
  static const String requestDate = "Request Date";
  static const String clearAll = "Clear all";
  static const String filter = "Filter";
  static const String clear = "Clear";
}
class CourseApprovalsDetailStrings extends AppStrings {
  static const String courseApprovals = "Course Approvals";
  static const String aboutCourse = "About Course";
  static const String curriculum = "Curriculum";
  static const String courseType = "Course Type";
  static const String language = "Language";
  static const String assessmentTest = "Assessment Test";
  static const String instructor = "Instructor";
  static const String descriptionOfCourse = "Description of Course";
  static const String learningOutcomes = "Learning Outcomes";
  static const String requirements = "Requirements";
  static const String features = "Features";


}
class CourseApproveDialogStrings extends AppStrings {
  static const String courseApproved = "Course Approved!";
  static const String courseApprovedDes = "All Checks completed! Course has been reviewed & live on the app for students";
  static const String goToCourse = "Go to Course";
  static const String courseDeclined= "Course Declined!";
  static const String courseDeclinedDes= "Course has been declined & Instructor will be notified shortly about the course status";
  static const String continueAndDecline= "Continue & Decline";
  static const String feedbackToInstructor= "Feedback to Instructor";
  static const String feedback= "Feedback";
  static const String feedbackDes= "enter feedback to instructor...";
}

class InstructorDetailViewStrings extends AppStrings {
  static const String instructorApprovals = "Instructor Approvals";


}


class ConnectionStrings extends AppStrings {
  static const String noConnection = "Oops! You’re offline now!";
  static const String noInternetFound =
      "Reconnect to continue your learning journey or view your downloads.";
  static const String goToDownloads = "Go to Downloads";
}

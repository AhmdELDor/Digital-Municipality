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
  static const enterEmailId = "Enter email id";
  static const enterPassword = "Enter password";
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
  static const lectureDetail = "Lecture Details";



}

class AddNoteStrings extends AppStrings {
  static const addNote = "Add Note";
  static const title = "Title";
  static const enterTitle = "Enter title";
  static const note = "Note";
  static const enterNote = "Enter note...";
  static const saveNote = "Save Note";


}

class ChangesPasswordStrings extends AppStrings {
  static const changePassword = "Change Password";
  static const currentPassword = "Current Password";
  static const enterPassword = "Enter password";
  static const newPassword = "New Password";
  static const enterNewPassword = "Enter new password";
  static const confirmPassword = "Confirm Password";



}
class LogOutStrings extends AppStrings {
  static const confirmLogout = "Confirm Signout";
  static const confirmLogoutDes = "You are exiting the secure Super Admin area. Proceed with signout?";
  static const stayHere = "Stay Here";
  static const signOut = "Sign Out";

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
  static const String sessionDetails = "Session Details";
  static const String attendees = "Attendees";
  static const String reviews = "Reviews";
  static const String quizLeaderBoardPosition = "Quiz Leader Board Position";


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
  static const String feedbackDes= "Enter feedback to instructor...";
  static const String deleteCourse = "Delete Course";
  static const String deleteCourseDes = "Are you sure you want to delete this course? This action can not be undone.";
  static const String deleteInstructor = "Delete Instructor";
  static const String deleteInstructorDes = "Are you sure you want to delete this instructor? This action can not be undone.";
  static const String deleteUniversity = "Delete University";
  static const String deleteUniversityDes = "Are you sure you want to delete this university? This action can not be undone.";

}

class InstructorDetailViewStrings extends AppStrings {
  static const String instructorProfile = "Instructor Profile";
  static const String instructorApprovals = "Instructor Approvals";
  static const String emailId = "Email ID";
  static const String mobileNo = "Mobile No.";
  static const String about = "About";
  static const String specialization = "Specialization";
  static const String instagramAccount = "Instagram Account";
  static const String facebookAccount = "Facebook Account";
  static const String youTubeChannel = "YouTube Channel";
  static const String identityProof = "Identity Proof";
  static const String qualificationProof = "Qualification Proof";


}

class InstructorDialogStrings extends AppStrings{
  static const String instructorApproved = "Instructor Approved!";
  static const String instructorApprovedDes = "All Checks completed! Instructor profile approved and ready to\n start creating courses.";
  static const String instructorDeclined = "Instructor Declined!";
  static const String instructorDeclinedDes = "Instructor has been declined & Instructor will be notified shortly about the status";
  static const String goToInstructor = "Go to Instructor";

}

class UniversityDialogStrings extends AppStrings{
  static const String universityApprovals = "University Approvals";
  static const String universityApproved = "University Approved!";
  static const String universityApprovedDes = "All Checks completed! University profile approved and ready to start creating courses.";
  static const String instructorDeclined = "Go to University";
  static const String courseCompletionCertificate = "Course Completion Certificate";
  static const String universityDeclined = "University Declined!";
  static const String universityDeclinedDes = "University has been declined & University will be notified shortly about the status";
  static const String goToUniversity = "Go to University";
  static const String feedBackToUniversity = "Feedback to University";
  static const String feedBackToUniversityHint = "Enter feedback to university...";


}

class CourseManagementStrings extends AppStrings{
  static const String edit = "Edit";
  static const String view = "View";

}

class AddCoursesStrings extends AppStrings{
  static const String addCourses = "Add Courses";
  static const String basicInformation = "Basic Information";
  static const String extraInformation = "Extra Information";
  static const String curriculum = "Curriculum";
  static const String name = "Name";
  static const String enterCourseName = "Enter course name";
  static const String category = "Category";
  static const String select = "Select";
  static const String price = "Price";
  static const String enterAmount = "Enter amount";
  static const String imageVideo = "Image / Video";
  static const String chooseFile = "Choose file";
  static const String courseType = "Course Type";
  static const String language = "Language";
  static const String sessions = "Sessions";
  static const String lectures = "Lectures";
  static const String instructor = "Instructor";
  static const String selectInstructor = "Select instructor";
  static const String assessmentTest = "Assessment Test";
  static const String description = "Description";
  static const String enterDescription = "Enter course description...";
  static const String previous = "Previous";
  static const String saveAndNext = "Save & Next";
  static const String learningOutcomeOne = "Learning Outcome 1";
  static const String learningOutcomeOneHint = "Enter learning outcome";
  static const String learningOutcomeTwo = "Learning Outcome 2";
  static const String learningOutcomeThree = "Learning Outcome 3";
  static const String learningOutcomeFour = "Learning Outcome 4";
  static const String image = "Image 1";
  static const String imageTwo = "Image 2";
  static const String featureOne = "Feature 1";
  static const String featureTwo = "Feature 2";
  static const String enterRequirements = "Enter Requirements";
  static const String enterRequirementsHint = "Enter requirements...";
  static const String sessionNo = "Session no.";
  static const String enterSessionNo = "Enter session no.";
  static const String sessionTitle = "Session Title";
  static const String enterSessionTitle = "Enter session title";
  static const String session = "Session";
  static const String srNo = "Sr. no.";
  static const String titleOfLecture = "Title of Lecture";
  static const String durationOfVideo = "Duration of Video";
  static const String enterDuration = "Enter duration";
  static const String enterFeatureDescription = "Enter feature description";
  static const String addCourse = "Add Course";

}

class ClassManagementStrings extends AppStrings{
  static const String upcomingClass = "Upcoming Class";

}
class TodayClassManagementStrings extends AppStrings{
  static const String time = "Time";
  static const String date = "Date";
  static const String remindInstructor = "Remind Instructor";

}
class AddClassStrings extends AppStrings{
  static const String addClass = "Add Class";
  static const String name = "Name";
  static const String course = "Course";
  static const String select = "Select";
  static const String date = "Date";
  static const String selectDate = "Select date";
  static const String time = "Time";
  static const String enterTime = "Enter time";
  static const String imageVideo = "Image / Video";
  static const String instructor = "Instructor";
  static const String selectInstructor = "Select instructor";
  static const String description = "Description";
  static const String enterDescription = "Enter description";
  static const String scheduleClass = "Schedule Class";



}

class InstructorManagementStrings extends AppStrings{
  static const String courseDetails = "Course Details";
  static const String deactive = "Deactive";
  static const String suspend = "Suspend";
  static const String addInstructor = "Add Instructor";
}
class AddInstructorStrings extends AppStrings{
  static const String addInstructor = "Add Instructor";
  static const String enterName = "Enter name";
  static const String enterEmail = "Enter email id";
  static const String sendInvite = "Send Invite";
}

class InviteSendStrings extends AppStrings{
  static const String inviteSent = "Invitation Sent";
  static const String inviteSentDes = "Instructor will be notified shortly to complete their onboarding process & join the platform.";
  static const String backToDashboard = "Back to Dashboard";

}
class DeActiveStrings extends AppStrings{
  static const String instructorAccountDeactivation = "Instructor Account Deactivation";
  static const String instructorAccountDeactivationDes = "Once deactivated, the instructor will no longer be able to manage courses or access their dashboard";
  static const String deactivate = "Deactivate";

}

class SuspendStrings extends AppStrings{
  static const String instructorAccountSuspension = "Instructor Account Suspension";
  static const String instructorAccountSuspensionDes = "Suspending this account will disable the instructor’s access without deleting their data";
  static const String suspend = "Suspend";

}

class InstructorManagementDetailStrings extends AppStrings{
  static const String contactInformation = "Contact Information";
  static const String name = "Name";
  static const String email = "Email";
  static const String mobileNo= "Mobile no.";
  static const String verificationDocuments= "Verification Documents";
  static const String otherInformation= "Other Information";
  static const String statistics= "Statistics";
  static const String specialization= "Specialization";
  static const String about= "About";
  static const String courses= "Courses";


}


class UniversityViewStrings extends AppStrings{
  static const String universityManagement = "University Management";
  static const String viewUniversity = "View University";
  static const String addUniversity = "Add University";

}

class UniversityInviteSentStrings extends AppStrings{
  static const String invitationSent = "Invitation Sent";
  static const String invitationSentDes = "University will be notified shortly to complete their onboarding process & join the platform.";

}

class UniversityDeActiveStrings extends AppStrings{
  static const String universityAccountDeactivation = "University Deactivation";
  static const String universityAccountDeactivationDes = "Deactivating this university will block access to all its courses, instructors, and students. Do you want to proceed?";
  static const String deactivate = "Deactivate";

}

class UniversitySuspensionStrings extends AppStrings{
  static const String universitySuspension = "University Suspension";
  static const String universitySuspensionDes = "Are you sure you want to suspend this university? All associated courses will be temporarily disabled until reactivation";


}

class CourseCategoryStrings extends AppStrings{
  static const String addCategory = "Add Category";
  static const String image = "Image";
  static const String select = "Select";
  static const String chooseFile = "Choose file";
  static const String add = "Add";
  static const String deleteCategory = "Delete Category";
  static const String deleteCategoryDes = "Are you sure you want to delete this category? This action can not be undone.";
  static const String viewCategory = "View Category";
}


class ViewCourseCategoryStrings extends AppStrings{
  static const String viewCategory = "View Category";
  static const String addCourse = "Add Course";
  static const String viewCourse = "View Courses";


}

class QuizStrings extends AppStrings{
  static const String quiz = "Quiz";
  static const String totalQuestions = "Total Questions";
  static const String totalAttendees = "Total Attendees";
  static const String answerChangeable = "Answer Changeable";
  static const String quizStatus = "Quiz Status";
  static const String viewLeaderBoard = "View Leaderboard";
  static const String question = "Question";
  static const String deleteQuiz = "Delete Quiz";
  static const String createQuiz = "Create Quiz";
  static const String deleteQuizDes = "Are you sure you want to delete this quiz? This action can not be undone.";
}

class AddQuizStrings extends AppStrings{
  static const String addQuiz = "Add Quiz";
  static const String enterQuizName = "Enter quiz name";
  static const String course = "Course";

  static const String yes = "Yes";
  static const String no = "No";
  static const String question1 = "Question 1";
  static const String multipleChoiceQuestions = "Multiple Choice Question";
  static const String aAndBAnswer = "A/B Answer";
  static const String enterQuestions = "Enter question";
  static const String option = "Option";
  static const String optionOne = "Option 1";
  static const String enterOptionOne = "Enter option 1";

  static const String optionTwo = "Option 2";
  static const String enterOptionTwo = "Enter option 2";

  static const String optionThree = "Option 3";
  static const String enterOptionThree = "Enter option 3";

  static const String optionFour = "Option 4";
  static const String enterOptionFour = "Enter option 4";

  static const String imageA = "Image A";
  static const String imageB = "Image B";




}

class ViewQuizStrings extends AppStrings{
  static const String viewQuiz = "View Quiz";

}
class TestStrings extends AppStrings{
  static const String test = "Test";
  static const String viewQuiz = "View Quiz";
  static const String addTest = "Add Test";
  static const String viewTest = "View Test";
  static const String testStatus = "Test Status";
  static const String createTest = "Create Test";
}
class LeaderBoardStrings extends AppStrings{
  static const String leaderboard = "Leaderboard";
  static const String totalCoins = "Total Coins";
  static const String dateUpdated = "Date Updated";

}


class StudentManagementStrings extends AppStrings{
  static const String studentManagement = "Student Management";
  static const String totalCourseEnrolled = "Total Course Enrolled";
  static const String totalCoinsEarned = "Total Coins Earned";
  static const String leaderBoardPosition = "Leader Board Position";
  static const String status = "Status";
  static const String deleteStudent = "Delete Student";
  static const String deleteStudentDes = "Are you sure you want to delete this student? This action can not be undone.";
}
class StudentManagementDetailStrings extends AppStrings{
  static const String pointsAndLLeaderBoard = "Points & Leader Board";
  static const String studentProfile = "Student Profile";
  static const String leaderBoardPosition = "Leader Board Position";
  static const String totalEarnedCoins = "Total Earned Coins";
  static const String statistics = "Statistics";
  static const String totalCourses = "Total Courses";
  static const String completedCourses = "Completed Courses";
  static const String ongoingCourses = "Ongoing Courses";
  static const String paymentDate = "Payment Date";
  static const String coinsUsed = "Coins Used";
  static const String paymentMethod = "Payment Method";
  static const String status = "Status";

}
class FinanceManagementStrings extends AppStrings{
  static const String financeManagement = "Finance Management";
  static const String totalEarning = "Total Earning";
  static const String coursesSelling = "Courses Selling";
  static const String courseEarning = "Course Earning";
  static const String instructorPayOut = "Instructor Pay-Out";
  static const String paymentMethods = "Payment Methods";
  static const String paymentReceived = "Payment Received";
  static const String addPaymentMethod = "Add Payment Method";
  static const String totalNoOfPayments = "Total no of Payments";
  static const String paymentID = "Payment ID";
  static const String addReceivedPayment = "Add Received Payment";
  static const String addInstructorPayOut = "Add Instructor Pay-Out";
  static const String setPayOut = "Set Pay-Out";
  static const String addPayment = "Add Payment";
  static const String course = "Course";
  static const String select = "Select";
  static const String amount = "Amount";
  static const String enterAmount = "Enter amount";
  static const String paymentMethod = "Payment Method";
  static const String paymentDate = "Payment Date";
  static const String usedCoins = "Used Coins";
  static const String ifApplicable = "(if applicable)";
  static const String enterUsedCoins = "Enter used coins";
  static const String paymentId = "Payment ID";
  static const String enterPaymentId = "Enter payment id";
  static const String status = "Status";
  static const String instructor = "Instructor";
  static const String occurrence = "Occurrence";
  static const String noOfPayment = "No. of Payment";
  static const String enterNoOfPayment = "Enter no of payment";
  static const String paymentAmount = "Payment Amount";
  static const String enterPaymentAmount = "Enter payment amount";
  static const String paymentStatus = "Payment Status";
  static const String addInstructorPayout = "Add Instructor Payout";
  static const String setPayOutText = "Set Pay Out";
  static const String everyMonths = "Every Month’s";
  static const String totalRevenue = "% of Total Revenue detucted";
  static const String enterPercent = "Enter %";
  static const String addPayOut = "Add Pay Out";



}


class ReportsAnalysis extends AppStrings{
  static const String reportAnalytics = "Report & Analytics";
  static const String totalStudents = "Total Students";
  static const String comparingLastMonth = "Comparing with last month";
  static const String totalRevenue = "Total Revenue";
  static const String courseCompletionRate = "Course Completion Rate";
  static const String activeInstructor = "Active Instructor";
  static const String newUsersToday = "New Users (Today)";
  static const String activeCourses = "Active Courses";
  static const String last6MonthAverage = "Last 6 Month Average";
  static const String last3YearAverage = "Last 3 Year Average";
  static const String topCourseCompletionRated = "Top Course Completion Rated";
  static const String course = "Course";
  static const String avgTimeToComplete = "Avg. Time to Complete";
  static const String completionRate = "Completion Rate";
  static const String comparingToLastMonth = "Comparing to Last Month";
  static const String assignedCourses = "Assigned Courses";
  static const String courseCompletionRates = "Course Completion Rates";
  static const String avgStudentRating = "Avg. Student Rating";
  static const String totalCourses = "Total Courses";
  static const String instructorPerformanceReport = "Instructor Performance Report";


}

class CertificateManagementStrings extends AppStrings{
  static const String certificateManagement = "Certificate Management";
  static const String addCertificate = "Add Certificate";
  static const String logo = "Logo";
  static const String select = "Select";
  static const String chooseFile = "Choose file";
  static const String background = "Background";
  static const String studentName = "Student Name";
  static const String enterStudentName = "Enter student name";
  static const String course = "Course";
  static const String customText = "Custom Text";
  static const String enterCustomText = "Enter custom text";
  static const String completionDate = "Completion Date";
  static const String signature = "Signature";

}

class UserManagementStrings extends AppStrings{
  static const String userManagement = "User Management";
  static const String manageUsers = "Manage Users";
  static const String manageRoles = "Manage Roles";
  static const String role = "Role";
  static const String dateCreated = "Date Created";
  static const String mobileNo = "Mobile No.";
  static const String active = "Active";
  static const String addUser = "Add User";
  static const String name = "Name";
  static const String enterName = "Enter name";
  static const String select = "Select";
  static const String email = "Email";
  static const String enterEmailId = "Enter email id";
  static const String phoneNo = "Phone No.";
  static const String enterMobileNo = "Enter mobile no.";
  static const String image = "Image";
  static const String addRole = "Add Role";
  static const String enterRollName = "Enter role name";

  static const String permissions = "Permissions";
  static const String create = "Create";
  static const String read = "Read";
  static const String update = "Update";
  static const String delete = "Delete";



}

class SettingViewStrings extends AppStrings{
  static const String setting = "Setting";
  static const String customBranding = "Custom Branding";
  static const String faq = "Frequently Asked Question (FAQ)";
  static const String faqText = "FAQ’s";
  static const String privacyPolicy = "Privacy Policy";
  static const String contactUs = "Contact Us";
  static const String platformColourPreference = "Platform & Colour Preference";
  static const String change = "Change";
  static const String platformName = "Platform Name";
  static const String eduLift = "EduLift";
  static const String primaryColor = "Primary Color";
  static const String secondaryColor = "Secondary Color";
  static const String languageThemePreference = "Language & Theme Preference";
  static const String addLanguage = "Add Language";
  static const String update = "Update";
  static const String languagePreference = "Language Preference";
  static const String themePreference = "Theme Preference";
  static const String lightTheme = "Light Theme";
  static const String darkTheme = "Dark Theme";
  static const String faqQuestion = "Lorem ipsum dolor sit amet consectetur. Ultrices vel nulla mauris nulla?";
  static const String faqAns = "Lorem ipsum dolor sit amet consectetur. Enim non amet mi in fusce a elit. Tempus pretium nisi duis in magna ultricies auctor in. Pellentesque egestas semper id purus. Aliquam gravida lectus eget sapien tempus eu aliquam vestibulum. Blandit tristique ac id porttitor vitae justo. Velit venenatis ut urna viverra. Eu urna aliquet cum sollicitudin. ";
  static const String addFAQ = "Add FAQ";
  static const String question = "Question";
  static const String enterQuestion = "Enter question";
  static const String answer = "Answer";
  static const String enterAnswer = "Enter answer";
  static const String addPrivacyPolicy = "Add Privacy Policy";
  static const String enterPrivacyPolicy = "Enter privacy policy";
  static const String deletePrivacyPolicy = "Delete privacy policy";
  static const String deletePrivacyPolicyDes = "Are you sure you want to delete this privacy policy? This action can not be undone.";
  static const String editPrivacyPolicy = "Edit Privacy Policy";
  static const String deleteContact = "Delete Contact";
  static const String deleteContactDes = "Are you sure you want to delete this contact? This action can not be undone.";
}
class ProfileViewStrings extends AppStrings{
  static const String myProfile = "My Profile";
  static const String personalInformation = "Personal Information";
  static const String edit = "Edit";
  static const String fName = "First Name";
  static const String lName = "Last Name";
  static const String joined = "Joined";
  static const String email = "Email";
  static const String phoneNo = "Phone No.";
  static const String userRole = "User Role";
  static const String address = "Address";
  static const String country = "Country";
  static const String city = "City";
  static const String postalCode = "Postal Code";
  static const String editProfile = "Edit Profile";
  static const String name = "Name";
  static const String role = "Role";
  static const String image = "Image";
  static const String backgroundImage = "Background Image";
  static const String editPersonalInformation = "Edit Personal Information";
  static const String joinedDate = "Joined Date";
  static const String editAddress = "Edit Address";







}

class ConnectionStrings extends AppStrings {
  static const String noConnection = "Oops! You’re offline now!";
  static const String noInternetFound =
      "Reconnect to continue your learning journey or view your downloads.";
  static const String goToDownloads = "Go to Downloads";
}

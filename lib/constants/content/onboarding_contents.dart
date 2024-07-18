class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> onboardingContents = [
  OnboardingContents(
    title: "Welcome to Dongi Expense Tracker!",
    image: "assets/images/image1.png",
    desc:
        "We're thrilled to have you on board. Let's simplify expense tracking together.",
  ),
  OnboardingContents(
    title: "Effortlessly Record Your Expenses",
    image: "assets/images/image2.png",
    desc:
        "Stay organized by easily logging your expenses and categorizing them.",
  ),
  OnboardingContents(
    title: "Stay in the Loop with Notifications",
    image: "assets/images/image3.png",
    desc:
        "Receive timely notifications about your expenses, reminders, and financial updates.",
  ),
];

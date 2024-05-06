class IntroLandingContent {
  String image;
  String title;
  String description;

  IntroLandingContent({
    required this.image,
    required this.title,
    required this.description,
  });

  static List<IntroLandingContent> contents = [
    IntroLandingContent(
      image: 'assets/Lottie/student_onboarding_p1.json',
      title: 'Welcome To Treasure Hunter',
      description:
          'We are an online scholarship provided platform to help all students to get the financial support awarded',
    ),
    IntroLandingContent(
      image: 'assets/Lottie/student_onboarding_p2.json',
      title: 'Feeling Stress?',
      description:
          'Don\'t feel stress about education, we provided scholarships that are suitable for most people',
    ),
    IntroLandingContent(
      image: 'assets/Lottie/student_onboarding_p3.json',
      title: 'Start Your Scholarship',
      description: 'We provided comprehensive scholarship sources in Malaysia',
    ),
  ];
}

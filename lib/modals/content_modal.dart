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
      title: 'Welcome To Talent Treasure',
      description:
          'An online scholarship platform to help students get the financial support awarded',
    ),
    IntroLandingContent(
      image: 'assets/Lottie/student_onboarding_p2.json',
      title: 'Feeling Stress?',
      description:
          'Don\'t feel stress about education, we provide scholarships that are suitable for students',
    ),
    IntroLandingContent(
      image: 'assets/Lottie/student_onboarding_p3.json',
      title: 'Start Your Scholarship',
      description:
          'We provide comprehensive scholarship sources for students who study in Malaysia',
    ),
  ];
}

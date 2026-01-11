import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:giveon/DonorFormPage.dart';
import 'package:giveon/FeedPage.dart';
import 'package:giveon/NGOFormPage.dart';
import 'package:giveon/LoginPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Give On",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset("asset/logo.png", height: 60, width: 60),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.purple),
                        tooltip: 'Logout',
                        onPressed: () async {
                          final supabase = Supabase.instance.client;
                          await supabase.auth.signOut();
                          if (context.mounted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ✅ Gradient card (only one kept)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Make a difference today",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Your small act of kindness can create ripples of positive change in someone's life.",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FeedPage(),
                          ),
                        );
                      },
                      child: const Text("Donate Now"),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ✅ Help Options
              const Text(
                "How would you like to help?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  HelpCard(
                    icon: Icons.volunteer_activism,
                    title: "Donate Money",
                    subtitle: "Support causes with financial contributions",
                  ),
                  HelpCard(
                    icon: Icons.card_giftcard,
                    title: "Donate Goods",
                    subtitle: "Share clothes, food, and essentials",
                  ),
                  HelpCard(
                    icon: Icons.people,
                    title: "Volunteer",
                    subtitle: "Offer your time and skills to help",
                  ),
                  HelpCard(
                    icon: Icons.campaign,
                    title: "Spread Awareness",
                    subtitle: "Share causes with your network",
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ✅ Quick Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  QuickAction(
                    icon: Icons.search,
                    label: "Browse",
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FeedPage()),
                      );
                    },
                  ),
                  QuickAction(
                    icon: Icons.add_circle,
                    label: "Post",
                    color: Colors.pink,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DonorFormPage()),
                      );
                    },
                  ),
                  QuickAction(
                    icon: Icons.paid_outlined,
                    label: "Donate",
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NGOFormPage()),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ✅ Featured Causes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Featured Causes",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "View all",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ✅ Horizontal List of Causes
              SizedBox(
                height: 230,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    CauseCard(
                      imageUrl: "https://akm-img-a-in.tosshub.com/indiatoday/images/story/201706/girl-647_062117030708.jpg?size=690:388",
                      title: "Education for All",
                      description: "Help provide quality education to underprivileged children",
                      raised: "₹1,24,500",
                      goal: "₹2,00,000",
                    ),
                    CauseCard(
                      imageUrl: "https://www.shutterstock.com/image-photo/hand-wanderer-extends-receive-food-260nw-2442974679.jpg",
                      title: "Feed the Hungry",
                      description: "Provide meals and feed the families in hunger across the country",
                      raised: "₹89,000",
                      goal: "₹15,000",
                    ),
                    CauseCard(
                      imageUrl: "https://media.istockphoto.com/id/174895325/photo/emergency-air-lift.jpg?s=612x612&w=0&k=20&c=p4Z-kxeV91W67YpxbnCJSjA9EyuQ3QLYwZpbDdrtAz0=",
                      title: "Disaster Relief",
                      description: "Support victims of recent floods with shelter and essentials",
                      raised: "₹2,15,000",
                      goal: "₹3,00,000",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ✅ Reusable CauseCard
class CauseCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String raised;
  final String goal;

  const CauseCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.raised,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(description, style: const TextStyle(color: Colors.black54, fontSize: 10)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$raised raised", style: const TextStyle(color: Colors.blue, fontSize: 11)),
                    Text("Goal: $goal", style: const TextStyle(color: Colors.red, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ HelpCard widget
class HelpCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const HelpCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.purple),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap; // ✅ Add callback

  const QuickAction({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // ✅ Fire action
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 6),
          Text(label),
        ],
      ),
    );
  }
}




import 'package:flutter/material.dart';

void main() {
  runApp(const DatingApp());
}

class DatingApp extends StatelessWidget {
  const DatingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dating App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFFF8FA),
      ),
      home: const HomeScreen(),
    );
  }
}

class Person {
  final String name;
  final int age;
  final String location;
  final String bio;
  final String image;

  const Person({
    required this.name,
    required this.age,
    required this.location,
    required this.bio,
    required this.image,
  });
}

const people = [
  Person(
    name: 'Nia',
    age: 23,
    location: 'Nairobi, Kenya',
    bio: 'Good music, good conversations and beautiful sunsets.',
    image: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
  ),
  Person(
    name: 'Amani',
    age: 25,
    location: 'Kiambu, Kenya',
    bio: 'Adventurous soul looking for something genuine.',
    image: 'https://images.unsplash.com/photo-1531123897727-8f129e1688ce',
  ),
  Person(
    name: 'Zuri',
    age: 22,
    location: 'Mombasa, Kenya',
    bio: 'Beach lover. Dancer. Coffee addict.',
    image: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1',
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  int bottomIndex = 0;

  final List<Person> matches = [];

  void likePerson() {
    if (currentIndex >= people.length) return;

    setState(() {
      matches.add(people[currentIndex]);
      currentIndex++;
    });

    if (currentIndex <= people.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❤️ You liked this profile'),
          duration: Duration(milliseconds: 800),
        ),
      );
    }
  }

  void passPerson() {
    if (currentIndex >= people.length) return;

    setState(() {
      currentIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: bottomIndex,
        children: [
          DiscoverScreen(
            currentIndex: currentIndex,
            onLike: likePerson,
            onPass: passPerson,
          ),
          MatchesScreen(matches: matches),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: bottomIndex,
        onDestinationSelected: (index) {
          setState(() {
            bottomIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Matches',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DiscoverScreen extends StatelessWidget {
  final int currentIndex;
  final VoidCallback onLike;
  final VoidCallback onPass;

  const DiscoverScreen({
    super.key,
    required this.currentIndex,
    required this.onLike,
    required this.onPass,
  });

  @override
  Widget build(BuildContext context) {
    if (currentIndex >= people.length) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.favorite,
                size: 70,
                color: Colors.pink,
              ),
              const SizedBox(height: 20),
              const Text(
                'That’s everyone for now',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Check back later for more people near you.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final person = people[currentIndex];

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
            child: Row(
              children: [
                const Text(
                  'Discover',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.tune),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 5, 18, 10),
              child: ProfileCard(person: person),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActionButton(
                  icon: Icons.close,
                  color: Colors.grey.shade700,
                  size: 62,
                  onPressed: onPass,
                ),
                const SizedBox(width: 25),
                ActionButton(
                  icon: Icons.favorite,
                  color: Colors.pink,
                  size: 72,
                  onPressed: onLike,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final Person person;

  const ProfileCard({
    super.key,
    required this.person,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            person.image,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade300,
                child: const Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.white,
                ),
              );
            },
          ),

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Color.fromRGBO(0, 0, 0, 0.85),
                ],
              ),
            ),
          ),

          Positioned(
            left: 22,
            right: 22,
            bottom: 22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${person.name}, ${person.age}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      person.location,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  person.bio,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.4,
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

class ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.size,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: color.withValues(alpha: 0.25),
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: size * 0.42,
          ),
        ),
      ),
    );
  }
}

class MatchesScreen extends StatelessWidget {
  final List<Person> matches;

  const MatchesScreen({
    super.key,
    required this.matches,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Matches',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'People you liked',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),

            if (matches.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 70,
                        color: Colors.pink.shade200,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'No matches yet',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start discovering people!',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final person = matches[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(person.image),
                        ),
                        title: Text(
                          '${person.name}, ${person.age}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(person.location),
                        trailing: const Icon(
                          Icons.chat_bubble,
                          color: Colors.pink,
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Chat with ${person.name} coming soon!',
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 65,
              backgroundColor: Colors.pink,
              child: Icon(
                Icons.person,
                size: 70,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Your Profile',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Tell people a little about yourself.',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 30),

            ProfileOption(
              icon: Icons.person,
              title: 'Edit profile',
              onTap: () {},
            ),

            ProfileOption(
              icon: Icons.photo,
              title: 'Add photos',
              onTap: () {},
            ),

            ProfileOption(
              icon: Icons.location_on,
              title: 'Location',
              subtitle: 'Nairobi, Kenya',
              onTap: () {},
            ),

            ProfileOption(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.pink.shade50,
          child: Icon(
            icon,
            color: Colors.pink,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle == null ? null : Text(subtitle!),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

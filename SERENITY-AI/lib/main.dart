import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  // Define your light and dark color schemes
  static final lightColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF7EAAC9),
    secondary: const Color(0xFFA8D5BA),
    brightness: Brightness.light,
  );

  static final darkColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF7EAAC9),
    secondary: const Color(0xFFA8D5BA),
    brightness: Brightness.dark,
    background: const Color(0xFF121212),
    surface: const Color(0xFF1E1E1E),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serenity.AI',
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: lightColorScheme,
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        fontFamily: 'Poppins',
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
      ),
      home: MyHomePage(
        title: 'Serenity.AI',
        onThemeToggle: () => setState(() => _isDarkMode = !_isDarkMode),
        isDarkMode: _isDarkMode,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const MyHomePage({
    super.key,
    required this.title,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currentMood = 'Neutral';

  final List<Map<String, dynamic>> _moodOptions = [
    {'emoji': '😊', 'label': 'Happy'},
    {'emoji': '😌', 'label': 'Calm'},
    {'emoji': '😐', 'label': 'Neutral'},
    {'emoji': '😔', 'label': 'Sad'},
    {'emoji': '😰', 'label': 'Anxious'},
    {'emoji': '😤', 'label': 'Frustrated'},
  ];

  void _updateMood(String mood) {
    setState(() {
      _currentMood = mood;
    });
  }

  void _showMoodDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('How are you feeling?'),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _moodOptions.map((mood) {
                return InkWell(
                  onTap: () {
                    _updateMood(mood['label']);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal.shade200),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          mood['emoji'],
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(height: 5),
                        Text(mood['label']),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              actions: [
                IconButton(
                  icon: Icon(
                    widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: colorScheme.onPrimary,
                  ),
                  onPressed: widget.onThemeToggle,
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 20,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        colorScheme.primary,
                        colorScheme.secondary,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How are you feeling?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: widget.isDarkMode
                                ? Colors.black26
                                : Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: _showMoodDialog,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getMoodEmoji(),
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Mood',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  _currentMood,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildQuickActions(colorScheme),
                    const SizedBox(height: 30),
                    _buildActivitiesList(colorScheme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implement voice chat
        },
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        label: const Text('Start Chat'),
        icon: const Icon(Icons.mic),
      ),
    );
  }

  String _getMoodEmoji() {
    return _moodOptions.firstWhere(
      (mood) => mood['label'] == _currentMood,
      orElse: () => _moodOptions[2], // Default to neutral
    )['emoji'];
  }

  Widget _buildQuickActions(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionCard(
              Icons.favorite_border,
              'Breathe',
              widget.isDarkMode ? Colors.red[900]! : Colors.red[100]!,
              colorScheme,
            ),
            _buildActionCard(
              Icons.self_improvement,
              'Meditate',
              widget.isDarkMode ? Colors.blue[900]! : Colors.blue[100]!,
              colorScheme,
            ),
            _buildActionCard(
              Icons.psychology,
              'Journal',
              widget.isDarkMode ? Colors.green[900]! : Colors.green[100]!,
              colorScheme,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
      IconData icon, String label, Color color, ColorScheme colorScheme) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: widget.isDarkMode
                ? Colors.black26
                : Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 30, color: colorScheme.onBackground),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesList(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggested Activities',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 15),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              color: Theme.of(context).cardColor,
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      Icon(Icons.spa, color: colorScheme.onSecondaryContainer),
                ),
                title: Text(
                  [
                    '5-Minute Meditation',
                    'Gratitude Journal',
                    'Deep Breathing'
                  ][index],
                  style: TextStyle(color: colorScheme.onBackground),
                ),
                subtitle: Text(
                  ['Reduce stress', 'Improve mood', 'Calm your mind'][index],
                  style: TextStyle(
                      color: colorScheme.onBackground.withOpacity(0.7)),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: colorScheme.onBackground,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

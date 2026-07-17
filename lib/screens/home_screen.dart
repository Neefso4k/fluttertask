import 'package:flutter/material.dart';
import '../models/check_in.dart';
import '../services/storage_service.dart';
import '../widgets/check_in_card.dart';
import '../widgets/empty_state.dart';
import 'new_check_in_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final StorageService storageService;

  const HomeScreen({Key? key, required this.storageService}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  List<CheckIn> checkIns = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _loadCheckIns();

    // Initialize animation controller for FAB
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadCheckIns() {
    setState(() {
      checkIns = widget.storageService.getAllCheckIns();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient Background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E27), // Deep dark blue (top left)
              Color(0xFF1A1A3E), // Midnight blue
              Color(0xFF2D1B4E), // Deep purple
              Color(0xFF1A2A4A), // Dark navy
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar with gradient text
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                      ).createShader(bounds),
                      child: const Text(
                        'Check-Ins',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${checkIns.length} items',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Main content
              Expanded(
                child: checkIns.isEmpty
                    ? const EmptyState()
                    : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: checkIns.length,
                  itemBuilder: (context, index) {
                    final checkIn = checkIns[index];
                    return CheckInCard(
                      checkIn: checkIn,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              checkIn: checkIn,
                              storageService: widget.storageService,
                            ),
                          ),
                        ).then((_) => _loadCheckIns());
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // Animated Floating Action Button with pulse animation
      floatingActionButton: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (0.05 * _animationController.value),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C5CE7).withOpacity(0.4),
                    blurRadius: 20 + (10 * _animationController.value),
                    spreadRadius: 5 + (5 * _animationController.value),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewCheckInScreen(
                        storageService: widget.storageService,
                      ),
                    ),
                  ).then((_) => _loadCheckIns());
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const ApiListApp());
}

// App chính của Lab 8
class ApiListApp extends StatelessWidget {
  const ApiListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 8 - API Powered List Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const PostListScreen(),
    );
  }
}

// Model class: chuyển JSON thành Dart object
class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  const Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  // factory fromJson dùng để parse JSON sang object Post
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  // Dùng cho POST request
  Map<String, dynamic> toJson() {
    return {'userId': userId, 'id': id, 'title': title, 'body': body};
  }
}

// Service Layer Pattern: tách phần gọi API ra khỏi UI
class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Lab 8.1 + 8.2: GET request + JSON to Model
  Future<List<Post>> fetchPosts({bool forceError = false}) async {
    try {
      // Dùng để test error state khi bấm nút bug trên AppBar
      if (forceError) {
        await Future.delayed(const Duration(seconds: 1));
        throw Exception('Simulated network error');
      }

      final Uri url = Uri.parse('$baseUrl/posts');

      final response = await client
          .get(url)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // json.decode chuyển String JSON thành Dart object
        final decodedData = json.decode(response.body);

        if (decodedData is List) {
          return decodedData.map((item) {
            return Post.fromJson(item as Map<String, dynamic>);
          }).toList();
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Something went wrong. Please try again.');
    }
  }

  // Optional Lab 8: POST request tạo item mới
  Future<Post> createPost({required String title, required String body}) async {
    try {
      final Uri url = Uri.parse('$baseUrl/posts');

      final response = await client
          .post(
            url,
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: json.encode({'title': title, 'body': body, 'userId': 1}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        final decodedData = json.decode(response.body);

        return Post.fromJson(decodedData as Map<String, dynamic>);
      } else {
        throw Exception('Failed to create post');
      }
    } catch (error) {
      throw Exception('Create post failed. Please try again.');
    }
  }

  void dispose() {
    client.close();
  }
}

// Màn hình chính hiển thị danh sách API
class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late final ApiService apiService;

  // Future lưu kết quả gọi API
  late Future<List<Post>> postsFuture;

  @override
  void initState() {
    super.initState();

    apiService = ApiService();

    // Gọi API khi màn hình được tạo
    postsFuture = apiService.fetchPosts();
  }

  @override
  void dispose() {
    apiService.dispose();
    super.dispose();
  }

  // Retry hoặc refresh lại dữ liệu
  void _loadPosts() {
    setState(() {
      postsFuture = apiService.fetchPosts();
    });
  }

  // Nút test lỗi để chụp screenshot error state
  void _simulateError() {
    setState(() {
      postsFuture = apiService.fetchPosts(forceError: true);
    });
  }

  // Pull to refresh
  Future<void> _refreshPosts() async {
    setState(() {
      postsFuture = apiService.fetchPosts();
    });

    await postsFuture;
  }

  // Mở dialog tạo post mới
  Future<void> _openCreatePostDialog() async {
    final Post? createdPost = await showDialog<Post>(
      context: context,
      builder: (context) {
        return CreatePostDialog(apiService: apiService);
      },
    );

    if (createdPost != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Created post successfully: ID ${createdPost.id}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Mở màn hình detail
  void _openPostDetail(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetailScreen(post: post)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Posts'),
        centerTitle: true,
        actions: [
          // Test error state
          IconButton(
            tooltip: 'Simulate Error',
            onPressed: _simulateError,
            icon: const Icon(Icons.bug_report),
          ),

          // Retry / Reload API
          IconButton(
            tooltip: 'Reload',
            onPressed: _loadPosts,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: FutureBuilder<List<Post>>(
        future: postsFuture,
        builder: (context, snapshot) {
          // Lab 8.3: Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          // Lab 8.3: Error state
          if (snapshot.hasError) {
            return _buildErrorState();
          }

          // Nếu không có data
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final posts = snapshot.data!;

          // Lab 8.2: Hiển thị API results bằng ListView.builder
          return RefreshIndicator(
            onRefresh: _refreshPosts,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return PostCard(post: post, onTap: () => _openPostDetail(post));
              },
            ),
          );
        },
      ),

      // Optional POST request
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreatePostDialog,
        icon: const Icon(Icons.add),
        label: const Text('POST'),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),

          SizedBox(height: 16),

          Text('Loading posts...', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 80, color: Colors.red),

            const SizedBox(height: 16),

            const Text(
              'Something went wrong',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'Please check your internet connection or try again later.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _loadPosts,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text('No posts found', style: TextStyle(fontSize: 18)),
    );
  }
}

// Card hiển thị từng Post trong danh sách
class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;

  const PostCard({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 3,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(child: Text(post.id.toString())),
        title: Text(
          post.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('User ID: ${post.userId}'),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}

// Màn hình chi tiết post - Optional Enhancement
class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post #${post.id}')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Chip(
              avatar: const Icon(Icons.person),
              label: Text('User ID: ${post.userId}'),
            ),

            const SizedBox(height: 20),

            const Text(
              'Body',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(post.body, style: const TextStyle(fontSize: 16, height: 1.5)),
          ],
        ),
      ),
    );
  }
}

// Dialog gửi POST request
class CreatePostDialog extends StatefulWidget {
  final ApiService apiService;

  const CreatePostDialog({super.key, required this.apiService});

  @override
  State<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  bool isSubmitting = false;

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  Future<void> _submitPost() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final Post createdPost = await widget.apiService.createPost(
        title: titleController.text.trim(),
        body: bodyController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context, createdPost);
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Create post failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Post'),

      content: Form(
        key: formKey,

        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: bodyController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Body',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Body is required';
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: isSubmitting
              ? null
              : () {
                  Navigator.pop(context);
                },
          child: const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed: isSubmitting ? null : _submitPost,
          child: isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Submit'),
        ),
      ],
    );
  }
}

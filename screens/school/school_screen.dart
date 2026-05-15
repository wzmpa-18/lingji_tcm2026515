import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../services/content_compliance.dart';
import '../../models/course/instructor_course_model.dart';

class SchoolScreen extends StatefulWidget {
  const SchoolScreen({super.key});

  @override
  State<SchoolScreen> createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  final List<Instructor> sampleInstructors = [
    Instructor(
      id: '1',
      name: '林老师',
      title: '中医经典讲师',
      avatar: '',
      bio: '专注于《伤寒论》《金匮要略》教学10年',
      followerCount: 1200,
      courseCount: 5,
      isVerified: true,
    ),
    Instructor(
      id: '2',
      name: '王老师',
      title: '针灸经络讲师',
      avatar: '',
      bio: '倪海厦学术传人，精通针灸',
      followerCount: 850,
      courseCount: 3,
      isVerified: true,
    ),
  ];

  final List<Course> sampleCourses = [
    Course(
      id: '1',
      title: '伤寒论逐句解读',
      description: '逐条讲解《伤寒论》原文，结合临床案例',
      instructorId: '1',
      instructorName: '林老师',
      price: 199,
      originalPrice: 399,
      imageUrl: '',
      category: '中医',
      duration: 2400,
      lessonCount: 48,
      enrolledCount: 520,
      rating: 4.9,
      isFree: false,
    ),
    Course(
      id: '2',
      title: '经络穴位入门',
      description: '十四经络基础入门，精准取穴',
      instructorId: '2',
      instructorName: '王老师',
      price: 0,
      originalPrice: 99,
      imageUrl: '',
      category: '针灸',
      duration: 1200,
      lessonCount: 24,
      enrolledCount: 1200,
      rating: 4.8,
      isFree: true,
    ),
  ];

  final List<SchoolCategory> categories = [
    SchoolCategory(
      id: '1',
      name: '中医经典',
      icon: Icons.menu_book,
      color: Colors.brown,
    ),
    SchoolCategory(
      id: '2',
      name: '针灸推拿',
      icon: Icons.spa,
      color: Colors.green,
    ),
    SchoolCategory(
      id: '3',
      name: '命理典籍',
      icon: Icons.auto_awesome,
      color: Colors.purple,
    ),
    SchoolCategory(
      id: '4',
      name: '风水文化',
      icon: Icons.house,
      color: Colors.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('学堂'),
        actions: [
          IconButton(
            icon: const Icon(Icons.school),
            tooltip: '讲师入驻',
            onPressed: () => _showInstructorEntry(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategories(),
            const SizedBox(height: 24),
            _buildSectionTitle('热门课程'),
            const SizedBox(height: 12),
            _buildCourseList(),
            const SizedBox(height: 24),
            _buildSectionTitle('传统文化流派科普'),
            const SizedBox(height: 12),
            _buildSchoolPopularization(),
            const SizedBox(height: 24),
            _buildSectionTitle('推荐讲师'),
            const SizedBox(height: 12),
            _buildInstructorList(),
            const SizedBox(height: 24),
            ComplianceHelper.buildDisclaimerBanner(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '课程分类',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: categories.map((category) {
              return GestureDetector(
                onTap: () {},
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: category.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        category.icon,
                        color: category.color,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('查看更多'),
        ),
      ],
    );
  }

  Widget _buildCourseList() {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: sampleCourses.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final course = sampleCourses[index];
          return _buildCourseCard(course);
        },
      ),
    );
  }

  Widget _buildCourseCard(Course course) {
    return SizedBox(
      width: 280,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: const Center(
                child: Icon(Icons.play_circle_outline, size: 48, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.instructorName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (course.isFree)
                        const Text(
                          '免费',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        Text(
                          '¥${course.price}',
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (!course.isFree && course.originalPrice > course.price)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            '¥${course.originalPrice}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade400,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 12, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text(
                            '${course.rating}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchoolPopularization() {
    final items = [
      _PopularizationItem(
        title: '儒家文化',
        subtitle: '孔孟之道，仁义礼智信',
        color: Colors.blue,
        icon: Icons.local_library,
        content: '''
儒家文化是中國傳統文化的核心，起源於春秋時期的孔子，
發展於孟子、荀子，經過宋明理學的深化，
成為影響中國兩千多年的思想體系。

核心經典：
• 四書：《大學》、《中庸》、《論語》、《孟子》
• 五經：《詩》、《書》、《禮》、《易》、《春秋》

核心思想：
• 仁：「己所不欲，勿施於人」
• 義：正義道德
• 禮：禮儀規範
• 智：智慧修養
• 信：誠信原則

本內容僅供學術研究和文化學習使用。''',
      ),
      _PopularizationItem(
        title: '道家文化',
        subtitle: '道法自然，清靜無為',
        color: Colors.teal,
        icon: Icons.nature,
        content: '''
道家文化以「道」為核心，起源於老子的《道德經》，
發展於莊子，融合了神仙方術，
形成了獨特的東方哲學體系。

核心經典：
• 《道德經》（老子）
• 《莊子》（南華真經）
• 《列子》（沖虛經）

核心思想：
• 道法自然：順應自然規律
• 清靜無為：不刻意妄為
• 柔弱勝剛：以柔克剛
• 返璞歸真：回歸質樸本性

本內容僅供學術研究和文化學習使用。''',
      ),
      _PopularizationItem(
        title: '佛家文化',
        subtitle: '慈悲濟世，覺悟人生',
        color: Colors.orange,
        icon: Icons.favorite,
        content: '''
佛教於東漢時期傳入中國，經過兩千多年的發展，
與中國本土文化融合，形成了具有中國特色的佛教文化。

重要經典：
• 心經：《般若波羅蜜多心經》
• 金剛經：《金剛般若波羅蜜經》
• 法華經：《妙法蓮華經》

核心教義：
• 四諦：苦、集、滅、道
• 八正道：正見、正思維、正語等
• 緣起：一切事物因緣和合

本內容僅供學術研究和文化學習使用。''',
      ),
      _PopularizationItem(
        title: '兵家文化',
        subtitle: '知己知彼，百戰不殆',
        color: Colors.red,
        icon: Icons.shield,
        content: '''
兵家文化是中國古代軍事思想的總結，
以《孫子兵法》為代表，影響深遠。

核心經典：
• 《孫子兵法》（孫武）
• 《吳子兵法》（吳起）
• 《孫臏兵法》（孫臏）

核心思想：
• 知己知彼，百戰不殆
• 不戰而屈人之兵，善之善者也
• 兵者，詭道也
• 上兵伐謀，其次伐交，其次伐兵

本內容僅供學術研究和文化學習使用。''',
      ),
    ];

    return Column(
      children: items.map((item) => _buildPopularizationCard(item)).toList(),
    );
  }

  Widget _buildPopularizationCard(_PopularizationItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: item.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(item.icon, color: item.color, size: 24),
        ),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(item.subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showPopularizationDetail(context, item),
      ),
    );
  }

  Widget _buildInstructorList() {
    return Column(
      children: sampleInstructors.map((instructor) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, size: 28, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            instructor.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (instructor.isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.verified, size: 16, color: Colors.blue),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        instructor.title,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        instructor.bio,
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '${instructor.courseCount}门课程',
                            style: const TextStyle(fontSize: 11),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${instructor.followerCount}位学员',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('查看'),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showPopularizationDetail(BuildContext context, _PopularizationItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: item.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(item.icon, size: 32, color: item.color),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  item.subtitle,
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: item.color.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          item.content,
                          style: const TextStyle(fontSize: 14, height: 1.8),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: const Text(
                          '本內容僅供學術研究和文化學習使用，不涉及任何宗教活動或封建迷信內容。',
                          style: TextStyle(fontSize: 12, color: Colors.brown),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInstructorEntry(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('讲师入驻'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('入驻要求：'),
              SizedBox(height: 8),
              Text('• 上传相关资质证明'),
              Text('• 缴纳课程质量保证金'),
              Text('• 遵守平台教学规范'),
              Text('• 保证原创内容版权'),
              SizedBox(height: 16),
              Text('平台收益：'),
              SizedBox(height: 8),
              Text('• 初始分成：讲师得50%'),
              Text('• 随好评率提升，最高90%'),
              Text('• 学员评价4.8分以上，平台分成降至10%'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('申请入驻'),
          ),
        ],
      ),
    );
  }
}

class SchoolCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  SchoolCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class _PopularizationItem {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final String content;

  _PopularizationItem({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.content,
  });
}

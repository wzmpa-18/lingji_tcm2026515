import 'package:flutter/material.dart';

class ContentCompliance {
  static const String appName = '中医易学学习助手';
  static const String appNameEn = 'TCM & YiXue Learning Assistant';

  static const String appDescription =
      '中医易学学习助手是一款传统中医文化与易学文化学习工具。内容涵盖中医辨证思路、经方配伍研习、针灸配穴参考、董氏奇穴、倪海厦学术整理、丘雅昌配穴案例、八字排盘、命理古籍解析等。本应用仅供传统文化爱好者学习、研究、交流使用，不涉及医疗诊疗、不提供占卜服务，旨在传承与普及中华传统国学文化。';

  static const String appSlogan = '传承国学 · 研习经典 · 智慧生活';

  static const String fullDisclaimer =
      '免责声明：本应用为「中医易学学习助手」，仅为中华传统文化（中医、针灸、易学、命理）知识学习与学术研究工具。所有内容来自公开古籍、名家学术整理、传统典籍解析，不提供医疗诊断、处方用药、针灸治疗、占卜算命服务。内容仅供学习参考，非医疗建议、非人生决策依据。身体不适请咨询专业医师，请勿自行按方用药、施针。';

  static const String pageDisclaimer =
      '本内容仅供传统文化学习参考，不构成医疗或占卜服务';

  static const Map<String, String> globalTextReplacements = {
    '诊病': '中医症候辨证学习',
    '治病': '传统医理思路参考',
    '治疗': '调理思路学习',
    '诊疗': '医理思路参考',
    '开方': '经方配伍思路研习',
    '处方': '古方案例参考',
    '配药': '经方配伍研习',
    '用药': '古法养生参考',
    '算命': '易学文化探讨',
    '批命': '命理古籍研习',
    '运势': '命理学术探讨',
    '占卜': '易学文化研究',
    '诊断': '辨证思路学习',
    '治愈': '调理思路参考',
    '效果': '学习效果展示',
  };

  static String applyTextReplacement(String input) {
    String result = input;
    globalTextReplacements.forEach((key, value) {
      result = result.replaceAll(key, value);
    });
    return result;
  }
}

class ComplianceTexts {
  static const String homeIntro = '''
中医易学学习助手是一款传统中医文化与易学文化学习工具。

📚 学习内容
• 中医辨证思路与经方配伍
• 针灸经络与董氏奇穴
• 倪海厦学术整理
• 八字排盘与命理古籍

🎯 学习目的
传承中华传统国学文化，供传统文化爱好者学习、研究、交流使用。

⚠️ 重要提示
本应用不涉及医疗诊疗、不提供占卜服务，所有内容仅供学习参考。
''';

  static const String tcmSectionIntro = '''
【中医经方研习】

本板块收录中医常见症候辨证逻辑、经典方剂配伍、君臣佐使思路、历代医案，供用户学习中医理法方药思维框架。

📖 学习内容
• 八纲辨证基础理论
• 脏腑辨证思路
• 经方配伍原则
• 名家医案解析

💡 学习目的
帮助用户建立中医思维框架，了解传统医学智慧。

⚠️ 免责声明
所有内容仅作学术学习与文化参考，不构成医疗建议及用药指导。
''';

  static const String acupunctureSectionIntro = '''
【针灸经络学习】

本板块整理传统经络穴位、董氏奇穴、倪海厦针灸学术、丘雅昌配穴经验，提供取穴位置、配穴思路、经典案例。

📖 学习内容
• 十四经络循行
• 361个标准穴位
• 董氏奇穴体系
• 倪海厦特效穴
• 配穴思路与实操

💡 学习目的
用于针灸文化学习与技法研究，非实操施针指导。

⚠️ 免责声明
本内容仅供学术学习参考，非施针指导，请勿自行施针。
''';

  static const String fortuneSectionIntro = '''
【易学文化探讨】

本板块提供八字排盘、十神解析、格局分析、命理古籍阅读，以文化研究、历史哲学、传统术数知识普及为目的。

📖 学习内容
• 八字基础排盘
• 十神关系解析
• 格局分析理论
• 命理古籍研读
• 数字能量学
• 手相面相

💡 学习目的
传统文化研究、历史哲学探讨、术数知识学习。

⚠️ 免责声明
不做运势预测、吉凶判断、改运指导。本内容仅供易学文化学习参考。
''';

  static const String pediatricSectionIntro = '''
【儿科调理学习】

本板块整理倪海厦小儿论述、小儿辨证、小儿调理手法，包含开天河水等经典小儿推拿实操内容。

📖 学习内容
• 小儿生理特点
• 常见症候辨证
• 推拿手法学习
• 调理方案参考

💡 学习目的
帮助家长了解传统小儿调理方法，供学习研究使用。

⚠️ 免责声明
如有不适请及时就医，请勿自行处理。
''';
}

class ComplianceHelper {
  static String replaceMedicalTerms(String text) {
    return ContentCompliance.applyTextReplacement(text);
  }

  static String getFormattedDisclaimer() {
    return ContentCompliance.fullDisclaimer;
  }

  static String getPageDisclaimer() {
    return ContentCompliance.pageDisclaimer;
  }

  static Widget buildDisclaimerBanner({
    bool showIcon = true,
    Color? backgroundColor,
    Color? textColor,
    double fontSize = 12,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.orange.shade50,
        border: Border(
          top: BorderSide(color: Colors.orange.shade200),
        ),
      ),
      child: Row(
        children: [
          if (showIcon) ...[
            Icon(
              Icons.info_outline,
              size: 16,
              color: textColor ?? Colors.orange.shade700,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              ContentCompliance.pageDisclaimer,
              style: TextStyle(
                fontSize: fontSize,
                color: textColor ?? Colors.orange.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFullDisclaimerBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '免责声明',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            ContentCompliance.fullDisclaimer,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class MedicalTermReplacer {
  static String process(String input) {
    String result = input;

    final replacements = {
      RegExp(r'诊病|治病|治疗|诊疗'): '中医症候辨证学习',
      RegExp(r'开方|处方|配药|用药'): '经方配伍思路研习',
      RegExp(r'算命|批命|运势|占卜'): '易学文化探讨',
      RegExp(r'诊断|治愈|效果'): '调理思路参考',
    };

    replacements.forEach((pattern, replacement) {
      result = result.replaceAll(pattern, replacement);
    });

    return result;
  }

  static String processTitle(String title) {
    if (title.contains('开方') || title.contains('处方')) {
      return title.replaceAll('开方', '经方研习').replaceAll('处方', '古方参考');
    }
    if (title.contains('算命') || title.contains('运势')) {
      return title.replaceAll('算命', '命理研习').replaceAll('运势', '命理探讨');
    }
    if (title.contains('治疗') || title.contains('诊疗')) {
      return title.replaceAll('治疗', '调理').replaceAll('诊疗', '辨证');
    }
    return title;
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/settings_service.dart';
import '../../core/theme/palette.dart';
import '../../core/utils/script_converter.dart';
import '../../core/utils/search_fold.dart';
import '../../core/widgets/page_scaffold.dart';
import '../../core/widgets/svg_icon.dart';
import '../../data/models/enums.dart';
import '../../data/models/path_model.dart';
import '../../routes/app_routes.dart';
import 'search_controller.dart';
import 'search_index.dart';

class SearchView extends GetView<AppSearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return PageScaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: Get.back,
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 22,
                    color: p.heading,
                  ),
                ),
                Expanded(child: _Field(controller: controller)),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.query.value.trim().isEmpty) {
                return const _QuickAccess();
              }
              final paths = controller.paths;
              final verses = controller.verses;
              final sevas = controller.sevas;
              final feats = controller.matchedFeatures;
              if (paths.isEmpty &&
                  verses.isEmpty &&
                  sevas.isEmpty &&
                  feats.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 52,
                        color: p.pillBorder,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'no_results'.tr,
                        style: TextStyle(fontSize: 16, color: p.subtext),
                      ),
                    ],
                  ),
                );
              }
              final ui = Get.find<SettingsController>().uiLang.value;
              final script = Get.find<SettingsController>().script.value;
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                children: [
                  if (paths.isNotEmpty)
                    _Section('sec_paths'.tr, paths.length, [
                      for (final x in paths)
                        _Row(
                          lead: SvgIcon(x.icon, size: 26),
                          title: x.title(ui),
                          subtitle: 'n_verses'.trParams({
                            'n': '${x.verses.length}',
                          }),
                          onTap: () =>
                              Get.toNamed(Routes.reader, arguments: x.id),
                        ),
                    ]),
                  if (verses.isNotEmpty)
                    _Section('sec_verses'.tr, verses.length, [
                      for (final (x, v) in verses.take(
                        AppSearchController.verseLimit,
                      ))
                        _Row(
                          lead: SvgIcon(x.icon, size: 26),
                          title:
                              '${x.title(ui)} · ${'verse_n'.trParams({'n': '${v.number}'})}',
                          subtitle: _snippet(v, script, controller.query.value),
                          onTap: () => Get.toNamed(
                            Routes.reader,
                            arguments: {'id': x.id, 'verse': v.number},
                          ),
                        ),
                      if (verses.length > AppSearchController.verseLimit)
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'more_results'.trParams({
                              'n':
                                  '${verses.length - AppSearchController.verseLimit}',
                            }),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: p.subtext),
                          ),
                        ),
                    ]),
                  if (sevas.isNotEmpty)
                    _Section('sec_sevas'.tr, sevas.length, [
                      for (final s in sevas)
                        _Row(
                          lead: SvgIcon(s.icon, size: 26),
                          title: '${s.nameKey.tr} ${'seva_suffix'.tr}',
                          subtitle: s.subKey.tr,
                          onTap: () =>
                              Get.toNamed(Routes.seva, arguments: s.id),
                        ),
                    ]),
                  if (feats.isNotEmpty)
                    _Section('sec_features'.tr, feats.length, [
                      for (final f in feats) _FeatureRow(f),
                    ]),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  /// The matching verse line in the reader's script, else the matching
  /// meaning (the reader's meaning language first), else line one.
  static String _snippet(Verse v, ReaderScript script, String query) {
    final q = fold(query.trim());
    final shown = ScriptConverter.convert(v.dev, script).split('\n');
    final dev = v.dev.split('\n');
    for (var i = 0; i < dev.length; i++) {
      final all = [
        dev[i],
        ScriptConverter.convert(dev[i], ReaderScript.gujarati),
        ScriptConverter.convert(dev[i], ReaderScript.roman),
      ].join(' ');
      if (fold(all).contains(q)) return shown[i];
    }
    final lang = Get.find<SettingsController>().meaningLang.value;
    final ordered = [
      v.meanings[lang.code],
      ...v.meanings.entries
          .where((e) => e.key != lang.code)
          .map((e) => e.value),
    ].whereType<String>();
    for (final m in ordered) {
      if (!fold(m).contains(q)) continue;
      final i = m.toLowerCase().indexOf(query.trim().toLowerCase());
      if (i <= 30) return m;
      return '…${m.substring(i - 30)}';
    }
    return shown.first;
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.controller});
  final AppSearchController controller;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(23),
      borderSide: BorderSide(color: p.cardBorder),
    );
    return TextField(
      controller: controller.field,
      autofocus: true,
      textInputAction: TextInputAction.search,
      style: TextStyle(fontSize: 15.5, color: p.text),
      decoration: InputDecoration(
        hintText: 'search_hint'.tr,
        hintStyle: TextStyle(color: p.subtext, fontSize: 14.5),
        prefixIcon: Icon(Icons.search_rounded, color: p.subtext),
        suffixIcon: Obx(
          () => controller.query.value.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  icon: Icon(Icons.close_rounded, color: p.subtext),
                  onPressed: controller.field.clear,
                ),
        ),
        filled: true,
        fillColor: p.card,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: p.primary, width: 1.5),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title, this.count, this.children);
  final String title;
  final int count;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: p.heading,
                  ),
                ),
              ),
              Text(
                '$count',
                style: TextStyle(
                  fontFamily: 'NotoSans',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: p.subtext,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: p.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: p.cardBorder),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) Divider(height: 1, color: p.cardBorder),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.lead,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Widget lead;
  final String title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: p.iconTile,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: IconTheme(
                  data: IconThemeData(color: p.heading, size: 22),
                  child: lead,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: p.text,
                      ),
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: p.subtext),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: p.subtext),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow(this.f);
  final Feature f;

  @override
  Widget build(BuildContext context) => _Row(
    lead: Icon(f.icon),
    title: f.titleKey.tr,
    subtitle: 'sec_features'.tr,
    onTap: () => Get.toNamed(f.route, arguments: f.args),
  );
}

/// Shown before anything is typed: a tip and every feature as a chip.
class _QuickAccess extends StatelessWidget {
  const _QuickAccess();

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(
          'search_tip'.tr,
          style: TextStyle(fontSize: 14, height: 1.6, color: p.subtext),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 18, 2, 10),
          child: Text(
            'quick_access'.tr,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: p.heading,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final f in features)
              ActionChip(
                avatar: Icon(f.icon, size: 18, color: p.primary),
                label: Text(f.titleKey.tr),
                labelStyle: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: p.text,
                ),
                backgroundColor: p.card,
                side: BorderSide(color: p.cardBorder),
                shape: const StadiumBorder(),
                onPressed: () => Get.toNamed(f.route, arguments: f.args),
              ),
          ],
        ),
      ],
    );
  }
}

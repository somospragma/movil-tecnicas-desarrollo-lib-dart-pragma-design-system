import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../domain/models/model_color_token.dart';
import '../domain/models/model_theme_pragma.dart';
import '../theme/pragma_theme_builder.dart';
import '../tokens/pragma_spacing.dart';
import 'pragma_button.dart';
import 'pragma_card_widget.dart';
import 'pragma_color_token_row_widget.dart';

/// Interactive widget that edits a [ModelThemePragma] and previews it live.
class PragmaThemeEditorWidget extends StatefulWidget {
  const PragmaThemeEditorWidget({
    required this.theme,
    this.onChanged,
    this.fontOptions = const <String>[
      'Poppins',
      'Roboto',
      'Space Grotesk',
      'Source Sans 3',
      'Nunito',
    ],
    super.key,
  });

  /// Theme currently being edited.
  final ModelThemePragma theme;

  /// Callback fired whenever the internal theme changes.
  final ValueChanged<ModelThemePragma>? onChanged;

  /// List of Google Fonts families available in the dropdown selector.
  final List<String> fontOptions;

  @override
  State<PragmaThemeEditorWidget> createState() =>
      _PragmaThemeEditorWidgetState();
}

class _PragmaThemeEditorWidgetState extends State<PragmaThemeEditorWidget> {
  late ModelThemePragma _current;
  late ThemeData _previewTheme;

  @override
  void initState() {
    super.initState();
    _current = widget.theme;
    _previewTheme = PragmaThemeBuilder.buildTheme(_current);
  }

  @override
  void didUpdateWidget(covariant PragmaThemeEditorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.theme != oldWidget.theme) {
      _current = widget.theme;
      _previewTheme = PragmaThemeBuilder.buildTheme(_current);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isWide = constraints.maxWidth > 960;
        final Widget editorPanel = _buildEditorPanel(context);
        final Widget previewPanel = _buildPreviewPanel(context);
        final Widget content = isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(flex: 11, child: editorPanel),
                  const SizedBox(width: PragmaSpacing.xl),
                  Expanded(flex: 9, child: previewPanel),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  editorPanel,
                  const SizedBox(height: PragmaSpacing.xl),
                  previewPanel,
                ],
              );

        return SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: content,
          ),
        );
      },
    );
  }

  Widget _buildEditorPanel(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(PragmaSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Constructor de tema', style: textTheme.titleLarge),
            const SizedBox(height: PragmaSpacing.xs),
            Text(
              'Ajusta la tipografía, colores de superficie y text styles. Todas las variaciones se serializan a JSON automáticamente.',
              style: textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: PragmaSpacing.lg),
            _buildFontSelector(),
            const SizedBox(height: PragmaSpacing.md),
            _buildBrightnessSelector(),
            const SizedBox(height: PragmaSpacing.lg),
            _buildTokenSection(
              title: 'Colores base',
              tokens: _current.colorTokens,
              onTokenChanged: (String key, ModelColorToken token) {
                final Map<String, ModelColorToken> updated =
                    Map<String, ModelColorToken>.from(_current.colorTokens);
                updated[key] = token;
                _replaceTheme(_current.copyWith(colorTokens: updated));
              },
            ),
            const SizedBox(height: PragmaSpacing.lg),
            _buildTokenSection(
              title: 'Colores para texto',
              tokens: _current.textColorTokens,
              onTokenChanged: (String key, ModelColorToken token) {
                final Map<String, ModelColorToken> updated =
                    Map<String, ModelColorToken>.from(_current.textColorTokens);
                updated[key] = token;
                _replaceTheme(_current.copyWith(textColorTokens: updated));
              },
            ),
            const SizedBox(height: PragmaSpacing.lg),
            _buildJsonExporter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSelector() {
    final List<String> options = List<String>.from(widget.fontOptions);
    if (!options.contains(_current.typographyFamily)) {
      options.add(_current.typographyFamily);
    }

    return Row(
      children: <Widget>[
        const Text('Tipografía principal'),
        const SizedBox(width: PragmaSpacing.md),
        DropdownButton<String>(
          value: _current.typographyFamily,
          items: options
              .map(
                (String font) => DropdownMenuItem<String>(
                  value: font,
                  child: Text(font),
                ),
              )
              .toList(),
          onChanged: (String? value) {
            if (value == null) {
              return;
            }
            _replaceTheme(_current.copyWith(typographyFamily: value));
          },
        ),
      ],
    );
  }

  Widget _buildBrightnessSelector() {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Modo', style: textTheme.labelLarge),
        const SizedBox(height: PragmaSpacing.xs),
        SegmentedButton<ThemeBrightness>(
          segments: const <ButtonSegment<ThemeBrightness>>[
            ButtonSegment<ThemeBrightness>(
              value: ThemeBrightness.light,
              icon: Icon(Icons.light_mode_outlined),
              label: Text('Claro'),
            ),
            ButtonSegment<ThemeBrightness>(
              value: ThemeBrightness.dark,
              icon: Icon(Icons.dark_mode_outlined),
              label: Text('Oscuro'),
            ),
          ],
          selected: <ThemeBrightness>{_current.brightness},
          onSelectionChanged: (Set<ThemeBrightness> selection) {
            if (selection.isEmpty) {
              return;
            }
            _replaceTheme(_current.copyWith(brightness: selection.first));
          },
        ),
      ],
    );
  }

  Widget _buildTokenSection({
    required String title,
    required Map<String, ModelColorToken> tokens,
    required void Function(String key, ModelColorToken token) onTokenChanged,
  }) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return ExpansionTile(
      initiallyExpanded: true,
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      title: Text(title, style: textTheme.titleMedium),
      children: tokens.entries.map((MapEntry<String, ModelColorToken> entry) {
        return PragmaColorTokenRowWidget(
          key: ValueKey<String>('${title.toLowerCase()}-${entry.key}'),
          token: entry.value,
          onChanged: (ModelColorToken updated) =>
              onTokenChanged(entry.key, updated),
        );
      }).toList(),
    );
  }

  Widget _buildJsonExporter(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String payload =
        const JsonEncoder.withIndent('  ').convert(_current.toJson());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('JSON listo para exportar', style: textTheme.titleMedium),
        const SizedBox(height: PragmaSpacing.sm),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(PragmaSpacing.sm),
          ),
          padding: const EdgeInsets.all(PragmaSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SelectableText(
                payload,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
              const SizedBox(height: PragmaSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _copyJson(payload),
                  icon: const Icon(Icons.copy_outlined),
                  label: const Text('Copiar JSON'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewPanel(BuildContext context) {
    return Theme(
      data: _previewTheme,
      child: Builder(
        builder: (BuildContext previewContext) {
          final TextTheme textTheme = Theme.of(previewContext).textTheme;
          final ColorScheme scheme = Theme.of(previewContext).colorScheme;

          return Card(
            elevation: 3,
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(PragmaSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Preview en vivo', style: textTheme.titleLarge),
                  const SizedBox(height: PragmaSpacing.xs),
                  Text(
                    'Usamos botones, tarjetas y el row de tokens para que valides contrastes y jerarquías.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: PragmaSpacing.lg),
                  Wrap(
                    spacing: PragmaSpacing.md,
                    runSpacing: PragmaSpacing.md,
                    children: <Widget>[
                      PragmaPrimaryButton(
                        label: 'Primario',
                        onPressed: () {},
                      ),
                      PragmaSecondaryButton(
                        label: 'Secundario',
                        onPressed: () {},
                      ),
                      PragmaButton.icon(
                        label: 'Acción',
                        icon: Icons.arrow_forward,
                        hierarchy: PragmaButtonHierarchy.tertiary,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: PragmaSpacing.lg),
                  PragmaCardWidget(
                    title: 'Card preview',
                    subtitle: 'Sincroniza tokens y tipografías',
                    metadata: Text(
                      'Actualizado en vivo',
                      style: textTheme.labelMedium,
                    ),
                    body: Text(
                      'Explora cómo se ven los estados base usando tus colores personalizados.',
                      style: textTheme.bodyMedium,
                    ),
                    actions: <Widget>[
                      PragmaButton.icon(
                        label: 'Documentar',
                        icon: Icons.description_outlined,
                        hierarchy: PragmaButtonHierarchy.secondary,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: PragmaSpacing.lg),
                  PragmaCardWidget(
                    title: 'Prototipo desktop',
                    subtitle: 'Listo para pruebas internas',
                    metadata: Text(
                      'Actualizado por UX Research',
                      style: textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    media: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              scheme.primaryContainer,
                              scheme.onSecondary,
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.view_in_ar, size: 48),
                        ),
                      ),
                    ),
                    body: Text(
                      'Comparte enlaces a los archivos clave sin perder el contexto visual.',
                      style: textTheme.bodyMedium,
                    ),
                    size: PragmaCardSize.small,
                    variant: PragmaCardVariant.outlined,
                    actions: <Widget>[
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.visibility_outlined),
                        label: const Text('Abrir preview'),
                      ),
                    ],
                  ),
                  const SizedBox(height: PragmaSpacing.lg),
                  PragmaColorTokenRowWidget(
                    token: _current.colorFor('primary'),
                    enabled: false,
                    hexFieldLabel: 'Hex',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _replaceTheme(ModelThemePragma theme) {
    setState(() {
      _current = theme;
      _previewTheme = PragmaThemeBuilder.buildTheme(theme);
    });
    widget.onChanged?.call(theme);
  }

  Future<void> _copyJson(String payload) async {
    await Clipboard.setData(ClipboardData(text: payload));
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Theme JSON copiado al portapapeles.')),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/localization/generated/app_localizations.dart';
import '../../../../common/localization/locale_cubit.dart';
import '../../../../common/network/local_storage_service.dart';
import '../../../../common/theme/theme_cubit.dart';
import '../../../../common/utils/f1_colors.dart';
import '../../../driver/domain/i_driver_repository.dart';
import '../../../driver/domain/driver_model.dart';
import '../../../constructor/domain/constructor_repository.dart';
import '../../../constructor/domain/constructor_model.dart';
import '../../../widgets/data/desktop_widget_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _favDriver1 = 'verstappen';
  String _favDriver2 = 'piastri';
  String _favTeam = 'red_bull';

  bool _is24Hour = true;
  bool _isDetailedResults = false;
  String _unitSystem = 'Метрика';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _favDriver1 = LocalStorageService.getString('fav_driver_1') ?? 'verstappen';
      _favDriver2 = LocalStorageService.getString('fav_driver_2') ?? 'piastri';
      _favTeam = LocalStorageService.getString('fav_team') ?? 'red_bull';

      final h24 = LocalStorageService.getString('is_24_hour');
      _is24Hour = h24 == null ? true : (h24 == 'true');

      final det = LocalStorageService.getString('is_detailed_results');
      _isDetailedResults = det == 'true';

      _unitSystem = LocalStorageService.getString('unit_system') ?? 'Метрика';
    });
  }

  String _getDriverNum(String driverId) {
    switch (driverId.toLowerCase()) {
      case 'verstappen': return '1';
      case 'piastri': return '81';
      case 'leclerc': return '16';
      case 'hamilton': return '44';
      case 'norris': return '4';
      case 'sainz': return '55';
      case 'russell': return '63';
      case 'perez': return '11';
      case 'alonso': return '14';
      case 'stroll': return '18';
      case 'tsunoda': return '22';
      case 'lawson': return '30';
      case 'gasly': return '10';
      case 'ocon': return '31';
      case 'albon': return '23';
      case 'colapinto': return '43';
      case 'magnussen': return '20';
      case 'hulkenberg': return '27';
      case 'bottas': return '77';
      case 'zhou': return '24';
      case 'bearman': return '38';
      case 'antonelli': return '12';
      case 'bortoleto': return '5';
      case 'hadjar': return '6';
      default: return '3';
    }
  }

  String _getDriverTeam(String driverId) {
    switch (driverId.toLowerCase()) {
      case 'verstappen': case 'perez': case 'lawson': case 'hadjar':
        return 'Red Bull Racing';
      case 'piastri': case 'norris':
        return 'McLaren';
      case 'leclerc': case 'sainz':
        return 'Ferrari';
      case 'hamilton': case 'russell': case 'antonelli':
        return 'Mercedes';
      case 'alonso': case 'stroll':
        return 'Aston Martin';
      case 'gasly': case 'ocon': case 'doohan':
        return 'Alpine';
      case 'albon': case 'colapinto':
        return 'Williams';
      case 'tsunoda':
        return 'Racing Bulls';
      case 'hulkenberg': case 'magnussen':
        return 'Haas';
      case 'bottas': case 'zhou': case 'bortoleto':
        return 'Sauber';
      default:
        return 'Red Bull Racing';
    }
  }

  void _openSelectDriverSheet(int driverIndex) async {
    List<DriverModel> allDrivers = [];
    try {
      allDrivers = await context.read<IDriverRepository>().getDrivers();
    } catch (_) {}

    if (!mounted) return;

    final selectedId = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return _SelectDriverModal(
          drivers: allDrivers,
          getDriverNum: _getDriverNum,
          getDriverTeam: _getDriverTeam,
        );
      },
    );

    if (selectedId != null && selectedId.isNotEmpty) {
      if (driverIndex == 1) {
        await LocalStorageService.setString('fav_driver_1', selectedId);
      } else {
        await LocalStorageService.setString('fav_driver_2', selectedId);
      }
      _loadSettings();
    }
  }

  void _openSelectTeamSheet() async {
    List<ConstructorModel> allTeams = [];
    try {
      allTeams = await context.read<IConstructorRepository>().getConstructors();
    } catch (_) {}

    if (!mounted) return;

    final selectedId = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return _SelectTeamModal(
          teams: allTeams,
          currentSelected: _favTeam,
        );
      },
    );

    if (selectedId != null && selectedId.isNotEmpty) {
      await LocalStorageService.setString('fav_team', selectedId);
      _loadSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentTheme = context.watch<ThemeCubit>().state;
    final currentLocale = context.watch<LocaleCubit>().state;

    final team1Name = _getDriverTeam(_favDriver1);
    final team1Color = F1Colors.getTeamColor(team1Name);

    final team2Name = _getDriverTeam(_favDriver2);
    final team2Color = F1Colors.getTeamColor(team2Name);

    final favTeamColor = F1Colors.getTeamColor(_favTeam);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.settingsTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.favoritesSection,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openSelectDriverSheet(1),
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: team1Color,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getDriverNum(_favDriver1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.unfold_more,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: GestureDetector(
                    onTap: () => _openSelectDriverSheet(2),
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: team2Color,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getDriverNum(_favDriver2),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.unfold_more,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: GestureDetector(
                    onTap: _openSelectTeamSheet,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: favTeamColor,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              _favTeam.toUpperCase().replaceAll('_', ' '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.unfold_more,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            Text(
              l10n.generalSection,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF141416),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                children: [
                  _buildSettingRow(
                    icon: Icons.notifications_none_outlined,
                    title: l10n.notifications,
                    trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                    onTap: () {},
                  ),
                  _buildDivider(),

                  _buildSettingRow(
                    icon: Icons.contrast,
                    title: l10n.appTheme,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currentTheme == ThemeMode.system
                              ? l10n.themeSystem
                              : (currentTheme == ThemeMode.dark ? l10n.themeDark : l10n.themeLight),
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.unfold_more, color: Colors.white54, size: 16),
                      ],
                    ),
                    onTap: () => context.read<ThemeCubit>().toggleTheme(),
                  ),
                  _buildDivider(),

                  _buildSettingRow(
                    icon: Icons.speed,
                    title: l10n.unitSystem,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _unitSystem,
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.unfold_more, color: Colors.white54, size: 16),
                      ],
                    ),
                    onTap: () {
                      final newSys = _unitSystem == 'Метрика' ? 'Имперская' : 'Метрика';
                      setState(() => _unitSystem = newSys);
                      LocalStorageService.setString('unit_system', newSys);
                    },
                  ),
                  _buildDivider(),

                  _buildSettingRow(
                    icon: Icons.access_time,
                    title: l10n.timeFormat24,
                    trailing: Switch(
                      value: _is24Hour,
                      activeTrackColor: Colors.redAccent,
                      onChanged: (val) {
                        setState(() => _is24Hour = val);
                        LocalStorageService.setString('is_24_hour', val.toString());
                      },
                    ),
                  ),
                  _buildDivider(),

                  _buildSettingRow(
                    icon: Icons.view_agenda_outlined,
                    title: l10n.detailedResults,
                    trailing: Switch(
                      value: _isDetailedResults,
                      activeTrackColor: Colors.redAccent,
                      onChanged: (val) {
                        setState(() => _isDetailedResults = val);
                        LocalStorageService.setString('is_detailed_results', val.toString());
                      },
                    ),
                  ),
                  _buildDivider(),

                  _buildSettingRow(
                    icon: Icons.translate,
                    title: l10n.language,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currentLocale.languageCode == 'ru' ? 'Русский' : 'English',
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right, color: Colors.white54, size: 18),
                      ],
                    ),
                    onTap: () => context.read<LocaleCubit>().toggleLocale(),
                  ),
                  _buildDivider(),

                  _buildSettingRow(
                    icon: Icons.widgets_outlined,
                    title: 'Виджет часов на рабочий стол',
                    trailing: const Icon(Icons.add_circle_outline, color: Colors.redAccent, size: 22),
                    onTap: () async {
                      final success = await DesktopWidgetService.createClockWidget();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? 'Виджет часов создан на рабочем столе!'
                                  : 'Не удалось создать виджет',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.white.withValues(alpha: 0.08), height: 1);
  }
}

class _SelectDriverModal extends StatefulWidget {
  final List<DriverModel> drivers;
  final String Function(String) getDriverNum;
  final String Function(String) getDriverTeam;

  const _SelectDriverModal({
    required this.drivers,
    required this.getDriverNum,
    required this.getDriverTeam,
  });

  @override
  State<_SelectDriverModal> createState() => _SelectDriverModalState();
}

class _SelectDriverModalState extends State<_SelectDriverModal> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final displayDrivers = widget.drivers.where((d) {
      if (_search.isEmpty) return true;
      final q = _search.toLowerCase();
      return d.name.toLowerCase().contains(q) || d.teamName.toLowerCase().contains(q);
    }).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          color: Colors.black,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2C2E),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          l10n.cancel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        l10n.selectDriver,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 60),
                  ],
                ),
              ),
              Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),

              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: displayDrivers.length,
                  itemBuilder: (context, index) {
                    final driver = displayDrivers[index];
                    final num = widget.getDriverNum(driver.id);
                    final team = widget.getDriverTeam(driver.id);
                    final teamColor = F1Colors.getTeamColor(team);

                    return Column(
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pop(driver.id),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 44,
                                  child: Text(
                                    num,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: teamColor,
                                      fontStyle: FontStyle.italic,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    driver.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(color: Colors.white.withValues(alpha: 0.06), height: 1),
                      ],
                    );
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: l10n.searchDriver,
                    hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54, size: 20),
                    filled: true,
                    fillColor: const Color(0xFF2C2C2E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  ),
                  onChanged: (val) => setState(() => _search = val),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SelectTeamModal extends StatefulWidget {
  final List<ConstructorModel> teams;
  final String currentSelected;

  const _SelectTeamModal({
    required this.teams,
    required this.currentSelected,
  });

  @override
  State<_SelectTeamModal> createState() => _SelectTeamModalState();
}

class _SelectTeamModalState extends State<_SelectTeamModal> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final displayTeams = widget.teams.where((t) {
      if (_search.isEmpty) return true;
      final q = _search.toLowerCase();
      return t.name.toLowerCase().contains(q) || t.id.toLowerCase().contains(q);
    }).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          color: Colors.black,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2C2E),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          l10n.cancel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        l10n.selectTeam,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 60),
                  ],
                ),
              ),
              Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),

              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: displayTeams.length,
                  itemBuilder: (context, index) {
                    final team = displayTeams[index];
                    final isSelected = team.id.toLowerCase() == widget.currentSelected.toLowerCase();

                    return Column(
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pop(team.id),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            child: Row(
                              children: [
                                _TeamBadge(
                                  teamId: team.id,
                                  teamName: team.name,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    team.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check,
                                    color: Colors.redAccent,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Divider(color: Colors.white.withValues(alpha: 0.06), height: 1),
                      ],
                    );
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: l10n.searchTeam,
                    hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54, size: 20),
                    filled: true,
                    fillColor: const Color(0xFF2C2C2E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  ),
                  onChanged: (val) => setState(() => _search = val),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TeamBadge extends StatelessWidget {
  final String teamId;
  final String teamName;

  const _TeamBadge({
    required this.teamId,
    required this.teamName,
  });

  String _getLogoFileName() {
    final lower = '$teamId $teamName'.toLowerCase();
    if (lower.contains('ferrari')) return 'ferrari';
    if (lower.contains('mercedes')) return 'mercedes';
    if (lower.contains('red_bull') || lower.contains('red bull')) return 'red_bull';
    if (lower.contains('mclaren')) return 'mclaren';
    if (lower.contains('aston')) return 'aston_martin';
    if (lower.contains('alpine')) return 'alpine';
    if (lower.contains('rb') || lower.contains('racing_bulls') || lower.contains('racing bulls')) return 'racing_bulls';
    if (lower.contains('haas')) return 'haas';
    if (lower.contains('williams')) return 'williams';
    if (lower.contains('sauber') || lower.contains('kick')) return 'sauber';
    return teamId.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final fileName = _getLogoFileName();
    final assetPath = 'assets/images/team_logo/$fileName.png';
    final teamColor = F1Colors.getTeamColor(teamName);

    return Image.asset(
      assetPath,
      width: 32,
      height: 32,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _buildFallbackBadge(teamColor),
    );
  }

  Widget _buildFallbackBadge(Color teamColor) {
    final lower = '$teamId $teamName'.toLowerCase();
    if (lower.contains('ferrari')) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFFFE000),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black26, width: 1),
        ),
        child: const Center(
          child: Icon(Icons.shield, color: Colors.black, size: 18),
        ),
      );
    }
    if (lower.contains('mercedes')) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          shape: BoxShape.circle,
          border: Border.all(color: teamColor, width: 1.5),
        ),
        child: Icon(Icons.star_outline, color: teamColor, size: 18),
      );
    }
    if (lower.contains('mclaren')) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: teamColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Icon(Icons.speed, color: Colors.black, size: 18),
        ),
      );
    }
    if (lower.contains('red_bull') || lower.contains('red bull')) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFF1E2442),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: teamColor, width: 1.5),
        ),
        child: const Center(
          child: Icon(Icons.sports_motorsports, color: Color(0xFFE80020), size: 18),
        ),
      );
    }
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: teamColor, width: 1.5),
      ),
      child: Icon(Icons.shield_outlined, color: teamColor, size: 18),
    );
  }
}
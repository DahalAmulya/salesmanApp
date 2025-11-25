import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../routes/route_generator_constants.dart';
import '../../../../../themes/custom_colors.dart';
import '../../../../../widgets/app_bars/custom_app_bars.dart';
import '../../../../../widgets/buttons/elevated_button.dart';
import '../../../../../widgets/containers/custom_container.dart';
import '../../../../../widgets/drop_downs/custom_dropdown.dart';
import '../../../../../widgets/expansion_tile/custom_expansiontile.dart';
import '../../../../../widgets/text_fields/text_from_field.dart';
import '../../../../../widgets/texts/custom_text.dart';
import '../../../mr_admin_providers/mr_admin_referral log_provider.dart';

class ReferralLogScreen extends StatefulWidget {
  const ReferralLogScreen({super.key});

  @override
  State<ReferralLogScreen> createState() => _ReferralLogScreenState();
}

class _ReferralLogScreenState extends State<ReferralLogScreen>
    with SingleTickerProviderStateMixin {
  bool _animateList = false;
  double _screenWidth = 0;
  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.98,
      upperBound: 1.02,
    )..repeat(reverse: true);

    final mr = Provider.of<MrAdminReferralLogProvider>(context, listen: false);
    mr.getDataForDistrict();
    mr.getDataForState();
    mr.getVisitLogsList(context);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _stagger() {
    setState(() => _animateList = false);
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) setState(() => _animateList = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      onPopInvoked: (didpop) {
        if (didpop) return;
        Navigator.of(context).pop(MarketingManagerConstants.homePage);
      },
      child: GestureDetector(
        onTap: () {
          final currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            FocusScope.of(context).unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: CustomColors.primaryWhite,
          appBar: _appBar(context),
          body: _body(context),
        ),
      ),
    );
  }

  PreferredSize _appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Consumer<MrAdminReferralLogProvider>(
        builder: (context, mr, _) {
          return CustomAppBar(
            tabName: 'Referral Report',
            centerTitle: true,
            automaticallyImplyLeading: true,
            showTrailingIcons: true,
            showApproveButton: true,
            onTapTrailingApproveIcon: () {
              mr.updateApprovalStatus(context);
            },
            onTap: () {
              Navigator.of(context).pop(MarketingManagerConstants.homePage);
            },
          );
        },
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Consumer<MrAdminReferralLogProvider>(
      builder: (context, mr, _) {
        final hasData = mr.patientReferralModel.data != null &&
            mr.patientReferralModel.data!.isNotEmpty;

        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 300));
            mr.getVisitLogsList(context);
          },
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              const SizedBox(height: 12),

              // Sticky-ish summary card (appears when data is present)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: hasData
                    ? Padding(
                        key: const ValueKey('summary'),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: _summaryHeader(context, mr),
                      )
                    : const SizedBox.shrink(key: ValueKey('nosummary')),
              ),

              const SizedBox(height: 12),

              // FILTERS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _filters(context, mr),
              ),

              const SizedBox(height: 12),

              // RESULT HEADER + DOWNLOAD
              if (hasData)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _resultHeader(context, mr),
                ),

              const SizedBox(height: 8),

              // LIST
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: hasData
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: _referralList(context, mr),
                      )
                    : _emptyState(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _summaryHeader(BuildContext context, MrAdminReferralLogProvider mr) {
    final username = mr.patientReferralModel.data![0].userId.username;
    final profile = mr.patientReferralModel.data![0].userId.profileImage ?? '';

    final total = mr.patientReferralModel.data!.length;

    return ScaleTransition(
      scale: _pulseCtrl,
      child: CustomContainer(
        horizontalPad: 16,
        verticalPad: 16,
        applyShadow: true,
        child: Row(
          children: [
            _safeAvatar(profile, username),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: username, isSubHeading: true),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _miniInfo('', mr.from),
                      _dot(),
                      _miniInfo('', mr.to),
                      // _dot(),
                      // _miniInfo(
                      //   mr.selectedReferralType == 'Country'
                      //       ? 'Country'
                      //       : mr.selectedReferralType == 'Region'
                      //       ? 'Region'
                      //       : 'City',
                      //   mr.selectedReferralType == 'Country'
                      //       ? mr.selectedCountry
                      //       : mr.selectedReferralType == 'City'
                      //       ? mr.selectedCities
                      //       : mr.selectedReferralType == 'Region'
                      //       ? mr.selectedDistrict
                      //       : mr.selectedState,
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            _animatedCount('Total', total),
          ],
        ),
      ),
    );
  }

  Widget _miniInfo(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // CustomText(text: '$label: ', isContent: true),
        CustomText(text: value, isContent: true),
      ],
    );
  }

  Widget _dot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          color: CustomColors.primaryBlack.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _animatedCount(String label, int value) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: const Duration(milliseconds: 700),
      builder: (context, v, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomText(text: label, isContent: true),
            CustomText(
              text: '$v',
              isSubHeading: true,
            ),
          ],
        );
      },
    );
  }

  Widget _filters(BuildContext context, MrAdminReferralLogProvider mr) {
    return CustomContainer(
      horizontalPad: 0,
      verticalPad: 0,
      color: Colors.transparent,
      child: CustomExpansionTile(
        initiallyExpanded: mr.isExpanded,
        applyAllBorderRadius: true,
        title: 'Filters',
        size: 20,
        fontWeight: FontWeight.w600,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(FontAwesomeIcons.sliders),
            const SizedBox(width: 8),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Column(
              children: [
                // User selection
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        labelText: 'Select User',
                        items: mr.referralLogsUsersList,
                        value: mr.selectedUser,
                        onChanged: (value) {
                          mr.setSelectedUser(value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Date quick chips
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: mr.referralDateTypeList.map((type) {
                      final selected = mr.selectedDateReferralType == type;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: selected
                              ? CustomColors.primaryColor.withOpacity(0.15)
                              : Colors.transparent,
                          border: Border.all(
                            color: selected
                                ? CustomColors.primaryColor
                                : CustomColors.primaryBlack.withOpacity(0.15),
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            mr.setSelectedVisitType(type);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  selected
                                      ? FontAwesomeIcons.solidCircleCheck
                                      : FontAwesomeIcons.circle,
                                  size: 14,
                                  color: selected
                                      ? CustomColors.primaryColor
                                      : CustomColors.primaryBlack
                                          .withOpacity(0.65),
                                ),
                                const SizedBox(width: 8),
                                CustomText(
                                  text: type,
                                  isContent: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Custom date range
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFromFieldWithPrefixSuffix(
                            labelText: 'From',
                            readOnly: true,
                            controller: mr.fromTextEditingController,
                            onTap: () => mr.selectDateFrom(context),
                            validator: (value) {
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFromFieldWithPrefixSuffix(
                            labelText: 'To',
                            readOnly: true,
                            controller: mr.toTextEditingController,
                            onTap: () => mr.selectDateTo(context),
                            validator: (value) {
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  crossFadeState: mr.selectedDateReferralType == 'Custom'
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 250),
                ),

                const SizedBox(height: 16),

                // Submit button
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        onPressed: () {
                          mr.getPatientReferralByUser(context);
                          _stagger();
                        },
                        height: 50,
                        backgroundColor: CustomColors.primaryColor,
                        widget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(FontAwesomeIcons.magnifyingGlass),
                            const SizedBox(width: 10),
                            CustomText(
                              text: 'Apply Filters',
                              fontWeight: FontWeight.w600,
                              color: CustomColors.primaryBlack,
                              size: 18.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultHeader(BuildContext context, MrAdminReferralLogProvider mr) {
    final total = mr.patientReferralModel.data!.length;

    return CustomContainer(
      horizontalPad: 12,
      verticalPad: 12,
      applyShadow: true,
      child: Row(
        children: [
          const Icon(FontAwesomeIcons.clipboardList),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: 'Referral Log', isSubHeading: true),
                const SizedBox(height: 4),
                CustomText(
                  text: '$total records',
                  isContent: true,
                ),
              ],
            ),
          ),
          CustomElevatedButton(
            onPressed: () {
              mr.downloadReferralReport(context);
            },
            borderColor: CustomColors.jadeGreen,
            widget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FontAwesomeIcons.download, color: CustomColors.jadeGreen),
                const SizedBox(width: 8),
                CustomText(
                  text: 'Download',
                  isContent: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _referralList(BuildContext context, MrAdminReferralLogProvider mr) {
    final list = mr.patientReferralModel.data!;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final patient = list[index];
        final poc = patient.pocId;
        final amb = patient.ambId;

        // animated entrance per item
        final delay = 60 + (index * 35);
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 1, end: 0),
          duration: Duration(milliseconds: 400 + delay),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            final dx = (_animateList ? 0.0 : 1.0) + value;
            return Transform.translate(
              offset: Offset(dx * _screenWidth * 0.08, value * 8),
              child: Opacity(
                opacity: 1 - (value * 0.9),
                child: child,
              ),
            );
          },
          child: CustomContainer(
            horizontalMargin: 0,
            applyShadow: true,
            child: Column(
              children: [
                Row(
                  children: [
                    _indexBadge(index + 1, patient.approvalStatus),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _titleRow(patient.fullName, patient.age),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(FontAwesomeIcons.solidCalendarDays, size: 18),
                    const SizedBox(width: 16),
                    CustomText(text: '${patient.createdAtBS}', isContent: true,),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.note, size: 18),
                    const SizedBox(width: 16),
                    Expanded(child: CustomText(text: '${patient.remarks}', isContent: true, maxLines: 3,)),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),

                _kv('Provisional Diagnosis', patient.provisionalDiagnosis,
                    maxLines: 3),
                const SizedBox(height: 6),

                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _chipKV('Country', patient.country),
                    _chipKV('Region', patient.region),
                    _chipKV('City', patient.city),
                  ],
                ),
                const SizedBox(height: 8),

                const Divider(),
                const SizedBox(height: 8),

                // POC
                Row(
                  children: [
                    _iconLabel(FontAwesomeIcons.userDoctor, 'POC'),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _softPill('Name', poc == null ? 'N/A' : poc.pocName),
                          _softPill('Number', poc == null ? 'N/A' : poc.number),
                          _softPill(
                              'Category', poc == null ? 'N/A' : poc.category),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // AMB
                Row(
                  children: [
                    _iconLabel(FontAwesomeIcons.truckMedical, 'Ambulance'),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _softPill('Driver',
                              amb == null ? 'N/A' : (amb.pocName ?? 'N/A')),
                          _softPill(
                              'Number', amb == null ? 'N/A' : (amb.number)),
                          _softPill('AMB',
                              amb == null ? 'N/A' : (amb.ambNumber ?? 'N/A')),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                _approvalRow(context, mr, index, patient.approvalStatus),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _indexBadge(int index, String status) {
    Color bg;
    if (status == 'Approved') {
      bg = CustomColors.jadeGreen;
    } else if (status == 'Pending') {
      bg = CustomColors.lightYellow;
    } else {
      bg = CustomColors.lightRed;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(FontAwesomeIcons.hashtag, size: 12),
          const SizedBox(width: 6),
          CustomText(text: '$index', isContent: true),
        ],
      ),
    );
  }

  Widget _titleRow(String name, int age) {
    return Row(
      children: [
        Expanded(
          child: CustomText(
            text: name,
            isSubHeading: true,
            maxLines: 4,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: CustomColors.primaryBlack.withOpacity(0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: CustomColors.primaryBlack.withOpacity(0.08),
            ),
          ),
          child: Row(
            children: [CustomText(text: 'Age: '), CustomText(text: '$age')],
          ),
        )
      ],
    );
  }

  Widget _kv(String k, String v, {int? maxLines}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 1,
            child: CustomText(
              text: k,
              isContent: true,
              size: 16,
              maxLines: 2,
            )),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: CustomText(
            text: v,
            isContent: true,
            size: 16,
            maxLines: 3,
          ),
        ),
      ],
    );
  }

  Widget _chipKV(String k, String v) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: CustomColors.primaryBlack.withOpacity(0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(text: '$k: ', isContent: true),
          CustomText(text: v, isContent: true),
        ],
      ),
    );
  }

  Widget _iconLabel(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 6),
        CustomText(text: label, isContent: true),
      ],
    );
  }

  Widget _softPill(String k, String v) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: CustomColors.primaryBlack.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: CustomColors.primaryBlack.withOpacity(0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: CustomText(
            text: '$k: ',
            isContent: true,
            maxLines: 3,
          )),
          Expanded(
              child: CustomText(
            text: v,
            isContent: true,
            maxLines: 3,
          )),
        ],
      ),
    );
  }

  Widget _approvalRow(BuildContext context, MrAdminReferralLogProvider mr,
      int index, String status) {
    Color bg;
    Color textColor = CustomColors.primaryBlack;
    if (status == 'Approved') {
      bg = CustomColors.jadeGreen.withOpacity(0.15);
    } else if (status == 'Pending') {
      bg = CustomColors.lightYellow.withOpacity(0.25);
    } else {
      bg = CustomColors.lightRed.withOpacity(0.15);
    }

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: CustomColors.primaryBlack.withOpacity(0.08),
              ),
            ),
            child: Row(
              children: [
                const Icon(FontAwesomeIcons.circleCheck, size: 14),
                const SizedBox(width: 8),
                CustomText(text: 'Status', isContent: true),
                const Spacer(),
                // Container(
                //   padding:
                //   const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(24),
                //     border: Border.all(
                //       color: CustomColors.primaryBlack.withOpacity(0.1),
                //     ),
                //   ),
                //   child: CustomText(text: status, isContent: true),
                // ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.42,
          child: CustomDropdown(
            labelText: '',
            items: mr.approvalType,
            value: status,
            onChanged: (value) {
              if (value != null) {
                mr.approvalStatus(index, value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _emptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 24),
      child: Column(
        children: [
          const Icon(
            FontAwesomeIcons.clipboardQuestion,
            size: 48,
          ),
          const SizedBox(height: 16),
          CustomText(
            text: 'No Referral log found',
            isSubHeading: true,
          ),
          const SizedBox(height: 8),
          CustomText(
            text: 'Try adjusting filters or refreshing.',
            isContent: true,
          ),
        ],
      ),
    );
  }

  Widget _safeAvatar(String profileUrl, String username) {
    if (profileUrl.isEmpty) {
      return CircleAvatar(
        radius: 26,
        backgroundColor: CustomColors.primaryBlack.withOpacity(0.08),
        child: CustomText(
          text: _initials(username),
          isSubHeading: true,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(1000),
      child: SizedBox(
        height: 52,
        width: 52,
        child: Image.network(
          profileUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => CircleAvatar(
            radius: 26,
            backgroundColor: CustomColors.primaryBlack.withOpacity(0.08),
            child: CustomText(
              text: _initials(username),
              isSubHeading: true,
            ),
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return (parts.first.isNotEmpty ? parts.first[0] : '?').toUpperCase();
    }
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.last.isNotEmpty ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }
}

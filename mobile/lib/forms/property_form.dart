import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/property.dart';
import '../widgets/chips_selector.dart';
import '../widgets/agents_selector.dart';
import '../utils/uid.dart';

class PropertyForm extends StatefulWidget {
  final Property? initial;
  final void Function(Property value) onSubmit;
  final String submitLabel;

  const PropertyForm({super.key, this.initial, required this.onSubmit, this.submitLabel = 'Save'});

  @override
  State<PropertyForm> createState() => _PropertyFormState();
}

class _PropertyFormState extends State<PropertyForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _location = TextEditingController();
  final _agentName = TextEditingController(); // deprecated
  List<String> _agentIds = [];
  final _occupancy = TextEditingController();
  String _type = 'Club';

  // common
  final _entryFee = TextEditingController();
  List<String> _themes = [];
  List<String> _amenities = [];

  // farmhouse
  final _entryFee24h = TextEditingController();
  final _entryFeePerHour = TextEditingController();
  final _weekend24h = TextEditingController();
  final _weekendPerHour = TextEditingController();
  final _eventDelta = TextEditingController();

  // banquet
  final _priceRangeHours = TextEditingController();
  final _priceRangeDays = TextEditingController();
  final _discountPercent = TextEditingController();

  List<String> _media = [];
  String? _image;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _name.text = i?.name ?? '';
    _location.text = i?.location ?? '';
    _agentName.text = i?.agentName ?? '';
    _agentIds = [...(i?.agentIds ?? [])];
    _occupancy.text = i?.occupancy?.toString() ?? '';
    _type = i?.type ?? 'Club';
    _entryFee.text = i?.entryFee ?? '';
    _themes = [...(i?.themes ?? [])];
    _amenities = [...(i?.amenities ?? [])];
    _entryFee24h.text = i?.entryFee24h ?? '';
    _entryFeePerHour.text = i?.entryFeePerHour ?? '';
    _weekend24h.text = i?.weekendPrice24h ?? '';
    _weekendPerHour.text = i?.weekendPricePerHour ?? '';
    _eventDelta.text = i?.eventPriceDelta?.toString() ?? '';
    _priceRangeHours.text = i?.priceRangeHours ?? '';
    _priceRangeDays.text = i?.priceRangeDays ?? '';
    _discountPercent.text = i?.discountPercent?.toString() ?? '';
    _media = [...(i?.media ?? [])];
    _image = i?.image;
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage(maxWidth: 2000, maxHeight: 2000, imageQuality: 85);
    if (files.isEmpty) return;
    final items = <String>[];
    for (final f in files) {
      final bytes = await f.readAsBytes();
      items.add(_base64DataUrl(bytes, 'image/${f.path.split('.').last}'));
    }
    setState(() {
      _media.addAll(items);
      _image ??= items.first;
    });
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final f = await picker.pickVideo(source: ImageSource.gallery, maxDuration: const Duration(minutes: 2));
    if (f == null) return;
    final bytes = await f.readAsBytes();
    setState(() {
      _media.add(_base64DataUrl(bytes, 'video/${f.path.split('.').last}'));
    });
  }

  String _base64DataUrl(Uint8List bytes, String mime) {
    final b64 = base64Encode(bytes);
    return 'data:$mime;base64,$b64';
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final p = Property(
      id: widget.initial?.id ?? uid(),
      name: _name.text.trim(),
      location: _location.text.trim(),
      agentName: _agentName.text.trim().isEmpty ? null : _agentName.text.trim(),
      agentIds: _agentIds.isEmpty ? null : _agentIds,
      type: _type,
      occupancy: _occupancy.text.trim().isEmpty ? null : int.tryParse(_occupancy.text.trim()),
      themes: _themes.isEmpty ? null : _themes,
      amenities: _amenities.isEmpty ? null : _amenities,
      image: _image ?? _media.where((m) => m.startsWith('data:image')).cast<String?>().firstOrNull,
      media: _media.isEmpty ? null : _media,
      entryFee: _entryFee.text.trim().isEmpty ? null : _entryFee.text.trim(),
      entryFee24h: _entryFee24h.text.trim().isEmpty ? null : _entryFee24h.text.trim(),
      entryFeePerHour: _entryFeePerHour.text.trim().isEmpty ? null : _entryFeePerHour.text.trim(),
      weekendPrice24h: _weekend24h.text.trim().isEmpty ? null : _weekend24h.text.trim(),
      weekendPricePerHour: _weekendPerHour.text.trim().isEmpty ? null : _weekendPerHour.text.trim(),
      eventPriceDelta: _eventDelta.text.trim().isEmpty ? null : int.tryParse(_eventDelta.text.trim()),
      priceRangeHours: _priceRangeHours.text.trim().isEmpty ? null : _priceRangeHours.text.trim(),
      priceRangeDays: _priceRangeDays.text.trim().isEmpty ? null : _priceRangeDays.text.trim(),
      discountPercent: _discountPercent.text.trim().isEmpty ? null : int.tryParse(_discountPercent.text.trim()),
      verified: widget.initial?.verified,
      totalBookings: widget.initial?.totalBookings,
    );
    widget.onSubmit(p);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text('Basic Info', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          ),
          TextFormField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (v) => v == null || v.trim().isEmpty ? 'Enter name' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _location,
            decoration: const InputDecoration(labelText: 'Location (Area, City)'),
            validator: (v) => v == null || v.trim().isEmpty ? 'Enter location' : null,
          ),
          const SizedBox(height: 12),
          AgentsSelector(initial: _agentIds, onChanged: (v) => _agentIds = v),
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 6),
            child: Text('Property Type', style: Theme.of(context).textTheme.titleMedium),
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final t in [
                ['Club', Icons.nightlife, 'Club'],
                ['Bar', Icons.liquor, 'Bar'],
                ['Restaurant', Icons.restaurant, 'Restaurant'],
                ['Restaurant & Bar', Icons.restaurant_menu, 'Restaurant & Bar'],
                ['Farmhouse', Icons.villa, 'Farmhouse'],
                ['Banquet', Icons.celebration, 'Banquet'],
              ])
                ChoiceChip(
                  selected: _type == t[0],
                  onSelected: (_) => setState(() => _type = t[0] as String),
                  label: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(t[1] as IconData, size: 18),
                    const SizedBox(width: 6),
                    Text(t[2] as String),
                  ]),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _occupancy,
            decoration: const InputDecoration(labelText: 'Occupancy (optional)'),
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 8),
          if (_type == 'Club' || _type == 'Bar' || _type == 'Restaurant' || _type == 'Restaurant & Bar') ...[
            TextFormField(controller: _entryFee, decoration: const InputDecoration(labelText: 'Entry Fee (optional)')),
            const SizedBox(height: 8),
            ChipsSelector(
              label: 'Themes',
              options: const ['DJ', 'Bollywood', 'Sufi', 'Live Band', 'Ladies Night', 'Karaoke', 'Jazz', 'Rock', 'Hip Hop'],
              initial: _themes,
              onChanged: (v) => _themes = v,
              hintAddCustom: 'Add custom themes (comma separated)',
            ),
            const SizedBox(height: 8),
            ChipsSelector(
              label: 'Amenities',
              options: const ['Parking', 'Valet', 'Smoking Area', 'Pet Friendly', 'Rooftop', 'WiFi', 'AC', 'Dance Floor', 'VIP Section'],
              initial: _amenities,
              onChanged: (v) => _amenities = v,
              hintAddCustom: 'Add custom amenities (comma separated)',
            ),
          ],

          if (_type == 'Farmhouse') ...[
            Row(children: [
              Expanded(child: TextFormField(controller: _entryFee24h, decoration: const InputDecoration(labelText: 'Entry Fee 24h'))),
              const SizedBox(width: 12),
              Expanded(child: TextFormField(controller: _entryFeePerHour, decoration: const InputDecoration(labelText: 'Entry Fee / hour'))),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: TextFormField(controller: _weekend24h, decoration: const InputDecoration(labelText: 'Weekend 24h'))),
              const SizedBox(width: 12),
              Expanded(child: TextFormField(controller: _weekendPerHour, decoration: const InputDecoration(labelText: 'Weekend / hour'))),
            ]),
            const SizedBox(height: 8),
            TextFormField(controller: _eventDelta, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Event Price Delta %')),
            const SizedBox(height: 8),
            ChipsSelector(
              label: 'Themes',
              options: const ['Pool Party', 'BBQ', 'Wedding', 'Corporate', 'Birthday', 'Family Gathering', 'Festival', 'Retreat', 'Adventure'],
              initial: _themes,
              onChanged: (v) => _themes = v,
              hintAddCustom: 'Add custom themes (comma separated)',
            ),
            const SizedBox(height: 8),
            ChipsSelector(
              label: 'Amenities',
              options: const ['Swimming Pool', 'Garden', 'Parking', 'Kitchen', 'BBQ Area', 'WiFi', 'AC Rooms', 'Outdoor Games', 'Security'],
              initial: _amenities,
              onChanged: (v) => _amenities = v,
              hintAddCustom: 'Add custom amenities (comma separated)',
            ),
          ],

          if (_type == 'Banquet') ...[
            Row(children: [
              Expanded(child: TextFormField(controller: _priceRangeHours, decoration: const InputDecoration(labelText: 'Price Range (per hour)'))),
              const SizedBox(width: 12),
              Expanded(child: TextFormField(controller: _priceRangeDays, decoration: const InputDecoration(labelText: 'Price Range (per day)'))),
            ]),
            const SizedBox(height: 8),
            TextFormField(controller: _discountPercent, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Discount %')),
            const SizedBox(height: 8),
            ChipsSelector(
              label: 'Themes',
              options: const ['Wedding', 'Corporate', 'Birthday', 'Engagement', 'Anniversary', 'Reception', 'Conference', 'Seminar', 'Gala'],
              initial: _themes,
              onChanged: (v) => _themes = v,
              hintAddCustom: 'Add custom themes (comma separated)',
            ),
            const SizedBox(height: 8),
            ChipsSelector(
              label: 'Amenities',
              options: const ['AC Hall', 'Parking', 'Stage', 'Catering', 'Sound System', 'Lighting', 'Projector', 'WiFi', 'Decoration'],
              initial: _amenities,
              onChanged: (v) => _amenities = v,
              hintAddCustom: 'Add custom amenities (comma separated)',
            ),
          ],

          const SizedBox(height: 16),
          Text('Media', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: [
            OutlinedButton.icon(onPressed: _pickImages, icon: const Icon(Icons.image), label: const Text('Add Images')),
            OutlinedButton.icon(onPressed: _pickVideo, icon: const Icon(Icons.videocam), label: const Text('Add Video')),
          ]),
          const SizedBox(height: 10),
          if (_media.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 1),
              itemCount: _media.length,
              itemBuilder: (_, i) {
                final m = _media[i];
                return Stack(children: [
                  Positioned.fill(
                    child: m.startsWith('data:video')
                        ? Container(color: Colors.black12, child: const Center(child: Icon(Icons.videocam)))
                        : ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.memory(base64Decode(m.split(',').last), fit: BoxFit.cover)),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.black45,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 16,
                        onPressed: () => setState(() => _media.removeAt(i)),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  )
                ]);
              },
            ),

          const SizedBox(height: 20),
          FilledButton(onPressed: _submit, child: Text(widget.submitLabel)),
        ],
      ),
    );
  }
}

extension<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}


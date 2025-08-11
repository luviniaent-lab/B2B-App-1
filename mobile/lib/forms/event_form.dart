import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import '../models/event.dart';
import '../data/app_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/uid.dart';
import 'package:intl/intl.dart';

class EventForm extends ConsumerStatefulWidget {
  final EventItem? initial;
  final void Function(EventItem value) onSubmit;
  final String submitLabel;

  const EventForm({super.key, this.initial, required this.onSubmit, this.submitLabel = 'Save'});

  @override
  ConsumerState<EventForm> createState() => _EventFormState();
}

class _EventFormState extends ConsumerState<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _date = TextEditingController();
  final _startTime = TextEditingController();
  final _price = TextEditingController();
  final _limit = TextEditingController();
  final _description = TextEditingController();
  bool _published = true;
  List<String> _propertyIds = [];
  String? _image;
  String? _video;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _title.text = i?.title ?? '';
    _date.text = i?.date ?? '';
    _startTime.text = i?.startTime ?? '';
    _price.text = i?.price ?? '';
    _limit.text = i?.bookingLimit?.toString() ?? '';
    _published = i?.published ?? true;
    _propertyIds = List<String>.from(i?.propertyIds ?? []);
    _image = i?.image;
    _description.text = i?.description ?? '';
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_propertyIds.isEmpty) return; // require at least one property
    final e = EventItem(
      id: widget.initial?.id ?? uid(),
      title: _title.text.trim(),
      date: _date.text.trim(),
      startTime: _startTime.text.trim().isEmpty ? null : _startTime.text.trim(),
      price: _price.text.trim().isEmpty ? null : _price.text.trim(),
      bookingLimit: _limit.text.trim().isEmpty ? null : int.tryParse(_limit.text.trim()),
      image: _image,
      video: _video,
      published: _published,
      status: widget.initial?.status ?? 'active',
      bookingsCount: widget.initial?.bookingsCount,
      propertyIds: _propertyIds,
      description: _description.text.trim().isEmpty ? null : _description.text.trim(),
    );
    widget.onSubmit(e);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final f = await picker.pickImage(source: ImageSource.gallery, maxWidth: 2000, maxHeight: 2000, imageQuality: 85);
    if (f == null) return;
    final bytes = await f.readAsBytes();
    setState(() => _image = 'data:image/${f.path.split('.').last};base64,${base64Encode(bytes)}');
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final f = await picker.pickVideo(source: ImageSource.gallery, maxDuration: const Duration(minutes: 2));
    if (f == null) return;
    final bytes = await f.readAsBytes();
    setState(() => _video = 'data:video/${f.path.split('.').last};base64,${base64Encode(bytes)}');
  }

  Future<void> _generateCover() async {
    // Placeholder generation: solid color PNG (1x1) base64 to simulate generated cover
    final png1x1Base64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAukB9TAb0R8AAAAASUVORK5CYII=';
    setState(() => _image = 'data:image/png;base64,$png1x1Base64');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    final props = state.properties;
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text('Basic Info', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        ),
        TextFormField(controller: _title, decoration: const InputDecoration(labelText: 'Title'), validator: (v) => v!.trim().isEmpty ? 'Enter title' : null),
        const SizedBox(height: 18),
        Row(children: [
          Expanded(child: TextFormField(
            controller: _date,
            decoration: const InputDecoration(
              labelText: 'Date (DDMMYYYY)',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                _date.text = DateFormat('ddMMyyyy').format(date);
              }
            },
          )),
          const SizedBox(width: 16),
          Expanded(child: TextFormField(controller: _startTime, decoration: const InputDecoration(labelText: 'Start Time (HH:mm)'))),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: TextFormField(controller: _price, decoration: const InputDecoration(labelText: 'Price (optional)'))),
          const SizedBox(width: 16),
          Expanded(child: TextFormField(controller: _limit, decoration: const InputDecoration(labelText: 'Maximum Booking (optional)'), keyboardType: TextInputType.number)),
        ]),
        const SizedBox(height: 16),
        TextFormField(controller: _description, maxLines: 4, decoration: const InputDecoration(labelText: 'Description (optional)')),

        Padding(
          padding: const EdgeInsets.only(top: 14.0, bottom: 8.0),
          child: Text('Properties', style: Theme.of(context).textTheme.titleMedium),
        ),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final p in props)
            FilterChip(
              label: Text('${p.name} — ${p.location}'),
              selected: _propertyIds.contains(p.id),
              onSelected: (sel) => setState(() {
                if (sel) {
                  _propertyIds.add(p.id);
                } else {
                  _propertyIds.remove(p.id);
                }
              }),
            ),
        ]),
        if (_propertyIds.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text('Select at least one property', style: TextStyle(color: Colors.red, fontSize: 12)),
          ),
        const SizedBox(height: 12),
        Wrap(spacing: 8, children: [
          OutlinedButton.icon(onPressed: _pickImage, icon: const Icon(Icons.image), label: const Text('Add Cover')),
          OutlinedButton.icon(onPressed: _pickVideo, icon: const Icon(Icons.videocam), label: const Text('Add Video')),
          OutlinedButton.icon(onPressed: _generateCover, icon: const Icon(Icons.auto_awesome), label: const Text('Generate Cover')),
        ]),
        if (_image != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _image!.startsWith('data:')
                  ? Image.memory(base64Decode(_image!.split(',').last), height: 140, fit: BoxFit.cover)
                  : Image.network(_image!, height: 140, fit: BoxFit.cover),
            ),
          ),
        if (_video != null)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(children: [Icon(Icons.videocam), SizedBox(width: 6), Text('Video selected')]),
          ),

        SwitchListTile(
          value: _published,
          onChanged: (v) => setState(() => _published = v),
          title: const Text('Published'),
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 22),
        Align(alignment: Alignment.centerRight, child: FilledButton(onPressed: _submit, child: Text(widget.submitLabel))),
      ]),
    );
  }
}


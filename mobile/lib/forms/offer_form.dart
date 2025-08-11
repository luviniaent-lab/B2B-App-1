import 'package:flutter/material.dart';
import '../models/offer.dart';
import '../data/app_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/uid.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class OfferForm extends ConsumerStatefulWidget {
  final Offer? initial;
  final void Function(Offer value) onSubmit;
  final String submitLabel;
  const OfferForm({super.key, this.initial, required this.onSubmit, this.submitLabel = 'Save'});
  @override
  ConsumerState<OfferForm> createState() => _OfferFormState();
}

class _OfferFormState extends ConsumerState<OfferForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _startDate = TextEditingController();
  final _endDate = TextEditingController();
  final _discountType = TextEditingController();
  final _amount = TextEditingController();
  final _status = TextEditingController(text: 'active');
  List<String> _propertyIds = [];

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _name.text = i?.name ?? '';
    _description.text = i?.description ?? '';
    _startDate.text = i?.startDate ?? '';
    _endDate.text = i?.endDate ?? '';
    _discountType.text = i?.discountType ?? '';
    _amount.text = i?.amount ?? '';
    _status.text = i?.status ?? 'active';
    _propertyIds = List<String>.from(i?.propertyIds ?? []);
  }

  String? _image;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_propertyIds.isEmpty) return;
    final o = Offer(
      id: widget.initial?.id ?? uid(),
      name: _name.text.trim(),
      description: _description.text.trim().isEmpty ? null : _description.text.trim(),
      startDate: _startDate.text.trim(),
      endDate: _endDate.text.trim(),
      discountType: _discountType.text.trim().isEmpty ? null : _discountType.text.trim(),
      amount: _amount.text.trim().isEmpty ? null : _amount.text.trim(),
      image: _image ?? widget.initial?.image,
      status: _status.text.trim(),
      bookingsCount: widget.initial?.bookingsCount,
      propertyIds: _propertyIds,
    );
    widget.onSubmit(o);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final f = await picker.pickImage(source: ImageSource.gallery, maxWidth: 2000, maxHeight: 2000, imageQuality: 85);
    if (f == null) return;
    final bytes = await f.readAsBytes();
    setState(() => _image = 'data:image/${f.path.split('.').last};base64,${base64Encode(bytes)}');
  }

  Future<void> _generateCover() async {
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
        TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Name'), validator: (v) => v!.trim().isEmpty ? 'Enter name' : null),
        const SizedBox(height: 18),
        TextFormField(controller: _description, decoration: const InputDecoration(labelText: 'Description (optional)')),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: TextFormField(
            controller: _startDate,
            decoration: const InputDecoration(
              labelText: 'Start Date (DDMMYYYY)',
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
                _startDate.text = DateFormat('ddMMyyyy').format(date);
              }
            },
          )),
          const SizedBox(width: 16),
          Expanded(child: TextFormField(
            controller: _endDate,
            decoration: const InputDecoration(
              labelText: 'End Date (DDMMYYYY)',
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
                _endDate.text = DateFormat('ddMMyyyy').format(date);
              }
            },
          )),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: TextFormField(controller: _discountType, decoration: const InputDecoration(labelText: 'Discount Type (Flat/%/BuyXGetY)'))),
          const SizedBox(width: 16),
          Expanded(child: TextFormField(controller: _amount, decoration: const InputDecoration(labelText: 'Amount (optional)'))),
        ]),
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
          OutlinedButton.icon(onPressed: _generateCover, icon: const Icon(Icons.auto_awesome), label: const Text('Generate Cover')),
        ]),
        if ((_image ?? widget.initial?.image) != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ((_image ?? widget.initial!.image)!).startsWith('data:')
                  ? Image.memory(base64Decode((_image ?? widget.initial!.image)!.split(',').last), height: 140, fit: BoxFit.cover)
                  : Image.network((_image ?? widget.initial!.image)!, height: 140, fit: BoxFit.cover),
            ),
          ),
        const SizedBox(height: 22),
        Align(alignment: Alignment.centerRight, child: FilledButton(onPressed: _submit, child: Text(widget.submitLabel))),
      ]),
    );
  }
}


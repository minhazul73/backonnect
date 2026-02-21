import 'package:backonnect/app/theme/app_colors.dart';
import 'package:backonnect/app/theme/app_text_styles.dart';
import 'package:backonnect/core/utils/validators/input_validators.dart';
import 'package:backonnect/features/items/controllers/create_item_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ItemInputForm extends StatelessWidget {
  const ItemInputForm({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CreateItemController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Item Name *'),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl.nameController,
          textInputAction: TextInputAction.next,
          validator: InputValidators.validateName,
          style: const TextStyle(fontSize: 15),
          decoration: const InputDecoration(
            hintText: 'e.g. Laptop, Mouse, USB Cable...',
          ),
        ),
        const SizedBox(height: 20),
        _label('Description'),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl.descriptionController,
          maxLines: 3,
          textInputAction: TextInputAction.next,
          validator: InputValidators.validateDescription,
          style: const TextStyle(fontSize: 15),
          decoration: const InputDecoration(
            hintText: 'Optional description...',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Price *'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: ctrl.priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    textInputAction: TextInputAction.next,
                    validator: InputValidators.validatePrice,
                    style: const TextStyle(fontSize: 15),
                    decoration: const InputDecoration(
                      prefixText: r'$ ',
                      hintText: '0.00',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Tax'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: ctrl.taxController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    textInputAction: TextInputAction.done,
                    validator: InputValidators.validateTax,
                    style: const TextStyle(fontSize: 15),
                    decoration: const InputDecoration(
                      prefixText: r'$ ',
                      hintText: '0.00',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: AppTextStyles.label.copyWith(
        color: AppColors.onSurface,
        fontWeight: FontWeight.w500,
        fontSize: 13,
      ),
    );
  }
}


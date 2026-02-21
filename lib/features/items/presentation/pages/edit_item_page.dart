import 'package:backonnect/app/theme/app_colors.dart';
import 'package:backonnect/features/items/controllers/create_item_controller.dart';
import 'package:backonnect/features/items/presentation/widgets/item_input_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditItemPage extends GetView<CreateItemController> {
  const EditItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(color: AppColors.onSurface),
        title: const Text('Edit Item'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ItemInputForm(),
                const SizedBox(height: 32),
                Obx(() {
                  return ElevatedButton(
                    onPressed:
                        controller.isLoading.value ? null : controller.submit,
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Save Changes'),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

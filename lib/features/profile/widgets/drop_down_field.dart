import 'package:flutter/material.dart';
import 'package:project/features/auth/widgets/registerlogin_text.dart';

class DropdownFormWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final String? value;
  final Color itemColor;
  final List<String> items;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;
  final double? width;
  final Color? dialogBackgroundColor;
  final TextStyle? hintStyle;
  final Map<String, IconData>? itemIcons; // For Material icons (e.g., Year)
  final Map<String, String>? itemImageIcons; // For image assets (e.g., Department)

  const DropdownFormWidget({
    super.key,
    required this.labelText,
    this.value,
    required this.items,
    required this.onChanged,
    required this.hintText,
    this.validator,
    required this.itemColor,
    this.width,
    this.dialogBackgroundColor,
    this.hintStyle,
    this.itemIcons,
    this.itemImageIcons,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RegisterLoginText(regTextContent: labelText),
        const SizedBox(height: 15),
        FormField<String>(
          initialValue: value,
          validator: validator ??
              (val) {
                if (val == null || val.isEmpty) {
                  return 'Please select $labelText';
                }
                return null;
              },
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width ?? double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: state.hasError ? Colors.red : const Color(0xFFC4C4C4),
                      width: 1.0,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(32),
                      onTap: () async {
                        final selectedValue = await showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: dialogBackgroundColor ?? Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 20),
                            content: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  return ListTile(
                                    leading: _buildLeadingIcon(item),
                                    title: Text(
                                      item,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: itemColor,
                                        fontFamily: "Inter",
                                      ),
                                    ),
                                    hoverColor: itemColor.withOpacity(0.1),
                                    onTap: () {
                                      Navigator.of(context).pop(item);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        );

                        if (selectedValue != null) {
                          state.didChange(selectedValue);
                          onChanged(selectedValue);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                state.value?.isNotEmpty == true ? state.value! : hintText,
                                style: state.value?.isNotEmpty == true
                                    ? const TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.black87,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.bold,
                                      )
                                    : (hintStyle ??
                                        const TextStyle(
                                          fontSize: 12.0,
                                          color: Color(0xFFC4C4C4),
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.normal,
                                        )),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down, color: Colors.black54, size: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: Text(
                      state.errorText!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget? _buildLeadingIcon(String item) {
    if (itemIcons != null && itemIcons!.containsKey(item)) {
      return Icon(
        itemIcons![item],
        size: 24,
        color: itemColor,
      );
    }
    if (itemImageIcons != null && itemImageIcons!.containsKey(item)) {
      return Image.asset(
        itemImageIcons![item]!,
        width: 24,
        height: 24,
      );
    }
    return null;
  }
}
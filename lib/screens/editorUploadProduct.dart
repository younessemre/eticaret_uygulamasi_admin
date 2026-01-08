import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ecommerce_flutter_admin/constans/app_constans.dart';
import 'package:ecommerce_flutter_admin/constans/validator.dart';
import 'package:ecommerce_flutter_admin/models/product_model.dart';
import 'package:ecommerce_flutter_admin/services/myapp_functions.dart';
import 'package:ecommerce_flutter_admin/widget/loader_manager.dart';
import 'package:ecommerce_flutter_admin/widget/subtitle_text.dart';
import 'package:ecommerce_flutter_admin/widget/title_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class EditorUploadProductScreen extends StatefulWidget {
  static const routName = "/EditorUploadProductScreen";

  const EditorUploadProductScreen({super.key, this.productModel});

  final ProductModel? productModel;

  @override
  State<EditorUploadProductScreen> createState() =>
      _EditorUploadProductScreenState();
}

class _EditorUploadProductScreenState extends State<EditorUploadProductScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;

  late TextEditingController _titleController,
      _priceController,
      _descriptionController,
      _quanttiyContoller;

  String? _categoryValue;
  bool isEditing = false;
  String? productNetworkImage;
  String? productImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    isEditing = widget.productModel != null;

    if (isEditing) {
      productNetworkImage = widget.productModel!.productImage;
      _categoryValue = widget.productModel!.productCategory;
    }

    _titleController =
        TextEditingController(text: widget.productModel?.productTitle);
    _priceController =
        TextEditingController(text: widget.productModel?.productPrice);
    _descriptionController =
        TextEditingController(text: widget.productModel?.productDescription);
    _quanttiyContoller =
        TextEditingController(text: widget.productModel?.productQuantity);

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _quanttiyContoller.dispose();
    super.dispose();
  }

  void removePickedImage() {
    setState(() {
      _pickedImage = null;
      productNetworkImage = null;
    });
  }

  void clearForm() {
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _quanttiyContoller.clear();
    removePickedImage();
    _categoryValue = null;
    setState(() {});
  }

  //Ürün Ekleme
  Future<void> _addProduct() async {
    if (_pickedImage == null) {
      MyAppFunctions.showErrorOrWaningDialog(
        context: context,
        subtitle: "Lütfen bir fotoğraf ekleyin",
        fct: () {},
      );
      return;
    }

    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) return;

    try {
      setState(() => _isLoading = true);

      //Resim yükleme
      final ref = FirebaseStorage.instance
          .ref()
          .child("productImages")
          .child("${_titleController.text.trim()}.jpg");

      await ref.putFile(
        File(_pickedImage!.path),
        SettableMetadata(contentType: "image/jpeg"),
      );
      productImageUrl = await ref.getDownloadURL();

      //Verileri veritabanına yazdırma
      final productId = const Uuid().v4();
      await FirebaseFirestore.instance
          .collection("products")
          .doc(productId)
          .set({
        'productId': productId,
        'productTitle': _titleController.text.trim(),
        'productPrice': _priceController.text.trim(),
        'productCategory': _categoryValue,
        'productDescription': _descriptionController.text.trim(),
        'productImage': productImageUrl,
        'productQuantity': _quanttiyContoller.text.trim(),
        'createdAt': Timestamp.now(),
      });

      Fluttertoast.showToast(
          msg: "Ürün başarıyla eklendi!", textColor: Colors.green);

      if (!mounted) return;
      MyAppFunctions.showErrorOrWaningDialog(
        context: context,
        subtitle: "Form temizlensin mi?",
        isError: false,
        fct: () {
          clearForm();
        },
      );
    } on FirebaseException catch (error) {
      if (!mounted) return;
      await MyAppFunctions.showErrorOrWaningDialog(
        context: context,
        subtitle: error.message.toString(),
        fct: () {},
      );
    } catch (error) {
      if (!mounted) return;
      await MyAppFunctions.showErrorOrWaningDialog(
        context: context,
        subtitle: error.toString(),
        fct: () {},
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  //Ürün düzenleme
  Future<void> _editProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) return;

    final productId = widget.productModel!.productId;

    try {
      setState(() => _isLoading = true);

      //Fotoğraf değiştirme işlemi
      String imageToSave = productNetworkImage ?? "";
      if (_pickedImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child("productImages")
            .child("${_titleController.text.trim()}_$productId.jpg");

        await ref.putFile(
          File(_pickedImage!.path),
          SettableMetadata(contentType: "image/jpeg"),
        );
        imageToSave = await ref.getDownloadURL();
      }

      //Veritabanını güncelleme
      await FirebaseFirestore.instance
          .collection("products")
          .doc(productId)
          .update({
        'productTitle': _titleController.text.trim(),
        'productPrice': _priceController.text.trim(),
        'productCategory':
            _categoryValue ?? widget.productModel!.productCategory,
        'productDescription': _descriptionController.text.trim(),
        'productImage': imageToSave.isNotEmpty
            ? imageToSave
            : widget.productModel!.productImage,
        'productQuantity': _quanttiyContoller.text.trim(),
        'updatedAt': Timestamp.now(),
      });

      Fluttertoast.showToast(msg: "Ürün güncellendi ✅");

      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      if (!mounted) return;
      await MyAppFunctions.showErrorOrWaningDialog(
        context: context,
        subtitle: e.message ?? "Firebase hatası",
        fct: () {},
      );
    } catch (e) {
      if (!mounted) return;
      await MyAppFunctions.showErrorOrWaningDialog(
        context: context,
        subtitle: e.toString(),
        fct: () {},
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  //Fotoğraf Ekleme Butonu
  Future<void> localImagePicker() async {
    final ImagePicker picker = ImagePicker();
    await MyAppFunctions.ImagePickerDialog(
      context: context,
      cameraFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.camera);
        setState(() {});
      },
      galleryFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      removeFCT: () {
        setState(() {
          _pickedImage = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        bottomSheet: SizedBox(
          height: kBottomNavigationBarHeight + 10,
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: clearForm,
                  icon: const Icon(Icons.clear),
                  label: const Text("Temizle"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(14),
                    backgroundColor: Colors.amber,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (isEditing) {
                      _editProduct();
                    } else {
                      _addProduct();
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: Text(isEditing ? "Ürün Kaydet" : "Ürün Ekle"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(14),
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, size: 20),
          ),
          title:
              TitleTextWidget(label: isEditing ? "Ürün Düzenle" : "Ürün Ekle"),
        ),
        body: LoadingManager(
          isLoading: _isLoading,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  if (isEditing &&
                      productNetworkImage != null &&
                      _pickedImage == null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        productNetworkImage!,
                        height: size.width * 0.7,
                        alignment: Alignment.center,
                      ),
                    ),
                  ] else if (_pickedImage == null) ...[
                    SizedBox(
                      width: size.width * 0.4 + 10,
                      height: size.width * 0.4,
                      child: DottedBorder(
                        color: Colors.deepPurple,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.image,
                                  size: 80, color: Colors.deepPurple),
                              TextButton(
                                onPressed: localImagePicker,
                                child: const Text("Fotoğraf Seç"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_pickedImage!.path),
                        height: size.width * 0.5,
                        alignment: Alignment.center,
                      ),
                    ),
                  ],

                  const SizedBox(height: 12),

                  if (_pickedImage != null || productNetworkImage != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: localImagePicker,
                          child: const Text("Fotoğraf Seç",
                              style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: removePickedImage,
                          child: const Text("Fotoğraf Kaldır",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _titleController,
                            key: const ValueKey("Baslik"),
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 2,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            decoration:
                                const InputDecoration(hintText: "Ürün Adı"),
                            validator: (value) => MyValidators.uploadProdText(
                              value: value,
                              toBeReturnedString: "Lütfen bir ürün adı giriniz",
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Flexible(
                                child: TextFormField(
                                  controller: _priceController,
                                  key: const ValueKey("Fiyat \$"),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    suffix: SubTitleTextWidget(
                                        label: "\$",
                                        color: Colors.green,
                                        fontSize: 18),
                                    hintText: "Fiyat",
                                  ),
                                  validator: (value) =>
                                      MyValidators.uploadProdText(
                                    value: value,
                                    toBeReturnedString:
                                        "Lütfen bir değer giriniz",
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: TextFormField(
                                  controller: _quanttiyContoller,
                                  key: const ValueKey("Adet"),
                                  keyboardType: TextInputType.number,
                                  decoration:
                                      const InputDecoration(hintText: "Adet"),
                                  validator: (value) =>
                                      MyValidators.uploadProdText(
                                    value: value,
                                    toBeReturnedString: "Lütfen adet giriniz",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: _categoryValue,
                            hint: const Text("Kategori"),
                            items: AppConstans.categoriesDropDownList,
                            onChanged: (val) =>
                                setState(() => _categoryValue = val),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2),
                              ),
                            ),
                            icon: const Icon(Icons.keyboard_arrow_down),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _descriptionController,
                            key: const ValueKey("Aciklama"),
                            maxLength: 1000,
                            minLines: 5,
                            maxLines: 8,
                            keyboardType: TextInputType.multiline,
                            decoration:
                                const InputDecoration(hintText: "Açıklama"),
                            validator: (value) => MyValidators.uploadProdText(
                              value: value,
                              toBeReturnedString: "Geçersiz Açıklama",
                            ),
                          ),
                          const SizedBox(
                              height: kBottomNavigationBarHeight + 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

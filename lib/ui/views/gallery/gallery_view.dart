import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:stacked/stacked.dart';

import 'gallery_viewmodel.dart';

class GalleryViewRoute extends CupertinoPageRoute {
  GalleryViewRoute(int? oid)
      : super(
          builder: (context) => const _GalleryView(),
          settings: RouteSettings(arguments: oid),
        );
}

class _GalleryView extends StatelessWidget {
  const _GalleryView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GalleryViewModel>.reactive(
      viewModelBuilder: () => GalleryViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
          isBusy: model.isBusy,
            title: 'Галерея',
            body: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: AssetImage(model.files[index].path),
                  initialScale: PhotoViewComputedScale.contained * 0.8,
                  heroAttributes: PhotoViewHeroAttributes(tag: model.files[index].path),
                );
              },
              itemCount: model.files.length,
            ));
      },
    );
  }
}

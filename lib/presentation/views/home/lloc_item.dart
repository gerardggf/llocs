import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:llocs/presentation/routes/routes.dart';
import 'package:llocs/domain/const.dart';

import '../../../domain/models/lloc_model.dart';

class LlocItem extends StatelessWidget {
  const LlocItem({super.key, required this.infoLloc, this.isFirst = false});
  final Lloc infoLloc;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kPadding - 5,
      ).copyWith(top: isFirst ? kPadding - 5 : 0, bottom: kPadding - 5),
      child: GestureDetector(
        onTap: () =>
            Navigator.pushNamed(context, Routes.lloc, arguments: infoLloc.id),
        child: Container(
          decoration: BoxDecoration(
              color: kColorP.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(kPadding - 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            infoLloc.nombre,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: kFSize1 + 2),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            infoLloc.categoria,
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      infoLloc.fechaPubl,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                child: CachedNetworkImage(
                  width: double.infinity,
                  height: 140,
                  imageUrl: infoLloc.urlImagen,
                  imageBuilder: (_, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (_, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (_, url, error) => const Icon(Icons.error),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(kPadding - 2),
                child: RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                        text: infoLloc.autor,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                          const TextSpan(text: "  "),
                          TextSpan(
                            text: infoLloc.desc,
                            style:
                                const TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

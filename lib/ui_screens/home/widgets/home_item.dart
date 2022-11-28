import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:llocz/utils/const.dart';

import '../../../models/lloc_model.dart';
import '../../lloc/lloc.dart';

class HomeItem extends StatelessWidget {
  const HomeItem({super.key, required this.infoLloc, this.isFirst = false});
  final Lloc infoLloc;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kPadding - 5,
      ).copyWith(top: isFirst ? kPadding - 5 : 0, bottom: kPadding - 5),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LlocScreen(
            idLloc: infoLloc.id,
          ),
        )),
        child: Container(
          decoration: BoxDecoration(
              color: kColorP.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(kPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        infoLloc.nombre,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: kFSize1 + 2),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          infoLloc.fechaPubl,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                        Text(
                          infoLloc.categoria,
                          textAlign: TextAlign.end,
                        ),
                      ],
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
                padding: const EdgeInsets.all(kPadding),
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

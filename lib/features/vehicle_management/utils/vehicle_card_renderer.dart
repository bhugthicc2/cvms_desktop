import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cvms_desktop/features/vehicle_management/widgets/qr/custom_qr_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class VehicleCardRenderer {
  static Future<Uint8List> _renderFlutterWidgetToImage(
    Widget widget, {
    Size logicalSize = const Size(420, 230),
    double pixelRatio = 2.0,
  }) async {
    final pipelineOwner = PipelineOwner();

    // Root RenderView
    final renderView = RenderView(
      child: null,
      configuration: ViewConfiguration(
        logicalConstraints: BoxConstraints.tight(logicalSize),
      ),
      view: ui.PlatformDispatcher.instance.views.first,
    );
    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    // Container for the widget (will hold the RepaintBoundary after build)
    final renderBoxContainer = RenderPositionedBox(alignment: Alignment.center);
    renderView.child = renderBoxContainer;

    final buildOwner = BuildOwner(focusManager: FocusManager());

    // Build the tree: RepaintBoundary wraps the widget (no key needed)
    final root = RenderObjectToWidgetAdapter<RenderBox>(
      container: renderBoxContainer,
      child: RepaintBoundary(
        // Remove key here
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: MediaQueryData(size: logicalSize),
            child: SizedBox(
              width: logicalSize.width,
              height: logicalSize.height,
              child: widget,
            ),
          ),
        ),
      ),
    ).attachToRenderTree(buildOwner);

    try {
      buildOwner.buildScope(root);
      buildOwner.finalizeTree();
    } catch (e) {
      rethrow;
    }

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    // Directly access the boundary from the container (no GlobalKey/context needed)
    final boundary = renderBoxContainer.child as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: pixelRatio);

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception(
        'Failed to convert image to PNG byte data. Try lower pixelRatio or check widget rendering.',
      );
    }
    return byteData.buffer.asUint8List();
  }

  /// Render full card as PNG (for bulk export)
  static Future<Uint8List> renderCardToPng({
    required String plateNumber,
    required String qrData,
  }) async {
    return _renderFlutterWidgetToImage(
      CustomQrCard(plateNumber: plateNumber, qrData: qrData),
    );
  }
}

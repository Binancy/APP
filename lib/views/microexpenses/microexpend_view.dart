import 'package:binancy/models/microexpend.dart';
import 'package:binancy/utils/dialogs/info_dialog.dart';
import 'package:binancy/utils/ui/styles.dart';
import 'package:binancy/utils/widgets.dart';
import 'package:flutter/material.dart';

class MicroExpendView extends StatefulWidget {
  final MicroExpend? selectedMicroExpend;
  final bool allowEdit;

  MicroExpendView({Key? key, this.allowEdit = false, this.selectedMicroExpend})
      : super(key: key);

  @override
  _MicroExpendViewState createState() =>
      _MicroExpendViewState(selectedMicroExpend, allowEdit);
}

class _MicroExpendViewState extends State<MicroExpendView> {
  MicroExpend? selectedMicroExpend;
  bool allowEdit = false, createMode = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  _MicroExpendViewState(this.selectedMicroExpend, this.allowEdit);

  @override
  Widget build(BuildContext context) {
    checkMicroExpend();
    return BinancyBackground(Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        brightness: Brightness.dark,
        title: Text("data", style: appBarStyle()),
        actions: [
          !createMode && !allowEdit
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      allowEdit = true;
                    });
                  },
                  icon: Icon(Icons.more_horiz_rounded))
              : SizedBox()
        ],
        leading: !allowEdit
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context))
            : createMode
                ? IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => BinancyInfoDialog(
                            context, "¿Estas seguro que quieres salir?", [
                          BinancyInfoDialogItem(
                              "Cancelar", () => Navigator.pop(context)),
                          BinancyInfoDialogItem("Abortar", () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          })
                        ]))
                : IconButton(
                    icon: Icon(Icons.close_outlined),
                    onPressed: () => BinancyInfoDialog(
                        context, "Estas seguro que quieres salir?", [
                      BinancyInfoDialogItem(
                          "Canelar", () => Navigator.pop(context)),
                      BinancyInfoDialogItem("Abortar", () {
                        Navigator.pop(context);
                        setState(() {
                          allowEdit = false;
                        });
                      })
                    ]),
                  ),
      ),
      body: Container(
        child: Column(
          children: [],
        ),
      ),
    ));
  }

  void checkMicroExpend() {
    if (selectedMicroExpend != null) {
      createMode = false;
      titleController.text = selectedMicroExpend!.title;
      amountController.text = selectedMicroExpend!.amount.toString();

      if (selectedMicroExpend!.description != null) {
        descriptionController.text = selectedMicroExpend!.description!;
      }
    } else {
      createMode = true;
      allowEdit = true;
    }
  }
}

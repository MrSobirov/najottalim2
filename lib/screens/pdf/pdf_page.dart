import 'package:dictionary/models/definition_model.dart';
import 'package:dictionary/models/eng_model.dart';
import 'package:dictionary/models/pdf_model.dart';
import 'package:dictionary/models/uzb_model.dart';
import 'package:dictionary/screens/pdf/pdf_cubit.dart';
import 'package:dictionary/services/pdf_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../services/cache_values.dart';

//ignore:must_be_immutable
class PdfPage extends StatelessWidget {
	PdfPage({Key? key}) : super(key: key);
	String type = "eng_uzb";
	List<PdfModel> items = [];
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text("Convert to pdf"),
			),
			body: BlocProvider(
				create: (ctx1) => PdfCubit()..getWords(type),
				child: BlocBuilder<PdfCubit, PdfState>(
					builder: (cubitCTX, state) {
						if(state is PdfLoading || state is PdfLoaded) {
							return Padding(
								padding: EdgeInsets.symmetric(horizontal: 20.w),
								child: Column(
									children: [
										SizedBox(height: 15.h),
										Row(
											mainAxisAlignment: MainAxisAlignment.spaceBetween,
											children: [
												DropdownButton<String>(
													value: type,
													items: <String>[
														'eng_uzb',
														'uzb_eng',
														'definition',
													].map<DropdownMenuItem<String>>((String value) {
														return DropdownMenuItem<String>(
															value: value,
															child: Text(
																value,
																style: TextStyle(fontSize: 20.sp),
															),
														);
													}).toList(),
													onChanged: (String? newValue) async {
														type = newValue!;
														await BlocProvider.of<PdfCubit>(cubitCTX).getWords(type);
													},
												),
												GestureDetector(
													onTap: () => buildAndSavePdf(context),
													child: Container(
														height: 40,
														width: 130.w,
														alignment: Alignment.center,
														padding: EdgeInsets.symmetric(horizontal: 7.w),
														decoration: BoxDecoration(
															color: Colors.amberAccent,
															borderRadius: BorderRadius.circular(10.r)
														),
														child: Text("Convert to pdf"),
													),
												)
											],
										),
										if(state is PdfLoading) Padding(
											padding: EdgeInsets.only(top: 50.h),
											child: Center(
												child: CircularProgressIndicator(),
											),
										),
										if(state is PdfLoaded) Expanded(
											child: Padding(
												padding: EdgeInsets.symmetric(vertical: 10.h),
												child: wordList(),
											),
										),
									],
								),
							);
						} else {
							return SizedBox();
						}
					},
				),
			),
		);
	}

	void buildAndSavePdf(BuildContext ctx) async {
		List<Map<String, String>> chosenItems = [];
		for(PdfModel element in items) {
			if(element.chosen) {
				chosenItems.add({
					"name": element.name,
					"text": element.text
				});
			}
		}
		ByteData data = await rootBundle.load("assets/Helvetica.ttf");
		await PdfService().savePdf(chosenItems, data);
		Navigator.pop(ctx);
	}

	Widget wordList() {
		items.clear();
		if(type == "eng_uzb") {
			for(EngUzbModel element in CachedModels.engUzbModel) {
				items.add(PdfModel(name: element.eng, text: element.uzb, chosen: false));
			}
		} else if(type == "uzb_eng") {
			for(UzbEngModel element in CachedModels.uzbEngModel) {
				items.add(PdfModel(name: element.uzb, text: element.eng, chosen: false));
			}
		} else if(type == "definition") {
			for(DefinitionModel element in CachedModels.definitionModel) {
				items.add(PdfModel(name: element.word, text: element.description, chosen: false));
			}
		}
		return ListView.builder(
			itemCount: items.length,
			itemBuilder: (wordCTX, index) => Padding(
				padding: EdgeInsets.only(bottom: 10.h),
				child: Row(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Expanded(
							flex: 6,
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(
										items[index].name,
										style: TextStyle(
												fontSize: 15.sp,
												fontWeight: FontWeight.w500
										),
									),
									Html(data: items[index].text),
								],
							),
						),
						Expanded(
							flex: 1,
							child: StatefulBuilder(
								builder: (ctxCheck, checkSetState) {
									return Checkbox(
										value: items[index].chosen,
										onChanged: (bool? newVal) {
											if(newVal != null) {
												items[index].chosen = newVal;
											}
											checkSetState(() {});
										},
									);
								},
							),
						)
					],
				),
			),
		);
	}
}

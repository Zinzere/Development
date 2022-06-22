import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'chevron.dart';
import 'chevron1.dart';

class Pdf extends StatefulWidget {
  @override
  _PdfState createState() => _PdfState();
}class _PdfState extends State<Pdf> {
  var sum;
  var total;
  List<Map> ROWS = [{'item':TextEditingController(),'qty':TextEditingController(),'price':TextEditingController(),'total':''}];
  var a = [];
  TextEditingController _invoiceId = TextEditingController();
  TextEditingController _ToWhom = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _toaddress = TextEditingController();
  TextEditingController _pdate = TextEditingController();
  TextEditingController _edate = TextEditingController();
  TextEditingController _signDate = TextEditingController();
  List<TextEditingController> row1 = [TextEditingController()];
  Size size = Size(0, 0);
  final pdf = pw.Document();
  var anchor;


  savePDF() async {
    Uint8List pdfInBytes = await pdf.save();
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'pdf.pdf';
    html.document.body?.children.add(anchor);
    anchor.click();
  }

  firstContainer(PdfGraphics canvas, PdfPoint size) {
    canvas.setColor(PdfColor.fromHex('#D9C4B1'));//light
    canvas.drawLine(0, 2, size.x-0, size.y);
    canvas.lineTo(0,size.x);
    canvas.fillPath(evenOdd:true);
  }
  secondContainer(PdfGraphics canvas, PdfPoint size) {
    canvas.setColor(PdfColor.fromHex('#31394D'));//navyblue
    canvas.drawLine(0, 20, size.x-14, size.y);
    canvas.lineTo(0,size.x);
    canvas.fillPath(evenOdd:true);
  }

  //pdf making code start as follows:
  createPDF() async {
    var imageData1 = await rootBundle.load('images/sign1.jpg');
    var imageData2 = await rootBundle.load('images/sign2.jpg');
    final font = await rootBundle.load("fonts/Merriweather-Regular.ttf");
    final robotoFont = pw.Font.ttf(font);
    List<pw.Widget> rows = [];
    for (var i = 0; i < row1.length; i++) {
      rows.add(
        pw.Text(row1[i].text),
      );
    }
    pdf.addPage(
      pw.Page(

        margin: pw.EdgeInsets.all(0),
        build: (pw.Context context) =>
            pw.Column(
                  children: [
                    pw.Padding(padding: pw.EdgeInsets.only(right:0),
                      child:pw.Stack(
                        children: [
                          pw.Container(
                            height: size.height * 0.19,
                            width: size.width * 0.390,
                            child: pw.CustomPaint(
                              painter: firstContainer,
                            ),
                          ),
                          pw.Container(
                            height: size.height * 0.20,
                            width: size.width * 0.360,
                            child: pw.CustomPaint(
                              painter: secondContainer,
                            ),
                          ),
                        ],
                      ),
                    ),


                    pw.Center(
                       child:pw.Container(
                         margin: pw.EdgeInsets.only(right:60,left:60),
                           // padding: pw.EdgeInsets.only(right:30,left:30)
                        child:pw.Column(
                          children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.only(right:0),
                              child:pw.Container(
                                width: size.width * 0.312,
                                child: pw.Column(
                                  children: [
                                    pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Column(
                                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Text("S&L Apparels", style: pw.TextStyle(fontSize:15,fontWeight: pw.FontWeight.bold,
                                              font: robotoFont,color:PdfColor.fromHex('#666666'),
                                            ),),
                                            pw.Text("5/162C, 2nd Floor, Arikatt kuries Building,",style:pw.TextStyle(color:PdfColor.fromHex('#5D6473'),fontSize: 10)),
                                            pw.Text("Alur P O, Alur -Mala Road Jn, Thrissur Dist- 680683,",style:pw.TextStyle(color:PdfColor.fromHex('#5D6473'),fontSize: 10)),
                                            pw.Text("Phone: 8078377990, 9645433711",style:pw.TextStyle(color:PdfColor.fromHex('#5D6473'),fontSize: 10)),
                                            pw.Text("http://sandlapparels.com",style:pw.TextStyle(color:PdfColor.fromHex('#5D6473'),fontSize: 10)),
                                          ],
                                        ),
                                        pw.Column(
                                          children: [
                                            pw.Row(
                                              children: [
                                                pw.Text("GSTIN:", style: pw.TextStyle( font: robotoFont,fontWeight: pw
                                                    .FontWeight.bold),),
                                                pw.Text("34GHY5672WD4672",style:pw.TextStyle(color:PdfColor.fromHex('#5D6473'),fontSize: 10)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            pw.SizedBox(height: 20),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(right:0),
                              child: pw.Container(
                                width: size.width * 0.312,
                                child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.end,
                                  children: [
                                    pw.Column(
                                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text("S&L QUOTES",style: pw.TextStyle( font: robotoFont,fontSize:25,color:PdfColor.fromHex('#31394D'))
                                        ),
                                        pw.Text(_invoiceId.text,style: pw.TextStyle(font: robotoFont,fontSize:23,color: PdfColor.fromHex('#D9C4B1'),)
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            pw.SizedBox(height: 30),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(right:0),
                              child:pw.Container(
                                width: size.width * 0.312,
                                child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Column(
                                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text("PREPARED FOR", style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold, fontSize: 10),),
                                        pw.SizedBox(height: 10),
                                        pw.Text(_ToWhom.text,style:pw.TextStyle(fontSize:18,color:PdfColor.fromHex('#31394D'))
                                        ),
                                        pw.SizedBox(height: 25),
                                        pw.Text(
                                          _name.text,style:pw.TextStyle(fontSize:18,color:PdfColor.fromHex('#31394D'),),
                                        ),
                                        pw.Text(_toaddress.text,style: pw.TextStyle(
                                            color:PdfColor.fromHex('#5D6473')),),
                                      ],
                                    ),
                                    pw.Row(
                                      children: [
                                        pw.Column(
                                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                                          children: [
                                            pw.Text("PREPARED DATE", style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold, fontSize: 10,),),
                                            pw.Text(_pdate.text, style: pw.TextStyle(
                                                color:PdfColor.fromHex('#5D6473')),),
                                            pw.SizedBox(height: 20),
                                            pw.Text("EXP.DATE", style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold, fontSize: 10),),
                                            pw.Text(_edate.text, style: pw.TextStyle(
                                                color:PdfColor.fromHex('#5D6473')),),
                                            pw.SizedBox(height: 15),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            pw.SizedBox(height: 30),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(right:0),
                              child:pw.Container(
                                width: size.width * 0.312,
                                child: pw.Table(
                                  defaultColumnWidth: pw.FixedColumnWidth(50.0),
                                  columnWidths: {
                                    0: pw.FlexColumnWidth(.7),
                                    1: pw.FlexColumnWidth(.7),
                                    2: pw.FlexColumnWidth(.7),
                                    3: pw.FlexColumnWidth(.7)
                                  },
                                  border: pw.TableBorder.all( color: PdfColor.fromHex('#394048')),
                                  children: [
                                    pw.TableRow(
                                      decoration: pw.BoxDecoration(  color: PdfColor.fromHex('#D9C4B1')),
                                      children: [
                                        pw.Column(
                                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Center(child: pw.Padding(
                                              padding:  pw.EdgeInsets.all(6.0),
                                              child: pw.Text("Material Details",style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,
                                              ),
                                              ),
                                            )),
                                          ],
                                        ),
                                        pw.Column(
                                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Center(
                                                child: pw.Padding(
                                                  padding:  pw.EdgeInsets.all(6.0),
                                                  child: pw.Text("Qty",style: pw.TextStyle(
                                                    fontWeight: pw.FontWeight.bold,
                                                  ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                        pw.Column(
                                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Center(
                                                child: pw.Padding(
                                                  padding:  pw.EdgeInsets.all(6.0),
                                                  child: pw.Text("Price",style: pw.TextStyle(
                                                    fontWeight: pw.FontWeight.bold,
                                                  ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                        pw.Column(
                                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Center(
                                                child: pw.Padding(
                                                  padding:  pw.EdgeInsets.all(6.0),
                                                  child: pw.Text("Total",style: pw.TextStyle(
                                                    fontWeight: pw.FontWeight.bold,)),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                    for(var j=0; j< ROWS.length;j++)
                                      pw.TableRow(
                                        children: [
                                          pw.Column(
                                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Center(
                                                child: pw.Padding(
                                                  padding:  pw.EdgeInsets.all(6.0),
                                                  child: pw.Text(ROWS[j]["item"].text,style:pw.TextStyle(color:PdfColor.fromHex('#666666'))),
                                                ),
                                              ),
                                            ],
                                          ),
                                          pw.Column(
                                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Center(
                                                child: pw.Padding(
                                                  padding:  pw.EdgeInsets.all(6.0),
                                                  child: pw.Text(ROWS[j]["qty"].text,style:pw.TextStyle(color:PdfColor.fromHex('#666666'))),
                                                ),
                                              ),
                                            ],
                                          ),
                                          pw.Column(
                                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Center(
                                                  child: pw.Padding(
                                                    padding:  pw.EdgeInsets.all(6.0),
                                                    child: pw.Text(ROWS[j]["price"].text,style:pw.TextStyle(color:PdfColor.fromHex('#666666'))),
                                                  )),
                                            ],
                                          ),
                                          pw.Column(
                                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Center(
                                                  child: pw.Padding(
                                                    padding:  pw.EdgeInsets.all(6.0),
                                                    child: pw.Text(ROWS[j]["total"].toString(),style:pw.TextStyle(color:PdfColor.fromHex('#666666'))),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    pw.TableRow(
                                      children: [
                                        pw.Column(
                                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Padding(
                                              padding:  pw.EdgeInsets.all(6.0),
                                              child: pw.Text("Total",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                        pw.Column(
                                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Center(
                                              child: pw.Padding(
                                                padding:  pw.EdgeInsets.all(6.0),
                                                child: pw.Text(""),
                                              ),
                                            ),
                                          ],
                                        ),
                                        pw.Column(
                                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Center(
                                                child: pw.Padding(
                                                  padding:  pw.EdgeInsets.all(6.0),
                                                  child: pw.Text(""),
                                                )),
                                          ],
                                        ),
                                        pw.Column(
                                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Center(
                                                child: pw.Padding(
                                                  padding:  pw.EdgeInsets.all(6.0),
                                                  child: pw.Text(total.toString()),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 200),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(10),
                      child:pw.Container(
                        margin: pw.EdgeInsets.only(right:60,left:60),
                        width: size.width * 0.312,
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Text("Note: ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 16),),
                            pw.Text("Rates are included with GST")
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );

    // pdf PAGE 2 code starts below
    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.all(0),
        build: (pw.Context context) =>
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                    pw.Padding(padding: pw.EdgeInsets.all(0),
                      child: pw.Stack(
                        children: [
                          pw.Container(
                            height: size.height * 0.19,
                            width: size.width * 0.380,
                            child:pw.CustomPaint(
                              painter: firstContainer,
                            ),
                          ),
                          pw.Container(
                            height: size.height * 0.20,
                            width: size.width * 0.360,
                            child: pw.CustomPaint(
                              painter: secondContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                     //  ]
                     // ),
                    pw.Center(
                      child:pw.Container(
                        margin: pw.EdgeInsets.only(right:55,left:55),
                        child:pw.Column(
                          children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.all(10),
                              child: pw.Container(
                                width: size.width * 0.321,
                                child:pw. Text(
                                  "THIS QUOTATION IS SUBJECT TO THE FOLLOWING\n\n\n\n\n\n\n\nTERMS AND CONDITIONS\n\n\n\n\n\n",
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: robotoFont,fontSize: 16),
                                ),
                              ),
                            ),
                            pw.SizedBox(height: 20),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(right:0),
                              child:pw.Container(
                                // padding: pw.EdgeInsets.only(left: 40.0),
                                width: size.width*0.35,
                                height: size.height*0.35,
                                child: pw.Text(
                                  '1. Finished product delivery will be made within 45 days following "S & L  Apparels"\n    receipt of advance payment. \n\n\n '
                                      '2. This will become a binding contract upon anyone of the following options: \n\n '
                                      '      a. Return this quote with your signature or email confirmation with this quote\n           attached, plus advance payment of 50% of order value to "S & L Apparels" prior to\n            the expiration date.\n\n\n '
                                      '      b. Issuance of a purchase order and advance payment of 50% of order value to\n           "S & L Apparels" referencing this quote and the terms and conditions here in prior to\n           the expiration date above.\n\n\n '
                                      '3. Details for online money transfer are as given below.\n              Account Name: - SANDL APPARELS \n              Account Number: - 919020082181867 \n              Name of Bank: - AXIS BANK \n              IFSC Code: - UTIB0002174',style:pw.TextStyle(color:PdfColor.fromHex('#5D6473'),fontSize: 12),

                                  maxLines: 30,
                                ),
                              ),
                            ),
                            pw.SizedBox(height:40),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(10),
                              child: pw.Container(
                                height: 0.7,
                                width: size.width * 0.312,
                                color:  PdfColor.fromHex('#394048'),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left:10.0),
                              child: pw.Container(
                                width: size.width * 0.321,
                                child: pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Row(
                                      children: [
                                        pw.Text("AGREED AND ACCEPTED:\n\n\n",style:pw.TextStyle(fontSize:14,font: robotoFont,)),
                                      ],
                                    ),
                                    pw.SizedBox(height: 30),
                                    pw.Container(
                                      padding: pw.EdgeInsets.all(10),
                                      width: size.width * 0.250,
                                      child: pw.Row(
                                        children: [
                                          pw.Column(
                                            children: [
                                              pw.Container(
                                                width:100,
                                                height: 50,
                                                child:pw.Image(
                                                    pw.MemoryImage(
                                                      imageData1.buffer.asUint8List(),
                                                    )),
                                              ),
                                              pw.SizedBox(height: 10),
                                              pw.Container(
                                                height: 1,
                                                width:140,
                                                color:  PdfColor.fromHex('#D3D3D3'),
                                              ),
                                              pw.SizedBox(height: 10),
                                              pw.Text("Sooraj E.R",style:pw.TextStyle(color:PdfColor.fromHex('#1F497D'),)),
                                            ],
                                          ),
                                          pw.SizedBox(width:20),
                                          pw.Column(
                                            children: [
                                              pw.Container(
                                                width:140,
                                                height: 50,
                                                child:pw.Image(
                                                    pw.MemoryImage(
                                                      imageData2.buffer.asUint8List(),
                                                    )),
                                              ),
                                              pw.SizedBox(height: 10),
                                              pw.Container(
                                                height: 1,
                                                width:140,
                                                color: PdfColor.fromHex('#D3D3D3'),
                                              ),
                                              pw.SizedBox(height: 10),
                                              pw.Text("Lijo Johny",style:pw.TextStyle(color:PdfColor.fromHex('#1F497D'),),),
                                            ],
                                          ),
                                          pw.SizedBox(width:20),
                                          pw.Column(
                                            children: [
                                              pw.Container(
                                                width:140,
                                                height: 50,
                                              ),
                                              pw.SizedBox(height: 10),
                                              pw.Container(
                                                height: 1,
                                                width:140,
                                                color: PdfColor.fromHex('#D3D3D3'),
                                              ),
                                              pw.SizedBox(height: 20),
                                              pw.Text(_signDate.text),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

      ),
    );
    savePDF();
  }
  // pdf making code ends //
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery
        .of(context)
        .size;
    return
      SingleChildScrollView(
        child: Column(
          children: rows(),
        ),
      );

  }

  //View page design starts as follows:
  List<Widget> rows() {
    List<Widget> rows = [];
    rows.add(
      Center(
        child: Container(
          //color:Colors.green,
          width: size.width * 1.9,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Stack(
                    children:[
                      Container(
                        height: size.height * 0.246,
                        width: size.width * 0.480,
                        child: CustomPaint(
                          painter: Chevron(),
                        ),
                      ),
                      Container(
                        height: size.height * 0.246,
                        width: size.width * 0.470,
                        child: CustomPaint(
                          painter: Chevron1(),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    //color:Colors.red,
                    padding: EdgeInsets.all(20.0),
                    width: size.width * 0.380,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("S&L Apparels",style: TextStyle(fontWeight: FontWeight.bold,fontSize:18,fontFamily: 'Merriweather')),
                                Text("5/162C, 2nd Floor, Arikatt kuries Building,",style:TextStyle(fontFamily: 'Tajawal',fontSize: 16)),
                                Text("Alur P O, Alur -Mala Road Jn, Thrissur Dist- 680683",style:TextStyle(fontFamily: 'Tajawal',fontSize: 16),),
                                Text("Phone: 8078377990, 9645433711",style:TextStyle(fontFamily: 'Tajawal',fontSize: 16)),
                                Text("http://sandlapparels.com",style:TextStyle(fontFamily: 'Tajawal',fontSize: 16)),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text("GSTIN:", style: TextStyle(fontWeight: FontWeight.bold),),
                                    Text("34GHY5672WD4672"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    width: size.width * 0.350,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("S&L QUOTES",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 30,fontFamily: 'Merriweather')
                            ),
                            SizedBox(
                              width:200,
                              child: TextField(
                                autofocus: true,
                                controller: _invoiceId,
                                decoration: InputDecoration(
                                  hintText: "Invoice Id",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    width: size.width * 0.350,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("PREPARED FOR", style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),),
                            SizedBox(height: 10),
                            SizedBox(
                              width: 200,
                              child: TextField(
                                autofocus: true,
                                controller: _ToWhom,
                                decoration: InputDecoration(
                                    hintText: "Institute"
                                ),
                              ),
                            ),
                            SizedBox(height: 25),
                            SizedBox(
                              width: 200,
                              child: TextField(
                                autofocus: true,
                                controller: _name,
                                decoration: InputDecoration(
                                    hintText: "Name"
                                ),
                              ),
                            ),
                            SizedBox(
                              width:200,
                              child: TextField(
                                autofocus: true,
                                keyboardType: TextInputType.multiline,
                                maxLines: 3,
                                controller: _toaddress,
                                decoration: InputDecoration(
                                    hintText: "To Address"
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("PREPARED DATE", style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),),
                                SizedBox(
                                  width:200,
                                  child: TextField(
                                    autofocus: true,
                                    controller: _pdate,
                                    decoration: InputDecoration(
                                        hintText: "Prepared Date"
                                    ),
                                    style: TextStyle(
                                        color: Colors.deepPurple),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text("EXP.DATE",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 12),),
                                SizedBox(
                                  width:200,
                                  child: TextField(
                                    autofocus: true,
                                    controller: _edate,
                                    decoration: InputDecoration(
                                        hintText: "Expiry Date"
                                    ),
                                    style: TextStyle(
                                        color: Colors.purple),
                                  ),
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    width: size.width * 0.350,
                    child: table(),
                  ),
                  Container(
                    padding: EdgeInsets.only(left:460.0),
                    width: size.width * 0.350,
                    child: IconButton(
                      onPressed: () {
                        ROWS.add({'item':TextEditingController(),'qty':TextEditingController(),'price':TextEditingController(),"total":""});
                        setState(() {
                        });
                      }, icon: Icon(Icons.add_box),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: size.width * 0.320,
                    child: Row(
                      children: [
                        Text("Note: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                        Text("Rates are included with GST")
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  Text("Page 2"),
                  SizedBox(height: 80),
                  Center(
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: size.height * 0.246,
                                    width: size.width * 0.480,
                                    child: CustomPaint(
                                      painter: Chevron(),
                                    ),
                                  ),
                                  Container(
                                    height: size.height * 0.246,
                                    width: size.width * 0.470,
                                    child: CustomPaint(
                                      painter: Chevron1(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 40),
                              Container(

                                width: size.width * 0.321,
                                child: Text(
                                  "THIS QUOTATION IS SUBJECT TO THE FOLLOWING\n\nTERMS AND CONDITIONS\n\n\n",
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                                ),
                              ),
                              Container(
                                width: size.width*0.37,
                                height: size.height*0.50,

                                child: Text(
                                  '1. Finished product delivery will be made within 45 days following "S & L  Apparels"\n    receipt of advance payment. \n\n'
                                      '2. This will become a binding contract upon anyone of the following options: \n\n '
                                      '      a. Return this quote with your signature or email confirmation with this quote\n           attached, plus advance payment of 50% of order value to "S & L Apparels" prior to\n            the expiration date.\n\n\n '
                                      '      b. Issuance of a purchase order and advance payment of 50% of order value to\n           "S & L Apparels" referencing this quote and the terms and conditions here in prior to\n           the expiration date above.\n\n\n '
                                      '3. Details for online money transfer are as given below.\n\n\n              Account Name: - SANDL APPARELS \n              Account Number: - 919020082181867 \n              Name of Bank: - AXIS BANK \n              IFSC Code: - UTIB0002174',
                                  maxLines: 30,
                                ),
                              ),
                              SizedBox(height:60),
                              Container(
                                height: 0.5,
                                width: size.width * 0.400,
                                color: Colors.grey,
                              ),
                              SizedBox(height:40),
                              Container(
                                width: size.width * 0.350,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text("AGREED AND ACCEPTED:"),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Container(
                                      width: size.width * 0.270,
                                      margin:EdgeInsets.all(20.0),
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                width:120,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage('images/sign1.jpg'),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Container(
                                                height: 1,
                                                width:120,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(height: 10),
                                              Text("Sooraj E.R",style:TextStyle(color:Colors.indigo)),
                                            ],
                                          ),
                                          SizedBox(width:20),
                                          Column(
                                            children: [
                                              Container(
                                                width:120,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage('images/sign2.jpg'),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Container(
                                                height: 1,
                                                width:120,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(height: 10),
                                              Text("Lijo Johny",style:TextStyle(color:Colors.indigo)),
                                            ],
                                          ),
                                          SizedBox(width:20),
                                          Column(
                                            children: [
                                              SizedBox(
                                                width: 120,
                                                child: TextField(
                                                  autofocus: true,
                                                  controller: _signDate,
                                                  decoration: InputDecoration(
                                                      hintText: "Date"
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    rows.addAll(
        [
          SizedBox(height: 20,),
          // RaisedButton(onPressed: () {
          //   createPDF();
          // },
          //   child: Text("Create PDF"),)

          TextButton(
            child: Text("Create PDF"),
            onPressed:() {
              createPDF();
            },
          )

        ]
    );
    return rows;
  }
  //ends view page design


//table widget function:
  Widget table() {
    List<TableRow> tableRow=[];
    tableRow.add(
      TableRow(
        decoration: BoxDecoration(  color: Colors.pink[100]),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Padding(
                    padding:  EdgeInsets.all(6.0),
                    child: Text("MATERIAL DETAILS",style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  )),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Padding(
                    padding:  EdgeInsets.all(6.0),
                    child: Text("QTY",style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  )),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Padding(
                    padding:  EdgeInsets.all(6.0),
                    child: Text("PRICE",style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  )),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Padding(
                    padding:  EdgeInsets.all(6.0),
                    child: Text("TOTAL",style: TextStyle(
                      fontWeight: FontWeight.bold,)),
                  )),
            ],
          ),
        ],
      ),
    );

    for(var k =0;k<ROWS.length;k++){
      tableRow.add(
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding:  EdgeInsets.all(12.0),
                    child:
                    SizedBox(
                      width: 500,
                      child: TextField(
                        autofocus: true,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        controller: ROWS[k]["item"],
                        decoration: InputDecoration(
                            hintText: "Material Details"
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding:  EdgeInsets.all(6.0),
                    child: SizedBox(
                      width: 50,
                      child: TextField(
                        autofocus: true,
                        controller:ROWS[k]["qty"],
                        decoration: InputDecoration(
                            hintText: "Qty"
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Padding(
                      padding:  EdgeInsets.all(6.0),
                      child: SizedBox(
                        width: 50,
                        child: TextField(
                          onChanged: (result) {
                            sum = double.parse(result)*double.parse(ROWS[k]["qty"].text);
                            ROWS[k]["total"] = sum.toString();
                            total = 0;
                            for(var n=0;n< ROWS.length;n++) {
                              total += double.parse(ROWS[n]["total"]);
                            }
                            setState(() => {
                            });
                          },
                          autofocus: true,
                          controller: ROWS[k]["price"],
                          decoration: InputDecoration(
                              hintText: "Price"
                          ),

                        ),
                      ),
                    )),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Padding(
                      padding: EdgeInsets.all(6.0),
                      child: SizedBox(
                        width: 50,
                        child: Text(
                          ROWS[k]["total"],
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),
      );
    }
    tableRow.add(
      TableRow(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.all(6.0),
                child: Text("Total",style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding:  EdgeInsets.all(6.0),
                  child: Text(""),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Padding(
                    padding:  EdgeInsets.all(6.0),
                    child: Text(""),
                  )),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Padding(
                    padding:  EdgeInsets.all(6.0),
                    child: Text(total.toString()),
                  )),
            ],
          ),
        ],
      ),);
    return Table(
      defaultColumnWidth: FixedColumnWidth(50.0),
      columnWidths: {
        0: FlexColumnWidth(.8),
        1: FlexColumnWidth(.7),
        2: FlexColumnWidth(.7),
        3: FlexColumnWidth(.7)
      },
      border: TableBorder.all( color: Colors.white),
      children: tableRow,
    );
  }
}



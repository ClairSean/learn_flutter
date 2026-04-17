import 'package:flutter/material.dart';

void main(List<String> args) {
  return runApp(HomePage());
}

const red = Colors.red;
const green = Colors.green;
const blue = Colors.blue;
const big = TextStyle(fontSize: 30);
const codeTextStyle = TextStyle(fontSize: 15);
const explanationTextStyle = TextStyle(
  color: Colors.deepPurpleAccent,
  fontSize: 12,
);

/////////////////////////////////////////////

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterLayoutArticle(<Example>[
      Example1(),
      Example2(),
      Example3(),
      Example4(),
      Example5(),
      Example6(),
      Example7(),
      Example8(),
      Example9(),
      Example10(),
      Example11(),
      Example12(),
      Example13(),
      Example14(),
      Example15(),
      Example16(),
      Example17(),
      Example18(),
      Example19(),
      Example20(),
      Example21(),
      Example22(),
      Example23(),
      Example24(),
      Example25(),
      Example26(),
      Example27(),
      Example28(),
      Example29(),
    ]);
  }
}

/////////////////////////////////////////////

abstract class Example extends StatelessWidget {
  String get code;
  String get explanation;
}

/////////////////////////////////////////////

class FlutterLayoutArticle extends StatefulWidget {
  final List<Example> examples;
  const FlutterLayoutArticle(this.examples, {super.key});
  @override
  State<FlutterLayoutArticle> createState() => _FlutterLayoutArticleState();
}

class _FlutterLayoutArticleState extends State<FlutterLayoutArticle> {
  late int count;
  late Example example;
  late String code;
  late String explanation;

  @override
  void initState() {
    count = 1;
    example = widget.examples[count - 1];
    code = Example1().code;
    explanation = Example1().explanation;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FlutterLayoutArticle oldWidget) {
    super.didUpdateWidget(oldWidget);
    var exmaple = widget.examples[count - 1];
    code = example.code;
    explanation = exmaple.explanation;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Layout Article',
      home: SafeArea(
        child: Material(
          color: Colors.black,
          child: FittedBox(
            child: Container(
              width: 400,
              height: 670,
              color: Color(0xFFCCCCCC),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      child: widget.examples[count - 1],
                    ),
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    color: Colors.black,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int i = 0; i < widget.examples.length; i++)
                            Container(
                              width: 58,
                              padding: const EdgeInsets.only(
                                left: 4.0,
                                right: 4.0,
                              ),
                              child: button(i + 1),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 273,
                    color: Colors.grey[200],
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        key: ValueKey(count),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Center(child: Text(code, style: codeTextStyle)),
                              SizedBox(height: 15),
                              Text(explanation, style: explanationTextStyle),
                            ],
                          ),
                        ),
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

  Widget button(int exampleNumber) => Button(
    key: ValueKey('button$exampleNumber'),
    isSelected: this.count == exampleNumber,
    exampleNumber: exampleNumber,
    onPressed: () {
      showExample(
        exampleNumber,
        widget.examples[exampleNumber - 1].code,
        widget.examples[exampleNumber - 1].explanation,
      );
    },
  );

  void showExample(int exampleNumber, String code, String explanation) {
    setState(() {
      this.count = exampleNumber;
      this.code = code;
      this.explanation = explanation;
    });
  }
}

/////////////////////////////////////////////

class Button extends StatelessWidget {
  final Key key;
  final bool isSelected;
  final int exampleNumber;
  final VoidCallback onPressed;

  Button({
    required this.key,
    required this.isSelected,
    required this.exampleNumber,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: isSelected ? Colors.grey : Colors.grey[800],
      child: Text(
        exampleNumber.toString(),
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Scrollable.ensureVisible(
          context,
          duration: Duration(milliseconds: 350),
          curve: Curves.easeOut,
          alignment: 0.5,
        );
        onPressed();
      },
    );
  }
}

/////////////////////////////////////////////

class Example1 extends Example {
  final String code = "Container(color: red)";
  final String explanation =
      "The screen is the parent of the Container. "
      "It forces the red Container to be exactly the same size of the screen."
      "\n\n"
      "So the Container fills the screen and it gets all red."
      "\n\n"
      "屏幕是该容器的父组件，会强制容器的尺寸与屏幕完全一致。"
      "\n\n"
      "因此该容器会铺满整个屏幕，且整体显示为红色。";

  @override
  Widget build(BuildContext context) {
    return Container(color: red);
  }
}

//////////////////////////////////////////////////

class Example2 extends Example {
  final String code = "Container(width: 100, height: 100, color: red)";
  final String explanation =
      "The red Container wants to be 100x100, but it can't, "
      "because the screen forces it to be exactly the same size of the screen."
      "\n\n"
      "So the Container fills the screen."
      "\n\n"
      "红色容器想要设置为100×100的尺寸，但无法实现，"
      "因为屏幕会强制容器的尺寸与自身完全一致。"
      "\n\n"
      "因此该容器最终铺满了整个屏幕。";

  @override
  Widget build(BuildContext context) {
    return Container(width: 100, height: 100, color: red);
  }
}

//////////////////////////////////////////////////

class Example3 extends Example {
  final String code =
      "Center(\n   child: Container(width: 100, height: 100, color: red))";
  final String explanation =
      "The screen forces the Center to be exactly the same size of the screen."
      '\n'
      "So the Center fills the screen."
      '\n'
      "The Center tells the Container it can be any size it wants, but not bigger than the screen."
      '\n'
      "Now the Container can indeed be 100x100."
      '\n\n'
      '屏幕强制Center组件的尺寸与自身完全一致，因此Center铺满整个屏幕。'
      '\n'
      'Center组件允许子容器自由设置尺寸，但不能超过屏幕大小。'
      '\n'
      '此时容器可以成功设置为100×100的尺寸。';

  @override
  Widget build(BuildContext context) {
    return Center(child: Container(width: 100, height: 100, color: red));
  }
}

//////////////////////////////////////////////////

class Example4 extends Example {
  final String code =
      "Align(\n   alignment: Alignment.bottomRight,\n   child: Container(width: 100, height: 100, color: red))";
  final String explanation =
      "This is different from the previous example in that it uses Align instead of Center."
      "\n"
      "The Align also tells the Container it can be any size it wants, but if there is empty space it will not center the Container, "
      "but will instead align it to the bottom-right of the available space."
      "\n\n"
      '本例与上例的区别是使用了Align组件而非Center组件。'
      '\n'
      'Align同样允许子容器自由设置尺寸，若存在剩余空间，不会将容器居中，'
      '\n'
      '而是按照alignment参数指定的方式（本例为右下）摆放容器。';

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(width: 100, height: 100, color: red),
    );
  }
}

//////////////////////////////////////////////////

class Example5 extends Example {
  final String code =
      "Center(\n   child: Container(\n              color: red,\n              width: double.infinity,\n              height: double.infinity))";
  final String explanation =
      "The screen forces the Center to be exactly the same size of the screen."
      "\n"
      "So the Center fills the screen."
      "\n"
      "The Center tells the Container it can be any size it wants, but not bigger than the screen."
      "\n"
      "The Container wants to be of infinite size, but since it can't be bigger than the screen it will just fill the screen."
      '\n\n'
      '屏幕强制Center组件尺寸与自身完全一致，因此Center铺满屏幕；'
      '\n'
      'Center允许子容器自由设置尺寸，但不能超过屏幕大小；'
      '\n'
      '容器想要设置为无限大，但受限于屏幕尺寸，最终只能铺满整个屏幕。';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: red,
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example6 extends Example {
  final String code = "Center(child: Container(color: red))";
  final String explanation =
      "The screen forces the Center to be exactly the same size of the screen."
      "\n"
      "So the Center fills the screen."
      "\n"
      "The Center tells the Container it is free to be any size it wants, but not bigger than the screen."
      "\n"
      "Since the Container has no child and no fixed size, it decides it wants to be as big as possible, so it fits the whole screen."
      "\n"
      "But why does the Container decide that? "
      "Simply because that's a design decision by those who created the Container widget. "
      "It could have been created differently, and you actually have to read the Container's documentation to understand what it will do depending on the circumstances. "
      '\n\n'
      '屏幕强制Center组件尺寸与自身完全一致，因此Center铺满屏幕；'
      '\n'
      'Center允许子容器自由设置尺寸，但不能超过屏幕大小；'
      '\n'
      '由于容器既没有子组件也没有固定尺寸，它会尽可能占据最大空间，因此铺满整个屏幕；'
      '\n'
      '这是Container组件的设计逻辑决定的——不同场景下Container的表现不同，需参考官方文档理解。';

  @override
  Widget build(BuildContext context) {
    return Center(child: Container(color: red));
  }
}

//////////////////////////////////////////////////

class Example7 extends Example {
  final String code =
      "Center(\n   child: Container(color: red\n      child: Container(color: green, width: 30, height: 30)))";
  final String explanation =
      "The screen forces the Center to be exactly the same size of the screen."
      "\n"
      "So the Center fills the screen."
      "\n"
      "The Center tells the red Container it can be any size it wants, but not bigger than the screen."
      "\n"
      "Since the red Container has no size but has a child, it decides it wants to be the same size of its child."
      "\n"
      "The red Container tells its child that if can be any size it wants, but not bigger than the screen."
      "\n"
      "The child happens to be a green Container, that wants to be 30x30."
      "\n"
      "As said, the red Container will size itself to its children size, so it will also be 30x30. "
      "No red color will be visible, since the green Container will occupy all of the red Container."
      '\n\n'
      '屏幕强制Center组件尺寸与自身完全一致，因此Center铺满屏幕；'
      '\n'
      'Center允许红色容器自由设置尺寸，但不能超过屏幕大小；'
      '\n'
      '红色容器未指定尺寸但包含子组件，因此会自适应为子组件的尺寸；'
      '\n'
      '红色容器允许子组件（绿色容器）自由设置尺寸，绿色容器设置为30×30；'
      '\n'
      '最终红色容器尺寸与绿色容器一致（30×30），被绿色容器完全遮挡，因此看不到红色。';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: red,
        child: Container(color: green, width: 30, height: 30),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example8 extends Example {
  final String code =
      "Center(\n   child: Container(color: red\n      padding: const EdgeInsets.all(20.0),\n      child: Container(color: green, width: 30, height: 30)))";
  final String explanation =
      "The red Container will size itself to its children size, but it takes its own padding into consideration. "
      "So it will also be 30x30, plus a 20x20 padding. "
      "The red color will be visible because of the padding, and the green Container will have the same size as the previous example."
      '\n\n'
      '红色容器会自适应子组件尺寸，但会包含自身的内边距；'
      '\n'
      '因此红色容器的最终尺寸为子组件的30×30，加上20×20的内边距；'
      '\n'
      '内边距区域会显示红色背景，而绿色容器的尺寸与上例一致（30×30）。';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        color: red,
        child: Container(color: green, width: 30, height: 30),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example9 extends Example {
  final String code =
      "ConstrainedBox(\n   constraints: BoxConstraints(\n              minWidth: 70, minHeight: 70,\n              maxWidth: 150, maxHeight: 150),\n      child: Container(color: red, width: 10, height: 10)))";
  final String explanation =
      "You would guess the Container would have to be between 70 and 150 pixels, but you would be wrong. "
      "The ConstrainedBox only imposes ADDITIONAL constraints than the ones it received from its parent."
      "\n\n"
      "Here, the screen forces the ConstrainedBox to be exactly the same size of the screen, "
      "so it will tell its child Container to also assume the size of the screen, "
      "thus ignoring its 'constraints' parameter."
      '\n\n'
      '你可能会认为容器尺寸会限制在70~150像素之间，但实际并非如此；'
      '\n'
      'ConstrainedBox仅会在父组件约束的基础上，添加额外的约束条件；'
      '\n'
      '本例中屏幕强制ConstrainedBox尺寸与自身完全一致，因此它会要求子容器也铺满屏幕，'
      '\n'
      '其constraints参数的约束条件会被忽略。';

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 70,
        minHeight: 70,
        maxWidth: 150,
        maxHeight: 150,
      ),
      child: Container(color: red, width: 10, height: 10),
    );
  }
}

//////////////////////////////////////////////////

class Example10 extends Example {
  final String code =
      "Center(\n   child: ConstrainedBox(\n      constraints: BoxConstraints(\n                 minWidth: 70, minHeight: 70,\n                 maxWidth: 150, maxHeight: 150),\n        child: Container(color: red, width: 10, height: 10))))";
  final String explanation =
      "Now, Center will allow ConstrainedBox to be any size up to the screen size."
      "\n\n"
      "The ConstrainedBox will impose its child the ADDITIONAL constraints from its 'constraints' parameter."
      "\n\n"
      "So the Container must be between 70 and 150 pixels. It wants to have 10 pixels, so it will end up having 70 (the MINIMUM)."
      '\n\n'
      '此时Center允许ConstrainedBox在不超过屏幕尺寸的范围内自由设置尺寸；'
      '\n'
      'ConstrainedBox会为子容器添加constraints参数指定的额外约束；'
      '\n'
      '因此容器尺寸必须在70~150像素之间，它原本想设置为10×10，最终会取最小值70×70。';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 70,
          minHeight: 70,
          maxWidth: 150,
          maxHeight: 150,
        ),
        child: Container(color: red, width: 10, height: 10),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example11 extends Example {
  final String code =
      "Center(\n   child: ConstrainedBox(\n      constraints: BoxConstraints(\n                 minWidth: 70, minHeight: 70,\n                 maxWidth: 150, maxHeight: 150),\n        child: Container(color: red, width: 1000, height: 1000))))";
  final String explanation =
      "Center will allow ConstrainedBox to be any size up to the screen size."
      "\n\n"
      "The ConstrainedBox will impose its child the ADDITIONAL constraints from its 'constraints' parameter."
      "\n\n"
      "So the Container must be between 70 and 150 pixels. It wants to have 1000 pixels, so it will end up having 150 (the MAXIMUM)."
      '\n\n'
      '与上例逻辑一致，ConstrainedBox会强制子容器遵守constraints参数的约束；'
      '\n'
      '容器原本想设置为1000×1000，超出约束范围，最终会取最大值150×150。';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 70,
          minHeight: 70,
          maxWidth: 150,
          maxHeight: 150,
        ),
        child: Container(color: red, width: 1000, height: 1000),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example12 extends Example {
  final String code =
      "Center(\n   child: ConstrainedBox(\n      constraints: BoxConstraints(\n                 minWidth: 70, minHeight: 70,\n                 maxWidth: 150, maxHeight: 150),\n        child: Container(color: red, width: 100, height: 100))))";
  final String explanation =
      "Center will allow ConstrainedBox to be any size up to the screen size."
      "\n\n"
      "The ConstrainedBox will impose its child the ADDITIONAL constraints from its 'constraints' parameter."
      "\n\n"
      "So the Container must be between 70 and 150 pixels. It wants to have 100 pixels, and that's the size it will have, since that's between 70 and 150."
      '\n\n'
      '与上例逻辑一致，容器设置的100×100尺寸在70~150的约束范围内，'
      '\n'
      '因此会保留原尺寸，不会被修改。';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 70,
          minHeight: 70,
          maxWidth: 150,
          maxHeight: 150,
        ),
        child: Container(color: red, width: 100, height: 100),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example13 extends Example {
  final String code =
      "UnconstrainedBox(\n   child: Container(color: red, width: 20, height: 50));";
  final String explanation =
      "The screen forces the UnconstrainedBox to be exactly the same size of the screen."
      "\n\n"
      "However, the UnconstrainedBox lets its Container child have any size it wants."
      '\n\n'
      '屏幕强制UnconstrainedBox尺寸与自身完全一致，'
      '\n'
      '但UnconstrainedBox允许其子容器自由设置任意尺寸。';

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(color: red, width: 20, height: 50),
    );
  }
}

//////////////////////////////////////////////////

class Example14 extends Example {
  final String code =
      "UnconstrainedBox(\n   child: Container(color: red, width: 4000, height: 50));";
  final String explanation =
      "The screen forces the UnconstrainedBox to be exactly the same size of the screen, "
      "and UnconstrainedBox lets its Container child have any size it wants."
      "\n\n"
      "Unfortunately, in this case the Container has 4000 pixels of width and is too big to fix UnconstrainedBox, "
      "so the UnconstrainedBox will display the much dreaded \"overflow warning\"."
      '\n\n'
      'UnconstrainedBox允许子容器设置任意尺寸，本例中容器宽度设为4000像素，'
      '\n'
      '超出了UnconstrainedBox的可用空间，因此会触发Flutter的溢出警告。';

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(color: red, width: 4000, height: 50),
    );
  }
}

//////////////////////////////////////////////////

class Example15 extends Example {
  final String code =
      "OverflowBox(\n   child: Container(color: red, width: 4000, height: 50));";
  final String explanation =
      "The screen forces the OverflowBox to be exactly the same size of the screen, "
      "and OverflowBox lets its Container child have any size it wants."
      "\n\n"
      "OverflowBox is similar to UnconstrainedBox, and the difference is that it won't display any warnings if the child doesn't fit the space."
      "\n\n"
      "In this case the Container has 4000 pixels of width, and is too big to fix OverflowBox, "
      "but the OverflowBox will simply show what it can, no warnings given."
      '\n\n'
      'OverflowBox与UnconstrainedBox逻辑类似，均允许子容器设置任意尺寸；'
      '\n'
      '核心区别是：即使子容器尺寸超出可用空间，OverflowBox也不会触发溢出警告，'
      '\n'
      '仅会显示其能容纳的部分内容。';

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      minWidth: 0,
      minHeight: 0,
      maxHeight: double.infinity,
      maxWidth: double.infinity,
      child: Container(color: red, height: 50, width: 4000),
    );
  }
}

//////////////////////////////////////////////////

class Example16 extends Example {
  final String code =
      "UnconstrainedBox(\n   child: Container(color: Colors.red, width: double.infinity, height: 100));";
  final String explanation =
      "This won't render anything, and you will get an error in the console."
      "\n\n"
      "The UnconstrainedBox lets its child have any size it wants, "
      "however its child is a Container with infinite size."
      "\n\n"
      "Flutter can't render infinite sizes, so it will throw an error with the following message: "
      "'BoxConstraints forces an infinite width.'"
      '\n\n'
      'Flutter无法渲染尺寸为无限大的组件，因此本例不会显示任何内容，'
      '\n'
      '且控制台会抛出“BoxConstraints forces an infinite width”的错误。';

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(color: red, width: double.infinity, height: 100),
    );
  }
}

//////////////////////////////////////////////////

class Example17 extends Example {
  final String code =
      "UnconstrainedBox(\n   child: LimitedBox(maxWidth: 100,\n      child: Container(color: Colors.red,\n                       width: double.infinity, height: 100));";
  final String explanation =
      "Here you won't get an error anymore, "
      "because when the LimitedBox is given an infinite size by the UnconstrainedBox, "
      "it will pass down to its child the maximum width of 100."
      "\n\n"
      "Note, if you change the UnconstrainedBox to a Center widget, "
      "the LimitedBox will not apply its limit anymore (since its limit is only applied when it gets infinite constraints), "
      "and the Container width will be allowed to grow past 100."
      "\n\n"
      "This makes it clear the difference between a LimitedBox and a ConstrainedBox."
      '\n\n'
      '父组件（UnconstrainedBox）传递了无限约束，因此LimitedBox会为子容器添加最大宽度100的约束；'
      '\n'
      '若将UnconstrainedBox替换为Center，LimitedBox的约束会失效（它仅对无限约束生效），'
      '\n'
      '容器宽度可超过100；这也体现了LimitedBox与ConstrainedBox的核心区别。';

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: LimitedBox(
        maxWidth: 100,
        child: Container(color: red, width: double.infinity, height: 100),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example18 extends Example {
  final String code = "FittedBox(\n   child: Text('Some Example Text.'));";
  final String explanation =
      "The screen forces the FittedBox to be exactly the same size of the screen."
      "\n\n"
      "The Text will have some natural width (also called its intrinsic width) that depends on the amount of text, its font size, etc."
      "\n\n"
      "The FittedBox will let the Text have any size it wants, "
      "but after the Text tells its size to the FittedBox, "
      "the FittedBox will scale it until it fills all of the available width."
      '\n\n'
      '屏幕强制FittedBox尺寸与自身完全一致，因此FittedBox铺满屏幕；'
      '\n'
      'Text组件的“固有宽度”由文本内容、字体大小等决定；'
      '\n'
      'FittedBox允许Text自由设置尺寸，但会将其缩放至填满自身的可用宽度。';

  @override
  Widget build(BuildContext context) {
    return FittedBox(child: Text('Some Example TextSome Example Text'));
  }
}

//////////////////////////////////////////////////

class Example19 extends Example {
  final String code =
      "Center(\n   child: FittedBox(\n      child: Text('Some Example Text.')));";
  final String explanation =
      "But what happens if we put the FittedBox inside of a Center? "
      "The Center will let the FittedBox have any size it wants, up to the screen size."
      "\n\n"
      "The FittedBox will then size itself to the Text, and let the Text have any size it wants."
      "\n\n"
      "Since both FittedBox and the Text have the same size, no scaling will happen."
      '\n\n'
      '屏幕强制Center铺满屏幕，Center允许FittedBox在不超过屏幕的范围内自由设置尺寸；'
      '\n'
      'FittedBox会自适应Text的尺寸，且允许Text自由设置尺寸；'
      '\n'
      '最终FittedBox与Text尺寸一致，因此不会触发缩放。';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(child: Text('Some Example TextSome Example Text')),
    );
  }
}

//////////////////////////////////////////////////

class Example20 extends Example {
  final String code =
      "Center(\n   child: FittedBox(\n      child: Text('…')));";
  final String explanation =
      "However, what happens if FittedBox is inside of Center, but the Text is too large to fit the screen?"
      "\n\n"
      "FittedBox will try to size itself to the Text, but it cannot be bigger than the screen. "
      "It will then assume the screen size, and resize the Text so that it fits the screen too."
      '\n\n'
      '当Text内容过长、尺寸超出屏幕时，FittedBox会先尝试自适应Text尺寸，'
      '\n'
      '但受限于屏幕尺寸，最终会将自身设为屏幕尺寸，并缩放Text使其适配屏幕。';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        child: Text(
          'Some Example TextSome Example TextSome Example TextSome Example TextSome Example TextSome Example TextSome Example TextSome Example TextSome Example TextSome Example Text',
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example21 extends Example {
  final String code = "Center(\n   child: Text('…'));";
  final String explanation =
      "If, however, we remove the FittedBox, "
      "the Text will get its maximum width from the screen, "
      "and will break the line so that it fits the screen."
      '\n\n'
      '移除FittedBox后，Text的最大宽度受限于屏幕，'
      '\n'
      '它会通过自动换行的方式适配屏幕尺寸，而非缩放。';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'TextSomeTextSomeTextSomeTextSomeTextSomeTextSomeTextSomeTextSomeTextSomeTextSomeTextSomeTextSomeTextSomeTextSomeTextSomeTextSomeTextSomeTextSomeTextSomeTextSomeTextSomeTextSomeTextSomeTextSome',
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example22 extends Example {
  final String code =
      "FittedBox(\n   child: Container(\n      height: 20.0, width: double.infinity));";
  final String explanation =
      "Note FittedBox can only scale a widget that is BOUNDED (has non infinite width and height)."
      "\n\n"
      "Otherwise, it won't render anything, and you will get an error in the console."
      '\n\n'
      'FittedBox仅能缩放“有界”组件（宽高为有限值）；'
      '\n'
      '若子组件要求无限尺寸，FittedBox无法完成缩放，会报错且不渲染任何内容。';

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(height: 20.0, width: double.infinity, color: Colors.red),
    );
  }
}

//////////////////////////////////////////////////

class Example23 extends Example {
  final String code =
      "Row(children:[\n   Container(color: red, child: Text('Hello!'))\n   Container(color: green, child: Text('Goodbye!'))]";
  final String explanation =
      "The screen forces the Row to be exactly the same size of the screen."
      "\n\n"
      "Just like an UnconstrainedBox, the Row won't impose any constraints to its children, "
      "and will instead let them have any size they want."
      "\n\n"
      "The Row will then put them side by side, and any extra space will remain empty."
      '\n\n'
      '屏幕强制Row组件尺寸与自身完全一致，因此Row铺满屏幕；'
      '\n'
      '与UnconstrainedBox类似，Row不会为子组件添加约束，允许它们自由设置尺寸；'
      '\n'
      'Row会将子组件从左到右依次排列，剩余空间保持空白。';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: red,
          child: Text("Hello!", style: big),
        ),
        Container(
          color: green,
          child: Text("Goodbye!", style: big),
        ),
      ],
    );
  }
}

//////////////////////////////////////////////////

class Example24 extends Example {
  final String code =
      "Row(children:[\n   Container(color: red, child: Text('…'))\n   Container(color: green, child: Text('Goodbye!'))]";
  final String explanation =
      "Since the Row won't impose any constraints to its children, "
      "it's quite possible that the children will be too big to fit the available Row width."
      "\n\n"
      "In this case, just like an UnconstrainedBox, the Row will display the \"overflow warning\"."
      '\n\n'
      'Row不为子组件添加约束，若子组件总宽度超出Row的可用宽度，'
      '\n'
      '会像UnconstrainedBox一样触发溢出警告。';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: red,
          child: Text(
            'alsdnmaklsdlakdmalkdmalkdmkaldmaldmkaldmaklsdmalsdmaklsdmakldmalsdmasdmaklsd',
            style: big,
          ),
        ),
        Container(
          color: green,
          child: Text('Nice', style: big),
        ),
      ],
    );
  }
}

//////////////////////////////////////////////////

class Example25 extends Example {
  final String code =
      "Row(children:[\n   Expanded(\n       child: Container(color: red, child: Text('…')))\n   Container(color: green, child: Text('Goodbye!'))]";
  final String explanation =
      "When a Row child is wrapped in an Expanded widget, the Row will not let this child define its own width anymore."
      "\n\n"
      "Instead, it will define the Expanded width according to the other children, and only then the Expanded widget will force the original child to have the Expanded's width."
      "\n\n"
      "In other words, once you use Expanded, the original child's width becomes irrelevant, and will be ignored."
      '\n\n'
      '当Row的子组件被Expanded包裹后，Row会接管该子组件的宽度控制权；'
      '\n'
      'Row会根据其他子组件的尺寸计算Expanded的宽度，再强制子组件适配该宽度；'
      '\n'
      '简言之，使用Expanded后，子组件自身的宽度设置会失效。';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Container(
              color: red,
              child: Text(
                'alsdnmaklsdlakdmalkdmalkdmkaldmaldmkaldmaklsdmalsdmaklsdmakldmalsdmasdmaklsd',
                style: big,
              ),
            ),
          ),
        ),
        Container(
          color: green,
          child: Text('Nice', style: big),
        ),
      ],
    );
  }
}

//////////////////////////////////////////////////

class Example26 extends Example {
  final String code =
      "Row(children:[\n   Expanded(\n       child: Container(color: red, child: Text('…')))\n   Expanded(\n       child: Container(color: green, child: Text('Goodbye!'))]";
  final String explanation =
      "If all Row children are wrapped in Expanded widgets, each Expanded will have a size proportional to its flex parameter, "
      "and only then each Expanded widget will force their child to have the Expanded's width."
      "\n\n"
      "In other words, the Expanded ignores their children preferred width."
      '\n\n'
      '若Row的所有子组件都被Expanded包裹，每个Expanded的宽度会按flex参数的比例分配（默认flex=1）；'
      '\n'
      'Expanded会强制子组件适配自身宽度，完全忽略子组件的首选宽度。';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: red,
            child: Text(
              'alsdnmaklsdlakdmalkdmalkdmkaldmaldmkaldmaklsdmalsdmaklsdmakldmalsdmasdmaklsd',
              style: big,
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: green,
            child: Text('Nice', style: big),
          ),
        ),
      ],
    );
  }
}

//////////////////////////////////////////////////

class Example27 extends Example {
  final String code =
      "Row(children:[\n   Flexible(\n       child: Container(color: red, child: Text('…')))\n   Flexible(\n       child: Container(color: green, child: Text('Goodbye!'))]";
  final String explanation =
      "The only difference if you use Flexible instead of Expanded, "
      "is that Flexible will let its child be SMALLER than the Flexible width, "
      "while Expanded forces its child to have the same width of the Expanded."
      "\n\n"
      "But both Expanded and Flexible will ignore their children width when sizing themselves."
      "\n\n"
      "Note, this means it's IMPOSSIBLE to expand Row children proportionally to their sizes. "
      "The Row will either use the exact child's with, or ignore it completely when you use Expanded or Flexible."
      '\n\n'
      'Flexible与Expanded的核心区别：'
      '\n'
      '1. Flexible允许子组件宽度小于自身分配的宽度；'
      '\n'
      '2. Expanded强制子组件宽度与自身分配的宽度完全一致；'
      '\n'
      '共性：二者计算自身宽度时，都会忽略子组件的首选宽度；'
      '\n'
      '补充：Row无法按子组件自身尺寸“比例分配”空间——要么用子组件原尺寸，要么用Expanded/Flexible强制分配。';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Container(
            color: red,
            child: Text(
              'alsdnmaklsdlakdmalkdmalkdmkaldmaldmkaldmaklsdmalsdmaklsdmakldmalsdmasdmaklsd',
              style: big,
            ),
          ),
        ),
        Flexible(
          child: Container(
            color: green,
            child: Text('Nice', style: big),
          ),
        ),
      ],
    );
  }
}

//////////////////////////////////////////////////

class Example28 extends Example {
  final String code =
      "Scaffold(\n   body: Container(color: blue,\n   child: Column(\n      children: [\n         Text('Hello!'),\n         Text('Goodbye!')])))";

  final String explanation =
      "The screen forces the Scaffold to be exactly the same size of the screen."
      "\n\n"
      "So the Scaffold fills the screen."
      "\n\n"
      "The Scaffold tells the Container it can be any size it wants, but not bigger than the screen."
      "\n\n"
      "Note: When a widget tells its child it can be smaller than a certain size, "
      "we say the widget supplies \"loose\" constraints to its child. More on that later."
      '\n\n'
      '屏幕强制Scaffold尺寸与自身完全一致，因此Scaffold铺满屏幕；'
      '\n'
      'Scaffold允许子容器在不超过屏幕的范围内自由设置尺寸（即“宽松约束”）；'
      '\n'
      '容器允许Column自由设置尺寸，Column会根据子组件计算宽度，并适配屏幕高度。';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: blue,
        child: Column(children: [Text('Hello!'), Text('Goodbye!')]),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example29 extends Example {
  final String code =
      "Scaffold(\n   body: Container(color: blue,\n   child: SizedBox.expand(\n      child: Column(\n         children: [\n            Text('Hello!'),\n            Text('Goodbye!')]))))";

  final String explanation =
      "If we want the Scaffold's child to be exactly the same size as the Scaffold itself, "
      "we can wrap its child into a SizedBox.expand."
      "\n\n"
      "Note: When a widget tells its child it must be of a certain size, "
      "we say the widget supplies \"tight\" constraints to its child. More on that later."
      '\n\n'
      'SizedBox.expand会强制子容器尺寸与Scaffold完全一致（即“严格约束”）；'
      '\n'
      '容器再强制Column尺寸与自身完全一致，因此Column铺满屏幕，且子Text组件水平居中显示。';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          color: blue,
          child: Column(children: [Text('Hello!'), Text('Goodbye!')]),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:example/components/buttons/gk_button.dart';
import 'package:example/components/dialogs/gk_dialog.dart';
import 'package:example/components/rate/gk_rating_bar.dart';
import 'package:example/components/splitter/splitter.dart';
import 'package:example/icons/example_icons_icons.dart';
import 'package:example/stores/rating_details_store/rating_details_model_store.dart';
import 'package:example/stores/request_store/request_model_store.dart';
import 'package:mobx/mobx.dart';

class RateScreen extends StatelessWidget {
  static final String name = '/rates';

  final controller = PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    final RequestModelStore request = ModalRoute.of(context).settings.arguments;
    final RatingModelStore ratingDetails = request.ratingDetails;
    reaction(
      (_) => ratingDetails.compliment,
      (Compliment compliment) {
        if (compliment == null) return;
        final page = Compliment.values.indexOf(compliment);
        controller.animateToPage(
          page,
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeOutQuint,
        );
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Rating"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 20),
                color: Colors.black12,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(50)),
                          child: Icon(
                            ExampleIcons.profile,
                            color: Colors.white70,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                    if (request.technician != null)
                      Text(request.technician.name),
                    Text(
                      request.unit.name,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: GKRatingBar(
                        initialRating: ratingDetails.rating,
                        onRatingUpdate: request.setRating,
                      ),
                    ),
                  ],
                ),
              ),
              Splitter(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Give a compliment?",
                      style: TextStyle(fontSize: 18),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      height: 220,
                      child: PageView(
                        pageSnapping: false,
                        controller: controller,
                        children: Compliment.values
                            .map(
                              (compliment) => ComplimentBlock(
                                compliment: compliment,
                                request: request,
                              ),
                            )
                            .toList(),
                      ),
                    )
                  ],
                ),
              ),
              Splitter(),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 50),
                      child: TextFormField(
                        initialValue: ratingDetails.notes,
                        onChanged: request.setRatingNotes,
                        decoration: InputDecoration(hintText: "Add Comments"),
                      ),
                    ),
                    Observer(
                      builder: (context) => GKButton(
                        onTap: () async {
                          await request.sendRate();
                          await GKDialog.show(
                              context: context,
                              reason: DialogReason.success,
                              text: 'Your feedback was submitted');
                          Navigator.pop(context);
                        },
                        text: 'Submit',
                        loading: ratingDetails.loading,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ComplimentBlock extends StatelessWidget {
  final Compliment compliment;
  final RequestModelStore request;

  final Map<Compliment, ImageWithText> complimentValue = {
    Compliment.cleanliness: ImageWithText(
      image: 'assets/compliments/clean_work',
      text: '\nCleanliness',
    ),
    Compliment.fastService: ImageWithText(
      image: 'assets/compliments/fast_service',
      text: '\nFast Service',
    ),
    Compliment.qualityWorkmanship: ImageWithText(
      image: 'assets/compliments/high_quality',
      text: 'Quality\nworkmanship',
    ),
    Compliment.proffesionalisn: ImageWithText(
      image: 'assets/compliments/tech_profesionnalism',
      text: '\nProfessionalisn',
    ),
  };

  final Map<ComplimentState, num> stateSize = {
    ComplimentState.initial: 100.0,
    ComplimentState.notSelected: 80.0,
    ComplimentState.selected: 120.0,
  };

  ComplimentBlock({
    @required this.compliment,
    @required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final content = complimentValue[compliment];
    final ratingDetails = request.ratingDetails;

    return Observer(
      builder: (_) {
        ComplimentState state;
        if (ratingDetails.compliment == null) {
          state = ComplimentState.initial;
        } else if (ratingDetails.compliment == compliment) {
          state = ComplimentState.selected;
        } else {
          state = ComplimentState.notSelected;
        }
        final size = stateSize[state];
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () => request.setCompliment(compliment),
              child: AnimatedContainer(
                curve: Curves.easeOutQuint,
                duration: Duration(milliseconds: 400),
                width: size,
                height: size,
                child: Image.asset(state == ComplimentState.selected
                    ? '${content.image}_full.png'
                    : '${content.image}.png'),
              ),
            ),
            Center(
              child: Text(
                content.text,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          ],
        );
      },
    );
  }
}

enum ComplimentState {
  initial,
  selected,
  notSelected,
}

class ImageWithText {
  final String image;
  final String text;

  ImageWithText({this.image, this.text});
}

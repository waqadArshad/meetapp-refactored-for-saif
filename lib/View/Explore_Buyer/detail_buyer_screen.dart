import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meeter/Model/demand_data.dart';
import 'package:meeter/providers/user_controller.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/Widgets/HWidgets/detail_data.dart';
import 'package:meeter/Widgets/HWidgets/detail_appbar_buyer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailsBuyerScreen extends StatefulWidget {
  final DemandData demands;
  DetailsBuyerScreen(this.demands);
  @override
  _DetailsBuyerScreenState createState() => _DetailsBuyerScreenState();
}

class _DetailsBuyerScreenState extends State<DetailsBuyerScreen> {
  OurUser? demandPerson;
  int? likes;
  late FirebaseAuth _auth;
  String timesAgo = "";

  onLoad() async {
    UserController user = UserController();
    demandPerson = await user.getUserInfo(widget.demands.demand_person_uid!);
    if (demandPerson != null) {
      FirebaseFirestore.instance
          .collection('demands')
          .doc(demandPerson!.uid)
          .collection('demand')
          .doc(widget.demands.demand_id)
          .snapshots()
          .listen((event) {
        likes = event['demand_likes'];
        setState(() {});
      });
    }
  }

  calcTimesAgo() {
    Duration dur = DateTime.now().difference(widget.demands.demand_date!);
    print(dur.inHours);
    if (dur.inHours < 24) {
      timesAgo = "Moments ago";
      setState(() {});
    }
    if (dur.inDays > 0 && dur.inDays < 7) {
      timesAgo =
          dur.inDays == 1 ? "${dur.inDays} day ago" : "${dur.inDays} days ago";
      setState(() {});
    }
    if (dur.inDays >= 7 && dur.inDays < 30) {
      timesAgo = (dur.inDays / 7).truncate() == 1
          ? "${(dur.inDays / 7).truncate()} week ago"
          : "${(dur.inDays / 7).truncate()} weeks ago";
      setState(() {});
    }
    if (dur.inDays >= 30 && dur.inDays < 365) {
      timesAgo = (dur.inDays / 30).truncate() == 1
          ? "${(dur.inDays / 30).truncate()} month ago"
          : "${(dur.inDays / 30).truncate()} months ago";
      setState(() {});
    }
    if (dur.inDays >= 365) {
      timesAgo = (dur.inDays / 365).truncate() == 1
          ? "${(dur.inDays / 365).truncate()} year ago"
          : "${(dur.inDays / 365).truncate()} years ago";
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calcTimesAgo();
    onLoad();
    _auth = FirebaseAuth.instance;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                DetailsData(
                  bannerImage: widget.demands.demand_bannerImage,
                  titleText: widget.demands.demand_title,
                  priceText: "\$${widget.demands.demand_price}",
                  priceText1: '/ 30 min',
                  timesAgo: timesAgo,
                  likesText: likes,
                  // categoryText: 'In Category',
                  detailText: widget.demands.demand_description,
                  location: widget.demands.demand_location,
                ),
              ],
            ),
          ),
          demandPerson != null
              ? _auth.currentUser!.uid != demandPerson!.uid
                  ? Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: DetailBarBuyer(
                            widget.demands, demandPerson!, likes!),
                      ),
                    )
                  : Container()
              : Container()
        ],
      ),
    );
  }
}

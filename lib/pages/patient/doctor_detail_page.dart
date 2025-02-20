import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sos_docteur/constants/controllers.dart';
import 'package:sos_docteur/constants/style.dart';
import 'package:sos_docteur/index.dart';
import 'package:sos_docteur/models/patients/home_model.dart';
import 'package:sos_docteur/models/patients/medecin_data_profil_view_model.dart';
import 'package:sos_docteur/pages/medecin/widgets/photo_viewer_widget.dart';
import 'package:sos_docteur/screens/auth_screen.dart';
import 'package:sos_docteur/utilities/utilities.dart';
import 'package:sos_docteur/widgets/user_session_widget.dart';

import 'avis_details_page.dart';
import 'details/ordre_details_page.dart';

class DoctorDetailPage extends StatefulWidget {
  final Profile profil;
  final HomeMedecins supDatas;
  const DoctorDetailPage({Key key, this.profil, this.supDatas})
      : super(key: key);
  @override
  _DoctorDetailPageState createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  String selectedDispoId = "";
  String selectedHoureId = "";

  List<Heures> heures = [];
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      uid: storage.read("patient_id").toString(),
      scaffold: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildStackHeader(context),
              Expanded(
                child: Container(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: _orderWidget(context),
                          ),
                          const HeaderTiles(
                            title: "Expériences professionnelles",
                            iconPath: "assets/icons/medical-svgrepo-com.svg",
                          ),
                          if ((widget.profil.experiences != null) &&
                              (widget.profil.experiences.isNotEmpty)) ...[
                            for (int index = 0;
                                index < widget.profil.experiences.length;
                                index++) ...[
                              ExpCard(
                                data: widget.profil.experiences[index],
                              )
                            ],
                          ],
                          const HeaderTiles(
                            title: "Etudes faites",
                            iconPath: "assets/icons/study.svg",
                          ),
                          if ((widget.profil.etudesFaites != null) &&
                              (widget.profil.etudesFaites.isNotEmpty)) ...[
                            for (int index = 0;
                                index < widget.profil.etudesFaites.length;
                                index++) ...[
                              ECard(
                                data: widget.profil.etudesFaites[index],
                              )
                            ],
                          ],

                          //services section
                          const HeaderTiles(
                            title: "Services",
                            iconPath:
                                "assets/icons/microscope-medical-svgrepo-com.svg",
                          ),
                          const ServiceCard(
                            label: "Interprétation des résultats",
                            icon: CupertinoIcons.doc_plaintext,
                          ),
                          const ServiceCard(
                            label: "Télé-consultation",
                            icon: CupertinoIcons.videocam,
                          ),

                          //end services section

                          const HeaderTiles(
                            title: "Autres diplômes",
                            iconPath: "assets/icons/medicine-sign.svg",
                          ),
                          if ((widget.supDatas.specialites != null) &&
                              (widget.supDatas.specialites.isNotEmpty)) ...[
                            for (int i = 0;
                                i < widget.supDatas.specialites.length;
                                i++) ...[
                              SpecCard(
                                data: widget.supDatas.specialites[i],
                              )
                            ],
                          ],
                          if ((widget.profil.langues != null) &&
                              (widget.profil.langues.isNotEmpty)) ...[
                            const HeaderTiles(
                              title: "Langues de consultation",
                              iconPath: "assets/icons/speech-svgrepo-com.svg",
                            ),
                            GridView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.fromLTRB(
                                10.0,
                                0,
                                10.0,
                                10.0,
                              ),
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 3.5,
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                              ),
                              itemCount: widget.profil.langues.length,
                              itemBuilder: (context, index) {
                                var data = widget.profil.langues[index];
                                // ignore: avoid_unnecessary_containers
                                return Container(
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: primaryColor.withOpacity(.2),
                                        width: .5,
                                      ),
                                    ),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 10.0,
                                        color: Colors.grey.withOpacity(.2),
                                        offset: const Offset(0, 3),
                                      )
                                    ],
                                  ),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/speech-svgrepo-com.svg",
                                          height: 15.0,
                                          width: 15.0,
                                          color: primaryColor,
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          data.langue,
                                          style: GoogleFonts.lato(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                          const Divider(
                            height: 30.0,
                            color: Colors.grey,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.profil.agenda != null &&
                                  widget.profil.agenda.isNotEmpty) ...[
                                Center(
                                  child: Text(
                                    "Veuillez renseigner les champs ci-dessous pour prendre un rendez-vous avec le Médecin !",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.amber[900],
                                      letterSpacing: 0.50,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 25.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.calendar,
                                        color: darkBlueColor,
                                        size: 15.0,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        "Sélectionnez le mois !",
                                        style: GoogleFonts.lato(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 10.0),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      for (int i = 0;
                                          i < widget.profil.agenda.length;
                                          i++) ...[
                                        DateCard(
                                          isActive:
                                              widget.profil.agenda[i].isActive,
                                          months: strSpliter(strDateLong(
                                              widget.profil.agenda[i].date))[0],
                                          day: strSpliter(strDateLong(
                                              widget.profil.agenda[i].date))[1],
                                          year: strSpliter(strDateLong(
                                              widget.profil.agenda[i].date))[3],
                                          onPressed: () {
                                            setState(() {
                                              heures.clear();
                                              for (var e
                                                  in widget.profil.agenda) {
                                                if (e.isActive == true) {
                                                  e.isActive = false;
                                                }
                                              }
                                              widget.profil.agenda[i].isActive =
                                                  true;
                                              heures.addAll(widget
                                                  .profil.agenda[i].heures);
                                              selectedDispoId = widget
                                                  .profil.agenda[i].agendaId;
                                            });
                                          },
                                        )
                                      ]
                                    ],
                                  ),
                                )
                              ],
                              // ignore: sized_box_for_whitespace
                              const SizedBox(height: 10.0),
                              if ((heures != null) && (heures.isNotEmpty)) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.time_solid,
                                        color: darkBlueColor,
                                        size: 18.0,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        "Sélectionnez une heure de rendez-vous !",
                                        style: GoogleFonts.lato(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                              if ((heures != null) && (heures.isNotEmpty))
                                const SizedBox(height: 20.0),
                              if ((heures != null) && (heures.isNotEmpty)) ...[
                                SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (int i = 0;
                                          i < heures.length;
                                          i++) ...[
                                        TimeCard(
                                          isActive: heures[i].isSelected,
                                          time: heures[i].heure,
                                          onPressed: () {
                                            for (var e in heures) {
                                              if (e.isSelected == true) {
                                                setState(() {
                                                  e.isSelected = false;
                                                });
                                              }
                                            }
                                            setState(() {
                                              heures[i].isSelected = true;
                                            });
                                            if (heures[i].isSelected) {
                                              selectedHoureId =
                                                  heures[i].agendaHeureId;
                                              print(heures[i].agendaHeureId);
                                            }
                                          },
                                        )
                                      ]
                                    ],
                                  ),
                                )
                              ],
                              if ((heures != null) && (heures.isNotEmpty)) ...[
                                const SizedBox(height: 20.0),
                              ],
                              if ((widget.profil.agenda != null) &&
                                  (widget.profil.agenda.isEmpty)) ...[
                                Center(
                                  child: Text(
                                    "Médecin indisponible !",
                                    style: GoogleFonts.lato(
                                      fontSize: 18.0,
                                      color: Colors.red[300],
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                )
                              ] else ...[
                                Container(
                                  height: 50.0,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  width: MediaQuery.of(context).size.width,
                                  // ignore: deprecated_member_use
                                  child: RaisedButton(
                                    onPressed: () => reserverRdv(context),
                                    color: Colors.orange[800],
                                    child: Text(
                                      "Prendre un rendez-vous".toUpperCase(),
                                      style: style1(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                )
                              ],
                              Container(
                                height: 50.0,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      primaryColor,
                                      darkBlueColor,
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Les avis des autres patients",
                                        style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                      // ignore: deprecated_member_use
                                      RaisedButton(
                                        color: Colors.blue,
                                        child: Text(
                                          "voir plus",
                                          style: GoogleFonts.lato(
                                            color: Colors.white,
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              child: AvisDetailsPage(
                                                doctorName: widget.supDatas.nom,
                                                avis: widget.profil.avis,
                                              ),
                                              type: PageTransitionType
                                                  .leftToRightWithFade,
                                            ),
                                          );
                                        },
                                        elevation: 5,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              buildContainerCommentaires()
                            ],
                          )
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
    );
  }

  Future<void> reserverRdv(context) async {
    bool isConnected = storage.read("isPatient") ?? false;
    if (isConnected == false) {
      XDialog.showConfirmation(
        context: context,
        icon: Icons.help_rounded,
        title: "Connectez-vous !",
        content:
            "vous devez vous connecter à votre compte pour prendre un rendez-vous avec le Médecin !",
      );
      return;
    }
    if (selectedDispoId.isEmpty) {
      Get.snackbar(
        "Action obligatoire !",
        "vous devez sélectionner une date de disponibilité du médecin!",
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.amber[900],
        maxWidth: MediaQuery.of(context).size.width - 4,
        borderRadius: 2,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (selectedHoureId.isEmpty) {
      Get.snackbar(
        "Action obligatoire !",
        "vous devez sélectionner une heure de disponibilité du médecin!",
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.amber[900],
        maxWidth: MediaQuery.of(context).size.width - 4,
        borderRadius: 2,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    try {
      Xloading.showLottieLoading(context);
      var result = await PatientApi.prendreRdvEnLigne(
          dateId: selectedDispoId, heureId: selectedHoureId);
      if (result != null) {
        Xloading.dismiss();
        if (result['reponse']['status'] == "success") {
          XDialog.showSuccessAnimation(context);
          setState(() {
            selectedDispoId = "";
            selectedHoureId = "";
            heures.clear();
          });
          Future.delayed(const Duration(milliseconds: 800), () {
            patientController.refreshDatas();
            Get.back();
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Widget buildContainerCommentaires() {
    return Container(
      height: 200.0,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
        itemCount: widget.profil.avis.length,
        itemBuilder: (context, index) {
          var data = widget.profil.avis[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            child: CommentaireCard(
              avis: data,
            ),
          );
        },
      ),
    );
  }

  Widget buildStackHeader(BuildContext context) {
    return Stack(
      // ignore: deprecated_member_use
      overflow: Overflow.visible,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .35,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage("assets/images/vector/undraw_medicine_b1ol.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [darkBlueColor.withOpacity(.9), Colors.cyan],
                begin: Alignment.center,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.supDatas.photo.isNotEmpty ||
                      widget.supDatas.photo.length > 200)
                    Container(
                      height: 110.0,
                      width: 110.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: MemoryImage(
                            base64Decode(
                              widget.supDatas.photo,
                            ),
                          ),
                        ),
                      ),
                      // ignore: prefer_const_constructors
                    )
                  else
                    Container(
                      height: 110.0,
                      width: 110.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.cyan,
                            Colors.blue[800],
                          ],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 12.0,
                            color: Colors.black26,
                            offset: Offset(0, 3),
                          )
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.person,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "Dr. ${widget.supDatas.nom}",
                    style: style1(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.supDatas.specialites != null &&
                            widget.supDatas.specialites.isNotEmpty
                        ? widget.supDatas.specialites.length > 1
                            ? widget.supDatas.specialites[0].specialite + ",..."
                            : widget.supDatas.specialites[0].specialite
                        : "aucune spécialité",
                    style: style1(color: Colors.grey[300]),
                  ),
                  const SizedBox(height: 8.0),
                  Center(
                    child: RatingBar.builder(
                      wrapAlignment: WrapAlignment.center,
                      initialRating: widget.supDatas.cote.toDouble(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemSize: 13.0,
                      allowHalfRating: false,
                      ignoreGestures: true,
                      unratedColor: Colors.transparent,
                      itemCount: 3,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.orange.withOpacity(.7),
                      ),
                      updateOnDrag: false,
                      onRatingUpdate: (double value) {},
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 10.0,
          right: 10.0,
          left: 10.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(.3),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Center(
                    child: Icon(
                      CupertinoIcons.back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (storage.read("isPatient") == true)
                UserSession()
              else
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.leftToRightWithFade,
                        alignment: Alignment.topCenter,
                        child: const AuthScreen(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0)),
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.person_circle_fill,
                          color: primaryColor,
                          size: 18.0,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          "Se connecter",
                          style: style1(
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _orderWidget(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
          height: 80.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                blurRadius: 12.0,
                color: Colors.black.withOpacity(.2),
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Center(
            child: (widget.profil.medecinOrdres != null &&
                    widget.profil.medecinOrdres.isNotEmpty)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: "Pays : ",
                                style: GoogleFonts.lato(
                                  color: primaryColor,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(
                                    text: truncateString(
                                      widget.profil.medecinOrdres.first.pays,
                                      22,
                                      pointed: true,
                                    ),
                                    style: GoogleFonts.lato(
                                      color: darkBlueColor,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            RichText(
                              text: TextSpan(
                                text: "N° d'ordre : ",
                                style: GoogleFonts.lato(
                                  color: primaryColor,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget
                                        .profil.medecinOrdres.first.numeroOrdre,
                                    style: GoogleFonts.lato(
                                      color: darkBlueColor,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ignore: deprecated_member_use
                      FlatButton(
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.arrow_right_alt_sharp,
                              size: 15,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              "Voir plus",
                              style: GoogleFonts.lato(color: Colors.white),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.leftToRightWithFade,
                              alignment: Alignment.topCenter,
                              child: OrdreDetailsPage(
                                medecinOrdres: widget.profil.medecinOrdres,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  )
                : Text(
                    "Non répertorié !",
                    style: GoogleFonts.lato(color: Colors.pink),
                  ),
          ),
        ),
        Positioned(
          top: -10.0,
          left: 10.0,
          right: 10.0,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                colors: [
                  Colors.pink,
                  darkBlueColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.2),
                  blurRadius: 10.0,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Center(
              child: Text(
                "Ordres de médecin",
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        )
      ],
      clipBehavior: Clip.none,
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String label;
  final IconData icon;
  const ServiceCard({
    Key key,
    this.label,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(.3),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.3),
              blurRadius: 10,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 18.0,
                    color: darkBlueColor,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    label,
                    style: GoogleFonts.lato(color: Colors.black),
                  ),
                ],
              ),
              Icon(
                CupertinoIcons.arrow_right_circle,
                color: Colors.grey[400],
              )
            ],
          ),
        ));
  }
}

class SpecCard extends StatelessWidget {
  final HomeSpecialites data;
  const SpecCard({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8, left: 10.0, right: 10.0),
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            blurRadius: 12.0,
            offset: const Offset(0, 10.0),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 30.0,
            width: 30.0,
            decoration: BoxDecoration(
                color: primaryColor.withOpacity(.5), shape: BoxShape.circle),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: SvgPicture.asset(
                  "assets/icons/medicine-sign.svg",
                  color: Colors.white,
                  width: 20.0,
                  height: 20.0,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Flexible(
            child: Text(
              data.specialite,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SpeechCard extends StatelessWidget {
  final Langues data;
  const SpeechCard({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8, left: 10.0, right: 10.0),
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            blurRadius: 12.0,
            offset: const Offset(0, 10.0),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 30.0,
            width: 30.0,
            decoration: BoxDecoration(
              color: Colors.grey[800],
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: SvgPicture.asset(
                  "assets/icons/speech-svgrepo-com.svg",
                  color: Colors.white,
                  width: 20.0,
                  height: 20.0,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Flexible(
            child: Text(
              data.langue,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderTiles extends StatelessWidget {
  final String title;
  final String iconPath;
  const HeaderTiles({
    Key key,
    this.title,
    this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        gradient: LinearGradient(
          colors: [
            primaryColor,
            darkBlueColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Container(
              height: 30.0,
              width: 30.0,
              margin: const EdgeInsets.only(right: 8.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  color: primaryColor,
                  height: 20.0,
                  width: 20.0,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              title,
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 16.0,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpCard extends StatelessWidget {
  final Experiences data;
  const ExpCard({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: double.infinity,
      margin: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: 10.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: const DecorationImage(
          image: AssetImage("assets/images/shapes/bg3.png"),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 12.0,
            color: Colors.black.withOpacity(.1),
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white.withOpacity(.7),
          boxShadow: [
            BoxShadow(
              blurRadius: 12.0,
              color: Colors.black.withOpacity(.1),
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 25.0,
                          width: 25.0,
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(.5),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(5.0),
                          child: SvgPicture.asset(
                            "assets/icons/medical-svgrepo-com.svg",
                            height: 20.0,
                            width: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        const Text("A travailler à "),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      data.entite,
                      style: GoogleFonts.lato(
                        color: primaryColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 15.0, color: Colors.grey),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 25.0,
                          width: 25.0,
                          decoration: BoxDecoration(
                            color: Colors.cyan[900].withOpacity(.5),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(5.0),
                          child: const Icon(CupertinoIcons.flag,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        const Text("Pays"),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      data.adresse.pays,
                      style: GoogleFonts.lato(
                        color: Colors.cyan[800],
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  "De ${data.periodeDebut} à ${data.periodeFin}",
                  style: GoogleFonts.lato(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ECard extends StatelessWidget {
  final EtudesFaites data;
  const ECard({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: 10.0,
      ),
      child: Stack(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: const DecorationImage(
                image: AssetImage("assets/images/shapes/bg3.png"),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 12.0,
                  color: Colors.black.withOpacity(.1),
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white.withOpacity(.7),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12.0,
                    color: Colors.black.withOpacity(.1),
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 25.0,
                                width: 25.0,
                                decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(.5),
                                    shape: BoxShape.circle),
                                padding: const EdgeInsets.all(5.0),
                                child: SvgPicture.asset(
                                  "assets/icons/study.svg",
                                  height: 20.0,
                                  width: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              const Text(
                                "Institut ou Université",
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            data.institut,
                            style: GoogleFonts.lato(
                              color: primaryColor,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 15.0, color: Colors.grey),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 25.0,
                                width: 25.0,
                                decoration: BoxDecoration(
                                    color: Colors.cyan[900].withOpacity(.5),
                                    shape: BoxShape.circle),
                                padding: const EdgeInsets.all(5.0),
                                child: SvgPicture.asset(
                                  "assets/icons/study.svg",
                                  height: 20.0,
                                  width: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              const Text("Etude"),
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            data.etude,
                            style: GoogleFonts.lato(
                              color: Colors.cyan[800],
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        "De ${data.periodeDebut} à ${data.periodeFin}",
                        style: GoogleFonts.lato(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10.0,
            right: 10.0,
            // ignore: deprecated_member_use
            child: FlatButton(
              padding: const EdgeInsets.all(8.0),
              color: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_right_alt_sharp,
                    size: 15,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    "Voir diplôme",
                    style: GoogleFonts.lato(color: Colors.white),
                  ),
                ],
              ),
              onPressed: data.certificat != null && data.certificat.length > 200
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoViewer(
                            tag: data.institut,
                            image: data.certificat,
                          ),
                        ),
                      );
                    }
                  : null,
            ),
          )
        ],
      ),
    );
  }
}

class DateCard extends StatelessWidget {
  final String months;
  final String day;
  final String year;
  final bool isActive;
  final Function onPressed;
  const DateCard({
    Key key,
    this.months,
    this.day,
    this.year,
    this.isActive = false,
    this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 100.0,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        width: 80.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              color:
                  isActive ? Colors.transparent : Colors.green.withOpacity(.5)),
          color: isActive ? Colors.green : Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$months.",
                style: GoogleFonts.lato(
                    color: isActive ? Colors.white : darkBlueColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                day,
                style: GoogleFonts.lato(
                  color: isActive ? Colors.white : Colors.green[700],
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                year,
                style: GoogleFonts.lato(
                  color: isActive ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentaireCard extends StatelessWidget {
  final Avis avis;
  const CommentaireCard({
    Key key,
    this.avis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 50.0,
          width: 50.0,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.cyan),
          child: Center(
            child: Text(
              avis.patient.substring(0, 1),
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 20.0),
            ),
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Flexible(
          child: Container(
            height: 80.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage("assets/images/shapes/bg1.png"),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  blurRadius: 12.0,
                  color: Colors.grey.withOpacity(.2),
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.9),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: [
                  Flexible(
                    child: Text(
                      avis.avis,
                      style: GoogleFonts.lato(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(strDateLongFr(avis.dateEnregistrement),
                        style: GoogleFonts.lato(color: Colors.blue)),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class HeadingTitle extends StatelessWidget {
  final IconData icon;
  final String title, subTitle;
  final Color color;
  const HeadingTitle({this.icon, this.title, this.subTitle, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20.0),
              const SizedBox(
                width: 10.0,
              ),
              Flexible(
                child: Text(
                  title,
                  style: GoogleFonts.lato(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              subTitle ?? "",
              style: GoogleFonts.lato(
                color: Colors.blue[800],
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimeCard extends StatelessWidget {
  final bool isActive;
  final String time;
  final Function onPressed;

  const TimeCard({Key key, this.isActive, this.time, this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.orange.withOpacity(.5),
              width: .5,
            ),
            borderRadius: BorderRadius.circular(5.0),
            color: (isActive) ? Colors.orange.withOpacity(.5) : Colors.white),
        height: 40.0,
        width: 80.0,
        child: Center(
          child: Text(
            time,
            style: style1(
                color: (isActive) ? Colors.white : Colors.orange[800],
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

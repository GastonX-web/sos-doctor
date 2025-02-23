import 'package:flutter/cupertino.dart';
import 'package:sos_docteur/models/medecins/medecin_profil.dart';
import 'package:sos_docteur/widgets/user_session_widget.dart';

import '../../index.dart';
import 'medecin_agenda_config.dart';

class MedecinAgendaPageView extends StatefulWidget {
  const MedecinAgendaPageView({Key key}) : super(key: key);

  @override
  _MedecinAgendaPageViewState createState() => _MedecinAgendaPageViewState();
}

class _MedecinAgendaPageViewState extends State<MedecinAgendaPageView> {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      uid: storage.read("medecin_id").toString(),
      scaffold: Scaffold(
        floatingActionButton: FloatingActionButton(
          elevation: 10.0,
          tooltip: "Configuration de l'agenda",
          backgroundColor: Colors.blue,
          child: const Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                child: const MedecinAgendaConfigPage(),
                type: PageTransitionType.rightToLeftWithFade,
              ),
            );
          },
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/shapes/bg4p.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.8),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
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
                            const SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              "Mon agenda",
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        if (storage.read("isMedecin") == true) UserSession()
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      return Container(
                        child: medecinController
                                .medecinProfil.value.datas.profilAgenda.isEmpty
                            ? Center(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 20.0),
                                  height: 70.0,
                                  width: MediaQuery.of(context).size.width,
                                  // ignore: deprecated_member_use
                                  child: RaisedButton(
                                    elevation: 10.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    color: Colors.blue[800],
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType
                                              .rightToLeftWithFade,
                                          alignment: Alignment.topCenter,
                                          curve: Curves.easeIn,
                                          child:
                                              const MedecinAgendaConfigPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Configurer votre agenda",
                                      style:
                                          GoogleFonts.lato(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: medecinController.medecinProfil.value
                                    .datas.profilAgenda.length,
                                itemBuilder: (context, index) {
                                  var data = medecinController.medecinProfil
                                      .value.datas.profilAgenda[index];
                                  return AgendaCard(
                                    heures: data.heures,
                                    date: data.date,
                                    onRemoved: () async {
                                      XDialog.show(
                                        context: context,
                                        icon: Icons.help_rounded,
                                        content:
                                            "Etes-vous sûr de vouloir supprimer définitivement votre ce rendez-vous ?",
                                        title: "Suppression rdv!",
                                        onValidate: () async {
                                          Get.back();
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AgendaCard extends StatelessWidget {
  final String date;
  final List<HeuresDispo> heures;
  final Function onRemoved;
  const AgendaCard({
    Key key,
    this.date,
    @required this.heures,
    this.onRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 120.0,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                blurRadius: 10.0,
                offset: const Offset(0, 3),
                color: Colors.grey.withOpacity(.3),
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 118,
                width: 6.0,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(8.0),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Agenda date & heure de disponibilité",
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w700,
                              fontSize: 15.0,
                            ),
                          ),
                          Container(
                            height: 25.0,
                            width: 25.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              gradient: const LinearGradient(
                                colors: [Colors.pink, Colors.black],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Material(
                              borderRadius: BorderRadius.circular(25.0),
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: onRemoved,
                                borderRadius: BorderRadius.circular(25.0),
                                child: const Center(
                                  child: Icon(
                                    Icons.clear,
                                    size: 14.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 15.0,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "${strDateLongFr(date)} ".capitalize,
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time_outlined,
                            size: 15.0,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          if (heures != null) ...[
                            Flexible(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (int i = 0; i < heures.length; i++) ...[
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white30,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Text(
                                          "${heures.first.heure} à ${heures.last.heure}",
                                          style: GoogleFonts.lato(
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        margin:
                                            const EdgeInsets.only(right: 8.0),
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                            )
                          ] else ...[
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white30,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                "Aucune heure répertoriée !",
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.pink,
                                ),
                              ),
                              margin: const EdgeInsets.only(right: 8.0),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, bottom: 10.0),
          child: Row(
            children: [
              Container(
                height: 10.0,
                width: 10.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              Flexible(
                child: Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.black,
                ),
              )
            ],
          ),
        )
      ],
    );
    /*Card(
      margin: const EdgeInsets.only(bottom: 10.0),
      elevation: 3.0,
      child: Container(
        height: 110.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 80.0,
                width: 80.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    primaryColor,
                    Colors.blue[300],
                  ], begin: Alignment.center, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      "assets/icons/schedule-svgrepo-com.svg",
                      color: Colors.white,
                      height: 25.0,
                      width: 25.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${strDateLongFr(date)} ".toUpperCase(),
                          style: GoogleFonts.lato(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          ),
                        ),
                        GestureDetector(
                          onTap: onRemoved,
                          child: Container(
                            height: 30.0,
                            width: 80.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.grey[800],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(.4),
                                  blurRadius: 12.0,
                                  offset: const Offset(0, 3),
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Annuler",
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    if (heures != null) ...[
                      SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int i = 0; i < heures.length; i++) ...[
                              TimeCard(
                                start: heures.first.heure,
                                end: heures.last.heure,
                              )
                            ]
                          ],
                        ),
                      )
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );*/
  }
}

class TimeCard extends StatelessWidget {
  final String start, end;
  const TimeCard({
    Key key,
    this.start,
    this.end,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
        child: Row(
          children: [
            Row(
              children: [
                Icon(
                  CupertinoIcons.time_solid,
                  color: primaryColor,
                  size: 16.0,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Text(
                  start,
                  style: GoogleFonts.lato(
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                  ),
                )
              ],
            ),
            Container(
              width: 15.0,
              height: 2,
              color: primaryColor,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
            ),
            Row(
              children: [
                Icon(
                  CupertinoIcons.time_solid,
                  color: Colors.cyan[800],
                  size: 16.0,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Text(
                  end,
                  style: GoogleFonts.lato(
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> time = [
    "10h-12h",
    "14h-16h",
    "16h-18h",
    "18h-20h",
  ];
  String selectedTime = "";
  List<String> reservedTime = [];
  String selectedStand = "";

  List<String> stands = [
    "Yatoo",
    "Mg Tbelbou",
    "Aziza cité zouhour",
    "Monoprix",
    "Librairie Jmai",
    "Librairie AL Raed",
    "Mg Bab Bhar",
  ];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    await fetchReservedTimes().then((value) {
      setState(() {
        reservedTime = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [],
        leading: const SizedBox(),
        title: Text(
          "Key Club Gabes Coast",
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              "Please select which time you want to reserve.",
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3.4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  shrinkWrap: true,
                  itemCount: time.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        if (selectedTime == time[index]) {
                          setState(() {
                            selectedTime = "";
                          });
                        } else {
                          setState(() {
                            selectedTime = time[index];
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(99),
                      child: Container(
                        width: 100,
                        height: 35,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedTime != time[index]
                                ? Colors.grey
                                : Colors.black,
                            width: selectedTime != time[index] ? 1 : 1.3,
                          ),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Center(
                          child: Text(
                            time[index],
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: selectedTime != time[index]
                                  ? FontWeight.w300
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Please select the stand you want to book.",
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3.4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                shrinkWrap: true,
                itemCount: stands.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if (selectedStand == stands[index]) {
                        setState(() {
                          selectedStand = "";
                        });
                      } else {
                        setState(() {
                          selectedStand = stands[index];
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(99),
                    child: Container(
                      width: 100,
                      height: 35,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedStand != stands[index]
                              ? Colors.grey
                              : Colors.black,
                          width: selectedStand != stands[index] ? 1 : 1.3,
                        ),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Center(
                        child: Text(
                          stands[index],
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: selectedStand != stands[index]
                                ? FontWeight.w300
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: InkWell(
                onTap: () async {
                  TextEditingController controller = TextEditingController();
                  TextEditingController controller2 = TextEditingController();
                  if (selectedTime != "" && selectedStand != "") {
                    if (reservedTime.contains("$selectedTime-$selectedStand")) {
                      String phrase = await getReservationString(
                          selectedTime, selectedStand);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            child: Container(
                              width: 250,
                              height: 250,
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 20,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Sorry too late,  this time is already reserved!",
                                    style: GoogleFonts.lato(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    phrase,
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "OK !!",
                                      style: GoogleFonts.lato(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Add the members of the club",
                                  style: GoogleFonts.lato(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                    hintText: "First member name",
                                    hintStyle: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    // border: const OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: controller2,
                                  decoration: InputDecoration(
                                    hintText: "Second member name",
                                    hintStyle: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    // border: const OutlineInputBorder(),
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () async {
                                    if (controller.text.isNotEmpty &&
                                        controller2.text.isNotEmpty) {
                                      await confirmReservation(
                                        time.indexOf(selectedTime),
                                        selectedTime,
                                        selectedStand,
                                        controller.text,
                                        controller2.text,
                                      );
                                      setState(() {
                                        selectedTime = "";
                                        selectedStand = "";
                                      });
                                      await fetch();
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: controller.text.isNotEmpty &&
                                                controller2.text.isNotEmpty
                                            ? Colors.black
                                            : Colors.grey,
                                        width: controller.text.isNotEmpty &&
                                                controller2.text.isNotEmpty
                                            ? 1.5
                                            : 1,
                                      ),
                                      borderRadius: BorderRadius.circular(99),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Confirm",
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: controller
                                                      .text.isNotEmpty &&
                                                  controller2.text.isNotEmpty
                                              ? FontWeight.w400
                                              : FontWeight.w200,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }
                },
                borderRadius: BorderRadius.circular(99),
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedTime != "" && selectedStand != ""
                          ? Colors.black
                          : Colors.grey,
                      width:
                          selectedTime != "" && selectedStand != "" ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Center(
                    child: Text(
                      "Book",
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: selectedTime != "" && selectedStand != ""
                            ? FontWeight.w400
                            : FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Future<void> confirmReservation(int index, String time, String stand,
      String member1, String member2) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final reservedTimesCollection = firestore.collection('reservedTimes');

      // Use a fixed document ID (e.g., "reservation_1")
      final documentId = "reservation_1";

      // Get the document with the fixed ID
      final documentSnapshot =
          await reservedTimesCollection.doc(documentId).get();

      final querySnapshot = await reservedTimesCollection
          .where('time', isEqualTo: time)
          .where('stand', isEqualTo: stand)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Stand and time are already reserved
        print('Stand and time are already reserved.');
        return;
      }

      // Update the existing document or create it if it doesn't exist
      await reservedTimesCollection.doc(documentId).set({
        "$time-$stand": {
          "time": time,
          "stand": stand,
          "member1": member1,
          "member2": member2
        }
      }, SetOptions(merge: true));

      print('Reservation added to reservedTimes collection successfully.');
    } catch (e) {
      print('Error adding reservation to reservedTimes collection: $e');
    }
    Navigator.pop(context);
  }

  Future<List<String>> fetchReservedTimes() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final reservedTimesCollection = firestore.collection('reservedTimes');

      // Get the document with the fixed ID
      final documentSnapshot =
          await reservedTimesCollection.doc("reservation_1").get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        final reservedTimes = <String>[];

        // Iterate through the data and extract time values
        data.forEach((key, value) {
          if (value is Map<String, dynamic> && value.containsKey('time')) {
            reservedTimes.add(key);
          }
        });

        return reservedTimes;
      } else {
        print('Reservation data not found.');
        return [];
      }
    } catch (e) {
      print('Error fetching reservation data: $e');
      return [];
    }
  }

  Future<String> getReservationString(String time, String stand) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final reservedTimesCollection = firestore.collection('reservedTimes');

      // Get the document with the fixed ID
      final documentSnapshot =
          await reservedTimesCollection.doc("reservation_1").get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;

        // Find the reservation that matches the given time
        final reservation = data.entries.firstWhere(
          (entry) =>
              entry.value['time'] == time && entry.value['stand'] == stand,
          orElse: () => MapEntry('', {}),
        );

        // If a reservation is found, build the formatted string
        if (reservation.value.isNotEmpty) {
          final stand = reservation.value['stand'];
          final member1 = reservation.value['member1'];
          final member2 = reservation.value['member2'];
          return '$stand is reserved at $time by $member1 and $member2.';
        } else {
          return 'No reservation found for time $time.';
        }
      } else {
        print('Reservation data not found.');
        return 'Reservation data not found.';
      }
    } catch (e) {
      print('Error fetching reservation data: $e');
      return 'Error fetching reservation data.';
    }
  }
}

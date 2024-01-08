import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class sandingPackages extends StatelessWidget {
  final Uri _url = Uri.parse('https://flutter.dev');
   final List<Map<String, dynamic>> weddingPackages = [
    {
      'name': 'Selangor Wedding Package', 
      'links': [
        {'subName': 'Grand Ammara', 'link': Uri.encodeFull('https://grandammara.com/')},
        {'subName': 'Bizmilla', 'link': Uri.encodeFull('https://bizmillacatering.com/pakej-perkahwinan/')},
        {'subName': 'Najiha Online', 'link': Uri.encodeFull('https://najihaonline.com/')},
        {'subName': 'Laman Perkahwinan', 'link': Uri.encodeFull('https://lamanperkahwinan.com/')},
        {'subName': 'The Kenduri', 'link': Uri.encodeFull('https://thekenduri.com/pakej-nikah-sanding-1000pax-2023-2024/')},
      ],
    },
    {'name': 'KL/Putrajaya Wedding Package', 
    'links': [
      {'subName': 'Bizmilla', 'link': Uri.encodeFull('https://bizmillacatering.com/pakej-perkahwinan/')}, 
      {'subName': 'Laman Perkahwinan', 'link': Uri.encodeFull('https://lamanperkahwinan.com/')},
      {'subName': 'I Heart Party', 'link': Uri.encodeFull('https://www.iheartparty.com.my/new-page')},
      {'subName': 'The Wedding Heritage', 'link': Uri.encodeFull('https://theweddingheritage.com/offer-package/')},
      {'subName': 'Rumah Abang Jamil', 'link': Uri.encodeFull('https://nikahsatu.com/venue/rumah-abang-jamil-kuala-lumpur/')},
    ],
    },
    {'name': 'Pulau Pinang Wedding Package', 
    'links': [
      {'subName':'Bizmilla', 'link': Uri.encodeFull('https://bizmillacatering.com/dewan-majlis/event-hall-seberang-prai/')},
      {'subName':'Bertam Resort Wedding Package', 'link': Uri.encodeFull('https://bertamresort.com/weddings-functions/')},
      {'subName':'Angsana', 'link': Uri.encodeFull('https://www.angsana.com/malaysia/penang/wedding-packages')},
      {'subName':'The Light Hotel Wedding Package', 'link': Uri.encodeFull('https://thelighthotelpg.com/events-weddings/')},
      {'subName':'Shangri-la Wedding Package', 'link': Uri.encodeFull('https://www.shangri-la.com/penang/rasasayangresort/weddings-celebrations/wedding-packages/')},
    ],
    },
    {'name': 'Kedah Wedding Package', 
    'links': [
      {'subName':'Aman Wedding Package', 'link': Uri.encodeFull('https://amanhomestay4u.com/Pakej_perkahwinan.html')},
      {'subName':'Hotel Darul Aman Wedding Package', 'link': Uri.encodeFull('https://hoteldarulaman.com.my/pakej-perkahwinan-hd-jitra/')},
      {'subName':'Hidayah Catering', 'link': Uri.encodeFull('https://kahwin.feedmyguest.com/menu-menu')},
      {'subName':'Star City', 'link': Uri.encodeFull('https://www.starcity.com.my/wedding.php')},
      {'subName':'Seri Impiana Inn', 'link': Uri.encodeFull('https://seriimpianainn.blogspot.com/p/hall.html')},
    ],
    },
    {'name': 'Perlis Wedding Package', 
    'links': [
      {'subName':'Hana Catering', 'link': Uri.encodeFull('https://hanacateringservices.blogspot.com/p/harga.html')},
      {'subName':'Kayaman Catering', 'link': Uri.encodeFull('https://www.facebook.com/kateringperlis/')},
      {'subName':'MnS Catering', 'link': Uri.encodeFull('https://www.kahwinmall.com/mns-katering-fotografi-butik-pengantin-3433')},
    ],
    },
    {'name': 'Kelantan Wedding Package', 
    'links': [
      {'subName':'Rumah Abang Jamil', 'link': Uri.encodeFull('https://nikahsatu.com/venue/rumah-abang-jamil-kota-bharu/')},
      {'subName':'Embun Garden Wedding', 'link': Uri.encodeFull('https://embungardenwedding.blogspot.com/p/pakej-perkahwinan.html')},
      {'subName':'SP Models', 'link': Uri.encodeFull('https://spmodels.net/kitchen/tag/pakej-perkahwinan-penuh-paling-murah-in-kota-bharu-kelantan/')},
      {'subName':'AD Banquet & Catering', 'link': Uri.encodeFull('https://ad-banquet-catering.business.site/')},
      {'subName':'Blok Pakej.MY', 'link': Uri.encodeFull('https://blog.pakej.my/perkahwinan/pakej-pelamin-di-kelantan/')},
    ],
    },
    {'name': 'Pahang Wedding Package', 
    'links': [
      {'subName':'Rumah Abang Jamil', 'link': Uri.encodeFull('https://nikahsatu.com/venue/')},
      {'subName':'Colmar Tropicale', 'link': Uri.encodeFull('https://colmartropicale.com.my/wedding-package/')},
      {'subName':'House of Sanding', 'link': Uri.encodeFull('https://houseofsanding.com/')},
      // {'subName':'Package D', 'link': Uri.encodeFull('https://nikahsatu.com/')},
      // {'subName':'Package E', 'link': Uri.encodeFull('https://nikahsatu.com/')},
    ],
    },
    {'name': 'Terengganu Wedding Package', 
    'links': [
      {'subName':'Rumah Abang Jamil', 'link': Uri.encodeFull('https://nikahsatu.com/venue/rumah-abang-jamil-kuala-terengganu/')},
      {'subName':'Pozi Catering', 'link': Uri.encodeFull('https://www.pozicatering.com.my/')},
      {'subName':'D Qalbu Catering', 'link': Uri.encodeFull('https://www.dqalbucatering.com/pakej-kami/')},

    ],
    },
    {'name': 'Perak Wedding Package', 
    'links': [
      {'subName':'Rumah Abang Jamil', 'link': Uri.encodeFull('https://nikahsatu.com/venue/rumah-abang-jamil-ipoh/')},
      {'subName':'MRoof', 'link': Uri.encodeFull('https://mroof.mboutiquehotels.com/kenduri-kahwin-package/')},
      {'subName':'SP Models', 'link': Uri.encodeFull('https://spmodels.net/kitchen/tag/best-premium-full-wedding-package-in-ipoh-perak/')},
      {'subName':'Impiana', 'link': Uri.encodeFull('https://ipohhotels.impiana.com.my/impianagreatdeals/weddings/')},
      {'subName':'Marina Island Wedding', 'link': Uri.encodeFull('https://marinaislandpangkorresort.com/weddings/')},

    ],
    },
    {'name': 'Sabah Wedding Package', 
    'links': [
      {'subName':'Kharisma Katering', 'link': Uri.encodeFull('https://kharismakatering.com/')},
      {'subName':'Najiha Online', 'link': Uri.encodeFull('https://najihaonline.com/pakej-perkahwinan-aura-green-management-sabah/')},
      {'subName':'SP Models', 'link': Uri.encodeFull('https://spmodels.net/kitchen/tag/pakej-perkahwinan-penuh-paling-murah-in-kota-kinabalu-sabah/')},
      {'subName':'The Hill Kinabalu', 'link': Uri.encodeFull('https://thehillkinabalu.com/dewan-perkahwinan-di-kundasang')},
      {'subName':'Sabah Hotel Wedding', 'link': Uri.encodeFull('https://www.sabahhotel.com.my/wedding-packages')},
    ],
    },
    {'name': 'Sarawak Wedding Package', 
    'links': [
      {'subName':'Wedding Project 2U', 'link': Uri.encodeFull('https://weddingproject2u.com/')},
      {'subName':'Sabariah Wedding Package', 'link': Uri.encodeFull('https://sabariahatot.com/pakej-katering-perkahwinan-di-kuching-2023-2024/')},
      {'subName':'SP Models', 'link': Uri.encodeFull('https://spmodels.net/kitchen/tag/pakej-perkahwinan-penuh-paling-murah-in-kuching-sarawak/')},
      {'subName':'Samsudin Enterprise', 'link': Uri.encodeFull('https://samsudinenterprise.com/pakej-masjid-putih-katering-di-kuching-sarawak/')},
      {'subName':'East Wood Valley', 'link': Uri.encodeFull('https://www.eastwoodvalley.com/wedding-malay.php')},
    ],
    },
    {'name': 'Negeri Sembilan Wedding Package', 
    'links': [
      {'subName':'Najiha Online', 'link': Uri.encodeFull('https://najihaonline.com/')},
      {'subName':'The Kenduri', 'link': Uri.encodeFull('https://thekenduri.com/pakej-perkahwinan-galeri-diraja-seremban-2021-2022/')},
      {'subName':'Qalessya', 'link': Uri.encodeFull('https://qalessya.com/pakej-lengkap-perkahwinan-seremban/')},
      {'subName':'Nurul Adilah Package', 'link': Uri.encodeFull('https://nuruladilahahmad.com/pakej-perkahwinan-dewan-pekerti-negeri-sembilan-darul-khusus/')},
      {'subName':'Rumah Abang Jamil', 'link': Uri.encodeFull('https://nikahsatu.com/venue/rumah-abang-jamil-seremban/')},
    ],
    },
    {'name': 'Johor Wedding Package', 
    'links': [
      {'subName':'Bizmilla', 'link': Uri.encodeFull('https://bizmillacatering.com/pakej-perkahwinan/')},
      {'subName':'Opero Hotel Wedding', 'link': Uri.encodeFull('https://operohotel.com/best-hotel-event-space-johor-bahru/wedding-hotel-johor-bahru')},
      {'subName':'Persada', 'link': Uri.encodeFull('https://persadajohor.com/wedding.php')},
      {'subName':'Berjaya Hotel Wedding', 'link': Uri.encodeFull('https://www.berjayahotel.com/johorbahru/weddings.html')},
      {'subName':'Rumah Abang Jamil', 'link': Uri.encodeFull('https://nikahsatu.com/venue/')},
    ],
    },
    {'name': 'Melaka Wedding Package', 
    'links': [
      {'subName':'Rumah Abang Jamil', 'link': Uri.encodeFull('https://nikahsatu.com/venue/rumah-abang-jamil-melaka/')},
      {'subName':'Najiha Online', 'link': Uri.encodeFull('https://najihaonline.com/')},
      {'subName':'Villa Istana', 'link': Uri.encodeFull('https://villaistana.com.my/')},
      {'subName':'Rosa Wedding', 'link': Uri.encodeFull('https://rosa.com.my/wedding/')},
      {'subName':'Hatten Hotel Wedding', 'link': Uri.encodeFull('https://www.hattenhotel.com/deals/eternal-love-wedding-package')},

    ],
    },

    // Add more packages with their respective links
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wedding Packages'),
         backgroundColor: Colors.purple[700],
      ),
       body: ListView.builder(
        itemCount: weddingPackages.length,
        itemBuilder: (context, index) {
          final package = weddingPackages[index];
          return DropdownCard(packageName: package['name'], subItems: List<Map<String, String>>.from(package['links']));
        },
      ),
      backgroundColor: const Color.fromARGB(255, 239, 226, 255),
    );
  }
}

class DropdownCard extends StatefulWidget {
   final String packageName;
  final List<Map<String, String>> subItems;


  const DropdownCard({required this.packageName, required this.subItems});

  @override
  _DropdownCardState createState() => _DropdownCardState();
}

class _DropdownCardState extends State<DropdownCard> {
   late Map<String, String> _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.subItems.first;
  }

  @override
  Widget build(BuildContext context) {
          return Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(widget.packageName),
                  subtitle: DropdownButton<Map<String, String>>(
                    value: _selectedItem,
                    items: widget.subItems.map((subItem) {
                       return DropdownMenuItem<Map<String, String>>(
                        value: subItem,
                        child: Text(subItem['subName']!),
                      );
                    }).toList(),
                     onChanged: (Map<String, String>? newValue) async {
                      setState(() {
                        _selectedItem = newValue!;
                      });
                      if (newValue != null && await launch(newValue['link']!)) {
                        await launch(newValue['link']!);
                      } else {
                      print('Could not launch ${newValue?['link']}');
                      throw 'Could not launch ${newValue?['link']}';
                      }
                    }, 
                  ),
                ),
              ],
            ),
          );
  }  
  }





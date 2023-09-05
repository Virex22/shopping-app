import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/api/price_history_api.dart';
import 'package:shopping_app/model/price_history.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/model/shop.dart';
import 'package:shopping_app/provider/product_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class ProductViewPage extends StatefulWidget {
  final int shopId;
  final int productId;

  const ProductViewPage(
      {Key? key, required this.shopId, required this.productId})
      : super(key: key);

  @override
  ProductViewPageState createState() => ProductViewPageState();
}

class ProductViewPageState extends State<ProductViewPage> {
  Product? product;
  List<PriceHistory>? priceHistory;

  @override
  void initState() {
    super.initState();
    _loadProductData();
    _loadPriceHistory();
  }

  // Méthode pour charger les données du produit de manière asynchrone
  _loadProductData() async {
    ProductProvider productProvider = context.read<ProductProvider>();
    if (productProvider.shops == null) {
      await productProvider.refreshShopListFromApi();
      if (productProvider.shops == null) {
        throw Exception('Impossible de récupérer les produits');
      }
    }
    final Shop shop = productProvider.shops!
        .firstWhere((element) => element.id == widget.shopId);
    if (shop.product == null) {
      await productProvider.updateShopProductsFromApi(widget.shopId);
      if (shop.product == null) {
        throw Exception('Impossible de récupérer les produits');
      }
    }
    setState(() {
      product =
          shop.product!.firstWhere((element) => element.id == widget.productId);
    });
  }

  // Méthode pour charger l'historique des prix de manière asynchrone
  _loadPriceHistory() async {
    PriceHistoryApi priceHistoryApi = PriceHistoryApi();
    List<PriceHistory> priceHistoryList =
        await priceHistoryApi.getPriceHistoriesByProductId(widget.productId);
    setState(() {
      priceHistory = priceHistoryList;
    });
  }

  String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
    final formatter = DateFormat(format);
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Produit'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(product!.name),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildProductInfoCard(
                        icon: Icons.people,
                        label: 'Quantité',
                        value: product!.quantityText,
                      ),
                      _buildProductInfoCard(
                        icon: Icons.date_range,
                        label: 'Date d\'ajout',
                        value: formatDate(product!.dateAdd),
                        bigger: true,
                      ),
                      _buildProductInfoCard(
                        icon: Icons.attach_money,
                        label: 'Prix',
                        value: '${product!.price.toStringAsFixed(2)} €',
                      ),
                      // Ajoutez d'autres cartes pour plus d'informations sur le produit au besoin
                    ],
                  ),
                ),
              ),
              const Divider(),
              priceHistory == null
                  ? const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()))
                  : priceHistory!.length < 2
                      ? const SizedBox(
                          height: 200,
                          child: Center(
                              child: Text('Aucun historique de prix trouvé')))
                      : SizedBox(
                          height: 200,
                          child: priceHistoryBarChart(priceHistory!),
                        ),
            ],
          ),
        ));
  }

  double calculateBarWidth(int dataLength, int widthTakenByTitles) {
    const double minWidth = 16.0;

    final double totalWidth =
        MediaQuery.of(context).size.width - widthTakenByTitles;

    final double barWidth = totalWidth /
        (dataLength + 1); // + 1 for not touching the edge of the chart

    return barWidth >= minWidth ? barWidth : minWidth;
  }

  BarChart priceHistoryBarChart(List<PriceHistory> priceHistoryList) {
    List<BarChartGroupData> bars = [];

    const limit = 10;

    priceHistoryList.sort((a, b) => a.dateUpdate.compareTo(b.dateUpdate));
    priceHistoryList = priceHistoryList.sublist(
        priceHistoryList.length > limit ? priceHistoryList.length - limit : 0);

    for (int i = 0; i < priceHistoryList.length; i++) {
      final priceHistory = priceHistoryList[i];
      final date = priceHistory.dateUpdate;
      final xValue = date.millisecondsSinceEpoch.toInt();
      final yValue = priceHistory.price;

      final bar = BarChartGroupData(
        x: xValue,
        barRods: [
          BarChartRodData(
            fromY: 0,
            toY: yValue,
            width: calculateBarWidth(priceHistoryList.length, 200),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            rodStackItems: [
              BarChartRodStackItem(
                0,
                yValue,
                const Color(0xff0074E4),
              ),
            ],
          ),
        ],
        showingTooltipIndicators: [],
      );
      bars.add(bar);
    }

    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.grey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toStringAsFixed(2)} €',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        alignment: BarChartAlignment.center,
        gridData: const FlGridData(
          show: true,
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              getTitlesWidget: (value, TitleMeta titleMeta) {
                final index = bars.indexWhere((element) => element.x == value);
                return Padding(
                  padding: EdgeInsets.only(
                      top: index % 2 != 0 && bars.length > 5 ? 15 : 0),
                  child: Text(
                    formatDate(
                        DateTime.fromMillisecondsSinceEpoch(value.toInt()),
                        format: 'dd/MM'),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                );
              },
              interval: 1,
              reservedSize: 30,
              showTitles: true,
            ),
            drawBelowEverything: true,
          ),
          rightTitles: const AxisTitles(
            axisNameSize: 20,
            axisNameWidget: Text(
              'Prix (€)',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            drawBelowEverything: true,
          ),
          topTitles: const AxisTitles(
            axisNameSize: 20,
            axisNameWidget: Text(
              'Date',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            drawBelowEverything: false,
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: bars,
        maxY: priceHistoryList.fold<double>(
                0.0,
                (max, priceHistory) =>
                    priceHistory.price > max ? priceHistory.price : max) +
            2,
      ),
    );
  }

  Widget _buildProductInfoCard({
    required IconData icon,
    required String label,
    required String value,
    bool bigger = false,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: bigger ? 100 : 80,
          height: bigger ? 100 : 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

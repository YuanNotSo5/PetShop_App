import 'package:flutter/material.dart';


class PaymentMethodScreen extends StatefulWidget {
  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  bool isCardSelected = false;
  bool isPayPalSelected = true;
  bool saveAsDefault = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: Text('Payment Method'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.grey,
                      ),
                      elevation: isCardSelected ? 2 : 0,
                    ),
                    onPressed: () {
                      setState(() {
                        isCardSelected = true;
                        isPayPalSelected = false;
                      });
                    },
                    child: Text(
                      'Card',
                      style: TextStyle(
                        color: isCardSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.grey,
                      ),
                      elevation: isPayPalSelected ? 2 : 0,
                    ),
                    onPressed: () {
                      setState(() {
                        isCardSelected = false;
                        isPayPalSelected = true;
                      });
                    },
                    child: Text(
                      'PayPal',
                      style: TextStyle(
                        color: isPayPalSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (isPayPalSelected) ...[
              TextField(
                decoration: InputDecoration(
                  labelText: 'PayPal Email',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'PayPal Password',
                ),
                obscureText: true,
              ),
            ],
            if (isCardSelected) ...[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Card Number',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Card Holder Name',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Expiration Date',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'CVV',
                ),
                obscureText: true,
              ),
            ],
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: saveAsDefault,
                  onChanged: (bool? value) {
                    setState(() {
                      saveAsDefault = value ?? false;
                    });
                  },
                ),
                Text('Save as default payment method'),
              ],
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Add'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:notes/model/noteData.dart';
import 'package:sqflite_common/sqlite_api.dart';

class BookDatabaseHome extends StatefulWidget{
  @override
  State<BookDatabaseHome> createState() => _BookDatabaseHomeState();
}

class _BookDatabaseHomeState extends State<BookDatabaseHome> {
  List<Map<String,dynamic >> _allData = [];

  bool _isLoading = true;

  void _refreshData() async{
    final data = await SQLHelper.getAllData();
    setState((){
      _allData =data;
      _isLoading=false;
    });

  }
  @override
  void initState(){
    super.initState();
    _refreshData();
  }


  Future<void> _addData() async{
    await SQLHelper.createData(_titleController.text,_detaliController.text);
    _refreshData();
  }

  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(id, _titleController.text, _detaliController.text);
    _refreshData();
  }

  void _deleteData(int id) async{
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Delete'),backgroundColor: Color(0xffFBC02D),));
    _refreshData();

  }


  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detaliController = TextEditingController();

  void showButtonSheet(int ?id) async{
    if(id != null){
      final existingData = _allData.firstWhere((element) => element['id'] == id);
      _titleController.text = existingData['title'];
      _detaliController.text = existingData['detali'];

    }



    showModalBottomSheet(
        elevation :5,
        isScrollControlled : true,
        context : context,
        builder : (_) => Container(
          padding: EdgeInsets.only(top: 30,left: 15,right: 15,bottom: MediaQuery.of(context).viewInsets.bottom+50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller : _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "title",
                ),
              ),
              SizedBox(height: 15,),
              TextField(
                controller : _detaliController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "detali",

                ),
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    if(id ==null){
                      await _addData();
                    }
                    if(id != null){
                      await _updateData(id);
                    }

                    _titleController.text = "";
                    _detaliController.text = "";

                    Navigator.of(context).pop();

                    print('data add');
                  },
                  child: Text(id == null ? "add data": "UPDATE DATA",style: TextStyle(color: Colors.black,),),
                ),
              )



            ],
          ),
        )
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes',style: TextStyle(color: Colors.black),),
        backgroundColor: Color(0xffFBC02D),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(),):
      ListView.builder(
        itemCount: _allData.length,
        itemBuilder: (context,index) => Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            title: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(_allData[index]['title'],style: TextStyle(color: Colors.black)
              ),
            ),
            subtitle:  Text(_allData[index]['detali'],style: TextStyle(color: Colors.black54)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: (){
                  showButtonSheet(_allData[index]['id'],);

                }, icon:Icon(Icons.edit,color: Colors.blue,)),
                IconButton(onPressed: (){
                  setState(() {
                    _deleteData(_allData[index]['id']);
                  });
                }, icon:Icon(Icons.delete,color: Colors.green,)),
              ],
            ),

          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showButtonSheet(null),
        backgroundColor: Color(0xffFBC02D),
        child: Icon(Icons.add),
      ),

    );
  }
}


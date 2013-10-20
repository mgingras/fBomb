
/*
 * GET home page.
 */

exports.index = function(req, res){
  res.render('index', { title: 'Express' });
};

exports.data = function(req, res){
  getData(function(data){
    if(data){
      // console.log(data);
      res.send(data);
    }
  });
};

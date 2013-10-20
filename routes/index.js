
/*
 * GET home page.
 */

exports.index = function(req, res){
  res.render('index', { title: 'Express' });
};

exports.data = function(req, res){
  getTweets(function(tweets){
    if(tweets){
      res.send(tweets);
    }
  });
};

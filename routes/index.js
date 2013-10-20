
/*
 * GET home page.
 */

exports.index = function(req, res){
  res.render('index', { title: 'FBomb' });
};

exports.data = function(req, res){
  getTweets(function(tweets){
    if(tweets){
      res.send(tweets);
    }
  });
};

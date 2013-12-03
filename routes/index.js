
/*
 * GET home page.
 */

exports.index = function(req, res){
  res.render('index', { title: 'FBomb', api: process.env.gmaps });
};

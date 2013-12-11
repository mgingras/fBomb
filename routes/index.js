
/*
 * GET home page.
 */

exports.index = function(req, res){
  res.render('index', { title: process.env.app_name , api: process.env.gmaps });
};

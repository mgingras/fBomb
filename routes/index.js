
/*
 * GET home page.
 */

var config = require('../config.json');
exports.index = function(req, res){
  res.render('index', { title: config.app_name , api: config.gmaps });
};

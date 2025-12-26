var page = require('webpage').create(),
    system = require('system'),
    t, url, path;

var fs = require('fs');
if (system.args.length === 2) {
    console.log('params error');
    phantom.exit();
}

t = Date.now();
url = system.args[1];
path = system.args[2];


page.open(url, function (status) {
    if(path.indexOf(".html") != -1){
        fs.write(path, page.content, 'w');
    }else if(path.indexOf(".png") != -1){
        page.render(path); //生成图片
    }else{
        console.log("error-->");
    }
    phantom.exit();
});
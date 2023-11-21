const fs = require("fs");
const path = require('path');
const JSZip = require("/data/data/com.termux/files/usr/lib/node_modules/jszip");
const argparse = require('/data/data/com.termux/files/usr/lib/node_modules/argparse');
const { folder } = require("/data/data/com.termux/files/usr/lib/node_modules/jszip");
const lumpimlib = require("./lumpimlib.js")

let parser = new argparse.ArgumentParser({
  description: 'i convert the png with given offsets'
});

parser.add_argument('image', { help: 'image to convert' });
parser.add_argument('x', { help: 'da x' });
parser.add_argument('y', { help: 'da y' });
parser.add_argument('name', { help: 'if provided, sets the name to this' });
parser.add_argument('colortxt', { help: 'color txt, if any' });

let colorArray = [];

let args = parser.parse_args()
if (fs.existsSync(path.basename(args.colortxt)))
{
  const colors = fs.readFileSync(path.basename(args.colortxt),
    { encoding: 'utf8', flag: 'r' });
  
  var fullarr = colors.split("\r\n")
  for (var i = 0; i < fullarr.length; i++)
  {
    const splitted = fullarr[i].split('||')
    if (!splitted[0] || !splitted[1]) continue
    
    splitted[0] = Number(splitted[0])
    splitted[1] = Number(splitted[1])
    
    colorArray.push(splitted)
    console.log(colorArray)
  }
}
//console.log(colors)
console.log(`Converting!`)

function processFilename(filename) {
    let stat = fs.statSync(filename)
    let data = {
        name: path.basename(filename),
        type: null,
        order: 0
    }
    if (stat.isDirectory()) {
        data.order = -100
        data.type = "folder"
    } else {
        data.type = "file"
        data.data = fs.readFileSync(filename)
    }
    if (args.debug) {
        //console.warn(`DEBUG: ${filename}'s name is ${data.name}, order ${data.order}`)
    }
    return data
}

const data = processFilename(path.basename(args.image))
const offset = [args.x, args.y]

function convertFile(file)
{
  if (!file.name.endsWith('.png')) return
  
  console.log(`${file.name}...`)

  return lumpimlib.png2lmp_manualoffset(file.data, offset, colorArray)
}

if (data)
{
	console.log('this exists so thats neat')
	if (data.type == 'file')
		fs.writeFile(path.basename(args.name), convertFile(data), function(err) {})

	if (data.type == 'folder')
	{
		var foldername = `${path.basename(args.image)}_CONVERT`
		if (!fs.existsSync(path.basename(args.name)))
			fs.mkdir(foldername, (error) => {})
		
		fs.readdirSync(path.basename(args.image)).forEach(function(filename) {
			var file = processFilename(`${path.basename(args.image)}/${filename}`)
			var convertedname = filename.replace('.png', '.lmp')
			
			if (file.type == 'file')
				fs.writeFile(`${foldername}/${convertedname}`, convertFile(file), (err) => {console.log(err)})
		})

		//fs.writeFile(`${foldername}/`)
	}
}